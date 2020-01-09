import 'package:flutter_gank/common/network/http_manager.dart';
import 'package:flutter_gank/common/network/http_response.dart';
import 'package:flutter_gank/config/gank_config.dart';

class ArticleApi {
  static Future getJueJinFlutterArticles(int page) async {
    String url =
        'https://timeline-merger-ms.juejin.im/v1/get_tag_entry?src=web&tagId=5a96291f6fb9a0535b535438'
        '&page=$page&pageSize=${GankConfig.PAGE_SIZE}'
        '&sort=createdAt';
    HttpResponse response = await HttpManager.instance.request(url);
    return response.data;
  }
}
