import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intelligent_check_new/model/message/SubscribeInfo.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/services/myinfo_services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';

class SubscribePage extends StatefulWidget {
  @override
  _SubscribePageState createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  SubscribeInfo _subscribeInfo;
  List<String> selectedRoute = List();

//  List<CheckPlan> checkPlans = List();

  bool _before = false;
  bool _started = false;
  bool _after = false;

  TextEditingController _beforeController = new TextEditingController();
  TextEditingController _startedController = new TextEditingController();
  TextEditingController _afterController = new TextEditingController();

  String checkGroupValue = "";

  bool isSavedPressed = false;

//  List<NameValue> selectedRoutes = List();
  bool isAnimating = false;
  String theme = "";

  @override
  void initState() {
    super.initState();
    getData();
    initConfig();
  }

  initConfig() async {
    SharedPreferences.getInstance().then((preferences) {
      setState(() {
        this.theme =
            preferences.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  getData() async {
    await getSubscribe().then((data) {
      if (!mounted) return;
      setState(() {
        _subscribeInfo = data;

        if (_subscribeInfo != null) {
          //获取plan数据
          if (_subscribeInfo.plan != null) {
            for (SubItem planItem in _subscribeInfo.plan) {
              if (planItem.msgType == "planBeginApp") {
                _before = planItem.attribute1 == "False" ? false : true;
                _beforeController.text = planItem.attribute2 ?? "";
              }

              if (planItem.msgType == "planWarnApp") {
                _started = planItem.attribute1 == "False" ? false : true;
                _startedController.text = planItem.attribute2 ?? "";
              }
              if (planItem.msgType == "planEndApp") {
                _after = planItem.attribute1 == "False" ? false : true;
                _afterController.text = planItem.attribute2 ?? "";
              }
            }
          }
          //获取检查项
          if (_subscribeInfo.check != null) {
            for (SubItem checkItem in _subscribeInfo.check) {
              if (checkItem.attribute1 == "True") {
                checkGroupValue = checkItem.msgType;
              }
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_subscribeInfo == null) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 0.2,
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.keyboard_arrow_left,
                  color: GetConfig.getColor(theme), size: 32),
            ),
          ),
          //backgroundColor: KColorConstant.floorTitleColor,
          title: Text(
            '消息订阅',
            style: new TextStyle(
              color: Colors.black,
//            fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
      );
    }
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 246, 249, 1),
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: GetConfig.getColor(theme),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        //backgroundColor: KColorConstant.floorTitleColor,
        title: Text(
          '消息订阅',
          style: new TextStyle(
            color: Colors.black,
//            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          Container(
            width: 50,
            child: GestureDetector(
              child: Text(
                "保存",
                style:
                    TextStyle(color: GetConfig.getColor(theme), fontSize: 18),
              ),
              onTap: () {
                if (isSavedPressed) {
                  HiddenDangerFound.popUpMsg("正在保存数据...");
                  return false;
                } else {
                  List<SubItem> msgOrderRes = new List();
                  //添加check
                  msgOrderRes.addAll(_subscribeInfo.check);
                  //添加plan
                  for (SubItem item in _subscribeInfo.plan) {
                    //先赋值
                    if (item.msgType == "planBeginApp") {
                      item.attribute1 = _before ? "True" : "False";
                      item.attribute2 = _beforeController.text ?? "";
                    }

                    if (item.msgType == "planWarnApp") {
                      item.attribute1 = _started ? "True" : "False";
                      item.attribute2 = _startedController.text ?? "";
                    }
                    if (item.msgType == "planEndApp") {
                      item.attribute1 = _after ? "True" : "False";
                      item.attribute2 = _afterController.text ?? "";
                    }
                  }
                  msgOrderRes.addAll(_subscribeInfo.plan);
                  //添加Email
                  msgOrderRes.addAll(_subscribeInfo.email);

                  saveData(msgOrderRes);
                }
              },
            ),
            alignment: Alignment.centerLeft,
          )
        ],
      ),
      body: ModalProgressHUD(
        child: new ListView(
          children: <Widget>[
            //第一大块
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                    child: new Text(
                      '检查计划',
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
//                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Divider(
                      height: 0.5,
                      color: Color(0XFFd9d9d9),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 5, bottom: 5, right: 3),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: new Checkbox(
                              value: _before,
                              onChanged: (newValue) {
                                setState(() {
                                  _before = newValue;
                                });
                              }),
                        ),
                        Expanded(
                          flex: 3,
                          child: new Text('检查计划开始前'),
                        ),
                        Expanded(
                          flex: 2,
                          child: new Container(
                              margin: EdgeInsets.only(left: 3, right: 3),
                              color: Colors.grey[100],
                              height: 40.0,
                              width: 40.0,
                              child: new TextField(
                                controller: _beforeController,
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                ),
                              )),
                        ),
                        Expanded(
                          flex: 4,
                          child: new Text('分钟，推送消息提醒。'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Divider(
                      height: 0.5,
                      color: Color(0XFFd9d9d9),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 3, bottom: 3, right: 5),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: new Checkbox(
                              value: _started,
//                          activeColor: Colors.grey,
                              onChanged: (newValue) {
                                setState(() {
                                  _started = newValue;
                                });
                              }),
                        ),
                        Expanded(
                          flex: 3,
                          child: new Text('检查计划已开始'),
                        ),
                        Expanded(
                          flex: 2,
                          child: new Container(
                              margin: EdgeInsets.only(left: 3, right: 3),
                              color: Colors.grey[100],
                              height: 40.0,
                              width: 40.0,
                              child: new TextField(
                                controller: _startedController,
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                ),
                              )),
                        ),
                        Expanded(
                          flex: 4,
                          child: new Text('分钟未开始巡检，推送消息提醒。'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Divider(
                      height: 0.5,
                      color: Color(0XFFd9d9d9),
                    ),
                  ),
                  Container(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: new Checkbox(
                              value: _after,
//                          activeColor: Colors.grey,
                              onChanged: (newValue) {
                                setState(() {
                                  _after = newValue;
                                });
                              }),
                        ),
                        Expanded(
                          flex: 3,
                          child: new Text('检查计划后'),
                        ),
                        Expanded(
                          flex: 2,
                          child: new Container(
                              color: Colors.grey[100],
                              margin: EdgeInsets.only(left: 3, right: 3),
                              height: 40.0,
                              width: 40.0,
                              child: new TextField(
                                controller: _afterController,
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                ),
                              )),
                        ),
                        Expanded(
                          flex: 4,
                          child: new Container(
                            width: 180,
                            child: new Text('分钟有漏检点，推送消息提醒。'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Divider(
                      height: 0.5,
                      color: Color(0XFFd9d9d9),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
            ),
            //第二大块
            new Container(
              color: Colors.white,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                    child: new Text(
                      '检查记录',
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
//                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Divider(
                      height: 0.5,
                      color: Color(0XFFd9d9d9),
                    ),
                  ),
                  this._subscribeInfo.check != null
                      ? Column(
                          children: this._subscribeInfo.check.map((f) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  child: RadioListTile(
                                    value: f.msgType,
                                    title: new Text(f.attribute5),
                                    groupValue: checkGroupValue,
                                    onChanged: (val) {
                                      // val 与 value 的类型对应
                                      this.setState(() {
                                        checkGroupValue = val;
                                        this._subscribeInfo.check.forEach(
                                            (s) => s.attribute1 = "False");
                                        f.attribute1 = f.attribute1 == "False"
                                            ? "True"
                                            : "False";
                                      });
                                      var ss = 0;
                                    },
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                )
                              ],
                            );
                          }).toList(),
                        )
                      : Container(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
            ),
            //第三大块
            new Container(
              color: Colors.white,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                    child: new Text(
                      '邮件提醒',
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
//                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Divider(
                      height: 0.5,
                      color: Color(0XFFd9d9d9),
                    ),
                  ),
                  this._subscribeInfo.email != null
                      ? Column(
                          children: this._subscribeInfo.email.map((f) {
                            return Container(
                              child: Column(
                                children: <Widget>[
                                  CheckboxListTile(
                                    title: Text(
                                      f.attribute5,
                                    ),
                                    value: f.attribute1 == "True",
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    onChanged: (val) {
                                      setState(() {
                                        f.attribute1 = f.attribute1 == "True"
                                            ? "False"
                                            : "True";
                                      });
                                    },
                                  ),
                                  Divider(
                                    height: 1,
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      : Container(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
            ),
//            //关注的线路按钮
//            new TouchCallBack(
//              child: Container(
//                color: Colors.white,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    //标题
//                    Container(
//                      margin:
//                          EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
//                      child: new Text(
//                        '我关注的路线',
//                        style: new TextStyle(
//                          fontSize: 18.0,
//                          color: Colors.black,
////                        fontWeight: FontWeight.bold,
//                        ),
//                      ),
//                    ),
//                    //右侧icon
//                    Container(
//                        width: 50.0,
//                        height: 32.0,
//                        child: new Icon(
//                          Icons.arrow_forward_ios,
//                          color: GetConfig.getColor(theme),
//                        ))
//                  ],
//                ),
//              ),
//              onPressed: () {
//                Navigator.push(
//                  context,
//                  new MaterialPageRoute(
//                      builder: (context) => new LinesPage(selectedRoute)),
//                ).then((val) {
////                print(val);
//                  setState(() {
//                    List<NameValue> _selectedRoutes = val;
//                    this.selectedRoute = [];
//                    if (_selectedRoutes != null && _selectedRoutes.length > 0) {
//                      _selectedRoutes.forEach((f) {
//                        selectedRoute.add(f.value.toString());
//                      });
//                    }
//                  });
//                });
//              },
//            )
          ],
        ),
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }

  saveData(List<SubItem> msgOrderResult) {
    setState(() {
      isSavedPressed = true;
      isAnimating = true;
    });
    saveSubscribe(msgOrderResult).then((data) {
      setState(() {
        isSavedPressed = false;
        isAnimating = false;
      });
      if (data) {
        showAlertMessageOnly("数据保存成功！");
      } else {
        showAlertMessageOnly("数据保存失败！");
      }
    });
  }

  showAlertMessageOnly(String text) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => new AlertDialog(
                title: Column(
                  children: <Widget>[
                    new Text("信息"),
                    Divider(height: 2),
                  ],
                ),
                content: Text(text),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("关闭",
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ])).then((v) {
      return v;
    });
  }
}
