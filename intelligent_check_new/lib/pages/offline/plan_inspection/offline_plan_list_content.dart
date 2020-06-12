import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_nfc_tools/flutter_nfc_tools.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intelligent_check_new/model/offline/offline_plan_list_output.dart';
import 'package:intelligent_check_new/pages/offline/CheckExecute/checkexec_inspection.dart';
import 'package:intelligent_check_new/pages/offline/CheckExecute/checkexec_inspection_list.dart';
import 'package:intelligent_check_new/pages/offline/plan_inspection/offline_qr_page.dart';
import 'package:intelligent_check_new/services/offline/offline_plan_inspection_services.dart';
import 'package:intelligent_check_new/tools/MessageBox.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';



class OfflinePlanListContent extends StatefulWidget{

//  final num planTaskId;
//  final String planTaskName;
  final OfflinePlanListOutput planListOutput;
  OfflinePlanListContent(this.planListOutput);

  @override
  State<StatefulWidget> createState() => _OfflinePlanListContent(planListOutput);

}

class _OfflinePlanListContent extends State<OfflinePlanListContent>
    with AutomaticKeepAliveClientMixin {

  OfflinePlanListOutput planListOutput;
  // 构造方法
  _OfflinePlanListContent(this.planListOutput);

  @override
  bool get wantKeepAlive => true;

  bool isAnimating = false;
  bool nfcProcess = false;
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  OfflinePlanListOutput initData;

  Future<void> initPlatformState() async {
    try {
      FlutterNfcTools.ndefEventsStream.listen((m) {
        if(m['ndefMessage']==null){
          Fluttertoast.showToast(
            msg: '标签无内容',
            toastLength: Toast.LENGTH_SHORT,
          );
          return;
        }

        print(m['ndefMessage'][0]['payload']);

        List<int> payload = m['ndefMessage'][0]['payload'].sublist(3).cast<int>().toList();
        String content = FlutterNfcTools.bytesToString(payload);
        if(content.isNotEmpty && nfcProcess == false){
          setState(() {
            nfcProcess = true;
          });
          getContent(content);
        }else{
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

    initPlatformState();
    loadData();
  }

  void loadData () async{
    setState(() {
      isAnimating = true;
    });
    await getOfflinePlanListOutputById(planListOutput.planTaskId).then((data){
      setState(() {
        initData = data;
        isAnimating = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    if (initData == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text("",style: TextStyle(color: Colors.black,fontSize: 19),),
            centerTitle: true,
            elevation: 0.2,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            leading:new Container(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
              ),
            ),
          )
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(initData.taskName??"",style: TextStyle(color: Colors.black,fontSize: 19),),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading:new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
          ),
        ),
        actions: <Widget>[
          initData.finishStatus==1?
            IconButton(icon: Icon(Icons.crop_free,color: Colors.red,),onPressed: (){
              Navigator.push( context,
                  new MaterialPageRoute(builder: (context) {
                    return QrPage(initData.planTaskId, initData.inOrder);
                  })).then((result){
                loadData();
              });
            }
            ,):Container(),
          IconButton(icon: Icon(Icons.autorenew,color: Colors.red,),onPressed: (){
            loadData();
          },)
        ],
      ),
      body:ModalProgressHUD(
      child:  Container(
        child: Column(
          children: <Widget>[
            Expanded(child: Container(
                width: 300,
                child: Stack(
                  children: <Widget>[
                    new charts.PieChart(
                        _createSampleData(initData),
                        animate: false,
                        defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 20,
                            arcRendererDecorators: [new charts.ArcLabelDecorator()])
                    ),
                    Positioned(
                      top: 70,
                      left: 120,
                      child: Column(
                        children: <Widget>[
                          Text(initData.taskPlanNum.toString(),style: TextStyle(fontSize: 18),),
                          Text("计划巡检")
                        ],
                      ),
                    )
                  ],
                )
            ),flex: 2,),

            Expanded(
                child: Container(
                    padding: EdgeInsets.only(left: 10,right: 10,top: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("计划状态：" + getStatus(initData.finishStatus),style: TextStyle(color:getBgColor(initData.finishStatus)),),
                            Padding(padding: EdgeInsets.only(left: 50),),
                            Text("按序巡检：",style: TextStyle(color: Colors.grey)),
                            Text(initData.inOrder == "0"?"否":"是",style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("时间：" +  initData.beginTime + " - "  +  initData.endTime,
                              style: TextStyle(color: Colors.grey),),
                          ],
                        )
                      ],
                    )),
                flex: 1
            ),
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
                      margin: EdgeInsets.only(left: 10,right: 10),
                      child: GestureDetector(
                        child: Card(
                            elevation:0.2,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 7,
                                  height: 110,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(4),bottomLeft:  Radius.circular(4)),
                                      color: getPointColor(initData.points[index].status)
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10,top:5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(initData.points[index].name,style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),
                                      Padding(padding: EdgeInsets.only(top: 5),),
                                      Row(
                                        children: <Widget>[
                                          Text("编号:" + initData.points[index].pointNO),
                                          Padding(padding: EdgeInsets.only(left: 36),),
                                          Text(getPointStatus(initData.points[index].status),style: TextStyle(color: getPointColor(initData.points[index].status)),)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //Padding(padding: EdgeInsets.only(left: 100),),
                                //new Icon(Icons.keyboard_arrow_right,color: Colors.red,)
                              ],
                            )
                        ),
                        onTap: (){
                          /*Navigator.push( context,
                              new MaterialPageRoute(builder: (context) {
                                return NavigationCheckExec(initData.points[index],null);
                              })
                          );*/
                          if(initData.points[index].isFixed == "1"){
                            // 必须扫码，所以跳转到详情页
//                            Navigator.push( context,
//                                new MaterialPageRoute(builder: (context) {
////                                return new CheckExecListContent(initData.points[index].pointId);
//                                  return new PlanListContentDetail(planTaskId,initData.points[index].pointId);
//                                })
//                            ).then((v){
//                              loadData();
//                            });
                          }else{
                            // 直接去填写页面
                            if(initData.points[index].status == "0"){
                              // check order
                              if(this.initData.inOrder == "1"){
                                // 按顺序巡检
                                Point lastPoint;
                                initData.points.forEach((point){
                                  if(point.orderNo == initData.points[index].orderNo - 1){
                                    lastPoint = point;
                                  }
                                });
                                if(lastPoint != null && lastPoint.status == "0"){
                                  MessageBox.showMessageOnly("请按顺序巡检!", context);
//                                  return;
                                }else{
                                  Navigator.push( context,
                                      new MaterialPageRoute(builder: (context) {
//                                        return CheckExecInspection(initData.points[index],null);
                                        if(initData.points[index].classifis != null && initData.points[index].classifis.length > 0){
                                          return OfflineCheckExecInspectionList(initData.points[index],null);
                                        }else{
                                          return CheckExecInspection(initData.points[index], null);
                                        }
                                      })
                                  ).then((v){
                                    loadData();
                                  });
                                }
                              }else{
                                Navigator.push( context,
                                    new MaterialPageRoute(builder: (context) {
//                                        return CheckExecInspection(initData.points[index],null);
                                      if(initData.points[index].classifis != null && initData.points[index].classifis.length > 0){
                                        return OfflineCheckExecInspectionList(initData.points[index],null);
                                      }else{
                                        return CheckExecInspection(initData.points[index], null);
                                      }
                                    })
                                ).then((v){
                                  loadData();
                                });
                              }
                            }else{
//                              Navigator.push( context,
//                                  new MaterialPageRoute(builder: (context) {
////                                return new CheckExecListContent(initData.points[index].pointId);
//                                    return new PlanListContentDetail(planTaskId,initData.points[index].pointId);
//                                  }));
                            }
                          }
                        },
                      )
                  );
                },
              ),
            ),flex: 4,),
          ],
        ),
      ),
      inAsyncCall: false,
      // demo of some additional parameters
      opacity: 0.7,
      progressIndicator: CircularProgressIndicator(),
    )
    );
  }
  List<charts.Series<LinearSales, String>> _createSampleData(OfflinePlanListOutput initData) {
    int uncheck = initData.taskPlanNum - initData.finshNum;

    int checked = initData.finshNum;

    var data = [
      new LinearSales("未巡检", uncheck, charts.MaterialPalette.gray.shadeDefault),
      new LinearSales("已巡检", checked,charts.MaterialPalette.green.shadeDefault),
    ];
    return [
      new charts.Series<LinearSales, String>(
        id: 'Sales',
        colorFn: (LinearSales data, _) => data.color,
        domainFn: (LinearSales data, _) => data.year,
        measureFn: (LinearSales data, _) => data.sales,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      )
    ];

  }

  Color getBgColor(int finishStatus){
    if(finishStatus == 0) { // 未开始
      return Colors.grey;
    }else if(finishStatus == 1) { // 进行中
      return Colors.orange;
    }else if(finishStatus == 2) { // 已结束
      return Colors.red[800];
    }else if(finishStatus == 3) { // 已超时
      return Colors.redAccent;
    }else{
      return Colors.white;
    }
  }

  String getStatus(int finishStatus){
    if(finishStatus == 0) { // 未完成
      return "未执行";
    }else if(finishStatus == 1) { // 进行中
      return "执行中";
    }else if(finishStatus == 2) { // 未开始
      return "已执行";
    }else if(finishStatus == 3) { // 已超时
      return "已超时";
    }else{
      return "";
    }
  }

  Color getPointColor(String pointStatus){
    if(pointStatus == "0") {
      return Colors.grey;
    }else if(pointStatus == "1") {
      return Colors.green;
    }else{
      return Colors.white;
    }
  }

  String getPointStatus(String pointStatus){
    if(pointStatus == "0") {
      return "未巡检";
    }else if(pointStatus == "1") {
      return "已巡检";
    }else{
      return "";
    }
  }

  getContent(String pointNo) async{
    // 获取点信息
    Point chkPoint;
    for(var point in initData.points){
      if(point.pointNO == pointNo){
        chkPoint = point;
        break;
      }
    }

    if(chkPoint==null){
      Fluttertoast.showToast(
        msg: '没有对应的巡检点！',
        toastLength: Toast.LENGTH_SHORT,
      ).then((v){
        return;
      });
      return;
    }

    // 已巡检
    if(chkPoint.status == "1"){
      Fluttertoast.showToast(
        msg: '当前点已提交巡检记录！',
        toastLength: Toast.LENGTH_SHORT,
      ).then((v){
        return;
      });
      return;
    }

    if(initData.inOrder == "1"){
      num lastOrder = chkPoint.orderNo - 1;
      if(lastOrder < 1){
        // 本次扫描的点就是第一个点
      }else{
        Point _lastPoint;
        for(var _point in initData.points){
          if(_point.orderNo == lastOrder){
            _lastPoint = _point;
            break;
          }
        }

        // check data
        if(_lastPoint.status == '1'){
          // 已完成 ok
        }else{
          Fluttertoast.showToast(
            msg: '此巡检为按序巡检,请按顺序进行巡检任务！',
            toastLength: Toast.LENGTH_SHORT,
          ).then((v){
            return;
          });
          return;
        }
      }
    }

    Navigator.push( context,
        new MaterialPageRoute(builder: (context) {
          if(chkPoint.classifis != null && chkPoint.classifis.length > 0){
            return OfflineCheckExecInspectionList(chkPoint,"NFC");
          }else{
            return CheckExecInspection(chkPoint, "NFC");
          }

        })).then((v){
          // 刷新页面数据
          setState(() {
            nfcProcess = false;
          });
          loadData();
    });
  }
}

class LinearSales {
  final String year;
  final int sales;
  final charts.Color color;

  LinearSales(this.year, this.sales,this.color);
}

