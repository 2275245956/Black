import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/InspectionRecordModel.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intelligent_check_new/pages/inspection_record/contact.dart';
import 'package:intelligent_check_new/pages/inspection_record/select_inspection_spot.dart';
import 'package:intelligent_check_new/pages/inspection_record/select_plan.dart';
import 'package:intelligent_check_new/model/name_value.dart';
import 'package:intelligent_check_new/services/company_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterPage extends StatefulWidget {
  FilterPage({this.callback});

  final callback;

  @override
  State<StatefulWidget> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String _startDate = '';
  String _endDate = '';
  String _departmentName = "";
  int _departmentId = -1;
  String _planName = "";
  int _planId = -1;
  String _checkPoint = "";
  int _checkPointId = -1;
  String _contactName = "";
  String _contactId = "";

  List<NameValue> departmentData = List();

  bool _checkboxSelected = false;
  String theme = "blue";

  @override
  void initState() {
    super.initState();
    getDepartment();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "巡检点筛选",
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.keyboard_arrow_left,
                color: GetConfig.getColor(theme), size: 32),
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
                                'assets/images/icons/calendar_' +
                                    theme +
                                    '.png',
                                width: 18,
                                height: 18,
                              ),
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
                            _startDate = date.toString().substring(0, 10);
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.zh);
                        /*DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            theme: DatePickerTheme(),
                            onChanged: (date) {
                            }, onConfirm: (date) {
                              setState(() {
                                _startDate = date.toString().substring(0,10);
                              });
                            }, currentTime: DateTime.now(), locale: LocaleType.zh);*/
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
                                'assets/images/icons/calendar_' +
                                    theme +
                                    '.png',
                                width: 18,
                                height: 18,
                              ),
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
                            _endDate = date.toString().substring(0, 10);
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.zh);
                        /*DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            theme: DatePickerTheme(),
                            onChanged: (date) {
                            }, onConfirm: (date) {
                              setState(() {
                                _endDate = date.toString().substring(0,10);
                              });
                            }, currentTime: DateTime.now(), locale: LocaleType.zh);*/
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    Text("检查部门"),
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
//                                          print("_departmentId:"+f.value.toString());
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
                    Text("检查计划"),
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
                              child: Text(_planName),
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
                          return SelectPlanPage();
                        })).then((value) {
                          setState(() {
                            if (value != null) {
                              _planName = value.name;
                              _planId = value.value;
                            }
                          });
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    Text("检查人员"),
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
                          setState(() {
                            if (value != null) {
                              _contactName = value.name;
                              _contactId = value.value.toString();
                            }
                          });
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                    ),
                    Text("点名称"),
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
                              child: Text(_checkPoint),
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
                          return SelectInspectionSpot();
                        })).then((value) {
                          setState(() {
                            if(value!=null){
                              _checkPoint = value.name;
                              _checkPointId = value.value;
                            }

                          });
                        });
                      },
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
                      _startDate = '';
                      _endDate = '';
                      _departmentName = "";
                      _departmentId = -1;
                      _planName = "";
                      _planId = -1;
                      _checkPoint = "";
                      _checkPointId = -1;
                      _contactName = "";
                      _contactId = "";
                      _checkboxSelected = false;
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
                  InspectionRecordFilter filter = new InspectionRecordFilter();
                  filter.isOnlyMyInspection = _checkboxSelected;
                  filter.beginDate = _startDate;
                  filter.endDate = _endDate;
                  filter.departmentId = _departmentId;
                  filter.planTaskId = _planId;
                  filter.pointId = _checkPointId;
                  filter.userId = _contactId;
                  widget.callback(filter);
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
}
