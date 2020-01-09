import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/api/api_github.dart';
import 'package:flutter_gank/common/constant/strings.dart';
import 'package:flutter_gank/common/event/event_refresh_db.dart';
import 'package:flutter_gank/common/localization/gank_localizations.dart';
import 'package:flutter_gank/common/manager/app_manager.dart';
import 'package:flutter_gank/common/model/gank_item.dart';
import 'package:flutter_gank/common/model/github_user.dart';
import 'package:flutter_gank/common/utils/common_utils.dart';
import 'package:flutter_gank/common/utils/navigator_utils.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_gank/ui/widget/widget_dialog_item.dart';
import 'package:flutter_gank/ui/widget/widget_icon_font.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:objectdb/objectdb.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FavoriteManager {
  static ObjectDB db;

  static init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path =
        join(documentsDirectory.path, "${AppStrings.STRING_DB_FAVORITE}");
    db = ObjectDB(path);
    await db.open();
  }

  static insert(GankItem gankItem) async {
    await db.insert(gankItem.toJsonMap());
  }

  static find(Map<dynamic, dynamic> query) async {
    return await db.find(query);
  }

  static remove(GankItem gankItem) async {
    await db.remove({'itemId': gankItem.itemId});
  }

  static _clearFavorites() async {
    await db.remove({});
  }

  static clearFavorites(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: Text(CommonUtils.getLocale(context).tips),
                content:
                    Text(CommonUtils.getLocale(context).confirmClearFavorites),
                actions: <Widget>[
                  FlatButton(
                      child: Text(CommonUtils.getLocale(context).cancel),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  FlatButton(
                      child: Text(CommonUtils.getLocale(context).confirm),
                      onPressed: () async {
                        await FavoriteManager._clearFavorites();
                        Fluttertoast.showToast(
                            msg: GankLocalizations.of(context)
                                .currentLocalized
                                .clearFavoritesSuccess,
                            backgroundColor: Colors.black,
                            gravity: ToastGravity.CENTER,
                            textColor: Colors.white);
                        AppManager.eventBus.fire(RefreshDBEvent());
                        Navigator.pop(context);
                      })
                ]));
  }

  static closeDB() async => await db.close();

  static uploadFavoritesToServer(BuildContext context) async {
    try {
      User user = StoreProvider.of<AppState>(context).state.userInfo;
      if (user == null) {
        NavigatorUtils.goLogin(context);
        return CommonUtils.getLocale(context).pleaseLogin;
      }
      var userGists = await GithubApi.listUserGists(user.login, user.token);
      String favoriteGistId;
      for (var gist in userGists) {
        if (gist['files'].containsKey('favorites.json')) {
          favoriteGistId = gist['id'];
          break;
        }
      }
      if (favoriteGistId == null) {
        favoriteGistId = await GithubApi.createFlutterGankGist(user.token);
      }
      var favoriteJson = json.encode(await find({}));
      GithubApi.editFlutterGankGist(user.token, favoriteGistId, favoriteJson);
      return CommonUtils.getLocale(context).uploadFavoritesSuccess;
    } catch (e) {
      return CommonUtils.getLocale(context).uploadFavoritesFail;
    }
  }

  static downloadFavoritesFromServer(BuildContext context) async {
    try {
      User user = StoreProvider.of<AppState>(context).state.userInfo;
      if (user == null) {
        NavigatorUtils.goLogin(context);
        return CommonUtils.getLocale(context).pleaseLogin;
      }
      var userGists = await GithubApi.listUserGists(user.login, user.token);
      String favoriteGistId;
      for (var gist in userGists) {
        if (gist['files'].containsKey('favorites.json')) {
          favoriteGistId = gist['id'];
          break;
        }
      }
      if (favoriteGistId != null) {
        var favoritesJson = json
            .decode(await GithubApi.getUserGist(user.token, favoriteGistId));
        _clearFavorites();
        for (var gankItemJson in favoritesJson) {
          insert(GankItem.fromJson(gankItemJson));
        }
        AppManager.eventBus.fire(RefreshDBEvent());
        return CommonUtils.getLocale(context).downloadFavoritesSuccess;
      } else {
        return CommonUtils.getLocale(context).serverHasNoFavorites;
      }
    } catch (e) {
      return CommonUtils.getLocale(context).downloadFavoritesFail;
    }
  }

  static syncFavorites(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
                title: Text(CommonUtils.getLocale(context).syncMethod),
                children: <Widget>[
                  DialogItem(
                      icon: IconFont(0xe741),
                      color: AppManager.getThemeData(context).primaryColor,
                      text: CommonUtils.getLocale(context).syncMethodUpload,
                      onPressed: () async {
                        Navigator.pop(context);
                        CommonUtils.showToast(
                            await FavoriteManager.uploadFavoritesToServer(
                                context));
                      }),
                  DialogItem(
                      icon: IconFont(0xe742),
                      color: AppManager.getThemeData(context).primaryColor,
                      text: CommonUtils.getLocale(context).syncMethodDownload,
                      onPressed: () async {
                        Navigator.pop(context);
                        CommonUtils.showToast(
                            await FavoriteManager.downloadFavoritesFromServer(
                                context));
                      }),
                  DialogItem(
                      icon: IconFont(0xe662),
                      text: CommonUtils.getLocale(context).syncMethodMerge,
                      onPressed: () {
                        Navigator.pop(context);
                        CommonUtils.showToast(
                            CommonUtils.getLocale(context).supportLater);
                      },
                      color: AppManager.getThemeData(context).primaryColor),
                ]));
  }
}
