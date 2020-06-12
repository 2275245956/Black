import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/model/plan_inspection/check_point_detail.dart';
import 'package:intelligent_check_new/model/plan_inspection/plan_task_detail.dart';
import 'package:intelligent_check_new/pages/CheckExecute/navigation_checkexec.dart';
import 'package:intelligent_check_new/pages/plan_inspection/plan_list_content_detail.dart';
import 'package:intelligent_check_new/pages/plan_inspection/plan_list_screen.dart';
import 'package:intelligent_check_new/pages/plan_inspection/qr_page.dart';
import 'package:intelligent_check_new/services/no_plan_inspection.dart';
import 'package:intelligent_check_new/services/plan_inspection_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/tools/MessageBox.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_nfc_tools/flutter_nfc_tools.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';

class PlanListContent extends StatefulWidget {
  final num planTaskId;
  bool nfcCanDo = false;
  PlanListContent(this.planTaskId,[this.nfcCanDo]);

  @override
  State<StatefulWidget> createState() => _PlanListContent(planTaskId);
}

class _PlanListContent extends State<PlanListContent>
    with AutomaticKeepAliveClientMixin {
  // 页面接受参数
  num planTaskId;

  // 构造方法
  _PlanListContent(this.planTaskId);

  @override
  bool get wantKeepAlive => true;

  bool isAnimating = false;
  bool nfcProcess = false;
  bool nfcCanDo = false;

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  PlanTaskDetail initData;

  String theme = "blue";
  LoginResult loginResult;
  bool hasOperationPermission = false;
  bool hasFixedPoint = false;

  ////////////////
  CheckPointDetail pointDetail;

  Future<void> initPlatformState() async {
    try {

      FlutterNfcTools.ndefEventsStream.listen((m) {
        this.nfcCanDo = this.widget.nfcCanDo;
        if (m['ndefMessage'] == null) {
          Fluttertoast.showToast(
            msg: '标签无内容',
            toastLength: Toast.LENGTH_SHORT,
          );
          return;
        }

        List<int> payload =
            m['ndefMessage'][0]['payload'].sublist(3).cast<int>().toList();
        String content = FlutterNfcTools.bytesToString(payload);
        if (content.isNotEmpty) {
          if (initData.finishStatus == 1 && nfcProcess == false && nfcCanDo == true) {
            setState(() {
              nfcProcess = true;
              nfcCanDo = false;
            });
            getNfcContent(content);
          }
        } else {
          Fluttertoast.showToast(
            msg: '标签内容无法识别！',
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      });
    } on PlatformException {
      Fluttertoast.showToast(
        msg: '内容读取失败！',
        toastLength: Toast.LENGTH_SHORT,
      );
    }

    if (!mounted) return;
  }

  @override
  void initState() {
    super.initState();

//    initPlatformState();
//    loadData();
    setState(() {
      nfcCanDo = this.widget.nfcCanDo;
    });
    initConfig();
  }

  initConfig() async {
    SharedPreferences.getInstance().then((preferences) {
//      setState(() {
//        this.theme = preferences.getString("theme");
//      });
      String str = preferences.get('LoginResult');
      setState(() {
        loginResult = LoginResult(str);
        this.theme =
            preferences.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
      });
    }).then((f) {
      loadData();
    });
  }

  void loadData() async {
    setState(() {
      isAnimating = true;
    });

    await queryPlanTaskById(planTaskId).then((data) {
      if (data.message != null && data.message.isNotEmpty) {
        MessageBox.showMessageAndExitCurrentPage(data.message, true, context);
        return;
      }

      setState(() {
        initData = data;
        isAnimating = false;
//        hasOperationPermission = loginResult.user.id == initData.userId;
        //id有多个
        if (initData.userId != null && initData.userId != "") {
          hasOperationPermission =
              initData.userId.split(",").contains(loginResult.user.id);
        }
        if (initData.points != null && initData.points.length > 0) {
          hasFixedPoint =
              initData.points.where((f) => f.isFixed == "1").length > 0;
        }
      });

      if (hasOperationPermission && hasFixedPoint) {
        initPlatformState();
      }
    }).then((v) {
      // 进行中的任务进行提示
      if (initData.finishStatus == 1 &&
          hasOperationPermission &&
          hasFixedPoint) {
        Fluttertoast.showToast(
          msg: '请您靠近标签或扫码！',
          textColor: Colors.white,
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
      }
      if (initData.finishStatus == 1 && !hasOperationPermission) {
        Fluttertoast.showToast(
          msg: '非本人计划不能进行巡检！',
          textColor: Colors.white,
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    });

//    DefaultAssetBundle.of(context).loadString("assets/data/plan_inspection.json").then((data){
//      setState(() {
//        var items =  json.decode(data);
//        print(items);
//        List<Point> points = List();
//        if(items["result"] == "SUCCESS"){
//          var dataList = items["dataList"];
//          var _points = dataList["points"];
//          for(var d in _points){
//            points.add(Point.fromJson(d));
//          }
//          initData = PlanTaskDetail.fromJson(dataList["planTask"]);
//          initData.points = points;
//          isAnimating = false;
//        }
//      });
//    });
  }

  getDetailData(int pointId) async {
    await queryPointPlanTaskDetail(this.widget.planTaskId, pointId)
        .then((data) {
      if (data.message != null && data.message.isNotEmpty) {
        MessageBox.showMessageAndExitCurrentPage(data.message, true, context);
        return;
      }

      setState(() {
        pointDetail = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (initData == null) {
      return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
          title: Text(
            "",
            style: TextStyle(color: Colors.black, fontSize: 19),
          ),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PlanListScreen();
                }));
              },
              child: Icon(Icons.keyboard_arrow_left,
                  color: GetConfig.getColor(theme), size: 32),
            ),
          ),
//            actions: <Widget>[
//              IconButton(icon: Icon(Icons.crop_free,color: Colors.red,),onPressed: (){},),
//              IconButton(icon: Icon(Icons.refresh,color: Colors.red,),onPressed: (){},)
//            ],
        )),
        onWillPop: () {
          setState(() {
            nfcCanDo = false;
            this.widget.nfcCanDo = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PlanListScreen();
          }));
        },
      );
    }

    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              initData.taskName ?? "",
              style: TextStyle(color: Colors.black, fontSize: 19),
            ),
            centerTitle: true,
            elevation: 0.2,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            leading: new Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PlanListScreen();
                  }));
                },
                child: Icon(Icons.keyboard_arrow_left,
                    color: GetConfig.getColor(theme), size: 32),
              ),
            ),
            actions: <Widget>[
              initData.finishStatus == 1 &&
                      hasOperationPermission &&
                      hasFixedPoint
                  ? IconButton(
                      icon: Icon(
                        Icons.crop_free,
                        color: GetConfig.getColor(theme),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) {
                          return QrPage(planTaskId);
                        })).then((v) {
                          // 刷新页面
                          loadData();
                        });
                      },
                    )
                  : Container(),
              IconButton(
                icon: Icon(
                  Icons.autorenew,
                  color: GetConfig.getColor(theme),
                ),
                onPressed: () {
                  loadData();
                },
              )
            ],
          ),
          body: ModalProgressHUD(
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        width: 400,
                        child: Stack(
                          children: <Widget>[
                            new charts.PieChart(_createSampleData(initData),
                                animate: false,
                                defaultRenderer: new charts.ArcRendererConfig(
                                    arcWidth: 20,
                                    arcRendererDecorators: [
                                      new charts.ArcLabelDecorator()
                                    ])),
                            Positioned(
                              top: 70,
                              left: 150,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    initData.taskPlanNum.toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text("计划巡检")
                                ],
                              ),
                            )
                          ],
                        )),
                    flex: 2,
                  ),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: 10, top: 20),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "计划状态：" + getStatus(initData.finishStatus),
                                    style: TextStyle(
                                        color:
                                            getBgColor(initData.finishStatus)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 50),
                                  ),
                                  Text("按序巡检：",
                                      style: TextStyle(color: Colors.grey)),
                                  Text(initData.inOrder == "0" ? "否" : "是",
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              Container(
//                          width: 320,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "时间:" +
                                          initData.beginTime +
                                          " - " +
                                          initData.endTime,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                      flex: 1),
                  Expanded(
                    child: EasyRefresh(
                      key: _easyRefreshKey,
                      behavior: ScrollOverBehavior(),
                      refreshHeader: ClassicsHeader(
                        key: _headerKey,
                        bgColor: Colors.transparent,
                        textColor: Colors.black87,
                        moreInfoColor: Colors.black54,
                        showMore: true,
                      ),
                      refreshFooter: ClassicsFooter(
                        key: _footerKey,
                        bgColor: Colors.transparent,
                        textColor: Colors.black87,
                        moreInfoColor: Colors.black54,
                        showMore: true,
                      ),
                      child: new ListView.builder(
                        //ListView的Item
                        itemCount: initData.points.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new Container(
                              height: 70.0,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: GestureDetector(
                                child: Card(
                                    elevation: 0.2,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 7,
                                          height: 110,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(4),
                                                  bottomLeft:
                                                      Radius.circular(4)),
                                              color: getPointColor(initData
                                                  .points[index].status)),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width-60,
                                          padding:
                                              EdgeInsets.only(left: 10, top: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Text(
                                                initData.points[index].name,
                                                style: new TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                              ),
                                              Container(
                                                width: 280,
                                                child: Row(
                                                  children: <Widget>[
                                                    Text("编号:" +
                                                        initData.points[index]
                                                            .pointNO),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 36),
                                                    ),
                                                    Text(
                                                      getPointStatus(initData
                                                          .points[index]
                                                          .status),
                                                      style: TextStyle(
                                                          color: getPointColor(
                                                              initData
                                                                  .points[index]
                                                                  .status)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
//                                Padding(padding: EdgeInsets.only(left: 100),),
                                        new Icon(
                                          Icons.keyboard_arrow_right,
                                          color: GetConfig.getColor(theme),
                                        )
                                      ],
                                    )),
                                onTap: () {
                                  if (hasOperationPermission) {
                                    if (initData.points[index].isFixed == "1") {
                                      // 必须扫码，所以跳转到详情页
//                              getDetailData(initData.points[index].pointId);

                                      Navigator.push(context,
                                          new MaterialPageRoute(
                                              builder: (context) {
//                                return new CheckExecListContent(initData.points[index].pointId);
                                        return new PlanListContentDetail(
                                            planTaskId,
                                            initData.points[index].pointId);
                                      })).then((v) {
                                        loadData();
                                      });
                                    } else {
                                      // 直接去填写页面
                                      if (initData.points[index].status ==
                                          "0") {
                                        Navigator.push(context,
                                            new MaterialPageRoute(
                                                builder: (context) {
                                          return NavigationCheckExec(
                                              initData.points[index].pointId,
                                              planId: this.planTaskId);
                                        })).then((v) {
                                          loadData();
                                        });
                                      } else {
                                        Navigator.push(context,
                                            new MaterialPageRoute(
                                                builder: (context) {
//                                return new CheckExecListContent(initData.points[index].pointId);
                                          return new PlanListContentDetail(
                                              planTaskId,
                                              initData.points[index].pointId);
                                        }));
                                      }
                                    }
                                  }
                                },
                              ));
                        },
                      ),
                    ),
                    flex: 4,
                  ),
                ],
              ),
            ),
            inAsyncCall: isAnimating,
            // demo of some additional parameters
            opacity: 0.7,
            progressIndicator: CircularProgressIndicator(),
          )),
      onWillPop: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PlanListScreen();
        }));
      },
    );
  }

  List<charts.Series<LinearSales, String>> _createSampleData(
      PlanTaskDetail initData) {
    List<LinearSales> data = [];
    if (initData.taskPlanNum == 0) {
      data.add(
          new LinearSales("", -1, charts.MaterialPalette.gray.shadeDefault));
    } else {
      if (initData.unqualified > 0) {
        data.add(new LinearSales("异常", initData.unqualified,
            charts.MaterialPalette.red.shadeDefault));
      }
      if (initData.omission > 0) {
        data.add(new LinearSales("漏检", initData.omission,
            charts.MaterialPalette.yellow.shadeDefault));
      }
      if (initData.finshNum > 0) {
        data.add(new LinearSales("正常", initData.finshNum,
            charts.MaterialPalette.green.shadeDefault));
      }
      if (initData.unplan > 0) {
        data.add(new LinearSales(
            "未开始", initData.unplan, charts.MaterialPalette.gray.shadeDefault));
      }
    }
    return [
      new charts.Series<LinearSales, String>(
        id: 'Sales',
        colorFn: (LinearSales data, _) => data.color,
        domainFn: (LinearSales data, _) => data.year,
        measureFn: (LinearSales data, _) => data.sales,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) =>
            row.sales == -1 ? "" : '${row.year}: ${row.sales}',
      )
    ];
  }

  Color getBgColor(int finishStatus) {
    if (finishStatus == 0) {
      // 未开始
      return Colors.grey;
    } else if (finishStatus == 1) {
      // 进行中
      return Colors.orange;
    } else if (finishStatus == 2) {
      // 已结束
      return Colors.red[800];
    } else if (finishStatus == 3) {
      // 已超时
      return Colors.redAccent;
    } else {
      return Colors.white;
    }
  }

  String getStatus(int finishStatus) {
    if (finishStatus == 0) {
      // 未完成
      return "未开始";
    } else if (finishStatus == 1) {
      // 进行中
      return "进行中";
    } else if (finishStatus == 2) {
      // 未开始
      return "已结束";
    } else if (finishStatus == 3) {
      // 已超时
      return "已超时";
    } else {
      return "";
    }
  }

  Color getPointColor(String pointStatus) {
    if (pointStatus == "0") {
      return Colors.grey;
    } else if (pointStatus == "1") {
      return Colors.green;
    } else if (pointStatus == "2") {
      return Colors.red;
    } else if (pointStatus == "3") {
      return Colors.yellow;
    } else {
      return Colors.white;
    }
  }

  String getPointStatus(String pointStatus) {
    if (pointStatus == "0") {
      return "未开始";
    } else if (pointStatus == "1") {
      return "正常";
    } else if (pointStatus == "2") {
      return "异常";
    } else if (pointStatus == "3") {
      return "漏检";
    } else {
      return "";
    }
  }

  //////////////////////////////////////////////
  getNfcContent(String no) async {
    // check点的合法性
    int pointNum =
        initData.points.where((f) => f.pointNO == no).toList().length;
    if (pointNum <= 0) {
      Fluttertoast.showToast(
        msg: '此点非巡检计划中的点，请确认后重新执行！',
        toastLength: Toast.LENGTH_SHORT,
      ).then((v) {
        return;
      });
      return;
    }

    await getQueryPlanTaskBySerialInfo(2, no, this.initData.planTaskId)
        .then((data) {
      // 跳转页面
      if (data != null && data.success) {
        Point _execPoint;
        for (var _point in initData.points) {
          if (_point.pointId == data.id) {
            _execPoint = _point;
            break;
          }
        }

        if (null == _execPoint) {
          Fluttertoast.showToast(
            msg: '此点非巡检计划中的点，请确认后重新执行！',
            toastLength: Toast.LENGTH_SHORT,
          );
          return;
        }

        // 检查点是否已经巡检过
        bool hasChecked = false;
        if (_execPoint != null && _execPoint.finish != 0) {
          hasChecked = true;
        }
        if (hasChecked) {
          Fluttertoast.showToast(
            msg: '该巡检点已经进行过巡检！',
            toastLength: Toast.LENGTH_SHORT,
          );
        } else {
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return NavigationCheckExec(data.id,
                planId: this.planTaskId, checkMode: "NFC");
          })).then((v) {
            // 刷新页面
            loadData();
            setState(() {
              nfcProcess = false;
              nfcCanDo = true;
            });
          });
        }
      } else {
        Fluttertoast.showToast(
          //msg: '没有对应的巡检计划！',
          msg: data.message,
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    });
  }
}

class LinearSales {
  final String year;
  final int sales;
  final charts.Color color;

  LinearSales(this.year, this.sales, this.color);
}
