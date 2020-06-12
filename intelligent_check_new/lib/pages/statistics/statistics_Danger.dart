import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/Statistics/StatisticsRiskDetail.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/services/Statistics_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsDanger extends StatefulWidget {
  final String title;
  StatisticsDanger({this.title});
  @override
  _StatisticsDanger createState() => _StatisticsDanger();
}

class _StatisticsDanger extends State<StatisticsDanger>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String theme = "";
  bool isAnimating = false;
  DangerDetailModel iniData=DangerDetailModel.fromParams();

  @override
  void initState() {
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
    await getStatisticsDetailByType("danger").then((data) {
      setState(() {
        if (data.success) {
          if (data.dataList != null) {
            iniData = DangerDetailModel.fromJson(data.dataList);
          }

        } else {
          HiddenDangerFound.popUpMsg(data.message ?? "获取数据失败");
        }
        isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (iniData==null) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        body: Text(""),
      );
    }
    //获取统计数据
//    StatisticsPage.queryAuthCompanyLeaves();
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 246, 249, 1),
      appBar: AppBar(
        title: Text(
          this.widget.title??'--',
          style: TextStyle(
            height: 1.25,
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: new Container(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.keyboard_arrow_left,
                color: GetConfig.getColor(theme), size: 32),
          ),
        ),
      ),
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
              child: Column(
            children: <Widget>[
              //按等级
              Container(
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  margin: EdgeInsets.all(10),

                  //设置四周圆角 角度
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.white,
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
                  ),
                  child: Column(

                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 20),

                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7.0),
                              topRight: Radius.circular(7.0)),
                          color: Color.fromRGBO(230, 230, 230, 1),
                        ),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Container(

                                child: Icon(
                                  Icons.trending_up,
                                  color: GetConfig.getColor(theme),
                                  size: 15,
                                )),
                            Container(
                              child: Text(
                                "按隐患等级统计",
                                style: TextStyle(
                                    height: 1.25,
                                    color: GetConfig.getColor(theme)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      iniData.byDangerLevel==null?Container(): SizedBox(
                        height:
                            (MediaQuery.of(context).size.width / 2 - 150) < 130
                                ? 130
                                : (MediaQuery.of(context).size.width / 2 - 150),
                        child: Stack(
                          alignment: const FractionalOffset(0.5, 0.7),
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text("${iniData.byDangerLevel==null?0:iniData.byDangerLevel[0].total??0}\r\n",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          height: 1.25,
                                          fontSize: 18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600)),
                                )),
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text( this.widget.title??'--',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height: 1.25,
                                        fontSize: 18,
                                        color: Colors.grey,
                                      )),
                                )),
                            Align(
                              alignment: Alignment.centerRight,
                              child: new charts.PieChart(_createSampleData(iniData.byDangerLevel),
                                  animate: true,
                                  defaultRenderer: new charts.ArcRendererConfig(
                                      arcWidth: 13,
                                      arcRendererDecorators: [
                                        new charts.ArcLabelDecorator(
                                            leaderLineStyleSpec: charts
                                                .ArcLabelLeaderLineStyleSpec(
                                                    length: 20,
                                                    thickness: 1,
                                                    color: charts
                                                        .MaterialPalette.black),
                                            labelPosition:
                                                charts.ArcLabelPosition.outside,
                                            outsideLabelStyleSpec:
                                                new charts.TextStyleSpec(
                                                    fontSize: 12,
                                                    color: charts
                                                        .MaterialPalette
                                                        .black)),
                                      ])),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        color: Color.fromRGBO(230, 230, 230, 1),
                        height: 1,
                        margin: EdgeInsets.all(10),
                      ),
                      iniData.byDangerLevel != null
                          ? Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Column(
                            children: iniData.byDangerLevel.map((f) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin:
                                    EdgeInsets.only(right: 10, top: 8),
                                    height: 20,
                                    width: 20,
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: _getColorSqure(
                                          iniData.byDangerLevel.indexOf(f)),
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    margin:
                                    EdgeInsets.only(right: 10, top: 8),
                                    child: Text(
                                      f.name ?? "--",
                                      style: TextStyle(
                                          height: 1.25,
                                          color: _getColorSqure(iniData
                                              .byDangerLevel
                                              .indexOf(f))),
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    padding: EdgeInsets.only(right: 0),
                                    margin: EdgeInsets.only(
                                        top: 8, right: 4),
                                    child: Text(
                                      f.value ?? "--",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          height: 1.25,
                                          color: _getColorSqure(iniData
                                              .byDangerLevel
                                              .indexOf(f))),
                                    ),
                                  ),
                                  Container(
                                    width: 10,
                                    margin: EdgeInsets.only(top: 8),
                                    child: Text(
                                      "|",
                                      style: TextStyle(
                                          height: 1.25,
                                          color: _getColorSqure(iniData
                                              .byDangerLevel
                                              .indexOf(f))),
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    margin: EdgeInsets.only(top: 8),
                                    child: Text(
                                      f.percent ?? "--",
                                      style: TextStyle(
                                          height: 1.25,
                                          color: _getColorSqure(iniData
                                              .byDangerLevel
                                              .indexOf(f))),
                                    ),
                                  ),
                                ],
                              );
                            }).toList()),
                      )
                          : Container(),



                    ],
                  ),
                ),
              ),


              Container(
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  margin: EdgeInsets.all(10),

                  //设置四周圆角 角度
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.white,
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
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7.0),
                              topRight: Radius.circular(7.0)),
                          color: Color.fromRGBO(230, 230, 230, 1),
                        ),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Container(

                                child: Icon(
                                  Icons.trending_up,
                                  color: GetConfig.getColor(theme),
                                  size: 15,
                                )

                                ),
                            Container(
                              child: Text(
                                "按状态统计",
                                style: TextStyle(
                                    height: 1.25,
                                    color: GetConfig.getColor(theme)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      iniData.byDangerStatus != null?SizedBox(
                        height:
                            (MediaQuery.of(context).size.width / 2 - 150) < 130
                                ? 130
                                : (MediaQuery.of(context).size.width / 2 - 150),
                        child: Stack(
                          alignment: const FractionalOffset(0.5, 0.7),
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text("${iniData.byDangerStatus[0].total??0}\r\n",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          height: 1.25,
                                          fontSize: 18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600)),
                                )),
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text( this.widget.title??'--',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height: 1.25,
                                        fontSize: 18,
                                        color: Colors.grey,
                                      )),
                                )),
                            Align(
                              alignment: Alignment.centerRight,
                              child: new charts.PieChart(
                                  _createSampleData(iniData.byDangerStatus),
                                  animate: true,
                                  defaultRenderer: new charts.ArcRendererConfig(
                                      arcWidth: 13,
                                      arcRendererDecorators: [
                                        new charts.ArcLabelDecorator(
                                            leaderLineStyleSpec: charts
                                                .ArcLabelLeaderLineStyleSpec(
                                                    length: 15,
                                                    thickness: 1,
                                                    color: charts
                                                        .MaterialPalette.black),
                                            labelPosition:
                                                charts.ArcLabelPosition.outside,
                                            outsideLabelStyleSpec:
                                                new charts.TextStyleSpec(
                                                    fontSize: 12,
                                                    color: charts
                                                        .MaterialPalette
                                                        .black)),
                                      ])),
                            ),
                          ],
                        ),
                      ):Container(),
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        color: Color.fromRGBO(230, 230, 230, 1),
                        height: 1,
                        margin: EdgeInsets.all(10),
                      ),

                      iniData.byDangerStatus != null
                          ? Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Column(
                            children: iniData.byDangerStatus.map((f) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin:
                                    EdgeInsets.only(right: 10, top: 8),
                                    height: 20,
                                    width: 20,
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: _getColorSqure(
                                          iniData.byDangerStatus.indexOf(f)),
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    margin:
                                    EdgeInsets.only(right: 10, top: 8),
                                    child: Text(
                                      f.name ?? "--",
                                      style: TextStyle(
                                          height: 1.25,
                                          color: _getColorSqure(iniData
                                              .byDangerStatus
                                              .indexOf(f))),
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    padding: EdgeInsets.only(right: 0),
                                    margin: EdgeInsets.only(
                                        top: 8, right: 4),
                                    child: Text(
                                      f.value ?? "--",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          height: 1.25,
                                          color: _getColorSqure(iniData
                                              .byDangerStatus
                                              .indexOf(f))),
                                    ),
                                  ),
                                  Container(
                                    width: 10,
                                    margin: EdgeInsets.only(top: 8),
                                    child: Text(
                                      "|",
                                      style: TextStyle(
                                          height: 1.25,
                                          color: _getColorSqure(iniData
                                              .byDangerStatus
                                              .indexOf(f))),
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    margin: EdgeInsets.only(top: 8),
                                    child: Text(
                                      f.percent ?? "--",
                                      style: TextStyle(
                                          height: 1.25,
                                          color: _getColorSqure(iniData
                                              .byDangerStatus
                                              .indexOf(f))),
                                    ),
                                  ),
                                ],
                              );
                            }).toList()),
                      )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }


}
//按级别获取颜色
charts.Color _getColorCircle(int level) {
  switch (level) {
    case 0: //一级
      return charts.Color(r: 255, g: 157, b: 10);
      break;
    case 1: //二级
      return  charts.MaterialPalette.red.shadeDefault;
      break;
    case 2: //三级
      return charts.MaterialPalette.yellow.shadeDefault;
      break;
    case 3: //四级
      return charts.Color(r: 44, g: 117, b: 211);
      break;
    case 4: //五级
      return charts.MaterialPalette.green.shadeDefault;
      break;
  }
  return charts.MaterialPalette.red.shadeDefault;
}

Color _getColorSqure(int level) {
  switch (level) {
    case 0: //一级
      return  Color.fromRGBO(255, 157, 10, 1);
      break;
    case 1: //二级
      return Colors.red;
      break;
    case 2: //三级
      return Colors.yellow;
      break;
    case 3: //四级
      return Color.fromRGBO(44, 117, 211, 1);
      break;
    case 4: //五级
      return Colors.green;
      break;
  }
  return Colors.grey;
}

List<charts.Series<LinearSales, String>> _createSampleData(List<RiskByLevel> risk) {
  List<LinearSales> data = [];
   for(var d in risk){
     data.add( new LinearSales(d.name??"--", int.tryParse(d.value),_getColorCircle(risk.indexOf(d))));
   }
  return [
    new charts.Series<LinearSales, String>(
      id: 'Sales',
      colorFn: (LinearSales data, _) => data.color,
      domainFn: (LinearSales data, _) => data.remark,
      measureFn: (LinearSales data, _) => data.val,
      data: data,
      labelAccessorFn: (LinearSales row, _) =>
          row.val == -1 ? "" : '${row.remark}: ${row.val}',
    )
  ];
}
class LinearSales {
  final String remark;
  final int val;
  final charts.Color color;

  LinearSales(this.remark, this.val, this.color);
}
