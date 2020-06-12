/// 全部状态统计
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

class ItemChart1 extends StatefulWidget {
  @override
  _ItemChart1State createState() => _ItemChart1State();
}

class _ItemChart1State extends State<ItemChart1> {
  var qualified = 0;
  var unqualified = 0;
  var unplan = 0;
  var omission = 0;
  var checkPoint = 0;
  var dataResult;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var data = await HttpUtil().get(ApiAddress.POINT_STATE_COUNT1);
    setState(() {
      if (data["result"] == "SUCCESS") {
        var dataList = data["dataList"];
        if (dataList != null) {
          qualified = dataList["qualified"];
          unqualified = dataList["unqualified"];
          unplan = dataList["unplan"];
          omission = dataList["omission"];
          checkPoint = qualified + unqualified + unplan + omission;
        } else {
          qualified = 0;
          unqualified = 0;
          unplan = 0;
          omission = 0;
          checkPoint = 0;
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    Widget mychart;
    String chartTitle;
    Widget myChartBottom;
    double chartHeight;

    var acount = qualified + unqualified + unplan + omission;
    //总计为0的情况
    if (acount == 0) {
      acount = 9999999999;
    }
    var a = qualified * 100 ~/ acount;
    // print(a);
    var b = unqualified * 100 ~/ acount;
    var c = unplan * 100 ~/ acount;
    var d = omission * 100 ~/ acount;

    // mychart = DonutAutoLabelChart.withSampleData();
    mychart = GetDonutAutoLabelChart();
    chartHeight = 200;
    chartTitle = "  全部状态统计";
    myChartBottom = Container(
      width: 300,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 80),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.green),
              ),
              Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 70,
                  child: Text(
                    "合格",
                    style: TextStyle(color: Colors.green),
                  )),
              Container(
                width: 50,
                child: Text(
                  "$qualified个",
                  style: TextStyle(color: Colors.green),
                ),
                alignment: Alignment.center,
              ),
              Text(
                "| $a%",
                style: TextStyle(color: Colors.green),
              )
            ],
          ),
          Container(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 80),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.red),
              ),
              Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 70,
                  child: Text(
                    "不合格",
                    style: TextStyle(color: Colors.red),
                  )),
              Container(
                width: 50,
                child: Text(
                  "$unqualified个",
                  style: TextStyle(color: Colors.red),
                ),
                alignment: Alignment.center,
              ),
              Text(
                "| $b%",
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          Container(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 80),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.yellow),
              ),
              Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 70,
                  child: Text(
                    "漏检",
                    style: TextStyle(color: Colors.yellow),
                  )),
              Container(
                width: 50,
                child: Text(
                  "$omission个",
                  style: TextStyle(color: Colors.yellow),
                ),
                alignment: Alignment.center,
              ),
              Text(
                "| $c%",
                style: TextStyle(color: Colors.yellow),
              )
            ],
          ),
          Container(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 80),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.blue),
              ),
              Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 70,
                  child: Text(
                    "未计划",
                    style: TextStyle(color: Colors.blue),
                  )),
              Container(
                width: 50,
                child: Text(
                  "$unplan个",
                  style: TextStyle(color: Colors.blue),
                ),
                alignment: Alignment.center,
              ),
              Text(
                "| $d%",
                style: TextStyle(color: Colors.blue),
              )
            ],
          ),
          Container(
            height: 20,
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 20),
    );
    //   mychart = SimpleBarChartMy.withSampleData();
    //   chartTitle = "  我的计划";
    //   chartHeight = 300;
    //   myChartBottom = C3ChartBottomMy();
    // } else if (type == 4) {
    //   mychart = SimpleBarChartDepartment.withSampleData();
    //   chartTitle = "  部门计划";
    //   chartHeight = 300;
    //   myChartBottom = C3ChartBottomDepartment();
    // } else if (type == 5) {
    //   mychart = SimpleBarChartCompany.withSampleData();
    //   chartTitle = "   公司计划";
    //   chartHeight = 300;
    //   myChartBottom = C3ChartBottomCompany();
    // } else if (type == 6) {
    //   mychart = Stack(
    //     children: <Widget>[
    //       DonutAutoLabelChartMy.withSampleData(),
    //       Positioned(
    //         top: 70,
    //         left: 95,
    //         child: Column(
    //           children: <Widget>[
    //             Text("41",style: TextStyle(fontSize: 20)),
    //             Text("巡检点",style: TextStyle(fontSize: 20)),
    //           ],
    //         ),
    //       )
    //     ],

    //   );
    //   chartHeight = 200;
    //   chartTitle = "  我接收的任务";
    //   myChartBottom = ChartBottomMy();
    // } else if (type == 7) {
    //   mychart = Stack(
    //     children: <Widget>[
    //       DonutAutoLabelChartDepartment.withSampleData(),
    //       Positioned(
    //         top: 70,
    //         left: 95,
    //         child: Column(
    //           children: <Widget>[
    //             Text("41",style: TextStyle(fontSize: 20)),
    //             Text("巡检点",style: TextStyle(fontSize: 20)),
    //           ],
    //         ),
    //       )
    //     ],

    //   );
    //   chartHeight = 200;
    //   chartTitle = "  部门接收的任务";
    //   myChartBottom = ChartBottomDepartment();
    // } else if (type == 8) {
    //   mychart = Stack(
    //     children: <Widget>[
    //       DonutAutoLabelChartCompany.withSampleData(),
    //       Positioned(
    //         top: 70,
    //         left: 95,
    //         child: Column(
    //           children: <Widget>[
    //             Text("41",style: TextStyle(fontSize: 20)),
    //             Text("巡检点",style: TextStyle(fontSize: 20)),
    //           ],
    //         ),
    //       )
    //     ],

    //   );
    //   chartHeight = 200;
    //   chartTitle = "  公司全部的任务";
    //   myChartBottom = ChartBottomCompany();
    // }

    Widget mycard = Card(
      elevation:0.2,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 3, bottom: 3, left: 15),
            height: 42,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/statistics/statistics_red.png',
                  width: 15,
                ),
                Text(
                  chartTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          // type >= 3 && type <=5 ? Container(
          //   child: Align(
          //     alignment: Alignment.centerRight,
          //     child: Text("2019-02-18"),
          //   ),
          //   margin: EdgeInsets.only(right: 20,top: 20),
          // ) : Container(),
          Container(
            // child: SimpleBarChart.withSampleData(),
            // child: DonutAutoLabelChart.withSampleData(),
            child: mychart,
            width: 400,
            height: chartHeight,
            margin: EdgeInsets.all(40),
          ),
          myChartBottom,
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );

    return Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: mycard);
  }
}

class GetDonutAutoLabelChart extends StatefulWidget {
  const GetDonutAutoLabelChart({Key key}) : super(key: key);

  @override
  _GetDonutAutoLabelChartState createState() => _GetDonutAutoLabelChartState();
}

class _GetDonutAutoLabelChartState extends State<GetDonutAutoLabelChart> {
  var qualified = 0;
  var unqualified = 0;
  var unplan = 0;
  var omission = 0;
  var checkPoint = 0;

  getData() async {
    var data = await HttpUtil().get(ApiAddress.POINT_STATE_COUNT1);
    setState(() {
      if (data["result"] == "SUCCESS") {
        var dataList = data["dataList"];
        if (dataList != null) {
          qualified = dataList["qualified"];
          unqualified = dataList["unqualified"];
          unplan = dataList["unplan"];
          omission = dataList["omission"];
          checkPoint = qualified + unqualified + unplan + omission;
        } else {
          qualified = 0;
          unqualified = 0;
          unplan = 0;
          omission = 0;
          checkPoint = 0;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    /// Create one series with sample hard coded data.
    List<charts.Series<LinearSales, String>> _createSampleData() {
      var acount = qualified + unqualified + unplan + omission;
      //总计为0的情况
      if (acount == 0) {
        acount = 9999999999;
        qualified = 1;
      }
      var a = qualified * 100 ~/ acount;
      // print(a);
      var b = unqualified * 100 ~/ acount;
      var c = omission * 100 ~/ acount;
      var d = unplan * 100 ~/ acount;
      final data = [
        new LinearSales(
            "合格", qualified, a, charts.MaterialPalette.green.shadeDefault),
        new LinearSales(
            "不合格", unqualified, b, charts.MaterialPalette.red.shadeDefault),
        new LinearSales(
            "漏检", omission, c, charts.MaterialPalette.yellow.shadeDefault),
        new LinearSales(
            "未计划", unplan, d, charts.MaterialPalette.blue.shadeDefault),
      ];

      return [
        new charts.Series<LinearSales, String>(
          id: 'Sales',
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: acount == 9999999999
              ? [
                  LinearSales(
                      "完成", 1, a, charts.MaterialPalette.blue.shadeDefault)
                ]
              : data,
          // Set a label accessor to control the text of the arc label.
          colorFn: (LinearSales data, _) => data.color,
          areaColorFn: (LinearSales data, _) => data.color,
          labelAccessorFn: (LinearSales row, _) =>
              acount == 9999999999 ? '全部为0' : '${row.year}: \n${row.hah}%',
        ),
      ];
    }

    return Stack(
      children: <Widget>[
        DonutAutoLabelChart(
          _createSampleData(),
          // Disable animations for image tests.
          animate: false,
        ),
        Stack(
          children: <Widget>[
            Positioned(
              top: 70,
              left: 95,
              child: Column(
                children: <Widget>[
                  Text(checkPoint.toString(), style: TextStyle(fontSize: 20)),
                  Text("巡检点", style: TextStyle(fontSize: 20)),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}

class DonutAutoLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutAutoLabelChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        //
        // [ArcLabelDecorator] will automatically position the label inside the
        // arc if the label will fit. If the label will not fit, it will draw
        // outside of the arc with a leader line. Labels can always display
        // inside or outside using [LabelPosition].
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 20,
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));
  }
}

/// Sample linear data type.
class LinearSales {
  final String year;
  final int sales;
  final int hah;
  final charts.Color color;

  LinearSales(this.year, this.sales, this.hah, this.color);
}
