import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/api//api_gank.dart';
import 'package:flutter_gank/common/localization/gank_localizations.dart';
import 'package:flutter_gank/common/utils/common_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SubmitPage extends StatefulWidget {
  @override
  SubmitPageState createState() => SubmitPageState();
}

class SubmitPageState extends State<SubmitPage> {
  String _url = '', _who = '', _desc = '';
  bool _saveNeeded = false;
  int _selectedItemIndex = 1;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Future<bool> _onWillPop() async {
    _saveNeeded = _url.isNotEmpty || _who.isNotEmpty || _desc.isNotEmpty;
    if (!_saveNeeded) return true;
    final TextStyle dialogTextStyle = Theme.of(context).textTheme.subhead;
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                  GankLocalizations.of(context)
                      .currentLocalized
                      .abandonSubmitConfirm,
                  style: dialogTextStyle),
              actions: <Widget>[
                FlatButton(
                    child: Text(CommonUtils.getLocale(context).confirm),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    }),
                FlatButton(
                  child: Text(CommonUtils.getLocale(context).cancel),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: _selectedItemIndex);
    return Scaffold(
      appBar: AppBar(
          title: Text(CommonUtils.getLocale(context).submitGanHuo),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.done),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    var result = await GankApi.submitData(
                        _url,
                        _desc,
                        _who,
                        GankLocalizations.of(context)
                            .currentLocalized
                            .submitType[_selectedItemIndex]);
                    Fluttertoast.showToast(
                        msg: result['msg'],
                        backgroundColor: Colors.black,
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.white);
                    if (!result['error']) {
                      Navigator.pop(context);
                    }
                  }
                })
          ]),
      body: Form(
          key: _formKey,
          onWillPop: _onWillPop,
          child:
              ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
            Container(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                alignment: Alignment.bottomLeft,
                child: TextFormField(
                    decoration: InputDecoration(
                        labelText: CommonUtils.getLocale(context).url,
                        hintText: '请输入干货的网址',
                        filled: true),
                    validator: (val) {
                      return val.isEmpty ? "网址不能为空" : null;
                    },
                    onSaved: (String value) {
                      _url = value;
                    })),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                alignment: Alignment.bottomLeft,
                child: TextFormField(
                    decoration: InputDecoration(
                        labelText: CommonUtils.getLocale(context).desc,
                        hintText: '请输入干货的简要描述',
                        filled: true),
                    validator: (val) {
                      return val.isEmpty ? "描述不能为空" : null;
                    },
                    onSaved: (String value) {
                      _desc = value;
                    })),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                alignment: Alignment.bottomLeft,
                child: TextFormField(
                    decoration: InputDecoration(
                        labelText: CommonUtils.getLocale(context).who,
                        hintText: '请输入干货的署名',
                        filled: true),
                    validator: (val) {
                      return val.isEmpty ? "昵称不能为空" : null;
                    },
                    onSaved: (String value) {
                      _who = value;
                    })),
            Container(
              padding: const EdgeInsets.only(top: 30.0),
              height: 120,
              child: CupertinoPicker(
                backgroundColor: Colors.transparent,
                scrollController: scrollController,
                itemExtent: 40,
                onSelectedItemChanged: (int index) {
                  setState(() => _selectedItemIndex = index);
                },
                children: List<Widget>.generate(
                    GankLocalizations.of(context)
                        .currentLocalized
                        .submitType
                        .length, (int index) {
                  return Center(
                    child: Text(
                        GankLocalizations.of(context)
                            .currentLocalized
                            .submitType[index],
                        style: Theme.of(context).textTheme.body1),
                  );
                }),
              ),
            ), //                Container(
          ])),
    );
  }
}
