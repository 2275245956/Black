import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/Statistics/StatisticsRiskDetail.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/services/Statistics_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsDangerPoint extends StatefulWidget {
  final String title;

  StatisticsDangerPoint({this.title});

  @override
  _StatisticsDangerPoint createState() => _StatisticsDangerPoint();
}

class _StatisticsDangerPoint extends State<StatisticsDangerPoint>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String theme = "";
  bool isAnimating = false;
  RiskDetailModel iniData;
  var levels = 0;


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
    await getStatisticsDetailByType("risk").then((data) {
      if (!mounted) return;
      setState(() {
        if (data.success) {
          if (data.dataList != null) {
            iniData = RiskDetailModel.fromJson(data.dataList);
            //获取等级数
            levels = iniData.byRiskLevel.length;
          }
        } else {
          HiddenDangerFound.popUpMsg(data.message ?? "获取数据失败");
        }
        isAnimating = false;
      });
    });
  }

  List<TableRow> getTableRows(RiskDetailModel model) {
    List<TableRow> trs = new List();
    List<Text> ts = new List();
    ts.add(Text(
      "风险",
      textAlign: TextAlign.center,
      style: TextStyle(
          height: 1.25,
          color: Color.fromRGBO(153, 153, 153, 1),
          fontSize: 18),
    ));
    for (var i = 1; i <= levels; i++) {
      ts.add(Text(
        "$i级",
        textAlign: TextAlign.center,
        style: TextStyle(height: 1.25, color: _getColorSqure(i-1), fontSize: 18),
      ));
    }


    var thead = TableRow(children: ts);
    trs.insert(0, thead);


    List<Text> tBody = new List();
    for (var tr in model.byHighLevel) {
      tBody.add(Text(
        tr.type ?? "--",
        textAlign: TextAlign.center,
        style: TextStyle(
            height: 1.25,
            color: Color.fromRGBO(153, 153, 153, 1),
            fontSize: 18),
      ));
      if (levels >= 1) {
        tBody.add(Text(
          "${tr.level1 ?? 0}",
          textAlign: TextAlign.center,
          style: TextStyle(
              height: 1.25,
              color: Color.fromRGBO(153, 153, 153, 1),
              fontSize: 18),
        ));
      }
      if (levels >= 2) {
        tBody.add(Text(
          "${tr.level2 ?? 0}",
          textAlign: TextAlign.center,
          style: TextStyle(
              height: 1.25,
              color: Color.fromRGBO(153, 153, 153, 1),
              fontSize: 18),
        ));
      }
      if (levels >= 3) {
        tBody.add(Text(
          "${tr.level3 ?? 0}",
          textAlign: TextAlign.center,
          style: TextStyle(
              height: 1.25,
              color: Color.fromRGBO(153, 153, 153, 1),
              fontSize: 18),
        ) );
      }
      if (levels >= 4) {
        tBody.add( Text(
          "${tr.level4 ?? 0}",
          textAlign: TextAlign.center,
          style: TextStyle(
              height: 1.25,
              color: Color.fromRGBO(153, 153, 153, 1),
              fontSize: 18),
        ));
      }
      if (levels >= 5) {
        tBody.add(
          Text(
            "${tr.level5 ?? 0}",
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.25,
                color: Color.fromRGBO(153, 153, 153, 1),
                fontSize: 18),
          ) );
      }
      if (levels >= 6) {
        tBody.add( Text(
          "${tr.level6 ?? 0}",
          textAlign: TextAlign.center,
          style: TextStyle(
              height: 1.25,
              color: Color.fromRGBO(153, 153, 153, 1),
              fontSize: 18),
        ));
      }
      if (levels >= 7) {
        tBody.add( Text(
          "${tr.level7 ?? 0}",
          textAlign: TextAlign.center,
          style: TextStyle(
              height: 1.25,
              color: Color.fromRGBO(153, 153, 153, 1),
              fontSize: 18),
        ));
      }

      var tb = TableRow(children: tBody);
      trs.add(tb);
      tBody=[];
    }
    return trs;
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (iniData == null) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        body: Text(this.widget.title ?? '--'),
      );
    }
    //获取统计数据
//    StatisticsPage.queryAuthCompanyLeaves();
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 246, 249, 1),
      appBar: AppBar(
        title: Text(
          this.widget.title ?? '--',
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
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7.0),
                                  topRight: Radius.circular(7.0)),
                              color: Color.fromRGBO(230, 230, 230, 1),
                            ),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: <Widget>[
                                Container(

                                    child: Icon(
                                      Icons.trending_up,
                                      color: GetConfig.getColor(theme),
                                      size: 15,
                                    )
//                                  Image.asset(
//                                    "assets/images/securityRiskJudegment/pieChart_dangerPoint.png",
//                                    height: 22,
//                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "按风险等级统计",
                                    style: TextStyle(
                                        height: 1.25,
                                        color: GetConfig.getColor(theme)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          iniData.byRiskLevel.length ==0
                              ? Container()
                              : SizedBox(
                            height: (MediaQuery
                                .of(context)
                                .size
                                .width / 2 -
                                150) <
                                130
                                ? 130
                                : (MediaQuery
                                .of(context)
                                .size
                                .width / 2 -
                                150),
                            child: Stack(
                              alignment: const FractionalOffset(0.5, 0.7),
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width -
                                          150,
                                      child: Text(
                                          "${iniData.byRiskLevel[0].total
                                              .toString()}\r\n",
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
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width -
                                          150,
                                      child: Text(this.widget.title ?? '--',
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
                                      _createSampleData(iniData),
                                      animate: true,
                                      defaultRenderer:
                                      new charts.ArcRendererConfig(
                                          arcWidth: 13,
                                          arcRendererDecorators: [
                                            new charts.ArcLabelDecorator(
                                                leaderLineStyleSpec: charts
                                                    .ArcLabelLeaderLineStyleSpec(
                                                    length: 20,
                                                    thickness: 1,
                                                    color: charts
                                                        .MaterialPalette
                                                        .black),
                                                labelPosition: charts
                                                    .ArcLabelPosition.outside,
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
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 80,
                            color: Color.fromRGBO(230, 230, 230, 1),
                            height: 1,
                            margin: EdgeInsets.all(10),
                          ),
                          iniData.byRiskLevel.length != 0
                              ? Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Column(
                                children: iniData.byRiskLevel.map((f) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: 5, top: 8),
                                        height: 20,
                                        width: 20,
                                        decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          color: _getColorSqure(
                                              iniData.byRiskLevel.indexOf(f)),
                                        ),
                                      ),
                                      Container(
                                        width: 30,
                                        margin: EdgeInsets.only(
                                            right: 5, top: 8),
                                        child: Text(
                                          f.name ?? "--",
                                          style: TextStyle(
                                              height: 1.25,
                                              color: _getColorSqure(iniData
                                                  .byRiskLevel
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
                                                  .byRiskLevel
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
                                                  .byRiskLevel
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
                                                  .byRiskLevel
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
                  //按车间部门
                  Container(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.only(bottom: 15),
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
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7.0),
                                  topRight: Radius.circular(7.0)),
                              color: Color.fromRGBO(230, 230, 230, 1),
                            ),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: <Widget>[
                                Container(

                                    child: Icon(
                                      Icons.trending_up,
                                      color: GetConfig.getColor(theme),
                                      size: 15,
                                    )
//                                  Image.asset(
//                                    "assets/images/securityRiskJudegment/pieChart_dangerPoint.png",
//                                    height: 22,
//                                  ),
                                ),
                                Container(
                                  child: Text(
                                    r"按部门\车间统计",
                                    style: TextStyle(
                                        height: 1.25,
                                        color: GetConfig.getColor(theme)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          iniData.byDepartment.length == 0
                              ? Container()
                              : Container(
                            height: double.parse(
                                (iniData.byDepartment.length * 100).toString()),
                            child: new charts.BarChart(
                              _createSampleDataRow(iniData, levels),
                              animate: true,
                              barGroupingType: charts.BarGroupingType.grouped,
                              vertical: false,
                              barRendererDecorator:
                              new charts.BarLabelDecorator<String>(
                                labelPosition:
                                charts.BarLabelPosition.outside,
                                outsideLabelStyleSpec:
                                new charts.TextStyleSpec(
                                    fontSize: 12,
                                    color: charts.MaterialPalette.black),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 80,
                            color: Color.fromRGBO(230, 230, 230, 1),
                            height: 1,
                            margin: EdgeInsets.all(10),
                          ),
                          iniData.byDepartment.length !=0
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              levels >= 1 ? Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      height: 20,
                                      width: 20,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: Colors.red,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: Text(
                                        "1级",
                                        style: TextStyle(
                                            height: 1.25, color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ) : Container(),
                              levels >= 2 ? Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 5),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      height: 20,
                                      width: 20,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color:
                                        Color.fromRGBO(255, 157, 10, 1),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: Text(
                                        "2级",
                                        style: TextStyle(
                                            height: 1.25,
                                            color: Color.fromRGBO(
                                                255, 157, 10, 1)),
                                      ),
                                    ),
                                  ],
                                ),
                              ) : Container(),
                              levels >= 3 ? Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      height: 20,
                                      width: 20,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: Text(
                                        "3级",
                                        style: TextStyle(
                                            height: 1.25,
                                            color: Colors.yellow),
                                      ),
                                    ),
                                  ],
                                ),
                              ) : Container(),
                              levels >= 4 ? Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 5),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      height: 20,
                                      width: 20,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: Text(
                                        "4级",
                                        style: TextStyle(
                                            height: 1.25,
                                            color: Colors.blueAccent),
                                      ),
                                    ),
                                  ],
                                ),
                              ) : Container(),
                              levels >= 5 ? Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 5),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      height: 20,
                                      width: 20,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: Colors.green,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: Text(
                                        "5级",
                                        style: TextStyle(
                                            height: 1.25,
                                            color: Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              ) : Container(),
                              levels >= 6 ? Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 5),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      height: 20,
                                      width: 20,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: Color.fromRGBO(184, 222, 80, 1),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: Text(
                                        "6级",
                                        style: TextStyle(
                                            height: 1.25,
                                            color: Color.fromRGBO(
                                                184, 222, 80, 1)),
                                      ),
                                    ),
                                  ],
                                ),
                              ) : Container(),
                              levels >= 7 ? Container(
                                margin: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 5),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      height: 20,
                                      width: 20,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: Color.fromRGBO(104, 33, 122, 1),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: Text(
                                        "7级",
                                        style: TextStyle(
                                            height: 1.25,
                                            color: Color.fromRGBO(
                                                104, 33, 122, 1)),
                                      ),
                                    ),
                                  ],
                                ),
                              ) : Container(),
                            ],
                          )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  //按维度
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
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7.0),
                                  topRight: Radius.circular(7.0)),
                              color: Color.fromRGBO(230, 230, 230, 1),
                            ),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
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
                                    r"按高纬度风险统计",
                                    style: TextStyle(
                                        height: 1.25,
                                        color: GetConfig.getColor(theme)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          iniData.byHighLevel.length!=0?Container(
                            padding: EdgeInsets.only(
                                top: 10, left: 5, right: 5),
                            child: Table(
                              columnWidths: {
                                0: FixedColumnWidth(110),
                                1: FixedColumnWidth(levels >= 1
                                    ? ((MediaQuery.of(context).size.width -
                                    140) /
                                    levels)
                                    : 0),
                                2: FixedColumnWidth(levels >= 2
                                    ? ((MediaQuery.of(context).size.width -
                                    140) /
                                    levels)
                                    : 0),
                                3: FixedColumnWidth(levels >= 3
                                    ? ((MediaQuery.of(context).size.width -
                                    140) /
                                    levels)
                                    : 0),
                                4: FixedColumnWidth(levels >= 4
                                    ? ((MediaQuery.of(context).size.width -
                                    140) /
                                    levels)
                                    : 0),
                                5: FixedColumnWidth(levels >= 5
                                    ? ((MediaQuery.of(context).size.width -
                                    140) /
                                    levels)
                                    : 0),
                                6: FixedColumnWidth(levels >= 6
                                    ? ((MediaQuery.of(context).size.width -
                                    140) /
                                    levels)
                                    : 0),
                                7: FixedColumnWidth(levels >= 7
                                    ? ((MediaQuery.of(context).size.width -
                                    140) /
                                    levels)
                                    : 0),
                              },
                              border: TableBorder.all(
                                  color: Color.fromRGBO(223, 223, 223, 1),
                                  width: 1,
                                  style: BorderStyle.solid),
                              children: getTableRows(iniData),
                            ),
                          ):Container(),
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
      return charts.MaterialPalette.red.shadeDefault;
      break;
    case 1: //二级
      return charts.Color(r: 255, g: 157, b: 10);
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

    case 5: //6级
      return charts.Color(r: 104, g: 33, b: 122);
      break;
    case 6: //7级
      return charts.Color(r: 184, g: 222, b: 80);
      break;
  }
  return charts.MaterialPalette.gray.shadeDefault;
}

Color _getColorSqure(int level) {
  switch (level) {
    case 0: //一级
      return Colors.red;
      break;
    case 1: //二级
      return Color.fromRGBO(255, 157, 10, 1);
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
    case 5: //6级
      return Color.fromRGBO(104, 33, 122, 1);
      break;
    case 6: //7级
      return Color.fromRGBO(184, 222, 80, 1);
      break;
  }
  return Colors.grey;
}

List<charts.Series<LinearSales, String>> _createSampleData(
    RiskDetailModel datas) {
  List<LinearSales> data = [];

  for (var risk in datas.byRiskLevel) {
    data.add(new LinearSales(risk.name ?? "--", int.parse(risk.value),
        _getColorCircle(datas.byRiskLevel.indexOf(risk))));
  }


  return [
    new charts.Series<LinearSales, String>(
      id: 'Sales',
      colorFn: (LinearSales data, _) => data.color,
      domainFn: (LinearSales data, _) => data.remark,
      measureFn: (LinearSales data, _) => data.val,
      data: data,
      labelAccessorFn: (LinearSales row, _) =>
      row.val == 100 ? "" : '${row.remark}: ${row.val}',
    )
  ];
}

class LinearSales {
  final String remark;
  final num val;
  final charts.Color color;

  LinearSales(this.remark, this.val, this.color);
}

List<charts.Series<OrdinalSales, String>> _createSampleDataRow(
    RiskDetailModel datas, levels) {
  List<charts.Series<OrdinalSales, String>> result = new List();
  List<OrdinalSales> list = new List();
  for (var i = 1; i <= levels; i++) {
    //先获取所有等级为1的 一次2 ，3，4，5
    for (var dept in datas.byDepartment) {
      switch (i) {
        case 1: //等级1
          list.add(
            new OrdinalSales(
                dept.departmentName ?? "--", dept.level1, _getColorCircle(0)),
          );
          break;
        case 2: //等级2
          list.add(
            new OrdinalSales(
                dept.departmentName ?? "--", dept.level2, _getColorCircle(1)),
          );
          break;
        case 3: //等级3
          list.add(
            new OrdinalSales(
                dept.departmentName ?? "--", dept.level3, _getColorCircle(2)),
          );
          break;
        case 4: //等级4
          list.add(
            new OrdinalSales(
                dept.departmentName ?? "--", dept.level4, _getColorCircle(3)),
          );
          break;
        case 5: //等级5
          list.add(
            new OrdinalSales(
                dept.departmentName ?? "--", dept.level5, _getColorCircle(4)),
          );
          break;
        case 6: //等级6
          list.add(
            new OrdinalSales(
                dept.departmentName ?? "--", dept.level6, _getColorCircle(4)),
          );
          break;
        case 7: //等级7
          list.add(
            new OrdinalSales(
                dept.departmentName ?? "--", dept.level7, _getColorCircle(4)),
          );
        break;
      }
    }
    charts.Series<OrdinalSales, String> res =
    new charts.Series<OrdinalSales, String>(
        id: "id_$i",
        data: list,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (OrdinalSales sales, _) => sales.color,
        labelAccessorFn: (OrdinalSales sales, _) =>
        '${sales.sales.toString()}');
    result.add(res);
    list = [];
  }

  return result;
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;
  final charts.Color color;

  OrdinalSales(this.year, this.sales, this.color);
}
