import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/common/localization/gank_localizations.dart';
import 'package:flutter_gank/common/utils/common_utils.dart';
import 'package:flutter_gank/ui/widget/widget_link_text_span.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  static const String ROUTER_NAME = 'about';

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    TextStyle linkTextStyle = Theme.of(context).textTheme.body1.copyWith(
        color: Theme.of(context).accentColor,
        fontSize: 15,
        decoration: TextDecoration.underline);
    TextStyle linkTitleStyle = Theme.of(context).textTheme.body1;
    return Scaffold(
      appBar: AppBar(
        title: Text(CommonUtils.getLocale(context).about),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(CommonUtils.getLocale(context).introduction,
                    style: Theme.of(context).textTheme.title),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(height: 0.0),
                ),
                Text(CommonUtils.getLocale(context).gankDesc,
                    style: Theme.of(context).textTheme.body1),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Text(
                          CommonUtils.getLocale(context).sourceCode,
                          style: linkTitleStyle,
                        ),
                      ),
                      RichText(
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: Theme.of(context).accentColor,
                                fontSize: 15,
                                decoration: TextDecoration.underline),
                            text: "lijinshanmx/flutter_gank",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch(
                                    'https://github.com/lijinshanmx/flutter_gank');
                              })
                      ]))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Text(
                          CommonUtils.getLocale(context).officialWebSite,
                          style: linkTitleStyle,
                        ),
                      ),
                      RichText(
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: Theme.of(context).accentColor,
                                fontSize: 15,
                                decoration: TextDecoration.underline),
                            text: "https://gank.io/app/gank",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch('https://gank.io/app/gank');
                              })
                      ]))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(CommonUtils.getLocale(context).developer,
                      style: Theme.of(context).textTheme.title),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(height: 0.0),
                ),
                Text("lijinshanmx", style: Theme.of(context).textTheme.body1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Icon(
                          IconData(0xe845, fontFamily: "IconFont"),
                          size: 20,
                        ),
                      ),
                      RichText(
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: Theme.of(context).accentColor,
                                fontSize: 15,
                                decoration: TextDecoration.underline),
                            text: "https://github.com/lijinshanmx",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch('https://github.com/lijinshanmx');
                              })
                      ]))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(CommonUtils.getLocale(context).join,
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(color: Colors.cyan)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                      GankLocalizations.of(context)
                          .currentLocalized
                          .contribution,
                      style: Theme.of(context).textTheme.title),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(height: 0.0),
                ),
                Text(
                    GankLocalizations.of(context)
                        .currentLocalized
                        .gankContribution,
                    style: Theme.of(context).textTheme.body1),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                      GankLocalizations.of(context)
                          .currentLocalized
                          .openSourceLibrary,
                      style: Theme.of(context).textTheme.title),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Divider(height: 0.0),
                ),
                LinkTextSpan(
                    'cached_network_image',
                    'https://github.com/renefloor/flutter_cached_network_image',
                    linkTitleStyle,
                    linkTextStyle),
                LinkTextSpan(
                    'flutter_webview_plugin',
                    'https://github.com/dart-flitter/flutter_webview_plugin',
                    linkTitleStyle,
                    linkTextStyle),
                LinkTextSpan(
                    'flutter_toast',
                    'https://github.com/PonnamKarthik/FlutterToast',
                    linkTitleStyle,
                    linkTextStyle),
                LinkTextSpan(
                    'photo_view',
                    'https://github.com/renancaraujo/photo_view',
                    linkTitleStyle,
                    linkTextStyle),
                LinkTextSpan(
                    'flutter_pulltorefresh',
                    'https://github.com/peng8350/flutter_pulltorefresh',
                    linkTitleStyle,
                    linkTextStyle),
                LinkTextSpan('dio', 'https://github.com/flutterchina/dio',
                    linkTitleStyle, linkTextStyle),
                LinkTextSpan(
                    'objectdb',
                    'https://github.com/netz-chat/objectdb',
                    linkTitleStyle,
                    linkTextStyle),
                LinkTextSpan(
                    'event-bus',
                    'http://code.makery.ch/library/dart-event-bus',
                    linkTitleStyle,
                    linkTextStyle),
                LinkTextSpan(
                    'flutter_parallax',
                    'https://github.com/letsar/flutter_parallax',
                    linkTitleStyle,
                    linkTextStyle),
                LinkTextSpan(
                    'url_launcher',
                    'https://github.com/flutter/plugins/tree/master/packages/url_launcher',
                    linkTitleStyle,
                    linkTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
