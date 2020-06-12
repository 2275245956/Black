import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/Hidden_Danger/hidden_danger_model.dart';
import 'package:intelligent_check_new/model/MovePointAttachment.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageList.dart';
import 'package:intelligent_check_new/pages/ImageViewPage.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_flowRecord.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_processed_rectification_measures_show.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_review.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_rectification_measures.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidedanger_pending.dart';
import 'package:intelligent_check_new/services/HiddenDanger.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HiddenDangerProcessedDetailsChecked extends StatefulWidget {
  final int dangerId;
  final int state;

  HiddenDangerProcessedDetailsChecked(this.dangerId, {this.state});

  @override
  _HiddenDangerProcessedDetailsChecked createState() =>
      new _HiddenDangerProcessedDetailsChecked();
}

class _HiddenDangerProcessedDetailsChecked
    extends State<HiddenDangerProcessedDetailsChecked> {
  TextEditingController remark = new TextEditingController();

  @override
  bool get wantKeepAlive => true;

  bool isAnimating = false;

  bool canOperate = true;
  String myUserId;
  List<String> recMeasures = new List();
  List<File> imageList;
  HideDangerInfoModel initData;
  HideDanger hideDanger = new HideDanger();

  String theme = "";

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
    await getHiddenDangerModel(this.widget.dangerId).then((data) {
      if (data != null) {
        setState(() {
          initData = data;
          initData.currentUserCanExcute =
          initData.currentUserCanExcute == null ? false : true;
          if (this.widget.state != null &&
              initData.dangerState != null &&
              this.widget.state != initData.dangerState) {
            HiddenDangerReview.goToPage(
                initData.dangerState, initData.dangerId, context);
          }

          isAnimating = false;
        });
      }
    });
  }

  _upDateImg(List<Attachment> att) async {
    setState(() {
      isAnimating = true;
      canOperate = false;
    });
    var bizCode = "latent_danger_recheck";
    await updataImg(att, bizCode).then((data) {
      setState(() {
        ///保存文件路径
        if (data.success) {
          hideDanger.photoUrls = data.message;
          HiddenDangerFound.popUpMsg("图片上传成功!");
        } else {
          HiddenDangerFound.popUpMsg(data.message);
        }
        isAnimating = false;
        canOperate = true;
      });
    });
  }

  _saveRecheckResult(HideDanger hd, radio) async {
    setState(() {
      isAnimating = true;
      canOperate = false;
    });
    var result = 0;
    if (radio == 1) {
      //常规处理
      result = 13;
    } else {
      //安措计划
      result = 14;
    }
    var jsonFlow = {

      "photoUrls": hd.photoUrls
    };

    await saveReviewResult(hd, result, initData.currentFlowRecordId, jsonFlow)
        .then((data) {
      setState(() {
        if (data.success) {
          HiddenDangerFound.popUpMsg(data.message);

          Navigator.pop(context);
        } else {
          HiddenDangerFound.popUpMsg(data.message);
        }
        isAnimating = false;
        canOperate = true;
      });
    });
  }

  bool _checkNeed() {
    if (radioValue == 2 && hideDanger.remark.text == "") {
      HiddenDangerFound.popUpMsg("验收不合格！请填写备注信息！");
      return false;
    }
//    if (imageList == [] || imageList == null) {
//      HiddenDangerFound.popUpMsg("请上传验证图片！");
//      return false;
//    }
    return true;
  }

  // Default placeholder text
  var radioValue = 1;

  @override
  Widget build(BuildContext context) {
    ///null == routeList || routeList.length <= 0
    if (initData == null || initData.dangerId == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              "隐患验证",
              style: TextStyle(
                  color: Colors.black, fontSize: 19, fontWeight: FontWeight.w500),
            ),
            actions: <Widget>[
              Align(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      //  onTap: () {
//                      searchData();
//                      loadData();
                      //  },
                      child: Icon(
                        Icons.save,
                        color: GetConfig.getColor(theme),
                        size: 32,
                      ), //Image.asset("assets/images/search_"+theme+".png",width: 20,color: GetConfig.getColor(theme)),
                      // child:Image.asset("assets/images/search_"+theme+".png",width: 20,color: GetConfig.getColor(theme)),
                    ),
                  ))
            ],
            centerTitle: true,
            elevation: 0.2,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            leading: new Container(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(
                        builder: (context) => new PendingHideDanger()),
                        (route) => route == null),
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: GetConfig.getColor(theme),
                  size: 32,
                ), //Image.asset("assets/images/search_"+theme+".png",width: 20,color: GetConfig.getColor(theme)),
              ),
            ),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "隐患验证",
          style: TextStyle(
              color: Colors.black, fontSize: 19, fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          Align(
              child: Padding(
                padding: EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    if (!initData.currentUserCanExcute) {
                      HiddenDangerFound.popUpMsg("无权限操作该任务！");
                      return false;
                    }

                    if (canOperate) {
                      if (_checkNeed()) _saveRecheckResult(hideDanger, radioValue);
                    } else {
                      HiddenDangerFound.popUpMsg("正在执行操作！请稍等...");
                    }
                  },
                  child: Icon(
                    Icons.save,
                    color: GetConfig.getColor(theme),
                    size: 32,
                  ), //Image.asset("assets/images/search_"+theme+".png",width: 20,color: GetConfig.getColor(theme)),
                ),
              ))
        ],
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
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
                initData.dangerType != 1
                    ? Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            height: 50,
                            child: Text(
                              "点名称",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(initData.riskInfo == null
                              ? "-"
                              : initData.riskInfo.pointName),
                        )
                      ],
                    ),
                    //点编号
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            height: 50,
                            child: Text(
                              "点编号",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(initData.riskInfo == null
                              ? "-"
                              : initData.riskInfo.pointNo),
                        )
                      ],
                    ),

                    //分割线
                    //所属部门/车间
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            width: 150,
                            height: 50,
                            child: Text(
                              "等级",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text("${initData.riskInfo!=null?initData.riskInfo.pointLevel:"--"}"),
                        )
                      ],
                    ),
                    //分割线
                    Container(
                      color: Colors.grey[100],
                      height: 10,
                    ),

                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          height: 50,
                          child: Text(
                            "检查依据",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),

                    initData.riskInfo != null &&
                        initData.riskInfo.basis != null
                        ? Column(
                      children: initData.riskInfo.basis.map((base) {
                        return Container(
                          height: 30,
                          decoration: new BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color.fromRGBO(
                                          244, 244, 244, 1)))),
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 30),
                          child: Text(
                            json.decode(base)["name"].toString(),
                            style: TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        );
                      }).toList(),
                    )
                        : Container(),
                    Container(
                      color: Colors.grey[100],
                      height: 10,
                    ),
                  ],
                )
                    : Text(""),

                ///隐患名称
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        width: 150,
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              ),
                              flex: 0,
                            ),
                            Expanded(
                              child: Text(
                                "隐患名称",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                              flex: 19,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child:Container(child:  Text(initData.dangerName ?? ""),padding: EdgeInsets.only(top: 5,right: 10),),

                    ),
                  ],
                ),

                ///隐患地点
                initData.position==null?Container():Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        width: 150,
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              ),
                              flex: 0,
                            ),
                            Expanded(
                              child: Text(
                                "隐患地点",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                              flex: 19,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(initData.position ?? "-"),
                    ),
                  ],
                ),

                ///隐患等级
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        width: 150,
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              ),
                              flex: 0,
                            ),
                            Expanded(
                              child: Text(
                                "隐患等级",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                              flex: 19,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        initData.levelDesc ?? "",
                        style: TextStyle(
                            color: initData.level == 1
                                ? Colors.orange
                                : Colors.red),
                      ),
                    ),
                  ],
                ),

                Container(
                  child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  flex: 0,
                                ),
                                Expanded(
                                  child: Text(
                                    "现场照片",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                  flex: 9,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            child: Wrap(
                                direction: Axis.horizontal,
                                spacing: -25.0, // 主轴(水平)方向间距
                                // runSpacing: 20.0, // 纵轴（垂直）方向间距
                                alignment: WrapAlignment.end, //沿主轴方向居中
                                children: initData.photoUrls != null
                                    ? initData.photoUrls.map((f) {
                                  return Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        width: 40,
                                        height: 40,
                                        //  margin: EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(
                                                    20.0)),
                                            image: DecorationImage(
                                                image: NetworkImage(f),
                                                fit: BoxFit.cover)),
                                      ),
                                    ],
                                  );
                                }).toList()
                                    : List()),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: GetConfig.getColor(theme),
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {

                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context) {
                            return PhotoViewPage(initData.photoUrls);
                          }));

                    },
                  ),
                ),

                Container(
                  color: Colors.grey[100],
                  height: 10,
                ),

                Container(
                  color: Colors.grey[100],
                  height: 10,
                ),

                //执行日志
                Container(
                  padding: EdgeInsets.only(left: 15),
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
                            return new HidenDangerFlowRecord(
                                this.initData.dangerId);
                          }));
                    },
                  ),
                ),
                Container(
                  color: Colors.grey[100],
                  height: 10,
                ),

                //评审部门
//                Row(
//                  children: <Widget>[
//                    Expanded(flex: 5,
//                      child:Container(
//                        padding: EdgeInsets.only(left: 10,top:10),
//                        width: 150,
//                        height: 50,
//                        child:Row(children: <Widget>[
//                          Expanded(
//                            child: Text("*",style: TextStyle(color: Colors.red),),
//                            flex: 0,
//                          ),
//                          Expanded(
//                            child:Text("评审部门",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
//                            flex: 19,
//                          ),
//                        ],),
//                      ),),
//                    Expanded(
//                      flex:5,
//                      child:
//                      Text(initData.reviewInfo==null?"":initData.reviewInfo.reviewUserDepartMent, style:TextStyle(color: Colors.black),),),
//
//                  ],
//                ),
//                //评审人
//                Row(
//                  children: <Widget>[
//                    Expanded(flex: 5,
//                      child:Container(
//                        padding: EdgeInsets.only(left: 10,top:10),
//                        width: 150,
//                        height: 50,
//                        child:Row(children: <Widget>[
//                          Expanded(
//                            child: Text("*",style: TextStyle(color: Colors.red),),
//                            flex: 0,
//                          ),
//                          Expanded(
//                            child:Text("评审人",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
//                            flex: 19,
//                          ),
//                        ],),
//                      ),),
//                    Expanded(
//                      flex:5,
//                      child:
//                      Text(initData.reviewInfo==null?"":initData.reviewInfo.reviewUser ,  style:TextStyle(color: Colors.blue),),),
//
//                  ],
//                ),
//                //整改部门
//                Row(
//                  children: <Widget>[
//                    Expanded(flex: 5,
//                      child:Container(
//                        padding: EdgeInsets.only(left: 10,top:10),
//                        width: 150,
//                        height: 50,
//                        child:Row(children: <Widget>[
//                          Expanded(
//                            child: Text("*",style: TextStyle(color: Colors.red),),
//                            flex: 0,
//                          ),
//                          Expanded(
//                            child:Text("治理部门",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
//                            flex: 19,
//                          ),
//                        ],),
//                      ),),
//                    Expanded(
//                      flex:5,
//                      child:
//                      Text(initData.reformInfo==null?"-":initData.reformInfo.reformUserDepartMent, style:TextStyle(color: Colors.black),),),
//
//                  ],
//                ),
//                //整改人
//                Row(
//                  children: <Widget>[
//                    Expanded(flex: 5,
//                      child:Container(
//                        padding: EdgeInsets.only(left: 10,top:10),
//                        width: 150,
//                        height: 50,
//                        child:Row(children: <Widget>[
//                          Expanded(
//                            child: Text("*",style: TextStyle(color: Colors.red),),
//                            flex: 0,
//                          ),
//                          Expanded(
//                            child:Text("治理人",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
//                            flex: 19,
//                          ),
//                        ],),
//                      ),),
//                    Expanded(
//                      flex:5,
//                      child:
//                      Text(initData.reformInfo==null?"-":initData.reformInfo.reformUser, style:TextStyle(color: Colors.blue),),),
//
//                  ],
//                ),
                //整改日期
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        width: 150,
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              ),
                              flex: 0,
                            ),
                            Expanded(
                              child: Text(
                                "治理日期",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                              flex: 19,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        new DateFormat('yyyy-MM-dd').format(DateTime.parse(
                            initData.reformLimitDate == null
                                ? new DateTime.now().toString()
                                : initData.reformLimitDate.toString())),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),

                //治理方式
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        width: 150,
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              ),
                              flex: 0,
                            ),
                            Expanded(
                              child: Text(
                                "治理方式",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                              flex: 19,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        initData.reformTypeDesc ?? "-",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),

                //治理措施
                Container(
                  padding: EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text("治理措施",
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
                            return new HiddenDangerProcessedRectificationMeasuresShow(
                                this.initData);
                          }));
                    },
                  ),
                ),

                Container(
                  color: Colors.grey[100],
                  height: 10,
                ),

                ///验收结果
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        width: 150,
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              ),
                              flex: 0,
                            ),
                            Expanded(
                              child: Text(
                                "验证结果",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                              flex: 19,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(
                              left: 30,
                              top: 5,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: new Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: RadioListTile(
                                            title: Text("合格"),
                                            value: 1,
                                            groupValue: radioValue,
                                            onChanged: (value) {
                                              setState(() {
                                                print(value);
                                                radioValue = value;
                                              });
                                            }),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: RadioListTile(
                                            title: Text("不合格"),
                                            value: 2,
                                            groupValue: radioValue,
                                            onChanged: (value) {
                                              setState(() {
                                                print(value);
                                                radioValue = value;
                                              });
                                            }),
                                      ),
                                    ],
                                  ),
                                  flex: 3,
                                ),
                              ],
                            )),
                      ],
                    )),
                Container(
                  color: Colors.grey[100],
                  height: 10,
                ),
                //拍照取证
                Container(
                  child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.only(left: 18),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                Expanded(
                                  child: Text(
                                    "拍照取证",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                  flex: 9,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            child: Wrap(
                                spacing: -25.0, // 主轴(水平)方向间距
                                // runSpacing: 20.0, // 纵轴（垂直）方向间距
                                alignment: WrapAlignment.end, //沿主轴方向居中
                                children: hideDanger.photoUrls != ""
                                    ? hideDanger.photoUrls.split(",").map((f) {
                                  return Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        width: 40,
                                        height: 40,
                                        //  margin: EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(
                                                    20.0)),
                                            image: DecorationImage(
                                                image: NetworkImage(f),
                                                fit: BoxFit.cover)),
                                      ),
                                    ],
                                  );
                                }).toList()
                                    : List()),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Icon(
                              Icons.photo_camera,
                              color: GetConfig.getColor(theme),
                              size: 22,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: GetConfig.getColor(theme),
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (!initData.currentUserCanExcute) {
                        HiddenDangerFound.popUpMsg("无权限操作该任务！");
                        return false;
                      }

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ImageList(this.imageList);
                          })).then((v) {
                        if (v != null) {
                          setState(() {
                            imageList = v;
                            List<Attachment> fileData = new List();
                            if (null != this.imageList &&
                                this.imageList.length > 0) {
                              this.imageList.forEach((f) {
                                fileData.add(Attachment.fromParams(file: f));
                              });
                              //保存图片
                              _upDateImg(fileData);
                            }
                          });
                        }
                      });
                    },
                  ),
                ),

                Container(
                  color: Colors.grey[100],
                  height: 10,
                ),

                ///备注
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "备注",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                              flex: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 100,
                  margin: EdgeInsets.only(bottom: 30),
                  decoration: new BoxDecoration(
                      color: Color.fromRGBO(244, 244, 244, 1)),
                  child: TextField(
                    maxLength: 500,
                    controller: hideDanger.remark,
                    maxLines: null,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      border: InputBorder.none,
                      hasFloatingPlaceholder: true,
                      hintText: "请输入备注",
                      filled: true,
                      fillColor: Color.fromRGBO(244, 244, 244, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }
}
