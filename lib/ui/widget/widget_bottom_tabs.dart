import 'package:flutter/material.dart';
import 'package:flutter_gank/common/localization/gank_localizations.dart';
import 'package:flutter_gank/common/utils/common_utils.dart';
import 'package:flutter_gank/ui/widget/widget_icon_font.dart';

class BottomTabs extends StatefulWidget {
  final PageController pageController;
  final ValueChanged<int> onTap;

  BottomTabs(this.pageController, this.onTap);

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var _bottomTabs = <BottomNavigationBarItem>[
      ///最新
      BottomNavigationBarItem(
        icon: Icon(IconFont(0xe67f)),
        title: Text(CommonUtils.getLocale(context).gankNew),
      ),

      ///分类
      BottomNavigationBarItem(
        icon: Icon(IconFont(0xe603)),
        title:
            Text(GankLocalizations.of(context).currentLocalized.gankCategory),
      ),

      ///妹纸
      BottomNavigationBarItem(
        icon: Icon(IconFont(0xe637)),
        title: Text(CommonUtils.getLocale(context).girl),
      ),

      ///文章
      BottomNavigationBarItem(
        icon: Icon(IconFont(0xe64f)),
        title:
            Text(GankLocalizations.of(context).currentLocalized.article),
      ),
    ];
    return BottomNavigationBar(
      items: _bottomTabs,
      type: BottomNavigationBarType.fixed,
      iconSize: 32,
      currentIndex: currentIndex,
      onTap: (int index) {
        if (widget.onTap != null) {
          currentIndex = index;
          widget.pageController.jumpToPage(index);
          widget.onTap(index);
        }
      },
    );
  }
}
