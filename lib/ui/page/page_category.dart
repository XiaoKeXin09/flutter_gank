import 'package:flutter/material.dart';
import 'package:flutter_gank/common/constant/strings.dart';
import 'package:flutter_gank/common/localization/gank_localizations.dart';
import 'package:flutter_gank/ui/widget/widget_list_category.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TabController(vsync: this, length: AppStrings.GANK_ALL_CATEGORY_KEYS.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                border: Border(
                    bottom: BorderSide(
                        width: 0.0, color: Theme.of(context).dividerColor))),
            child: TabBar(
                controller: _controller,
                isScrollable: true,
                labelColor: Theme.of(context).primaryColor,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: GankLocalizations.of(context)
                    .currentLocalized
                    .gankAllCategories
                    .map<Widget>((page) {
                  return Tab(text: page);
                }).toList())),
        Expanded(
          child: TabBarView(
              controller: _controller,
              children:
                  AppStrings.GANK_ALL_CATEGORY_KEYS.map<Widget>((String page) {
                return GankListCategory(page);
              }).toList()),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
