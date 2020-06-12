import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/Statistics/StatisticsModel.dart';
import 'package:intelligent_check_new/model/UserAuthModel.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/statistics/statistics_Activility.dart';
import 'package:intelligent_check_new/pages/statistics/statistics_Danger.dart';
import 'package:intelligent_check_new/pages/statistics/statistics_DangerPoint.dart';
import 'package:intelligent_check_new/pages/statistics/statistics_judge.dart';
import 'package:intelligent_check_new/services/Statistics_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String theme = "";
  bool isAnimating = false;
  UserShowAuth auth;

  StatisticsItemModel judgment ;
  StatisticsItemModel risk;
  StatisticsItemModel taskWork;
  StatisticsItemModel danger;
  @override
  void initState() {
    super.initState();
    initConfig();
  }

  void initConfig() async {
    await SharedPreferences.getInstance().then((preferences) {
      setState(() {
        this.theme =
            preferences.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
        var showAuthJson = preferences.getString("user_show");
        if (showAuthJson != "" && showAuthJson != null) {
          //拿到工作台下的功能模块权限
          this.auth = new UserShowAuth.fromJson(json.decode(showAuthJson)).children.firstWhere((f) => f.frontComponent == "statistics");
        }

        });
    }).then((preferences) {
      loadData();
    });
  }

  void loadData() async {
    setState(() {
      isAnimating = true;
    });
    await getStatisticsList().then((data) {
      if(mounted){
        setState(() {
          if (data.success) {
            if (data.dataList != null) {
            this.risk = StatisticsItemModel.fromJson(data.dataList["risk"]);
            this.danger = StatisticsItemModel.fromJson(data.dataList["danger"]);
            this.taskWork = StatisticsItemModel.fromJson(data.dataList["taskwork"]);
            this.judgment =StatisticsItemModel.fromJson( data.dataList["judgment"]);
           }
          } else {
            HiddenDangerFound.popUpMsg(data.message ?? "获取数据失败");
          }
          isAnimating = false;
        });

      }
        });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (theme.isEmpty) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        body: Text(""),
      );
    }

  List<Container> getContainers(){
    List<Container>  conList=new List();
    if(this.auth==null || this.auth.children==null)return conList;
    for(UserShowAuth au in this.auth.children){
      switch(au.frontComponent){
                  case "riskPointStatistics":

                    conList.add(Container(
                      child: risk == null
                          ? Container()
                          : GestureDetector(
                        child: Container(
                          //设置四周圆角 角度
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 10, top: 3),
                                    child: Image.asset(
                                      "assets/images/securityRiskJudegment/pieChart_dangerPoint.png",
                                      height: 22,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      au.permissionName??"--",
                                      style: TextStyle(
                                          color: GetConfig.getColor(theme)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:(MediaQuery.of(context).size.width / 2 - 50) < 130
                                    ? 130
                                    : (MediaQuery.of(context).size.width / 2 - 50),
                                child: Stack(
                                  alignment: const FractionalOffset(0.5, 0.7),
                                  children: <Widget>[
                                    Align(

                                      alignment: Alignment.center,
                                      child:Container(
                                        color:Colors.transparent,
                                        child: new charts.PieChart(
                                            _createSampleData("失效",risk.persentNum,
                                                charts.MaterialPalette.red.shadeDefault),
                                            animate: true,
                                            defaultRenderer: new charts.ArcRendererConfig(
                                                arcWidth:((MediaQuery.of(context).size.width / 2 - 50) < 130
                                                    ? 130
                                                    : (MediaQuery.of(context).size.width / 2 - 50))~/10,
                                                arcRendererDecorators: [
                                                  new charts.ArcLabelDecorator(
                                                      leaderLineStyleSpec: charts
                                                          .ArcLabelLeaderLineStyleSpec(
                                                          length: 10,
                                                          color: charts
                                                              .MaterialPalette
                                                              .red
                                                              .shadeDefault),
                                                      labelPosition:
                                                      charts.ArcLabelPosition.outside,
                                                      outsideLabelStyleSpec:
                                                      new charts.TextStyleSpec(
                                                          fontSize: 12,
                                                          color: charts
                                                              .MaterialPalette
                                                              .red
                                                              .shadeDefault))
                                                ])),
                                      ),
                                    ),

                                    Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          color:Colors.transparent,
                                          alignment: Alignment.center,

                                          width:(MediaQuery.of(context).size.width / 2 - 20) < 130
                                              ? 130
                                              : (MediaQuery.of(context).size.width / 2 - 20),

                                          child: Text("${risk.actualNum.toString()}\r\n",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w600)),
                                        )),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          color:Colors.transparent,
                                          alignment: Alignment.center,

                                          width:(MediaQuery.of(context).size.width / 2 - 20) < 130
                                              ? 130
                                              : (MediaQuery.of(context).size.width / 2 - 20),

                                          child: Text("\r\n${this.risk.totalNum.toString()}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600)),
                                        )),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap : () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context){
                                return  StatisticsDangerPoint(title: au.permissionName);
                              }));
                        },
                      ),));
                    break;
                  case "latentDangerStatistics":

                    conList.add(Container(
                      child: danger == null
                          ? Container()
                          : GestureDetector(
                        child: Container(
                          //设置四周圆角 角度
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Image.asset(
                                      "assets/images/securityRiskJudegment/pieChart_danger.png",
                                      height: 25,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      au.permissionName ?? "--",
                                      style: TextStyle(
                                          color: GetConfig.getColor(theme)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:(MediaQuery.of(context).size.width / 2 - 50) < 130
                                    ? 130
                                    : (MediaQuery.of(context).size.width / 2 - 50),
                                child: Stack(
                                  alignment: const FractionalOffset(0.5, 0.5),
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: new charts.PieChart(
                                          _createSampleData(
                                              "逾期",
                                              danger.persentNum,
                                              charts.Color(
                                                  r: 255, g: 157, b: 10)),
                                          animate: true,
                                          defaultRenderer:
                                          new charts.ArcRendererConfig(
                                              arcWidth:((MediaQuery.of(context).size.width / 2 - 50) < 130
                                                  ? 130
                                                  : (MediaQuery.of(context).size.width / 2 - 50))~/10,
                                              arcRendererDecorators: [
                                                new charts.ArcLabelDecorator(
                                                    leaderLineStyleSpec: charts
                                                        .ArcLabelLeaderLineStyleSpec(
                                                        length: 10,
                                                        color: charts.Color(
                                                            r: 255,
                                                            g: 157,
                                                            b: 10)),
                                                    labelPosition: charts
                                                        .ArcLabelPosition.outside,
                                                    outsideLabelStyleSpec:
                                                    new charts.TextStyleSpec(
                                                        fontSize: 12,
                                                        color: charts.Color(
                                                            r: 255,
                                                            g: 157,
                                                            b: 10)))
                                              ])),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.transparent,
                                          width:(MediaQuery.of(context).size.width / 2 - 20) < 130
                                              ? 130
                                              : (MediaQuery.of(context).size.width / 2 - 20),
                                          child: Text(
                                              "${danger.actualNum.toString()}\r\n",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w600)),
                                        )),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          alignment: Alignment.center,
                                          color: Colors.transparent,
                                          width:(MediaQuery.of(context).size.width / 2 - 20) < 130
                                              ? 130
                                              : (MediaQuery.of(context).size.width / 2 - 20),
                                          child: Text("\r\n${danger.totalNum.toString()}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600)),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return StatisticsDanger(title: au.permissionName);
                              }));
                        },
                      ),
                    ));
                    break;
                  case "taskworkStatistics":

                    conList.add(Container(
                      child: taskWork == null
                          ? Container()
                          : GestureDetector(
                        child: Container(
                          //设置四周圆角 角度
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Image.asset(
                                      "assets/images/securityRiskJudegment/pieChart_activility.png",
                                      height: 25,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      au.permissionName ?? "作业活动",
                                      style: TextStyle(
                                          color: GetConfig.getColor(theme)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:(MediaQuery.of(context).size.width / 2 - 50) < 130
                                    ? 130
                                    : (MediaQuery.of(context).size.width / 2 - 50),
                                child: Stack(
                                  alignment: const FractionalOffset(0.5, 0.5),
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: new charts.PieChart(
                                          _createSampleData(
                                              "违章",
                                              taskWork.persentNum,
                                              charts.Color(
                                                  r: 255, g: 157, b: 10)),
                                          animate: true,
                                          defaultRenderer:
                                          new charts.ArcRendererConfig(
                                              arcWidth:((MediaQuery.of(context).size.width / 2 - 50) < 130
                                                  ? 130
                                                  : (MediaQuery.of(context).size.width / 2 - 50))~/10,
                                              arcRendererDecorators: [
                                                new charts.ArcLabelDecorator(
                                                    leaderLineStyleSpec: charts
                                                        .ArcLabelLeaderLineStyleSpec(
                                                        length: 10,
                                                        color: charts.Color(
                                                            r: 255,
                                                            g: 157,
                                                            b: 10)),
                                                    labelPosition: charts
                                                        .ArcLabelPosition.outside,
                                                    outsideLabelStyleSpec:
                                                    new charts.TextStyleSpec(
                                                        fontSize: 12,
                                                        color: charts.Color(
                                                            r: 255,
                                                            g: 157,
                                                            b: 10)))
                                              ])),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          color:Colors.transparent,
                                          alignment: Alignment.center,
                                          width:(MediaQuery.of(context).size.width / 2 - 20) < 130
                                              ? 130
                                              : (MediaQuery.of(context).size.width / 2 - 20),
                                          child: Text(
                                              "${taskWork.actualNum.toString()}\r\n",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w600)),
                                        )),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          color:Colors.transparent,
                                          alignment: Alignment.center,
                                          width:(MediaQuery.of(context).size.width / 2 - 20) < 130
                                              ? 130
                                              : (MediaQuery.of(context).size.width / 2 - 20),
                                          child: Text(
                                              "\r\n${taskWork.totalNum.toString()}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600)),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return StatisticsActivility(title: au.permissionName);
                              }));
                        },
                      ),
                    ));
                    break;
                  case "riskJudgmentStatistics":

                    conList.add(Container(
                      child: judgment == null
                          ? Container()
                          : GestureDetector(
                        child: Container(
                          //设置四周圆角 角度
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Image.asset(
                                      "assets/images/securityRiskJudegment/pieChart_judge.png",
                                      height: 25,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      au.permissionName ?? "--",
                                      style: TextStyle(
                                          color: GetConfig.getColor(theme)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(

                                height:(MediaQuery.of(context).size.width / 2 - 50) < 130
                                    ? 130
                                    : (MediaQuery.of(context).size.width / 2 - 50),
                                child: Stack(
                                  alignment: const FractionalOffset(0.5, 0.5),
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: new charts.PieChart(
                                          _createSampleData(
                                              "",
                                              judgment.persentNum,
                                              charts.MaterialPalette.green
                                                  .shadeDefault),
                                          animate: true,
                                          defaultRenderer:
                                          new charts.ArcRendererConfig(
                                              arcWidth:((MediaQuery.of(context).size.width / 2 - 50) < 130
                                                  ? 130
                                                  : (MediaQuery.of(context).size.width / 2 - 50))~/10,
                                              arcRendererDecorators: [
                                                new charts.ArcLabelDecorator(
                                                  /* leaderLineStyleSpec: charts
                                                      .ArcLabelLeaderLineStyleSpec(
                                                          length: 10,
                                                          color: charts
                                                              .MaterialPalette
                                                              .green
                                                              .shadeDefault),
                                                  labelPosition: charts
                                                      .ArcLabelPosition.outside,
                                                  outsideLabelStyleSpec:
                                                      new charts.TextStyleSpec(
                                                          fontSize: 12,
                                                          color: charts
                                                              .MaterialPalette
                                                              .green
                                                              .shadeDefault)*/)
                                              ])),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          color: Colors.transparent,
                                          alignment: Alignment.center,
                                          width:(MediaQuery.of(context).size.width / 2 - 20) < 130
                                              ? 130
                                              : (MediaQuery.of(context).size.width / 2 - 20),
                                          height:(MediaQuery.of(context).size.width / 2 - 20) < 130
                                              ? 130
                                              : (MediaQuery.of(context).size.width / 2 - 20),
                                          child: Text("${judgment.persentNum}%",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w600)),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return StatisticsJudge(judgment.persentNum,title: au.permissionName);
                              }));
                        },
                      ),
                    ));
                    break;
                  default:
                    conList.add(Container());
                    break;
                }
              }

          return conList;
  }



    //获取统计数据
//    StatisticsPage.queryAuthCompanyLeaves();
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 246, 249, 1),
      appBar: AppBar(
        title: Text(
          '统计',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ModalProgressHUD(
        child: Container(
            child: GridView(
          //构造 GridView 的委托者，GridView.count 就相当于指定 gridDelegate 为 SliverGridDelegateWithFixedCrossAxisCount，
          //GridView.extent 就相当于指定 gridDelegate 为 SliverGridDelegateWithMaxCrossAxisExtent，它们相当于对普通构造方法的一种封装
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //必传参数，Cross 轴（在 GridView 中通常是横轴，即每一行）子组件个数
            crossAxisCount: 2,
            //子组件宽高比，如 2 表示宽：高=2:1,如 0.5 表示宽：高=0.5:1=1:2，简单来说就是值大于 1 就会宽大于高，小于 1 就会宽小于高
            childAspectRatio: 1,
            //Cross 轴子组件的间隔，一行中第一个子组件左边不会添加间隔，最后一个子组件右边不会添加间隔，这一点很棒
            crossAxisSpacing: 3,
            //Main 轴（在 GridView 中通常是纵轴，即每一列）子组件间隔，也就是每一行之间的间隔，同样第一行的上边和最后一行的下边不会添加间隔
            mainAxisSpacing: 3,
          ),

          cacheExtent: 0,

          padding: EdgeInsets.all(5),

          physics: new BouncingScrollPhysics(),
          //Item 的顺序是否反转，若为 true 则反转，这个翻转只是行翻转，即第一行变成最后一行，但是每一行中的子组件还是从左往右摆放的
//      reverse: true,
          //GirdView 的方向，为 Axis.vertical 表示纵向，为 Axis.horizontal 表示横向，横向的话 CrossAxis 和 MainAxis 表示的轴也会调换
          scrollDirection: Axis.vertical,

         children:getContainers(),
        )),
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }

}

List<charts.Series<LinearSales, String>> _createSampleData(
    String desc, num value, charts.Color col) {
  List<LinearSales> data = [];
  value = value ?? 0;
//  data.add(new LinearSales("", -1,charts.MaterialPalette.gray.shadeDefault));
  data.add(new LinearSales(desc, value, col));
  data.add(new LinearSales("", 100 - value <= 0 ? 0 : 100 - value,
      charts.MaterialPalette.gray.shadeDefault));

  return [
    new charts.Series<LinearSales, String>(
      id: 'Sales',
      //  labelAccessorFn: (LinearSales row, _) => row.sales == -1 ? "" : '${row.year}: ${row.sales}',
      colorFn: (LinearSales data, _) => data.color,
      domainFn: (LinearSales data, _) => data.remark,
      measureFn: (LinearSales data, _) => data.val,

      data: data,
      // Set a label accessor to control the text of the arc label.
    )
  ];
}

class LinearSales {
  final String remark;
  final num val;
  final charts.Color color;

  LinearSales(this.remark, this.val, this.color);
}
