import 'package:flutter/material.dart';
import 'package:flutter_gank/common/model/github_user.dart';

import 'package:flutter_gank/redux/redux_theme.dart';
import 'package:flutter_gank/redux/redux_user.dart';
import 'package:flutter_gank/redux/redux_locale.dart';
/**
 * Redux全局State
 * Created by lijinshan
 * Date: 2019-01-04
 */

///全局Redux store 的对象，保存State数据
class AppState {
  ///用户信息
  User userInfo;

  ///主题数据
  ThemeData themeData;

  ///语言
  Locale locale;

  ///当前手机平台默认语言
  Locale platformLocale;

  ///构造方法
  AppState({this.userInfo, this.themeData, this.locale});
}

///创建 Reducer
///源码中 Reducer 是一个方法 typedef State Reducer<State>(State state, dynamic action);
///我们自定义了 appReducer 用于创建 store
AppState appReducer(AppState state, action) {
  return AppState(
      userInfo: combineUserReducer(state.userInfo, action),
      themeData: combineThemeDataReducer(state.themeData, action),
      locale: combineLocaleReducer(state.locale, action));
}
