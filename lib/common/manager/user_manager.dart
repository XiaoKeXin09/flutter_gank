import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gank/api/api_github.dart';
import 'package:flutter_gank/common/localization/gank_localizations.dart';
import 'package:flutter_gank/common/model/github_user.dart';
import 'package:flutter_gank/common/utils/common_utils.dart';
import 'package:flutter_gank/common/utils/sp_utils.dart';
import 'package:flutter_gank/config/gank_config.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_gank/redux/redux_user.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';

class UserManager {
  ///获取本地登录用户信息
  static Future<User> getUserFromLocalStorage() async {
    var userInfoJson = await SPUtils.get(GankConfig.USER_INFO);
    if (userInfoJson != null) {
      var userMap = json.decode(userInfoJson);
      User user = User.fromJson(userMap);
      return user;
    }
    return null;
  }

  ///登录
  static login(context, callback, {username, password, code}) async {
    try {
      User user;
      if (code != null) {
        user = await GithubApi.login(code: code);
      } else {
        user = await GithubApi.login(username: username, password: password);
      }
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserAction(user));
      if (user != null) {
        Fluttertoast.showToast(
            msg: GankLocalizations.of(context)
                .currentLocalized
                .loginSuccess,
            backgroundColor: Colors.black,
            gravity: ToastGravity.CENTER,
            textColor: Colors.white);
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
            msg: GankLocalizations.of(context)
                .currentLocalized
                .loginFailed,
            backgroundColor: Colors.black,
            gravity: ToastGravity.CENTER,
            textColor: Colors.white);
      }
      if (callback != null) callback(true);
    } catch (e) {
      Fluttertoast.showToast(
          msg: GankLocalizations.of(context)
              .currentLocalized
              .loginFailed,
          backgroundColor: Colors.black,
          gravity: ToastGravity.CENTER,
          textColor: Colors.white);
      if (callback != null) callback(false);
    }
  }

  static _logout(store) async {
    await SPUtils.remove(GankConfig.USER_INFO);
    store.dispatch(UpdateUserAction(null));
  }

  static logout(context, {callback}) async {
    var store = StoreProvider.of<AppState>(context);
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: Text('提示'),
                content: Text('确定要退出登录吗?'),
                actions: <Widget>[
                  FlatButton(
                      child: const Text('取消'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  FlatButton(
                      child: const Text('确定'),
                      onPressed: () async {
                        if (callback != null) callback();
                        await UserManager._logout(store);
                        CommonUtils.showToast(GankLocalizations.of(context)
                            .currentLocalized
                            .logoutSuccess);
                        Navigator.pop(context);
                      })
                ]));
  }

  static saveUserToLocalStorage(User user) async {
    await SPUtils.save(GankConfig.USER_INFO, user.toJson());
  }

  ///更新用户信息
  static updateUserDao(params, Store store) async {}

  ///点赞
  static starFlutterGank(Store store) async {}
}
