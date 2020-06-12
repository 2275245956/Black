import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/name_value.dart';
import 'package:intelligent_check_new/pages/inspection_record/contact.dart';
import 'package:intelligent_check_new/services/company_services.dart';
import 'package:intelligent_check_new/model/Task/TaskContentInput.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String theme="";

  @override
  void initState() {
    super.initState();
    getDepartment();
    initConfig();
  }


  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(this.theme.isEmpty){
      return Scaffold(
          body:Text("")
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "巡检任务筛选",
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
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
                                color: GetConfig.getColor(theme),
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
                                  'assets/images/icons/calendar_'+theme+'.png',width: 18,height: 18,),
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
                                  'assets/images/icons/calendar_'+theme+'.png',width: 18,height: 18,),
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
                                Icons.keyboard_arrow_right,
                                size: 14,
                                color: GetConfig.getColor(theme),
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
                                color: GetConfig.getColor(theme),
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
              width: 170,
              height: 50,
              color: Color.fromRGBO(242, 246, 249, 1),
              child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      _startDate = "";
                      _endDate = "";
                      _departmentName = "";
                      _departmentId = -1;
                      _contactId = "";
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
              width: 170,
              height: 50,
              color: GetConfig.getColor(theme),
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
