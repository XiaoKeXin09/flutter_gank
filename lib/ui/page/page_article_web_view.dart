import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/common/event/event_refresh_db.dart';
import 'package:flutter_gank/common/manager/app_manager.dart';
import 'package:flutter_gank/common/model/gank_item.dart';
import 'package:flutter_gank/common/manager/favorite_manager.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleWebViewPage extends StatefulWidget {
  final articleItem;

  ArticleWebViewPage(this.articleItem);

  @override
  _ArticleWebViewPageState createState() => _ArticleWebViewPageState();
}

class _ArticleWebViewPageState extends State<ArticleWebViewPage>
    with FavoriteManager {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
          title: Text(widget.articleItem['content']?.isEmpty ?? true
              ? widget.articleItem['summaryInfo']
              : widget.articleItem['content'])),
      withLocalStorage: true,
      url: widget.articleItem['originalUrl'],
      withJavascript: true,
    );
  }
}
