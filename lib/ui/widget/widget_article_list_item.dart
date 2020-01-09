import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/common/utils/time_utils.dart';
import 'package:flutter_gank/ui/page/page_article_web_view.dart';
import 'package:flutter_gank/ui/page/page_gallery.dart';

class ArticleListItem extends StatefulWidget {
  final articleItem;

  ArticleListItem(this.articleItem);

  @override
  _ArticleListItemState createState() => _ArticleListItemState();
}

class _ArticleListItemState extends State<ArticleListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ArticleWebViewPage(widget.articleItem);
        }));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border(
              bottom:
                  BorderSide(width: 0.0, color: Theme.of(context).dividerColor),
            )),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildArticleListItem(context),
          ),
        ),
      ),
    );
  }

  ///build gank list item.
  List<Widget> _buildArticleListItem(BuildContext context) {
    var contentWidgets = <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 10),
              child: Text(
                widget.articleItem['content']?.isEmpty ?? true
                    ? widget.articleItem['summaryInfo']
                    : widget.articleItem['content'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.person_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: SizedBox(
                            width: 100,
                            child: Text(
                              widget.articleItem['user']['username'],
                              maxLines: 1,
                              style: Theme.of(context).textTheme.body2,
                              overflow: TextOverflow.ellipsis,
                            )),
                      )
                    ],
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.access_time,
                            color: Theme.of(context).primaryColor),
                        Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child: Text(
                            formatDateStr(widget.articleItem['createdAt']),
                            style: Theme.of(context).textTheme.body2,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];

    ///添加右侧缩略图显示
    if (widget.articleItem['screenshot'] != null &&
        widget.articleItem['screenshot'].isNotEmpty) {
      var imageUrl = widget.articleItem['screenshot'];
      contentWidgets.add(GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return GalleryPage([imageUrl], "");
            }));
          },
          child: Container(
            margin: EdgeInsets.only(right: 16, top: 20, bottom: 20),
            width: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(imageUrl),
              ),
            ),
          )));
    }
    return contentWidgets;
  }
}
