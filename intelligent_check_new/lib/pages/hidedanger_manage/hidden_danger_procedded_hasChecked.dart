import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/Hidden_Danger/hidden_danger_model.dart';
import 'package:intelligent_check_new/pages/ImageViewPage.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_flowRecord.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_processed.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_processed_rectification_measures_show.dart';
import 'package:intelligent_check_new/services/HiddenDanger.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HiddenDangerProcessedCheckedDetail extends StatefulWidget {
  final int dangerId;

  HiddenDangerProcessedCheckedDetail(this.dangerId);

  @override
  _HiddenDangerProcessedCheckedDetail createState() =>
      new _HiddenDangerProcessedCheckedDetail();
}

class _HiddenDangerProcessedCheckedDetail
    extends State<HiddenDangerProcessedCheckedDetail> {
  TextEditingController remark = new TextEditingController();

  @override
  bool get wantKeepAlive => true;

  bool isAnimating = false;

  String myUserId;

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
      setState(() {
        if (data != null) {
          initData = data;
        }
        isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ///null == routeList || routeList.length <= 0
    if (initData == null || initData.dangerId == null) {
      return Scaffold(
          appBar: AppBar(
        title: Text(
          "隐患验证详情",
          style: TextStyle(
              color: Colors.black, fontSize: 19, fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[],
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(
                    builder: (context) => new ProcessedHiddenDanger()),
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
          "隐患验证详情",
          style: TextStyle(
              color: Colors.black, fontSize: 19, fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[],
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(
                    builder: (context) => new ProcessedHiddenDanger()),
                (route) => route == null),
            child: Icon(Icons.keyboard_arrow_left,
                color: GetConfig.getColor(theme) /*GetConfig.getColor(theme)*/,
                size: 32),
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                        // Divider(),
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
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
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
              initData.position ==null?Container(): Row(
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
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
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
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
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
                          color:
                              initData.level == 1 ? Colors.orange : Colors.red),
                    ),
                  ),
                ],
              ),


              //拍照取证
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
                                    fontSize: 18,
                                  ),
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
                      return new HidenDangerFlowRecord(this.initData.dangerId);
                    }));
                  },
                ),
              ),
              Container(
                color: Colors.grey[100],
                height: 10,
              ),

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
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
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
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
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
                              "验收结果",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
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
                      initData.dangerStateDesc == null
                          ? "-"
                          : initData.dangerStateDesc,
                      style: TextStyle(
                          color: initData.recheckInfo == null
                              ? Colors.black
                              : (initData.recheckInfo.recheckState == 2
                                  ? Colors.green
                                  : Colors.red)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
