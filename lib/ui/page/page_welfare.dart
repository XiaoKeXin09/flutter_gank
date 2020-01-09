import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/api//api_gank.dart';
import 'package:flutter_gank/common/constant/strings.dart';
import 'package:flutter_gank/common/event/event_change_column.dart';
import 'package:flutter_gank/common/manager/app_manager.dart';
import 'package:flutter_gank/common/model/gank_item.dart';
import 'package:flutter_gank/common/utils/common_utils.dart';
import 'package:flutter_gank/common/utils/time_utils.dart';
import 'package:flutter_gank/ui/page/page_gallery.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WelfarePage extends StatefulWidget {
  @override
  _WelfarePageState createState() => _WelfarePageState();
}

class _WelfarePageState extends State<WelfarePage>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  List _gankItems = [];
  int _page = 1;
  bool isOneColumn = false;
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    initWelfareEventBus();
    initWelfareData();
  }

  void initWelfareEventBus() {
    AppManager.eventBus.on<ChangeWelfareColumnEvent>().listen((event) {
      if (mounted) {
        setState(() {
          isOneColumn = !isOneColumn;
        });
      }
    });
  }

  void initWelfareData() async {
    var gankItems = await _getCategoryData();
    setState(() {
      _gankItems.addAll(gankItems);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Offstage(
              offstage: _isLoading,
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                enablePullUp: true,
                child: GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isOneColumn ? 1 : 2,
                      childAspectRatio: 2 / (isOneColumn ? 2 : 3),
                      crossAxisSpacing: 10.0,
                    ),
                    itemCount: _gankItems?.length ?? 0,
                    padding: EdgeInsets.all(10),
                    itemBuilder: (BuildContext context, int index) {
                      var gankItem = _gankItems[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return GalleryPage(
                                [gankItem.url.replaceFirst("large", "mw690")],
                                gankItem.desc);
                          }));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _buildImageWidget(gankItem),
                        ),
                      );
                    }),
              )),
          Offstage(
            offstage: !_isLoading,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImageWidget(gankItem) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
              child: CachedNetworkImage(
            imageUrl: gankItem.url,
            fit: BoxFit.cover,
          )),
          Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                color: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      formatDateStr(gankItem.publishedAt),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  void _onRefresh() async {
    _page = 1;
    var gankItems = await _getCategoryData();
    _refreshController.refreshCompleted();
    setState(() {
      _gankItems = gankItems;
    });
  }

  void _onLoading() async {
    _page++;
    var gankItems = await _getCategoryData();
    _refreshController.loadComplete();
    setState(() {
      _gankItems.addAll(gankItems);
    });
  }

  Future _getCategoryData() async {
    var categoryData = await GankApi.getCategoryData(AppStrings.WELFARE, _page);
    var gankItems = categoryData['results']
        .map<GankItem>((itemJson) => GankItem.fromJson(itemJson,
            category: CommonUtils.getLocale(context).gankWelfare))
        .toList();
    return gankItems;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
