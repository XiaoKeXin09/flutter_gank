import 'package:flutter/material.dart';
import 'package:flutter_gank/common/event/event_refresh_new.dart';
import 'package:flutter_gank/common/event/event_show_history_date.dart';
import 'package:flutter_gank/common/manager/app_manager.dart';
import 'package:flutter_gank/common/utils/time_utils.dart';

class HistoryDate extends StatefulWidget {
  final List _historyData;

  HistoryDate(this._historyData);

  @override
  _HistoryDateState createState() =>
      _HistoryDateState();
}

class _HistoryDateState extends State<HistoryDate>
    with TickerProviderStateMixin {
  Animation<Offset> _historyDateDetailsPosition;
  AnimationController _controllerHistoryDate;
  Animation<double> _historyDateContentsOpacity;
  Animatable<Offset> _historyDateDetailsTween;

  ///当前日期
  String _currentDate;

  ///是否显示历史日期一栏
  bool _showHistoryDate = false;

  @override
  void initState() {
    super.initState();

    ///初始化动画相关
    _controllerHistoryDate = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _historyDateContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controllerHistoryDate),
      curve: Curves.fastOutSlowIn,
    );
    _historyDateDetailsTween = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).chain(CurveTween(
      curve: Curves.fastOutSlowIn,
    ));
    _historyDateDetailsPosition =
        _controllerHistoryDate.drive(_historyDateDetailsTween);

    ///设置当前高亮日期
    if (widget._historyData != null && widget._historyData.isNotEmpty) {
      _currentDate = widget._historyData[0];
    }

    ///事件监听
    AppManager.eventBus.on<ShowHistoryDateEvent>().listen((event) {
      if (mounted) {
        if (event.forceHide) {
          _showHistoryDate = false;
        } else {
          _showHistoryDate = !_showHistoryDate;
        }
        if (_showHistoryDate)
          _controllerHistoryDate.forward();
        else
          _controllerHistoryDate.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _historyDateDetailsPosition,
      child: FadeTransition(
        opacity: ReverseAnimation(_historyDateContentsOpacity),
        child: Card(
          elevation: 5,
          margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
          child: Container(
            color: Colors.white,
            height: 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget._historyData == null
                    ? 0
                    : widget._historyData.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentDate = widget._historyData[i];
                      });
                      AppManager.eventBus
                          .fire(RefreshNewPageEvent(_currentDate));
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  getDay(widget._historyData[i]),
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2
                                      .copyWith(
                                          fontSize: 18,
                                          color: (widget._historyData[i] ==
                                                  _currentDate)
                                              ? Theme.of(context).primaryColor
                                              : Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3.0, bottom: 2),
                                  child: Text(
                                    getWeekDay(widget._historyData[i]),
                                    style: Theme.of(context)
                                        .textTheme
                                        .body2
                                        .copyWith(
                                            fontSize: 8,
                                            color: (widget._historyData[i] ==
                                                    _currentDate)
                                                ? Theme.of(context).primaryColor
                                                : Colors.black),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 3.0, bottom: 2.0),
                              child: Text(
                                getMonth(widget._historyData[i]),
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .copyWith(
                                        fontSize: 8,
                                        color: (widget._historyData[i] ==
                                                _currentDate)
                                            ? Theme.of(context).primaryColor
                                            : Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
