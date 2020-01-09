import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/common/event/event_refresh_db.dart';
import 'package:flutter_gank/common/localization/gank_localizations.dart';
import 'package:flutter_gank/common/manager/app_manager.dart';
import 'package:flutter_gank/common/manager/favorite_manager.dart';
import 'package:flutter_gank/common/model/gank_item.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_gank/ui/widget/widget_list_item.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin, FavoriteManager {
  bool _isLoading = true;
  bool _isEmpty = false;
  List _gankItems = [];
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    AppManager.eventBus.on<RefreshDBEvent>().listen((event) {
      if (mounted) {
        ///刷新本地收藏，注意:mounted变量判断是否已挂载当前widget.
        _refreshFavorites();
      }
    });
    _readFavorites();
  }

  ///读取收藏数据,并更新UI
  void _readFavorites() async {
    List<GankItem> gankItems = await _getFavoritesData();
    setState(() {
      _isLoading = false;
      _gankItems = gankItems;
      _isEmpty = _gankItems.length == 0;
    });
  }

  ///刷新收藏,并更新UI
  void _refreshFavorites() async {
    List<GankItem> gankItems = await _getFavoritesData();
    _refreshController.refreshCompleted();
    setState(() {
      _gankItems = gankItems;
      _isEmpty = _gankItems.length == 0;
    });
  }

  ///从本地数据库获取收藏数据
  Future<List<GankItem>> _getFavoritesData() async {
    var results = await FavoriteManager.find({});
    return results.map<GankItem>((json) => GankItem.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return buildContainer(context);
  }

  ///build 组件
  Container buildContainer(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Offstage(
            offstage: _isLoading || _isEmpty,
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _refreshFavorites,
              enablePullUp: false,
              child: ListView.builder(
                itemCount: _gankItems?.length ?? 0,
                itemBuilder: (context, index) =>
                    GankListItem(_gankItems[index]),
              ),
            ),
          ),
          Offstage(
            offstage: !_isLoading,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
          Offstage(
            offstage: !_isEmpty,
            child: StoreConnector<AppState, ThemeData>(
              converter: (store) => store.state.themeData,
              builder: (context, themeData) => Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset("images/favorite_empty.png",
                          width: 130, color: themeData.primaryColor),
                      Text(
                          GankLocalizations.of(context)
                              .currentLocalized
                              .noFavorite,
                          style: Theme.of(context).textTheme.body2.copyWith(
                              color: themeData.primaryColor,
                              fontFamily: 'WorkSansMedium'))
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
