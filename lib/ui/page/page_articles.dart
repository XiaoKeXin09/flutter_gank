import 'package:flutter/material.dart';
import 'package:flutter_gank/api/api_article.dart';
import 'package:flutter_gank/ui/widget/widget_article_list_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';

class ArticlePage extends StatefulWidget {
  static const String ROUTER_NAME = 'article';

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage>
    with AutomaticKeepAliveClientMixin {
  int _page = 0;
  bool _isLoading = true;

  RefreshController _refreshController;

  var _articleItems = [];

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    initArticleData();
  }

  void initArticleData() async {
    var result = await ArticleApi.getJueJinFlutterArticles(_page);
    List articleItems = result['d']['entrylist'];
    setState(() {
      _articleItems.addAll(articleItems);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          enablePullUp: true,
          enablePullDown: true,
          child: ListView.builder(
            itemCount: _articleItems?.length ?? 0,
            itemBuilder: (context, index) =>
                ArticleListItem(_articleItems[index]),
          ),
        ),
        Offstage(
          offstage: !_isLoading,
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        )
      ],
    );
  }

  _onRefresh() async {
    _page = 0;
    var result = await ArticleApi.getJueJinFlutterArticles(_page);
    List articleItems = result['d']['entrylist'];
    _refreshController.refreshCompleted();
    setState(() {
      _articleItems = articleItems;
    });
  }

  _onLoading() async {
    _page++;
    var result = await ArticleApi.getJueJinFlutterArticles(_page);
    List articleItems = result['d']['entrylist'];
    _refreshController.loadComplete();
    setState(() {
      _articleItems.addAll(articleItems);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
