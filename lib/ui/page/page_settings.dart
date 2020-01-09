import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gank/common/constant/strings.dart';
import 'package:flutter_gank/common/localization/gank_localizations.dart';
import 'package:flutter_gank/common/manager/app_manager.dart';
import 'package:flutter_gank/common/manager/favorite_manager.dart';
import 'package:flutter_gank/common/manager/user_manager.dart';
import 'package:flutter_gank/common/model/github_user.dart';
import 'package:flutter_gank/common/utils/common_utils.dart';
import 'package:flutter_gank/common/utils/navigator_utils.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  static const String ROUTER_NAME = 'setting';

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  MethodChannel flutterNativePlugin;
  String _version;
  User currentUser;

  @override
  void initState() {
    super.initState();
    _initVersion();
  }

  void _initVersion() {
    flutterNativePlugin =
        MethodChannel(AppStrings.FLUTTER_NATIVE_PLUGIN_CHANNEL_NAME);
    flutterNativePlugin.invokeMethod('getversion').then((v) {
      setState(() {
        _version = v;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(CommonUtils.getLocale(context).settings),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    CommonUtils.showThemeDialog(context);
                  },
                  title: Text(CommonUtils.getLocale(context).themeSetting,
                      style: Theme.of(context).textTheme.body1),
                  trailing: Icon(Icons.chevron_right, color: Colors.black),
                ),
                ListTile(
                  onTap: () {
                    CommonUtils.showLanguageDialog(context);
                  },
                  title: Text(CommonUtils.getLocale(context).languageSetting,
                      style: Theme.of(context).textTheme.body1),
                  trailing: Icon(Icons.chevron_right, color: Colors.black),
                ),
                ListTile(
                  onTap: () {
                    FavoriteManager.syncFavorites(context);
                  },
                  title: Text(CommonUtils.getLocale(context).syncFavorites,
                      style: Theme.of(context).textTheme.body1),
                  trailing: Icon(Icons.chevron_right, color: Colors.black),
                ),
                ListTile(
                  onTap: () async {
                    FavoriteManager.clearFavorites(context);
                  },
                  title: Text(CommonUtils.getLocale(context).clearFavorites,
                      style: Theme.of(context).textTheme.body1),
                  trailing: Icon(Icons.chevron_right, color: Colors.black),
                ),
                ListTile(
                  onTap: () async {
                    flutterNativePlugin.invokeMethod('openFeedbackActivity');
                  },
                  title: Text(
                      GankLocalizations.of(context).currentLocalized.feedBack,
                      style: Theme.of(context).textTheme.body1),
                  trailing: Icon(Icons.chevron_right, color: Colors.black),
                ),
                ListTile(
                  onTap: () async {
                    Fluttertoast.showToast(
                        msg: GankLocalizations.of(context)
                            .currentLocalized
                            .beDeveloperTip,
                        backgroundColor: Colors.black,
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.white);
                  },
                  title: Text(
                      GankLocalizations.of(context)
                          .currentLocalized
                          .beDeveloper,
                      style: Theme.of(context).textTheme.body1),
                  trailing: Icon(Icons.chevron_right, color: Colors.black),
                ),
                ListTile(
                  onTap: () async {
                    AppManager.starFlutterGank(context);
                  },
                  title: Text(
                      GankLocalizations.of(context).currentLocalized.sourceStar,
                      style: Theme.of(context).textTheme.body1),
                  trailing: Icon(Icons.chevron_right, color: Colors.black),
                ),
                ListTile(
                  onTap: () async {
                    launch(
                        'https://github.com/lijinshanmx/flutter_gank/issues');
                  },
                  title: Text(CommonUtils.getLocale(context).sourceIssuePR,
                      style: Theme.of(context).textTheme.body1),
                  trailing: Icon(Icons.chevron_right, color: Colors.black),
                ),
                ListTile(
                  onTap: () async {
                    NavigatorUtils.goAbout(context);
                  },
                  title: Text(CommonUtils.getLocale(context).about,
                      style: Theme.of(context).textTheme.body1),
                  trailing: Icon(Icons.chevron_right, color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: ListTile(
                    onTap: () async {
                      AppManager.checkUpdate(context);
                    },
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(CommonUtils.getLocale(context).checkUpdate,
                            style: Theme.of(context).textTheme.body1),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: FutureBuilder<PackageInfo>(
                            builder: _buildVersion,
                            future: PackageInfo.fromPlatform(),
                          ),
                        )
                      ],
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.black),
                  ),
                ),
              ],
            ),
            StoreConnector<AppState, User>(
              converter: (store) => store.state.userInfo,
              builder: (context, userInfo) => Offstage(
                    offstage: userInfo == null,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            UserManager.logout(context);
                          },
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black, width: 3.0),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Text(CommonUtils.getLocale(context).logout,
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
            ),
          ],
        ));
  }

  Widget _buildVersion(
      BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
    return Text(
      snapshot.data?.version ?? "",
      style: Theme.of(context).textTheme.body2.copyWith(
            fontSize: 10,
            color: Colors.black,
          ),
    );
  }
}
