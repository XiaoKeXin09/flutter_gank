import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/api//api_gank.dart';
import 'package:flutter_gank/common/model/gank_item.dart';
import 'package:flutter_gank/common/model/gank_post.dart';
import 'package:flutter_gank/ui/page/page_gallery.dart';
import 'package:flutter_gank/ui/widget/widget_list_item.dart';
import 'package:flutter_gank/ui/widget/widget_list_title.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DetailPage extends StatefulWidget {
  final String _date;

  DetailPage(this._date);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<GankItem> _gankItems;
  RefreshController _refreshController;
  bool _isLoading = true;
  String _girlImage;

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    getNewData();
  }

  Future getNewData({String date, bool isRefresh = false}) async {
    var specialDayDataJson = await GankApi.getSpecialDayData(widget._date);
    var specialDayItem = GankPost.fromJson(specialDayDataJson);
    setState(() {
      _gankItems = specialDayItem.gankItems;
      _girlImage = specialDayItem.girlImage;
      _isLoading = false;
    });
    if (isRefresh) {
      _refreshController.refreshCompleted();
    }
  }

  _onRefresh() async {
    getNewData(date: widget._date, isRefresh: true);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._date),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          ///content view
          Offstage(
            offstage: _isLoading ? true : false,
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              onRefresh: _onRefresh,
              onOffsetChange: null,
              controller: _refreshController,
              child: _buildListView(),
            ),
          ),

          ///loading view
          Offstage(
            offstage: _isLoading ? false : true,
            child: Center(child: CupertinoActivityIndicator()),
          )
        ],
      ),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
        itemCount: _gankItems == null ? 0 : _gankItems.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return _buildImageBanner(context);
          } else {
            GankItem gankItem = _gankItems[i - 1];
            return gankItem.isTitle
                ? GankItemTitle(gankItem.category)
                : GankListItem(gankItem);
          }
        });
  }

  GestureDetector _buildImageBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return GalleryPage([_girlImage], widget._date);
        }));
      },
      child: CachedNetworkImage(
        height: 200,
        imageUrl: _girlImage,
        fit: BoxFit.cover,
      ),
    );
  }
}
