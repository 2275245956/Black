import 'package:flutter/material.dart';
import 'package:intelligent_check_new/pages/Activity/activility_list.dart';
import 'package:intelligent_check_new/pages/Activity/activility_run_log.dart';
import 'package:intelligent_check_new/pages/Activity/activility_steps_envConfirm.dart';
import 'package:intelligent_check_new/pages/Activity/activility_steps_envConfirming.dart';
import 'package:intelligent_check_new/pages/Activity/activility_steps_run.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityModel.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/services/Activility_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';

class ActivilityEnvironmentConfirm extends StatefulWidget {
  final int id;
  ActivilityEnvironmentConfirm(this.id);

  @override
  _ActivilityEnvironmentConfirm createState() => new _ActivilityEnvironmentConfirm();
}

class _ActivilityEnvironmentConfirm extends State<ActivilityEnvironmentConfirm> {
  bool isAnimating = false;
  bool canOperate = true;
  String theme = "";
  ActivilityModel initData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getInitInfo();
  }

  void getInitInfo() async {
    await SharedPreferences.getInstance().then((data) {
      if (data != null) {
        setState(() {
          this.theme = data.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
        });
      }
    }).then((data) {
      loadData();
    });
  }

  void loadData() async {
    setState(() {
      isAnimating = true;
    });
    await getActivilityDetail(this.widget.id).then((data) {
      setState(() {

        if (data.success && data.dataList != null) {
          initData = ActivilityModel.fromJson(data.dataList);
        } else {
          if (data.message != null) {
            HiddenDangerFound.popUpMsg(data.message);
          }
        }

      });
      isAnimating = false;
    });
    var data=  await getLogInfo(this.widget.id);
    if(data.success && this.initData!=null){
      this.initData.records=new List();
      for(var str in data.dataList){
        setState(() {
          var rec=new Records.fromJson(str);
          if(rec.actionFlag=="D_2" || rec.actionFlag=="D_3" || rec.actionFlag=="D_4"){
            this.initData.records.add(rec);
          }
        });
      }
    }else{
      HiddenDangerFound.popUpMsg(data.message??"获取日志失败");
    }
  }
  @override
  Widget build(BuildContext context) {
    if (this.initData == null) {
      return WillPopScope(
        child:Scaffold(body: Text("作业环境确认")),
        onWillPop: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return new ActivilityList();
          }));
        },
      );
    }
    return  WillPopScope(
      child:Scaffold(
        appBar: AppBar(
          title: Text(
            "作业环境确认",
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
            ),
          ),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return new ActivilityList();
                }));
              },
              child: Icon(Icons.keyboard_arrow_left,
                  color: Color.fromRGBO(
                      50, 89, 206, 1) /*GetConfig.getColor(theme)*/,
                  size: 32),
            ),
          ),
        ),
        body: ModalProgressHUD(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Column(children: <Widget>[

                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10, top: 10,bottom: 10),
                            //height: 50,
                            child: Text(
                              initData.taskworkName ?? "--",
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //等级
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.only(left: 10, top: 10,bottom: 10),
                            //height: 50,
                            child: Text(
                              "等级",
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(initData.levelDesc ?? "--"),
                        )
                      ],
                    ),
                    // Divider(),
                    //所属部门/车间
                    Row(

                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.only(left: 10, top: 10,bottom:10),

                            child: Text(
                              "所属部门/车间",
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child:
                          Text(initData.belongDepartmentAndGroupName ?? "--"),
                        ),
                      ],
                    ),
                    //分割线
                    Container(
                      color: Color.fromRGBO(242, 246, 249, 1),
                      height: 10,
                    ),

                    //作业活动基础信息
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: Text(
                            "作业活动基础信息",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(left:10, top: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    child: GestureDetector(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "作业活动名称",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                initData.taskworkName ?? "--",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {})),
                                Container(
                                    padding: EdgeInsets.only(left: 10, top: 10),
                                    width: MediaQuery.of(context).size.width,
                                    child: GestureDetector(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "作业活动类型",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                initData.taskWorkType ?? "--",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {})),
                                Container(
                                    padding: EdgeInsets.only(left:10, top: 10,bottom: 10),
                                    width: MediaQuery.of(context).size.width,
                                    //height: 50,
                                    child: GestureDetector(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "作业活动岗位",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                initData.postName ?? "--",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {})),
                                Container(
                                    padding: EdgeInsets.only(left:10, bottom: 10),
                                    width: MediaQuery.of(context).size.width,
                                    //height: 50,
                                    child: GestureDetector(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "作业活动部位",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                initData.partName ?? "--",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {})),
                              ],
                            )),
                      ],
                    ),

                    Container(
                      color: Color.fromRGBO(242, 246, 249, 1),
                      height: 10,
                    ),

                    //申请执行信息
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: Text(
                            "申请执行信息",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(left: 10, top: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    child: GestureDetector(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "申请人",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                initData.applyUserName ?? "--",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {})),
                                Container(
                                    padding: EdgeInsets.only(left: 10, top: 10,bottom: 10),
                                    width: MediaQuery.of(context).size.width,
                                    //height: 50,
                                    child: GestureDetector(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "申请部门/车间",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                initData.applyDepartmentName ?? "--",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {})),
                                Container(
                                    padding: EdgeInsets.only(left: 10, top: 10,bottom: 10),
                                    width: MediaQuery.of(context).size.width,
                                    //height: 50,
                                    child: GestureDetector(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "申请时间",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                initData.applyDateTime ?? "--",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {})),
                              ],
                            )),
                      ],
                    ),
                    Container(
                      color: Color.fromRGBO(242, 246, 249, 1),
                      height: 10,
                    ),

                    initData.records != null
                        ? Column(
                      children: <Widget>[
                        Column(
                          children: initData.records.map((record) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  padding:
                                  EdgeInsets.only(left: 10, top: 10,bottom: 10),
                                  width:
                                  MediaQuery.of(context).size.width,

                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 9,
                                        child: Text(
                                          record.excuteResult ?? "--",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: record.excuteState == 2
                                              ? Icon(
                                            Icons.check_circle,
                                            size: 20,
                                            color: Color.fromRGBO(
                                                0, 180, 22, 1),
                                          )
                                              : Icon(
                                            Icons.cancel,
                                            size: 20,
                                            color: Color.fromRGBO(
                                                209, 6, 24, 1),
                                          )),
                                    ],
                                  ),
                                ),

                                Container(
                                  color: Color.fromRGBO(242, 246, 249, 1),
                                  height: 10,
                                ),
                              ],
                            );
                          }).toList(),
                        )
                      ],
                    )
                        : Container(),

                    Container(
                      color: Color.fromRGBO(242, 246, 249, 1),
                      height: 10,
                    ),
                    //执行日志
                    Container(
                      padding: EdgeInsets.only(left:10),
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      child: GestureDetector(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text("执行日志",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19,
                                  )),
                              flex: 9,
                            ),
                            Expanded(
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: GetConfig.getColor(theme),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return new ActivilityRunLog(initData);
                              }));
                        },
                      ),
                    ),
                    Container(
                      color: Color.fromRGBO(242, 246, 249, 1),
                      height: 10,
                    )
                  ])
                ],
              ),
            ),
          ),
          inAsyncCall: isAnimating,
          // demo of some additional parameters
          opacity: 0.7,
          progressIndicator: CircularProgressIndicator(),
        ),
        persistentFooterButtons: <Widget>[
          Row(
            children: <Widget>[

              Container(
                width: MediaQuery.of(context).size.width-16,
                child: new MaterialButton(
                  color: GetConfig.getColor(theme),
                  height: 60,
                  textColor: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text('去确认', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ActivilityStepsEnvConfirm(this.initData,false);
                    }));

                  },
                ),
              ),
            ],
          ),
        ],
        resizeToAvoidBottomPadding: true,
      ),
      onWillPop: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return new ActivilityList();
        }));
      },
    );
  }
}
