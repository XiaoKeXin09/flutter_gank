import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gank/api//api_gank.dart';
import 'package:flutter_gank/common/constant/strings.dart';
import 'package:flutter_gank/common/event/event_change_column.dart';
import 'package:flutter_gank/common/event/event_refresh_new.dart';
import 'package:flutter_gank/common/event/event_show_history_date.dart';
import 'package:flutter_gank/common/manager/app_manager.dart';
import 'package:flutter_gank/common/manager/favorite_manager.dart';
import 'package:flutter_gank/common/utils/navigator_utils.dart';
import 'package:flutter_gank/ui/page/page_articles.dart';
import 'package:flutter_gank/ui/page/page_category.dart';
import 'package:flutter_gank/ui/page/page_new.dart';
import 'package:flutter_gank/ui/page/page_welfare.dart';
import 'package:flutter_gank/ui/widget/widget_bottom_tabs.dart';
import 'package:flutter_gank/ui/widget/widget_gank_drawer.dart';
import 'package:flutter_gank/ui/widget/widget_history_date.dart';
import 'package:flutter_gank/ui/widget/widget_icon_font.dart';

class HomePage extends StatefulWidget {
  static const String ROUTER_NAME = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  String _currentDate;
  List _historyData;
  PageController _pageController;
  MethodChannel flutterNativePlugin;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: 0);
    flutterNativePlugin =
        MethodChannel(AppStrings.FLUTTER_NATIVE_PLUGIN_CHANNEL_NAME);
    _getHistoryData();
    _checkUpdate();
    _registerEventListener();
  }

  ///调用native，检查更新
  void _checkUpdate() async {
    if (Platform.isAndroid) {
      await flutterNativePlugin.invokeMethod('checkupdate');
    }
  }

  ///获取干货历史发布日期
  void _getHistoryData() async {
    var historyData = await GankApi.getHistoryDateData();
    setState(() {
      _historyData = historyData;
      _currentDate = '今日最新干货';
    });
  }

  ///注册事件监听器
  void _registerEventListener() {
    AppManager.eventBus.on<RefreshNewPageEvent>().listen((event) {
      if (mounted) {
        setState(() {
          _currentDate = event.date;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: GankDrawer(),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: BottomTabs(_pageController, _pageChange),
    );
  }

  ///build main body.
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        PageView(
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: _pageChange,
          controller: _pageController,
          children: <Widget>[
            NewPage(),
            CategoryPage(),
            WelfarePage(),
            ArticlePage()
          ],
        ),
        HistoryDate(_historyData),
      ],
    );
  }

  ///build AppBar.
  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Offstage(
        offstage: _currentPageIndex != 0,

        ///标题栏显示当前日期
        child: Text(_currentDate ?? ''),
      ),
      actions: <Widget>[_buildActions()],
    );
  }

  ///页面切换回调
  void _pageChange(int index) {
    if (index != 0) {
      AppManager.eventBus.fire(ShowHistoryDateEvent.hide());
    }
    setState(() {
      if (_currentPageIndex != index) {
        _currentPageIndex = index;
      }
    });
  }

  ///创建标题栏右侧按钮
  IconButton _buildActions() {
    return IconButton(
      icon: Icon(getActionsIcon(), size: 22, color: Colors.white),
      onPressed: () async {
        if (_currentPageIndex == 0) {
          ///显示/隐藏日期
          AppManager.notifyShowHistoryDateEvent();
        } else if (_currentPageIndex == 1) {
          ///去搜索页
          NavigatorUtils.goSearch(context);
        } else if (_currentPageIndex == 2) {
          ///切换妹纸图列数按钮
          AppManager.eventBus.fire(ChangeWelfareColumnEvent());
        } else {
          FavoriteManager.syncFavorites(context);
        }
      },
    );
  }

  ///获取标题栏右侧图标.
  IconData getActionsIcon() {
    if (_currentPageIndex == 0) {
      return IconFont(0xe8a6);
    } else if (_currentPageIndex == 1) {
      return IconFont(0xe783);
    } else if (_currentPageIndex == 2) {
      return IconFont(0xe63a);
    } else {
      return null;
    }
  }
}
