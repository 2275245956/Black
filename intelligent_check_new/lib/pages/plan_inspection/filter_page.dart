import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intelligent_check_new/model/name_value.dart';
import 'package:intelligent_check_new/model/plan_list_input.dart';
import 'package:intelligent_check_new/pages/inspection_record/contact.dart';
import 'package:intelligent_check_new/pages/plan_inspection/select_route.dart';
import 'package:intelligent_check_new/services/company_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';

class FilterPage extends StatefulWidget{
  FilterPage({this.callback});
  final callback;

  @override
  State<StatefulWidget> createState() => _FilterPageState();

}

class _FilterPageState extends State<FilterPage>{

  String _startDate="";
  String _endDate="";
  String _departmentName="";
  int _departmentId = -1;
  String _routeName="";
  int _routeId = -1;
  String _contactName="";
  String  _contactId = "";

  List<NameValue> departmentData = List();
  String theme="";

  @override
  void initState() {
    super.initState();
    getDepartment();
    initConfig();
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
        title: Text("计划筛选",style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1),fontSize: 18),),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading:new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
          ),
        ),
      ),
      body:  ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 15),),
                    Text("开始时间"),
                    Padding(padding: EdgeInsets.only(top: 5),),
                    GestureDetector(
                      child:  Container(
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
                              padding:EdgeInsets.only(left: 5),
                              child: Text(_startDate),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child:  new Image.asset('assets/images/icons/calendar_'+theme+'.png',width: 18,height: 18),
                            )
                          ],
                        ),
                      ),
                      onTap: (){
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            theme: DatePickerTheme(),
                            onChanged: (date) {
                            }, onConfirm: (date) {
                              setState(() {
                                _startDate = date.toString().substring(0,19);
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
                    Padding(padding: EdgeInsets.only(top: 15),),
                    Text("结束时间"),
                    Padding(padding: EdgeInsets.only(top: 5),),
                    GestureDetector(
                      child:  Container(
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
                              padding:EdgeInsets.only(left: 5),
                              child: Text(_endDate),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child:  new Image.asset('assets/images/icons/calendar_'+theme+'.png',width: 18,height: 18),
                            )
                          ],
                        ),
                      ),
                      onTap: (){
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            theme: DatePickerTheme(),
                            onChanged: (date) {
                            }, onConfirm: (date) {
                              setState(() {
                                _endDate = date.toString().substring(0,19);
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
                    Padding(padding: EdgeInsets.only(top: 15),),
                    Text("巡检部门"),
                    Padding(padding: EdgeInsets.only(top: 5),),
                    GestureDetector(
                      child:  Container(
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
                              padding:EdgeInsets.only(left: 5),
                              child: Text(_departmentName),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child:  Icon(Icons.keyboard_arrow_right,size: 14,color: GetConfig.getColor(theme),),
                            )
                          ],
                        ),
                      ),
                      onTap: (){
                        showDialog<Null>(
                          context: context,
                          builder: (BuildContext context) {
                            return new SimpleDialog(
                              children: departmentData.map((f){
                                return Column(
                                  children: <Widget>[
                                    new SimpleDialogOption(
                                      child: new Text(f.name),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          _departmentName=f.name;
                                          _departmentId=f.value;
                                        });
                                      },
                                    ),
                                    Divider(height: 1,)
                                  ],
                                );
                              }).toList()
                            );
                          },
                        );
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: 15),),
                    Text("巡检人员"),
                    Padding(padding: EdgeInsets.only(top: 5),),
                    GestureDetector(
                      child:  Container(
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
                              padding:EdgeInsets.only(left: 5),
                              child: Text(_contactName),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child:  Icon(Icons.keyboard_arrow_right,size: 14,color: GetConfig.getColor(theme),),
                            )
                          ],
                        ),
                      ),
                      onTap: (){
                        Navigator.push( context,
                            new MaterialPageRoute(builder: (context) {
                              return Contact();
                            })).then((value){
                              if(value!=null){
                                setState(() {
                                
                                  _contactName = value.name;
                                  _contactId = value.value.toString();
                                  print(_contactId+""+_contactName);
                                });
                              }
                        });
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: 15),),
                    Text("巡检线路"),
                    Padding(padding: EdgeInsets.only(top: 5),),
                    GestureDetector(
                      child:  Container(
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
                              padding:EdgeInsets.only(left: 5),
                              child: Text(_routeName),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child:  Icon(Icons.keyboard_arrow_right,size: 14,color: GetConfig.getColor(theme),),
                            )
                          ],
                        ),
                      ),
                      onTap: (){
                        Navigator.push( context,
                            new MaterialPageRoute(builder: (context) {
                              return SelectRoutePage();
                            })).then((value){
                          if(value!=null){
                            setState(() {
                              _routeName = value.name;
                              _routeId = value.value;
                            });
                          }
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
                      _startDate="";
                      _endDate="";
                      _departmentName="";
                      _routeName="";
                      _contactName="";
                    });
                  },
                  child: Text("重置",
                      style: TextStyle(color: Colors.black,fontSize: 18)
                  )
              ),
            ),
            Container(
              width: 170,
              height: 50,
              color: GetConfig.getColor(theme),
              child: MaterialButton(
                onPressed: () {
                  PlanListInput filter=new PlanListInput();
                  filter.startTime = _startDate;
                  filter.endTime = _endDate;
                  filter.departmentId = _departmentId;
                  filter.routeId = _routeId;
                  filter.userId = _contactId;
                  widget.callback(filter);
                  Navigator.pop(context);
                },
                child: Text("确定",
                    style: TextStyle(color: Colors.white,fontSize: 18)
                ),
              ),
            )
          ],
        )
      ],
      resizeToAvoidBottomPadding: false,
    );
  }

  getDepartment(){
    getDepartmentInfo().then((data){
      setState(() {
        data.forEach((deartment){
          departmentData.add(NameValue(deartment.name, num.tryParse(deartment.id)));
        });
      });
    });
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }
}