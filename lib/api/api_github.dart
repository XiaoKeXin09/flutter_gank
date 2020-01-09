import 'dart:convert';

import 'package:flutter_gank/common/manager/user_manager.dart';
import 'package:flutter_gank/common/model/github_user.dart';
import 'package:flutter_gank/common/network/http_manager.dart';
import 'package:flutter_gank/common/network/http_response.dart';
import 'package:flutter_gank/config/gank_config.dart';

class GithubApi {
  static const List<String> GANK_OAUTH2_SCOPE = [
    'user',
    'repo',
    'gist',
    'notifications'
  ];
  static String browserOAuth2Url =
      'https://github.com/login/oauth/authorize?client_id=${GankConfig.CLIENT_ID}&scope=${GANK_OAUTH2_SCOPE.join(',')}&state=${DateTime.now().millisecondsSinceEpoch}';

  static Future<User> login(
      {String username, String password, String code}) async {
    String token;
    if (code != null) {
      token = await GithubApi.getTokenFromBrowserCode(code);
    } else {
      token = await GithubApi.getTokenFromPassword(username, password);
    }
    return await getUserInfo(token);
  }

  static Future<String> getTokenFromPassword(
      String userName, String password) async {
    String authorizationUrl = 'https://api.github.com/authorizations';
    String basic = "Basic ${base64Encode(utf8.encode("$userName:$password"))}";
    var response = await HttpManager.instance.request(authorizationUrl,
        params: {
          "client_id": GankConfig.CLIENT_ID,
          "client_secret": GankConfig.CLIENT_SECRET,
          "note": GankConfig.NOTE,
          "noteUrl": GankConfig.NOTE_URL,
          "scopes": GANK_OAUTH2_SCOPE
        },
        header: {"Authorization": basic, "cache-control": "no-cache"},
        method: HttpMethod.post);
    String token = response.data['token'];
    return token;
  }

  static String _getToken(String tokenStr) {
    List<String> tokenSplit = tokenStr.split('&');
    for (String str in tokenSplit) {
      if (str.startsWith('access_token')) {
        return str.split('=')[1];
      }
    }
    return null;
  }

  static Future<String> getTokenFromBrowserCode(String code) async {
    var response = await HttpManager.instance
        .request('https://github.com/login/oauth/access_token', params: {
      'client_id': GankConfig.CLIENT_ID,
      'client_secret': GankConfig.CLIENT_SECRET,
      'code': code
    });
    return _getToken(response.data);
  }

  static Future<User> getUserInfo(String accessToken) async {
    try {
      var response = await HttpManager.instance
          .request("https://api.github.com/user?access_token=$accessToken");
      var userInfo = response.data;
      userInfo['token'] = accessToken;
      User user = User.fromJson(userInfo);
      await UserManager.saveUserToLocalStorage(user);
      return user;
    } catch (e) {
      return null;
    }
  }

  static starFlutterGank(String accessToken) async {
    HttpResponse response = await HttpManager.instance.request(
        "https://api.github.com/user/starred/lijinshanmx/flutter_gank?access_token=$accessToken",
        method: HttpMethod.put);
    return response.code == 204;
  }

  static Future<String> createFlutterGankGist(String accessToken) async {
    Map payloadMap = Map();
    payloadMap['description'] =
        'this is flutter gank favorites json backup,这是flutter gank云端的json备份';
    payloadMap['public'] = false;
    Map filesMap = Map();
    Map contentMap = Map();
    contentMap['content'] = 'this is flutter gank favorites json backup.';
    filesMap['favorites.json'] = contentMap;
    payloadMap['files'] = filesMap;
    var response = await HttpManager.instance.request(
      'https://api.github.com/gists',
      params: json.encode(payloadMap),
      header: {'Authorization': 'Bearer $accessToken'},
      method: HttpMethod.post,
    );
    return response.data['id'];
  }

  static editFlutterGankGist(
      String accessToken, String gistId, String favoritesJson) async {
    Map payloadMap = Map();
    Map filesMap = Map();
    Map contentMap = Map();
    contentMap['content'] = favoritesJson;
    filesMap['favorites.json'] = contentMap;
    payloadMap['files'] = filesMap;
    await HttpManager.instance.request(
      'https://api.github.com/gists/$gistId',
      params: json.encode(payloadMap),
      header: {'Authorization': 'Bearer $accessToken'},
      method: HttpMethod.patch,
    );
  }

  static listUserGists(userName, accessToken) async {
    HttpResponse response = await HttpManager.instance.request(
        "https://api.github.com/users/$userName/gists?access_token=$accessToken");
    return response.data;
  }

  static Future<String> getUserGist(accessToken, gistId) async {
    HttpResponse response = await HttpManager.instance.request(
        "https://api.github.com/gists/$gistId?access_token=$accessToken");
    return response.data['files']['favorites.json']['content'];
  }
}
