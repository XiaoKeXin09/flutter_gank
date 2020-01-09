import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/api//api_gank.dart';
import 'package:flutter_gank/common/constant/strings.dart';
import 'package:flutter_gank/common/model/gank_item.dart';
import 'package:flutter_gank/ui/widget/widget_list_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GankListCategory extends StatefulWidget {
  final String category;

  GankListCategory(this.category);

  @override
  _GankListCategoryState createState() => _GankListCategoryState();
}

class _GankListCategoryState extends State<GankListCategory>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  List _gankItems = [];
  int _page = 1;
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    _initListCategoryData();
  }

  void _initListCategoryData() async {
    var gankItems = await _getCategoryData();
    setState(() {
      _gankItems = gankItems;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          )
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

  _getCategoryData() async {
    var categoryData = await GankApi.getCategoryData(
        widget.category == AppStrings.ALL_ZH
            ? AppStrings.ALL_EN
            : widget.category,
        _page);
    var gankItems = categoryData['results']
        .map<GankItem>((itemJson) =>
            GankItem.fromJson(itemJson, category: widget.category))
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
