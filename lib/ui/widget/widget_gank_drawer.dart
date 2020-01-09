import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gank/common/constant/strings.dart';
import 'package:flutter_gank/common/localization/gank_localizations.dart';
import 'package:flutter_gank/common/manager/app_manager.dart';
import 'package:flutter_gank/common/manager/favorite_manager.dart';
import 'package:flutter_gank/common/manager/user_manager.dart';
import 'package:flutter_gank/common/utils/common_utils.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_gank/ui/page/page_about.dart';
import 'package:flutter_gank/ui/page/page_history.dart';
import 'package:flutter_gank/ui/page/page_search.dart';
import 'package:flutter_gank/ui/page/page_settings.dart';
import 'package:flutter_gank/ui/page/page_submit.dart';
import 'package:flutter_gank/ui/widget/widget_icon_font.dart';
import 'package:flutter_gank/ui/widget/widget_sizable_drawer.dart';
import 'package:flutter_redux/flutter_redux.dart';

class GankDrawer extends StatefulWidget {
  @override
  _GankDrawerState createState() => _GankDrawerState();
}

class _GankDrawerState extends State<GankDrawer> with TickerProviderStateMixin {
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;
  AnimationController _controllerDrawer;
  Animation<double> _drawerContentsOpacity;
  Animatable<Offset> _drawerDetailsTween;

  ///native插件
  MethodChannel flutterNativePlugin;

  @override
  void initState() {
    super.initState();

    ///native插件初始化
    flutterNativePlugin =
        MethodChannel(AppStrings.FLUTTER_NATIVE_PLUGIN_CHANNEL_NAME);

    ///初始化动画相关
    _controllerDrawer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controllerDrawer),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsTween = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).chain(CurveTween(
      curve: Curves.fastOutSlowIn,
    ));
    _drawerDetailsPosition = _controllerDrawer.drive(_drawerDetailsTween);
  }

  @override
  Widget build(BuildContext context) {
    return SizableDrawer(
      widthPercent: 0.75,
      child: Column(
        children: <Widget>[
          StoreBuilder<AppState>(
            builder: (context, store) => UserAccountsDrawerHeader(
                  accountName: Text(store.state.userInfo?.userName ?? CommonUtils.getLocale(context).pleaseLogin),
                  accountEmail: Text(
                      store.state.userInfo?.userDesc ?? '~~(>_<)~~ 什么也没有~'),
                  currentAccountPicture: GestureDetector(
                      onTap: () {
                        if (!(store.state.userInfo?.isLogin ?? false)) {
                          Navigator.of(context).pushNamed('login');
                        }
                      },
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          border:
                              new Border.all(color: Colors.white, width: 1.0),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: store.state.userInfo?.avatarUrl == null ||
                                  store.state.userInfo.avatarUrl.isEmpty
                              ? Image.asset('images/gank.png')
                              : CachedNetworkImage(
                                  imageUrl: store.state.userInfo.avatarUrl),
                        ),
                      )),
                  margin: EdgeInsets.zero,
                  onDetailsPressed: store.state.userInfo?.isLogin ?? false
                      ? () {
                          _showDrawerContents = !_showDrawerContents;
                          if (_showDrawerContents)
                            _controllerDrawer.reverse();
                          else
                            _controllerDrawer.forward();
                        }
                      : null,
                ),
          ),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      // The initial contents of the drawer.
                      FadeTransition(
                        opacity: _drawerContentsOpacity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ListTile(
                                leading: Icon(
                                  IconFont(0xe655),
                                  color: Color(0xff737373),
                                ),
                                title: Text(CommonUtils.getLocale(context)
                                    .searchGanHuo),
                                onTap: () {
                                  _gotoActivity(context, SearchPage());
                                },
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                IconFont(0xe8a6),
                                color: Color(0xff737373),
                              ),
                              title: Text(
                                  CommonUtils.getLocale(context).historyGanHuo),
                              onTap: () {
                                _gotoActivity(context, HistoryPage());
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                IconFont(0xe62c),
                                color: Color(0xff737373),
                              ),
                              title: Text(
                                  CommonUtils.getLocale(context).submitGanHuo),
                              onTap: () {
                                _gotoActivity(context, SubmitPage());
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(
                                height: 0,
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                IconFont(0xe621),
                                color: Color(0xff737373),
                              ),
                              title:
                                  Text(CommonUtils.getLocale(context).settings),
                              onTap: () {
                                _gotoActivity(context, SettingPage());
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                IconFont(0xe710),
                                color: Color(0xff737373),
                              ),
                              title: Text(CommonUtils.getLocale(context).about),
                              onTap: () {
                                _gotoActivity(context, AboutPage());
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                IconFont(0xe6ab),
                                color: Color(0xff737373),
                              ),
                              title:
                                  Text(CommonUtils.getLocale(context).starGank),
                              onTap: () {
                                AppManager.starFlutterGank(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                IconFont(0xe61a),
                                color: Color(0xff737373),
                              ),
                              title: Text(
                                  CommonUtils.getLocale(context).feedBackShort),
                              onTap: () {
                                flutterNativePlugin
                                    .invokeMethod('openFeedbackActivity');
                              },
                            ),
                          ],
                        ),
                      ),
                      // The drawer's "details" view.
                      SlideTransition(
                        position: _drawerDetailsPosition,
                        child: FadeTransition(
                          opacity: ReverseAnimation(_drawerContentsOpacity),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ListTile(
                                  leading: Icon(
                                    IconFont(0xe69a),
                                    color: Color(0xff737373),
                                  ),
                                  onTap: () {
                                    CommonUtils.showThemeDialog(context);
                                  },
                                  title: Text(CommonUtils.getLocale(context)
                                      .themeSetting)),
                              ListTile(
                                  leading: Icon(
                                    IconFont(0xe64a),
                                    color: Color(0xff737373),
                                  ),
                                  onTap: () {
                                    CommonUtils.showLanguageDialog(context);
                                  },
                                  title: Text(CommonUtils.getLocale(context)
                                      .languageSetting)),
                              ListTile(
                                  leading: Icon(
                                    IconFont(0xe619),
                                    color: Color(0xff737373),
                                  ),
                                  onTap: () {
                                    FavoriteManager.syncFavorites(context);
                                  },
                                  title: Text(CommonUtils.getLocale(context)
                                      .syncFavorites)),
                              ListTile(
                                leading: Icon(
                                  IconFont(0xe65b),
                                  color: Color(0xff737373),
                                ),
                                title: Text(GankLocalizations.of(context)
                                    .currentLocalized
                                    .logout),
                                onTap: () {
                                  UserManager.logout(context, callback: () {
                                    _controllerDrawer.reverse();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _gotoActivity(BuildContext context, Widget activity) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return activity;
    }));
  }
}
