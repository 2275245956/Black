import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/Hidden_Danger/hidden_danger_model.dart';
import 'package:intelligent_check_new/model/MovePointAttachment.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageList.dart';
import 'package:intelligent_check_new/pages/ImageViewPage.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/MultySelectContract.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_check.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_flowRecord.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_processed_details_rescinded.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_rectification.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidedanger_pending.dart';
import 'package:intelligent_check_new/services/HiddenDanger.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HiddenDangerReview extends StatefulWidget {
  // HiddenDangerReview({Key key}) : super(key: key);
  final int dangerId;
  final num state;

  static goToPage(num state, num dangerId, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      switch (state) {
        case 1: //待评审
          return new HiddenDangerReview(dangerId);
          break;
        case 2: //待治理
          return new HiddenDangerRectification(dangerId);
          break;
        case 3: //安措计划中
          return new HiddenDangerProcessedDetailsRescinded(dangerId);
          break;

        case 4: //待验证
          return new HiddenDangerProcessedDetailsChecked(dangerId);
          break;
        case 5: //治理完毕
          return new HiddenDangerProcessedDetailsChecked(dangerId);
          break;
        case 6: //已撤销
          return new HiddenDangerProcessedDetailsRescinded(dangerId);
          break;
        default:
          return new HiddenDangerProcessedDetailsRescinded(dangerId);
          break;
      }
    }));
  }

  HiddenDangerReview(this.dangerId, {this.state});

  @override
  _HiddenDangerReview createState() => new _HiddenDangerReview();
}

class _HiddenDangerReview extends State<HiddenDangerReview> {
  @override
  bool get wantKeepAlive => true;
  bool canOperate = true;
  bool isAnimating = false;

  // 当前点的附件
  List<File> imageList;
  String myUserId;
  List<String> photoUrls = new List(5);
  HideDangerInfoModel initData;

  HideDanger hidedanger = HideDanger();

  String theme = "";

  // 当前页码
  int pageIndex = 0;

  // 是否有下一页
  bool hasNext = false;

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
      setState(() {
        if (data != null) {
          initData = data;
          if (this.widget.state!=null && initData.dangerState!=null &&  this.widget.state!=initData.dangerState) {
            HiddenDangerReview.goToPage( initData.dangerState, initData.dangerId, context);
          }

          //hasNext = false;
        }
        isAnimating = false;
      });
    });
  }

  _upDateImg(List<Attachment> att) async {
    setState(() {
      isAnimating = true;
      canOperate = false;
    });
    var bizCode = "latent_danger_review";
    await updataImg(att, bizCode).then((data) {
      setState(() {
        ///保存文件路径
        if (data.success) {
          hidedanger.photoUrls = data.message;
          HiddenDangerFound.popUpMsg("图片上传成功!");
        } else {
          HiddenDangerFound.popUpMsg(data.message);
        }

        isAnimating = false;
        canOperate = true;
      });
    });
  }

  _saveReviewResult(HideDanger hd, radio) async {
    setState(() {
      isAnimating = true;
      canOperate = false;
    });
    var result = 0;
    if (radio == 1) {
      result = 2;
    } else {
      result = 3;
    }
    var jsonFlow = {
      // "reformDept": hd.reviewDeptName.text,
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
    if (radioValue != 2) {
//      if (initData.dangerType == 1 && hidedanger.reviewDeptName.text == "") {
//        HiddenDangerFound.popUpMsg("请选择治理部门！");
//        return false;
//      }
      if (initData.dangerType == 1 && hidedanger.reviewUserName.text == "") {
        HiddenDangerFound.popUpMsg("请选择治理人！");

        return false;
      }
      if (hidedanger.limitDate.text == "") {
        HiddenDangerFound.popUpMsg("请选择治理期限！");

        return false;
      }
//      if (imageList == [] || imageList == null) {
//        HiddenDangerFound.popUpMsg("请上传图片！");
//        return false;
//      }
    } else {
      if (hidedanger.remark.text == "") {
        //不通过
        HiddenDangerFound.popUpMsg("评审结果不通过！请填写评审说明！");
        return false;
      }
    }

    return true;
  }

  ///初始化单选数据
  var radioValue = 1;

  @override
  Widget build(BuildContext context) {
    //null == routeList || routeList.length <= 0
    if (initData == null || initData.dangerId ==null) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              "隐患评审",
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
          "隐患评审",
          style: TextStyle(color: Colors.black, fontSize: 19),
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
                      if (_checkNeed()) {
                        _saveReviewResult(hidedanger, radioValue);
                      }
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
                // 风险点名称

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

                    //等级
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.only(left: 10, top: 10),
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
                        ),
                      ],
                    ),

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

                // Divider(),

                //隐患名称
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
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
                                    color: Colors.black, fontSize: 18),
                              ),
                              flex: 19,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(child: Text(initData.dangerName ?? "-"),padding: EdgeInsets.only(right: 10,top: 5),),
                    ),
                  ],
                ),
                //隐患地点
                initData.position==null?Container():Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
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
                                    color: Colors.black, fontSize: 18),
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
                //隐患等级
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
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
                                    color: Colors.black, fontSize: 18),
                              ),
                              flex: 19,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(initData.levelDesc ?? "-",
                          style: TextStyle(
                            color: initData.level == 1
                                ? Colors.orange
                                : Colors.red,
                          )),
                    ),
                  ],
                ),


                Container(
                  child: GestureDetector(
                    child:  Row(
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
                                        color: Colors.black, fontSize: 18),
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
                            child: GestureDetector(
                              //50  89  206
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: GetConfig.getColor(theme),
                                size: 22,
                              ),
                              onTap: () {

                                Navigator.push(context,
                                    new MaterialPageRoute(builder: (context) {
                                      return PhotoViewPage(initData.photoUrls);
                                    }));

                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (initData.photoUrls != null &&
                          initData.photoUrls.length > 0) {
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) {
                              return PhotoViewPage(initData.photoUrls);
                            }));
                      }
                    },
                  ),


                ),

                Container(
                  color: Colors.grey[100],
                  height: 10,
                ),

                //执行日志
                Container(
                  padding: EdgeInsets.only(left: 17),
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

                //评审结果
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      width: MediaQuery.of(context).size.width,
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
                              "评审结果",
                              style:
                              TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            flex: 19,
                          ),
                        ],
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
                                        flex: 5,
                                        child: RadioListTile(
                                            title: Text("通过"),
                                            value: 1,
                                            groupValue: radioValue,
                                            onChanged: (value) {
                                              setState(() {
                                                print(value);
                                                radioValue = value;
                                              });
                                            }),
                                        //带文字的单选按钮 value值=groupValue值 即选中状态
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: RadioListTile(
                                            title: Text("不通过"),
                                            value: 2,
                                            groupValue: radioValue,
                                            onChanged: (value) {
                                              setState(() {
                                                print(value);
                                                radioValue = value;
                                              });
                                            }),
                                        //带文字的单选按钮 value值=groupValue值 即选中状态
                                      ),
                                    ],
                                  ),
                                  flex: 3,
                                ),
                              ],
                            )),
                      ],
                    )),


                ///治理人
                initData.dangerType == 1 && radioValue == 1
                    ? Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                        EdgeInsets.only(left: 10, top: 10, bottom: 5),
                        width: MediaQuery.of(context).size.width - 50,
                        child: Column(
                          children: <Widget>[
                            Row(
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
                                    "治理人",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18),
                                  ),
                                  flex: 19,
                                ),
                              ],
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width -
                                    50,
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.only(
                                  top: 5,
                                  bottom: 5,
                                ),
                                color: Color.fromRGBO(244, 244, 244, 1),
                                child: GestureDetector(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 9,
                                              child: TextField(
                                                enabled: false,

                                                ///只读属性
                                                autofocus: false,
                                                controller: hidedanger
                                                    .reviewUserName,
                                                maxLines: null,
                                                decoration:
                                                InputDecoration(
                                                  contentPadding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10),
                                                  border:
                                                  InputBorder.none,
                                                  hintText: "治理人",
                                                  filled: true,
                                                  fillColor:
                                                  Color.fromRGBO(244,
                                                      244, 244, 1),
                                                ),
                                                onEditingComplete: () {
                                                  //print(this._controller.text);
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_right,
                                                color: GetConfig.getColor(theme),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(context,
                                        new MaterialPageRoute(
                                            builder: (context) {
                                              return MultySelContact();
                                            })).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          var userInfo =
                                          json.decode(value.name);
                                          hidedanger.reviewUserName.text =
                                          userInfo["uName"];
                                          hidedanger.reviewDeptName.text =
                                          userInfo["uDept"];
                                          hidedanger.reviewUserIds =
                                          userInfo["uIds"];
                                        });
                                      }
                                    });
                                  },
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                    : Container(),
                //整改日期

                radioValue == 1
                    ? Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                        EdgeInsets.only(left: 10, top: 10, bottom: 5),
                        width: MediaQuery.of(context).size.width - 50,
                        child: Column(
                          children: <Widget>[
                            Row(
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
                                        color: Colors.black,
                                        fontSize: 18),
                                  ),
                                  flex: 19,
                                ),
                              ],
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width -
                                    50,
                                margin:
                                EdgeInsets.only(top: 5, bottom: 10),
                                padding: EdgeInsets.only(
                                  top: 5,
                                  bottom: 5,
                                ),
                                color: Color.fromRGBO(244, 244, 244, 1),
                                child: GestureDetector(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 9,
                                              child: TextField(
                                                enabled: false,

                                                ///只读属性
                                                keyboardType:
                                                TextInputType.number,
                                                autofocus: false,
                                                controller:
                                                hidedanger.limitDate,
                                                maxLines: null,
                                                decoration:
                                                InputDecoration(
                                                  contentPadding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10),
                                                  border:
                                                  InputBorder.none,
                                                  hintText: "选择治理日期",
                                                  filled: true,
                                                  fillColor:
                                                  Color.fromRGBO(244,
                                                      244, 244, 1),
                                                ),
                                                onEditingComplete: () {
                                                  //print(this._controller.text);
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Icon(
                                                Icons.date_range,
                                                color: GetConfig.getColor(theme),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(2000, 1, 1),
                                        maxTime: DateTime(2199, 12, 31),
                                        theme: DatePickerTheme(
                                            itemStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.bold),
                                            doneStyle: TextStyle(
                                                color:  GetConfig.getColor(theme),
                                                fontSize: 16)),
                                        onConfirm: (date) {
                                          var selDate =
                                          new DateFormat("yyyy-MM-dd")
                                              .format(date);
                                          hidedanger.limitDate
                                              .text = new DateFormat(
                                              "yyyy-MM-dd HH:mm:ss")
                                              .format(DateTime.parse(selDate)
                                              .add(new Duration(days: 1))
                                              .add(new Duration(
                                              seconds: -1)));
                                        },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.zh);
                                  },
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                    : Container(),
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
                            padding: EdgeInsets.only(left: 10, top: 5),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "  ",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  flex: 0,
                                ),
                                Expanded(
                                  child: Text(
                                    "拍照取证",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
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
                                children: hidedanger.photoUrls != ""
                                    ? hidedanger.photoUrls.split(",").map((f) {
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
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
                      //  print("拍照取证");
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
                                fileData
                                    .add(Attachment.fromParams(file: f));
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
                //评审说明
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
                                "*",
                                style: TextStyle(color: Colors.red),
                              ),
                              flex: 0,
                            ),
                            Expanded(
                              child: Text(
                                "评审说明",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              flex: 9,
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
                    autofocus: false,
                    controller: hidedanger.remark,
                    enableInteractiveSelection: true,
                    maxLines: null,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      border: InputBorder.none,
                      hintText: "请输入",
                      filled: true,
                      fillColor: Color.fromRGBO(244, 244, 244, 1),
                    ),
                    onEditingComplete: () {},
                  ),
                ),
                Container(
                  color: Colors.grey[100],
                  height: 10,
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
