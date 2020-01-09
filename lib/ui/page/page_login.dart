import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gank/api//api_github.dart';
import 'package:flutter_gank/common/constant/colors.dart';
import 'package:flutter_gank/common/constant/strings.dart';
import 'package:flutter_gank/common/localization/gank_localizations.dart';
import 'package:flutter_gank/common/manager/user_manager.dart';
import 'package:flutter_gank/redux/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LoginPage extends StatefulWidget {
  static const String ROUTER_NAME = 'login';

  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final BasicMessageChannel<String> platform =
      const BasicMessageChannel<String>(
          AppStrings.FLUTTER_MESSAGE_CHANNEL_NAME, const StringCodec());

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  MethodChannel flutterNativePlugin;
  String _userName, _password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, ThemeData>(
        converter: (store) => store.state.themeData,
        builder: (context, themeData) => Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      themeData.primaryColor,
                      AppColors.COLOR_GRADIENT_END
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[_buildSignIn(context, themeData)],
                  ),
                  SafeArea(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 30,
                        )),
                  )),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        GankLocalizations.of(context).currentLocalized.loginTip,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontFamily: "WorkSansMedium"),
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: !isLoading,
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  )
                ],
              ),
            ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    flutterNativePlugin =
        MethodChannel(AppStrings.FLUTTER_NATIVE_PLUGIN_CHANNEL_NAME);
    platform.setMessageHandler(_handlePlatformMessage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<Null> _handlePlatformMessage(String message) async {
    Map pushData = json.decode(message);
    UserManager.login(context, (success) {
      setState(() {
        isLoading = false;
      });
    }, code: pushData['code']);
  }

  Widget _buildSignIn(BuildContext context, ThemeData themeData) {
    return Container(
      padding: EdgeInsets.only(top: 150.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          onChanged: (value) {
                            _userName = value;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              IconData(0xe653, fontFamily: 'IconFont'),
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: GankLocalizations.of(context)
                                .currentLocalized
                                .userNameHint,
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: true,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          onChanged: (value) {
                            _password = value;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              IconData(0xe659, fontFamily: 'IconFont'),
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: GankLocalizations.of(context)
                                .currentLocalized
                                .passWordHint,
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 170.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: themeData.primaryColor,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: AppColors.COLOR_GRADIENT_END,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                      colors: [
                        AppColors.COLOR_GRADIENT_END,
                        themeData.primaryColor
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: AppColors.COLOR_GRADIENT_END,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      UserManager.login(context, (success) {
                        setState(() {
                          isLoading = false;
                        });
                      }, username: _userName, password: _password);
                    }),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    "Or",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "WorkSansMedium"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                await flutterNativePlugin.invokeMethod(
                    'oAuthInBrowser', {'url': GithubApi.browserOAuth2Url});
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  IconData(0xe612, fontFamily: 'IconFont'),
                  size: 30,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
