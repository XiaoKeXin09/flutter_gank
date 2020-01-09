import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/common/event/event_refresh_db.dart';
import 'package:flutter_gank/common/manager/app_manager.dart';
import 'package:flutter_gank/common/model/gank_item.dart';
import 'package:flutter_gank/common/manager/favorite_manager.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  final GankItem gankItem;

  WebViewPage(this.gankItem);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> with FavoriteManager {
  bool _favorite = false;

  @override
  void initState() {
    super.initState();
    readFavoriteStatus();
  }

  void dispose() async {
    super.dispose();
  }

  void readFavoriteStatus() async {
    var results =
        await FavoriteManager.find({'itemId': widget.gankItem.itemId});
    if (results.length > 0) {
      setState(() {
        _favorite = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: Text(widget.gankItem.desc),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.favorite,
                  color: _favorite ? Colors.red : Colors.white),
              onPressed: () async {
                if (_favorite) {
                  await FavoriteManager.remove(widget.gankItem);
                  setState(() {
                    _favorite = false;
                  });
                } else {
                  await FavoriteManager.insert(widget.gankItem);
                  setState(() {
                    _favorite = true;
                  });
                }
                AppManager.eventBus.fire(RefreshDBEvent());
              }),
          IconButton(
              icon: Icon(Icons.language),
              onPressed: () async {
                if (await canLaunch(widget.gankItem.url)) {
                  launch(widget.gankItem.url);
                }
              })
        ],
      ),
      withLocalStorage: true,
      url: widget.gankItem.url,
      withJavascript: true,
    );
  }
}
