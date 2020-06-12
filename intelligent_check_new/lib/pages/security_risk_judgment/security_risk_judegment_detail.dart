import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/SecurityRiskJudgement/SecurityRiskModel.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/security_risk_judgment/security_risk_judegment_table.dart';
import 'package:intelligent_check_new/pages/security_risk_judgment/security_risk_judgement_geinfotable.dart';
import 'package:intelligent_check_new/pages/security_risk_judgment/security_risk_judgment_list.dart';
import 'package:intelligent_check_new/services/Security_Risk_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityRiskJudegmentDetail extends StatefulWidget {


 final int id;
  SecurityRiskJudegmentDetail(this.id);

  @override
  _SecurityRiskJudegmentDetail createState() => _SecurityRiskJudegmentDetail();
}

class _SecurityRiskJudegmentDetail extends State<SecurityRiskJudegmentDetail>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  SecurityRiskListModel initData;
  bool isAnimating = false;
  SecurityRiskListModel initDataModel = new SecurityRiskListModel.fromParams();
  String theme = "";
  bool isOverTime = false;
  bool isSubmit=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getData();
  }
   _getData () async{
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

void   loadData()async{

  await getSecurityRiskDetail(this.widget.id).then((data) {
    if (mounted) {
      setState(() {
        if (data.id != null) {
          this.initData = data;
          isOverTime = this.initData.status == 2;

          ///已超时
          isSubmit = this.initData.status >= 3;

          ///已提交
        }
      });
    }
  });
  }


  saveAllRecord() async {
    await saveTaskStatus(this.initData.id).then((date) {
      if (date.success) {
        HiddenDangerFound.popUpMsg("操作成功！");
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SecurityRiskJudegmentList();
        }));
      } else {
          date.message=date.message??"操作失败！";
          HiddenDangerFound.popUpMsg(date.message);

      }
    });
  }

  Color getBgColor(int finishStatus) {
    if (finishStatus == 1) {
      // 进行中
      return Colors.orange;
    } else if (finishStatus == 2) {
      // 已超时
      return Colors.red[800];
    } else if (finishStatus == 3) {
      // 已提交
      return Colors.green;
    } else if (finishStatus == 4) {
      // 已审核
      return Colors.teal;
    } else if (finishStatus == 5) {
      // 已汇总
      return Colors.purple;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (this.initData == null) {
      return Scaffold(body: Text(""));
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 246, 249, 1),
      appBar: AppBar(
        title: Text(
          "每日风险研判检查任务",
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context){
              return SecurityRiskJudegmentList();
            })),
            child: Icon(Icons.keyboard_arrow_left,
                color: GetConfig.getColor(theme), size: 32),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(top: 15, right: 20),
              child: Text(
                "提交",
                style: TextStyle(
                    color: isSubmit?Colors.grey:GetConfig.getColor(theme),
                    fontWeight: FontWeight.w800,
                    fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () {
              if(isSubmit){
                HiddenDangerFound.popUpMsg(
                    "任务" + this.initData.statusDesc + "！无法提交！",gravity: ToastGravity.BOTTOM);
                return false;
              }
              saveAllRecord();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: ModalProgressHUD(
          child: new Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 1),
                height: 100,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child:
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
                  //任务类型
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                                "assets/images/jiaoda/safe_danger_judgement_" +
                                    theme +
                                    ".png",
                                height: 30,
                                color: GetConfig.getColor(theme)),
                          ),
                        ),
                      ],
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 10, top: 6),
                                child: Text(
                                  this.initData.judgmentName.toString() +
                                      " " +
                                      this.initData.date.toString(),
                                  style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 10, top: 5),
                                child: Text(
                                    this.initData.departmentName ?? "-",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14)),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(left: 10, top: 5),
                                  child: Text("状态：",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14))),
                              Container(
                                  padding: EdgeInsets.only(left: 0, top: 5),
                                  child: Text(
                                      this.initData.statusDesc ?? "-",
                                      style: TextStyle(
                                          color: getBgColor(
                                              this.initData.status),
                                          fontSize: 14))),
                            ],
                          ),

                          //  Padding(padding: EdgeInsets.only(top: 10),),
                        ],
                      ),
                    ),
                    flex: 5,
                  ),
                ]),
              ),
              ///风险研判表
              isOverTime
                  ? Container(
                margin: EdgeInsets.only(top: 15 ),
                height: 80,
                width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(219, 222, 225, 1),
                        offset: Offset(3.0, 3.0),
                        blurRadius: 5.0,
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(219, 222, 225, 1),
                        offset: Offset(3.0, 3.0),
                        blurRadius: 5.0,
                      )
                    ],
                    color: Colors
                        .white /* getBgColor(initData[index].finishStatus)*/
                ),
                child: GestureDetector(
                  onTap: () {
                    HiddenDangerFound.popUpMsg(
                        "任务" + this.initData.statusDesc + "！无法处理！");
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Image.asset(
                              "assets/images/securityRiskJudegment/safe_risk_01.png",
                              height: 30,
                              color: Color.fromRGBO(215, 219, 225, 1))),
                      Expanded(
                        flex: 7,
                        child: Text(
                          "安全风险研判表",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(215, 219, 225, 1)),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            size: 25,
                            color: Color.fromRGBO(215, 219, 225, 1),
                          )),
                    ],
                  ),
                ),
              )
                  : Container(
                margin: EdgeInsets.only(top: 15, ),
                height: 80,
                width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(219, 222, 225, 1),
                        offset: Offset(3.0, 3.0),
                        blurRadius: 5.0,
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(219, 222, 225, 1),
                        offset: Offset(3.0, 3.0),
                        blurRadius: 5.0,
                      )
                    ],
                    color: Colors
                        .white /* getBgColor(initData[index].finishStatus)*/
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return SecurityRiskJudegmentTable(
                              this.initData.id, 1,isSubmit);
                        }));
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Image.asset(
                              "assets/images/securityRiskJudegment/safe_risk_01.png",
                              height: 30,
                              color: GetConfig.getColor(theme))),
                      Expanded(
                        flex: 7,
                        child: Text(
                          "安全风险研判表",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            size: 25,
                            color: GetConfig.getColor(theme),
                          )),
                    ],
                  ),
                ),
              ),
              ///风险信息采集表
              isOverTime
                  ? Container(
                  margin: EdgeInsets.only(top: 15,bottom: 20),
                  height: 80,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(219, 222, 225, 1),
                          offset: Offset(3.0, 3.0),
                          blurRadius: 5.0,
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(219, 222, 225, 1),
                          offset: Offset(3.0, 3.0),
                          blurRadius: 5.0,
                        )
                      ],
                      color: Colors
                          .white /* getBgColor(initData[index].finishStatus)*/
                  ),
                  child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Image.asset(
                              "assets/images/securityRiskJudegment/safe_risk_02.png",
                              height: 30,
                              color: Color.fromRGBO(215, 219, 225, 1),
                            )),
                        Expanded(
                          flex: 7,
                          child: Text(
                            "安全风险研判信息采集表",
                            style: TextStyle(
                                color: Color.fromRGBO(215, 219, 225, 1),
                                fontSize: 17,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: 25,
                              color: Color.fromRGBO(215, 219, 225, 1),
                            )),
                      ],
                    ),
                    onTap: () {
                      HiddenDangerFound.popUpMsg(
                          "任务" + this.initData.statusDesc + "！无法处理！");
                    },
                  ))
                  : Container(
                  margin: EdgeInsets.only(top: 15,bottom: 20),
                  height: 80,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(219, 222, 225, 1),
                          offset: Offset(3.0, 3.0),
                          blurRadius: 5.0,
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(219, 222, 225, 1),
                          offset: Offset(3.0, 3.0),
                          blurRadius: 5.0,
                        )
                      ],
                      color: Colors
                          .white /* getBgColor(initData[index].finishStatus)*/
                  ),
                  child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Image.asset(
                              "assets/images/securityRiskJudegment/safe_risk_02.png",
                              height: 30,
                              color: GetConfig.getColor(theme),
                            )),
                        Expanded(
                          flex: 7,
                          child: Text(
                            "安全风险研判信息采集表",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: 25,
                              color: GetConfig.getColor(theme),
                            )),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return new SecurityRiskJudegmentGetInfoTable(
                                this.initData.id, 2,isSubmit);
                          }));
                    },
                  )),
            ],

          ),
          inAsyncCall: isAnimating,
          // demo of some additional parameters
          opacity: 0.7,
          progressIndicator: CircularProgressIndicator(),
//        content: '加载中...',
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
