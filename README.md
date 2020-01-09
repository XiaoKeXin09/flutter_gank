<p align="center">
  <a href="http://gank.io">
    <img alt="gank.io" src="https://ws1.sinaimg.cn/large/0065oQSqly1fyli3kk857j305c05cjrc.jpg" width="140">
  </a>
</p>
<p align="center">干货集中营「官方版」</p>

<p align="center">
  <img src="https://img.shields.io/badge/build-passing-52C434.svg">
  <img src="https://img.shields.io/badge/version-1.0.3-52C434.svg">
  <img src="https://img.shields.io/badge/flutterSdk-1.6.6-red.svg">
  <img src="https://img.shields.io/badge/language-dart2.3.2-blue.svg">
  <img src="https://img.shields.io/badge/license-MIT-orange.svg">
</p>

# 简介
「干货集中营」是一款注重体验的 Gank.io 官方客户端，App整体秉承Material简洁风格，包含搜索，收藏，提交干货，按期浏览、分类浏览等功能，还有漂亮的妹纸等你哦，快来[下载体验](https://raw.githubusercontent.com/lijinshanmx/flutter_gank/master/apks/app-release-latest.apk)吧~

## 应用截图

| ![1](https://ws1.sinaimg.cn/large/0065oQSqly1fyt98vkcuxj30ps18yh9c.jpg) | ![2](https://ws1.sinaimg.cn/large/0065oQSqly1fylfbqnnzrj30ps18ywwv.jpg) | ![3](https://ws1.sinaimg.cn/large/0065oQSqly1fylfc4r4mgj30ps18ye81.jpg) | ![4](https://ws1.sinaimg.cn/large/0065oQSqly1fylhxlnd24j30ps18ydx3.jpg) | ![5](https://ws1.sinaimg.cn/large/0065oQSqly1fyt99whhpij30ps18yhdt.jpg) |
| :--: | :--: | :--: | :--: | :--: |
| 首页 | 分类 | 妹纸 | 收藏 | 干货历史|


## 下载

| 类型          | 二维码                                      |
| ----------- | ---------------------------------------- |
| **安卓下载**  | <img src="https://ws1.sinaimg.cn/large/0065oQSqly1fywl59574cj308c08c0sp.jpg" width = "160"  alt="qr_apk" /> |
| **IOS暂无下载** | <img src="https://ws1.sinaimg.cn/large/0065oQSqly1fynmxdifkmj306o05udgf.jpg" width = "160"  alt="qr_ios" /> |

## Todo

- [x] 用户登录(Github,现已支持密码和浏览器登录两种方式)
- [x] 收藏同步到云端【现已支持:上传本地到云端，下载云端到本地】
- [x] 多主题切换【目前有10种主题色:海棠红,鸢尾蓝,孔雀绿,柠檬黄,藤萝紫,暮云灰,虾壳青,牡丹粉,筍皮棕】
- [x] 多语言支持
- [x] 重构代码
- [x] 英文翻译完善
- [x] 网络缓存实现

## 版本更新记录
### V1.0.3  [2019-05-31]
  1、升级Flutter插件.
  2、Android依赖替换为androidx,解决新版编译报错.
  3、修复福利页面Log报错.
  4、bug fix.
### V1.0.2  [2018-01-03]  
  1、ui调整.  
  2、添加Github登录.  
  3、添加历史干货页面.  
  4、bug fix. 
### V1.0.1  [2018-12-29]  
  1、ui调整.  
  2、添加用户反馈.  
  3、添加设置页面.  
  4、bug fix.  
### V1.0.0  [2018-12-28]  
  1、first release 版本.  
  2、搭建了基础的项目框架结构.  
  3、实现了最新，分类，妹纸图，搜索等基本功能.  
  4、添加了APP在线更新.

## 编译运行

> 注意:运行之前，记得pull下代码，因为代码可能已经更新~

```bash
$ flutter run [--release]
```

## 功能

- 按期、按类别浏览
- 收藏
- 搜索
- 提交干货
- **妹子图**


## Developers

- [lijinshanmx](https://github.com/lijinshanmx)  
- [SwiftyWang](https://github.com/SwiftyWang)  


## FAQ

- 运行提示:FormatException: Bad UTF-8 encoding  
   编码问题，解决方法参考[Issue#2](https://github.com/lijinshanmx/flutter_gank/issues/2)  
- Tab切换页面或者调用Navigator.push会销毁重绘  
   解决方法：使用官方的AutomaticKeepAliveClientMixin，但是请注意：  
   在widget build函数中记得调用super函数: [super.build(context)](https://github.com/lijinshanmx/flutter_gank/commit/838ad9fa9c322b16672b2ddbbdefda2093af4e28);  
   官方注释：  
   /// A mixin with convenience methods for clients of [AutomaticKeepAlive]. Used  
   /// with [State] subclasses.  
   ///  
   /// Subclasses must implement [wantKeepAlive], and their [build] methods must  
   /// call `super.build` (the return value will always return null, and should be  
   /// ignored).    


## Thanks

[所有的开源的人](https://github.com)  
[干货集中营](http://gank.io/)    


### 第三方框架
> 当前 Flutter SDK 版本: 1.6.6 • channel dev • Dart 2.3.2 / Android Studio 3.4.1

项目中使用到的第三方library，感谢开源库作者们辛苦的付出~

库 | 功能
-------- | ---
**dio**|**网络框架**
**shared_preferences**|**本地数据缓存**
**fluttertoast**|**Toast**
**flutter_webview_plugin**|**浏览器**
**photo_view**|**图片预览**
**flutter_parallax**|**视差滚动**
**event_bus**|**全局事件分发**
**objectdb**|**对象数据库**
**pull_to_refresh**|**刷新组件**
**cached_network_image**|**图片加载**


## 贡献代码

请告知我们可以为你做些什么，不过在此之前，请检查一下是否有[已经存在的Bug或者意见](https://github.com/lijinshanmx/flutter_gank/issues)。

如果你是一个代码贡献者，请参考[代码贡献规范](CONTRIBUTING.md)。

## 开源协议

[MIT](LICENSE)
