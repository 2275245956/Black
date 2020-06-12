import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intelligent_check_new/model/name_value.dart';
import 'package:intelligent_check_new/pages/inspection_record/contact.dart';
import 'package:intelligent_check_new/services/company_services.dart';
import 'package:intelligent_check_new/model/Task/TaskContentInput.dart';

class TaskScreenPage extends StatefulWidget {
  final callback;
  TaskScreenPage(this.callback);

  @override
  _TaskScreenPageState createState() => _TaskScreenPageState();
}

class _TaskScreenPageState extends State<TaskScreenPage> {
  String _timeName = "";
  int _timeId = -1;
  String _startDate = "";
  String _endDate = "";
  String _departmentName = "";
  int _departmentId = -1;
  String _contactName = "";
  String  _contactId = "";
  bool onlyMeCheck = false;
  bool _checkboxSelected = true;
  List<NameValue> departmentData = List();
  List<NameValue> timeSelect = [
    NameValue("所有", -1),
    NameValue("今天", 0),
    NameValue("昨天", 1),
    NameValue("本周", 2),
    NameValue("上周", 3),
    NameValue("本月", 4),
    NameValue("上月", 5)
  ];
  TaskContentInput filter = new TaskContentInput();

  @override
  void initState() {
    super.initState();
    getDepartment();
  }

  @override
  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.white,
//      appBar: new AppBar(
//        backgroundColor: Colors.white,
//        elevation: 1.0,
//        leading: IconButton(
//            icon: Icon(
//              Icons.arrow_back_ios,
//              color: Colors.red,
//            ),
//            onPressed: () {
//              Navigator.pop(context);
//            }),
//        //backgroundColor: KColorConstant.floorTitleColor,
//        title: Text(
//          '巡检任务筛选',
//          style: new TextStyle(
//            color: Colors.black,
//            //fontWeight: FontWeight.bold,
//          ),
//        ),
//        centerTitle: true,
//      ),
//      body: Form(
//          child: ListView(children: <Widget>[
//        Container(
//          height: 30.0,
//          margin: EdgeInsets.only(left: 10.0, top: 5.0),
//          child: new Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Text(
//                '时间段',
//                style: new TextStyle(fontSize: 15.0),
//              ),
//            ],
//          ),
//        ),
//        Container(
//          margin: EdgeInsets.all(5.0),
//          color: Colors.grey[200],
//          child: new Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Expanded(
//                  flex: 5,
//                  child: TextField(
//                    enabled: false,
//                    controller: _periodcontroller,
//                    decoration: new InputDecoration(
//                      border: InputBorder.none,
//                      hintText: '选择',
//                      contentPadding: EdgeInsets.all(10.0),
//                    ),
//                  )),
//              Expanded(
//                flex: 1,
//                child: IconButton(
//                  icon: Icon(
//                    Icons.expand_more,
//                    color: Colors.red,
//                  ),
//                  onPressed: () {
//                    //下拉框
//                  },
//                ),
//              )
//            ],
//          ),
//        ),
//        Container(
//          height: 30.0,
//          margin: EdgeInsets.only(left: 10.0, top: 5.0),
//          child: new Text(
//            '开始时间',
//            style: new TextStyle(fontSize: 15.0),
//          ),
//        ),
//        Container(
//          margin: EdgeInsets.all(10.0),
//          color: Colors.grey[200],
//          child: new Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Expanded(
//                  flex: 5,
//                  child: TextField(
//                    enabled: false,
//                    controller: _starttimecontroller,
//                    decoration: new InputDecoration(
//                      border: InputBorder.none,
//                      hintText: '输入',
//                      contentPadding: EdgeInsets.all(10.0),
//                    ),
//                  )),
//              Expanded(
//                flex: 1,
//                child: IconButton(
//                  icon: Icon(
//                    Icons.date_range,
//                    color: Colors.red,
//                  ),
//                  onPressed: () {
//                    showDatePicker(
//                      context: context,
//                      initialDate: new DateTime.now(),
//                      firstDate: new DateTime(1970, 01, 01),
//                      lastDate: new DateTime(3000, 12, 31),
//                    ).then((DateTime val) {
//                      _starttimecontroller.text = val.year.toString() +
//                          '年' +
//                          val.month.toString() +
//                          '月' +
//                          val.day.toString() +
//                          '日';
//                    }).catchError((err) {});
//                  },
//                ),
//              )
//            ],
//          ),
//        ),
//        Container(
//          height: 30.0,
//          margin: EdgeInsets.only(left: 10.0, top: 5.0),
//          child: new Text(
//            '结束时间',
//            style: new TextStyle(fontSize: 15.0),
//          ),
//        ),
//        Container(
//          margin: EdgeInsets.all(10.0),
//          color: Colors.grey[200],
//          child: new Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Expanded(
//                  flex: 5,
//                  child: TextField(
//                    enabled: false,
//                    controller: _endtimecontroller,
//                    decoration: new InputDecoration(
//                      border: InputBorder.none,
//                      hintText: '输入',
//                      contentPadding: EdgeInsets.all(10.0),
//                    ),
//                  )),
//              Expanded(
//                flex: 1,
//                child: IconButton(
//                  icon: Icon(
//                    Icons.date_range,
//                    color: Colors.red,
//                  ),
//                  onPressed: () {
//                    showDatePicker(
//                      context: context,
//                      initialDate: new DateTime.now(),
//                      firstDate: new DateTime(1970, 01, 01),
//                      lastDate: new DateTime(3000, 12, 31),
//                    ).then((DateTime val) {
//                      _endtimecontroller.text = val.year.toString() +
//                          '年' +
//                          val.month.toString() +
//                          '月' +
//                          val.day.toString() +
//                          '日';
//                    }).catchError((err) {});
//                  },
//                ),
//              )
//            ],
//          ),
//        ),
//        Container(
//          height: 30.0,
//          margin: EdgeInsets.only(left: 10.0, top: 5.0),
//          child: new Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Text(
//                '执行部门',
//                style: new TextStyle(fontSize: 15.0),
//              ),
//            ],
//          ),
//        ),
//        Container(
//          margin: EdgeInsets.all(10.0),
//          color: Colors.grey[200],
//          child: new Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Expanded(
//                  flex: 5,
//                  child: TextField(
//                    enabled: false,
//                    controller: _personnelcontroller,
//                    decoration: new InputDecoration(
//                      border: InputBorder.none,
//                      hintText: '选择',
//                      contentPadding: EdgeInsets.all(10.0),
//                    ),
//                  )),
//              Expanded(
//                flex: 1,
//                child: IconButton(
//                  icon: Icon(
//                    Icons.chevron_right,
//                    color: Colors.red,
//                  ),
//                  onPressed: () {
//                    //弹出选人窗口
//                  },
//                ),
//              )
//            ],
//          ),
//        ),
//        Container(
//          height: 30.0,
//          margin: EdgeInsets.only(left: 10.0, top: 5.0),
//          child: new Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Text(
//                '执行人员',
//                style: new TextStyle(fontSize: 15.0),
//              ),
//            ],
//          ),
//        ),
//        Container(
//          margin: EdgeInsets.all(10.0),
//          color: Colors.grey[200],
//          child: new Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Expanded(
//                  flex: 5,
//                  child: TextField(
//                    enabled: false,
//                    controller: _departmentcontroller,
//                    decoration: new InputDecoration(
//                      border: InputBorder.none,
//                      hintText: '选择',
//                      contentPadding: EdgeInsets.all(10.0),
//                    ),
//                  )),
//              Expanded(
//                flex: 1,
//                child: IconButton(
//                  icon: Icon(
//                    Icons.chevron_right,
//                    color: Colors.red,
//                  ),
//                  onPressed: () {
//                    //弹出选人窗口
//                  },
//                ),
//              )
//            ],
//          ),
//        ),
//      ])),
//      persistentFooterButtons: <Widget>[
//        new Container(
//          child: new Row(
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.symmetric(vertical: 8.0),
//                width: 195.0,
//                child: RaisedButton(
//                  onPressed: () {
//                    //清空画面内输入值
//                    _departmentcontroller.clear();
//                    _personnelcontroller.clear();
//                    _starttimecontroller.clear();
//                    _endtimecontroller.clear();
//                    _periodcontroller.clear();
//                  },
//                  padding: EdgeInsets.all(10),
//                  color: Color.fromRGBO(242, 246, 249, 1),
//                  child: Text('重置',
//                      style: TextStyle(
//                          color: Colors.black,
//                          fontSize: 20,
//                          fontWeight: FontWeight.w700)),
//                ),
//              ),
//              Container(
//                padding: EdgeInsets.symmetric(vertical: 8.0),
//                width: 195.0,
//                child: RaisedButton(
//                  onPressed: () {
//                    //确定筛选操作
//                  },
//                  padding: EdgeInsets.all(10),
//                  color: Colors.red,
//                  child: Text('确定',
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 20,
//                          fontWeight: FontWeight.w700)),
//                ),
//              )
//            ],
//          ),
//        )
//      ],
//    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "巡检任务筛选",
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        centerTitle: true,
        elevation: 0.7,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CheckboxListTile(
                  value: _checkboxSelected,
                  title: new Text('只显示我巡检的点'),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool) {
                    setState(() {
                      _checkboxSelected = bool;
                    });
                  }),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    Text("时间段"),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    GestureDetector(
                      child: Container(
                        height: 40,
                        width: 340,
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: new BoxDecoration(
                          color: Colors.grey[100],
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 5),
                              child: Text(_timeName),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 14,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        showDialog<Null>(
                          context: context,
                          builder: (BuildContext context) {
                            return new SimpleDialog(
                                children: timeSelect.map((f) {
                              return Column(
                                children: <Widget>[
                                  new SimpleDialogOption(
                                    child: new Text(f.name),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        _timeName = f.name;
                                        _timeId = f.value;
                                      });
                                      getDateByTimeSelected(_timeId);
                                    },
                                  ),
                                  Divider(
                                    height: 1,
                                  )
                                ],
                              );
                            }).toList());
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    Text("开始时间"),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    GestureDetector(
                      child: Container(
                        height: 40,
                        width: 340,
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: new BoxDecoration(
                          color: Colors.grey[100],
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 5),
                              child: Text(_startDate),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: new Image.asset(
                                  'assets/images/icons/calendar_red.png'),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            theme: DatePickerTheme(),
                            onChanged: (date) {}, onConfirm: (date) {
                          setState(() {
                            _startDate = date.toString().substring(0, 16);
                            if (_startDate.isNotEmpty) {
                              filter.startTime = _startDate;
                            }
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.zh);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    Text("结束时间"),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    GestureDetector(
                      child: Container(
                        height: 40,
                        width: 340,
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: new BoxDecoration(
                          color: Colors.grey[100],
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 5),
                              child: Text(_endDate),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: new Image.asset(
                                  'assets/images/icons/calendar_red.png'),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            theme: DatePickerTheme(),
                            onChanged: (date) {}, onConfirm: (date) {
                          setState(() {
                            _endDate = date.toString().substring(0, 16);
                            if (_endDate.isNotEmpty) {
                              filter.endTime = _endDate;
                            }
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.zh);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    Text("巡检部门"),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    GestureDetector(
                      child: Container(
                        height: 40,
                        width: 340,
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: new BoxDecoration(
                          color: Colors.grey[100],
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 5),
                              child: Text(_departmentName),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 14,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        showDialog<Null>(
                          context: context,
                          builder: (BuildContext context) {
                            return new SimpleDialog(
                                children: departmentData.map((f) {
                              return Column(
                                children: <Widget>[
                                  new SimpleDialogOption(
                                    child: new Text(f.name),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        _departmentName = f.name;
                                        _departmentId = f.value;
                                      });
                                    },
                                  ),
                                  Divider(
                                    height: 1,
                                  )
                                ],
                              );
                            }).toList());
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    Text("巡检人员"),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    GestureDetector(
                      child: Container(
                        height: 40,
                        width: 340,
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: new BoxDecoration(
                          color: Colors.grey[100],
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 5),
                              child: Text(_contactName),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                size: 14,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) {
                          return Contact();
                        })).then((value) {
                          if (value != null) {
                            setState(() {
                              _contactName = value.name;
                              _contactId = value.value;
                            });
                          }
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
      persistentFooterButtons: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 160,
              height: 50,
              child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      _startDate = "";
                      _endDate = "";
                      _departmentName = "";
                      _departmentId = -1;
                      _contactId="";
                      _contactName = "";
                      _timeName = "";
                      _timeId = -1;
                      _checkboxSelected = true;
                    });
                  },
                  child: Text("重置",
                      style: TextStyle(color: Colors.black, fontSize: 18))),
            ),
            Container(
              width: 160,
              color: Color.fromRGBO(218, 37, 30, 1),
              child: MaterialButton(
                onPressed: () {
//                  getDateByTimeSelected(_timeId);
//                  if(_startDate.isNotEmpty){
//                    filter.startTime = _startDate;
//                  }
//                  if(_endDate.isNotEmpty){
//                    filter.endTime = _endDate;
//                  }
                  filter.departmentId = _departmentId;
                  filter.executorId = _contactId;
                  widget.callback(filter, _checkboxSelected);
                  Navigator.pop(context);
                },
                child: Text("确定",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            )
          ],
        )
      ],
      resizeToAvoidBottomPadding: false,
    );
  }

  getDepartment() {
    getDepartmentInfo().then((data) {
      setState(() {
        data.forEach((deartment) {
          departmentData
              .add(NameValue(deartment.name, num.tryParse(deartment.id)));
        });
      });
    });
  }

  getDateByTimeSelected(int timeSelectId) {
    setState(() {
      if (timeSelectId == -1) return;
      if (timeSelectId == 0) {
        DateTime now = new DateTime.now();
        filter.startTime = now.toString().substring(0, 16);
        filter.endTime = now.toString().substring(0, 16);
      } else if (timeSelectId == 1) {
        DateTime now = new DateTime.now();
        filter.startTime =
            (now.add(new Duration(days: -1))).toString().substring(0, 16);
        filter.endTime =
            (now.add(new Duration(days: -1))).toString().substring(0, 16);
      } else if (timeSelectId == 2) {
        DateTime now = new DateTime.now();
        DateTime firstDayOfWeek = Utils.firstDayOfWeek(now);
        filter.startTime = firstDayOfWeek.toString().substring(0, 10);
        filter.endTime = now.toString().substring(0, 10);
      } else if (timeSelectId == 3) {
        DateTime now = new DateTime.now();
        DateTime firstDayOfWeek = Utils.firstDayOfWeek(now);
        filter.startTime = (firstDayOfWeek.add(new Duration(days: -7)))
            .toString()
            .substring(0, 10);
        filter.endTime = (firstDayOfWeek.add(new Duration(days: -1)))
            .toString()
            .substring(0, 10);
      } else if (timeSelectId == 4) {
        DateTime now = new DateTime.now();
        filter.startTime = now.toString().substring(0, 8) + "01";
        filter.endTime = now.toString().substring(0, 10);
      } else if (timeSelectId == 5) {
        DateTime now = new DateTime.now();
        DateTime now1 = DateTime.parse(now.toString().substring(0, 8) + "01");
        filter.startTime =
            (now1.add(new Duration(days: -1))).toString().substring(0, 8) +
                "01";
        filter.endTime =
            (now1.add(new Duration(days: -1))).toString().substring(0, 10);
      }
    });
  }
}
