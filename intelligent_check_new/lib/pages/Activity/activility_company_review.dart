import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityModel.dart';
import 'package:intelligent_check_new/pages/Activity/activility_list.dart';
import 'package:intelligent_check_new/pages/Activity/activility_run_log.dart';
import 'package:intelligent_check_new/pages/Activity/activility_steps.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/services/Activility_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivilityCompanyReview extends StatefulWidget {
  final int id;

  ActivilityCompanyReview(this.id);

  @override
  _ActivilityCompanyReview createState() => new _ActivilityCompanyReview();
}

class _ActivilityCompanyReview extends State<ActivilityCompanyReview> {
  bool isAnimating = false;
  bool canOperate = true;
  String theme = "";
  ActivilityModel initData;
  TextEditingController _suggestion = new TextEditingController();

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
      canOperate=false;
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
        isAnimating = false;
        canOperate=true;
      });
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

  executeFlow(int type, String remark, dynamic flowJson) async {
    setState(() {
      isAnimating = true;
      canOperate=false;
    });
    await executeFlowActivility(
            initData.currentFlowRecordId, type, remark, flowJson)
        .then((response) {
      if (response.success) {
        //通过
        HiddenDangerFound.popUpMsg("操作成功！");
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return new ActivilityList();
        }));
      } else {
        //流程执行失败
        if (response.message != null) {
          HiddenDangerFound.popUpMsg(response.message);
        } else {
          HiddenDangerFound.popUpMsg("操作失败！");
        }
      }
      isAnimating = false;
      canOperate=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.initData == null) {
      return  WillPopScope(
        child:Scaffold(body: Text("")),
        onWillPop: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return new ActivilityList();
          }));
        },
      );
    }
    return WillPopScope(
      child:Scaffold(
        appBar: AppBar(
          title: Text(
            "待公司审核",
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
                            padding: EdgeInsets.only(left: 10, top: 10,bottom: 10),
                            //height: 50,
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
                                                initData.taskWorkType?? "--",
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
                                    //height: 50,
                                    width: MediaQuery.of(context).size.width,

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
                                    padding: EdgeInsets.only(left: 10, bottom: 10),
                                    //height: 50,
                                    width: MediaQuery.of(context).size.width,

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

                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, top: 10,bottom: 10),
                          //height: 50,
                          width: MediaQuery.of(context).size.width,

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
                                    padding: EdgeInsets.only(left: 10, top: 10,bottom: 10),
                                    //height: 50,
                                    width: MediaQuery.of(context).size.width,

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
                                    //height: 50,
                                    width: MediaQuery.of(context).size.width,

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
                                    //height: 50,
                                    width: MediaQuery.of(context).size.width,

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

                    Column(
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
                                  "公司审核意见",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
//                            Expanded(flex: 1,
//                              child: Icon(Icons.check_circle,size: 20,color: Color.fromRGBO(0, 180, 22, 1),),),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 100,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: new BoxDecoration(
                              color: Color.fromRGBO(244, 244, 244, 1)),
                          child: TextField(
                            autofocus: false,
                            enabled: true,
                            controller: _suggestion,
                            enableInteractiveSelection: true,
                            maxLength: 500,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(500)//限制长度
                            ],
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10),
                              border: InputBorder.none,
                              hintText: "审核意见",
                              filled: true,
                              fillColor: Color.fromRGBO(244, 244, 244, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: Color.fromRGBO(242, 246, 249, 1),
                      height: 10,
                    ),
                    //执行日志
                    Container(
                      padding: EdgeInsets.only(left: 10),
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
                width: (MediaQuery.of(context).size.width / 2) - 16,
                height: 60,
                margin: EdgeInsets.only(left: 0),
                child: new MaterialButton(
                  color: Color.fromRGBO(242, 246, 249, 1),
                  height: 60,
                  textColor: Colors.black,
                  child: new Text(
                    '驳回',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    if(canOperate){
                      executeFlow(3, this._suggestion.text, null);
                    }else{
                      HiddenDangerFound.popUpMsg("正在执行操作，请稍等...");
                    }

                  },
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width / 2),
                child: new MaterialButton(
                  color: GetConfig.getColor(theme),
                  height: 60,
                  textColor: Colors.white,
                  child: new Text('通过', style: TextStyle(fontSize: 24)),
                  onPressed: () {
                    if(canOperate){
                      executeFlow(2, this._suggestion.text, null);
                    }else{
                      HiddenDangerFound.popUpMsg("正在执行操作，请稍等...");
                    }
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
