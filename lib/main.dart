import 'package:flutter/material.dart';
import 'package:flutter_gank/common/constant/colors.dart';
import 'package:flutter_gank/common/localization/gank_localizations_delegate.dart';
import 'package:flutter_gank/common/localization/gank_localizations_wrapper.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_gank/ui/page/page_about.dart';
import 'package:flutter_gank/ui/page/page_articles.dart';
import 'package:flutter_gank/ui/page/page_home.dart';
import 'package:flutter_gank/ui/page/page_login.dart';
import 'package:flutter_gank/ui/page/page_search.dart';
import 'package:flutter_gank/ui/page/page_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(GankApp());

class GankApp extends StatelessWidget {
  ///init state
  final store = new Store<AppState>(
    appReducer,
    initialState: new AppState(
      userInfo: null,
      themeData: new ThemeData(
        primaryColor: AppColors.PRIMARY_DEFAULT_COLOR,
        platform: TargetPlatform.android,
      ),
      locale: Locale('zh', 'CH'),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreBuilder<AppState>(
        builder: (context, store) {
          return MaterialApp(
            theme: store.state.themeData,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GankLocalizationsDelegate.delegate,
            ],
            locale: store.state.locale,
            supportedLocales: [store.state.locale],
            routes: {
              SplashPage.ROUTER_NAME: (context) =>
                  ///Note that you only need to wrap the first open page,
                  ///and the BuildContext will be passed to the child widget tree.
                  GankLocalizationsWrapper(child: SplashPage()),
              HomePage.ROUTER_NAME: (context) => HomePage(),
              LoginPage.ROUTER_NAME: (context) => LoginPage(),
              SearchPage.ROUTER_NAME: (context) => SearchPage(),
              AboutPage.ROUTER_NAME: (context) => AboutPage(),
              ArticlePage.ROUTER_NAME: (context) => ArticlePage(),
            },
          );
        },
      ),
    );
  }
}
