/// 全部状态统计
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

class DonutAutoLabelChartMy extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutAutoLabelChartMy(this.seriesList, {this.animate});

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

class ItemChart6 extends StatefulWidget {
  @override
  _ItemChart6State createState() => _ItemChart6State();
}

class _ItemChart6State extends State<ItemChart6> {
  var cancel = 0;
  var proccesed = 0;
  var timeout = 0;
  var finished = 0;
  var data;
  var a, b, c, d;
  var acount;
  var checkPoint = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var data = await HttpUtil().get(ApiAddress.HID_DANGER_TASK_COUNT);
    var dataList = data["dataList"];
    if (dataList != null) {
      var user = dataList["user"];
      print(data.toString());
      cancel = user["cancel"];
      proccesed = user["proccesed"];
      timeout = user["timeout"];
      finished = user["finished"];
    }else{
      cancel = 0;
      proccesed = 0;
      timeout = 0;
      finished =0;
    }
    //setState(() {});
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<LinearSales, String>> _createSampleData() {
    acount = cancel + proccesed + timeout + finished;
    checkPoint = acount;
    if (acount == 0) {
      acount = 9999999999;
      cancel = 1;
    }
    print(acount);
    a = finished * 100 ~/ acount;
    b = cancel * 100 ~/ acount;
    c = timeout * 100 ~/ acount;
    d = proccesed * 100 ~/ acount;
    data = [
      new LinearSales(
          "完成", finished, a, charts.MaterialPalette.green.shadeDefault),
      new LinearSales(
          "取消", cancel, b, charts.MaterialPalette.red.shadeDefault),
      new LinearSales(
          "超时", timeout, c, charts.MaterialPalette.yellow.shadeDefault),
      new LinearSales(
          "未处理", proccesed, d, charts.MaterialPalette.blue.shadeDefault),
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

  @override
  Widget build(BuildContext context) {
    Widget mychart;
    String chartTitle;
    Widget myChartBottom;
    double chartHeight;

    mychart = Stack(
      children: <Widget>[
        DonutAutoLabelChartMy(
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
                  Text("全部任务", style: TextStyle(fontSize: 20)),
                ],
              ),
            )
          ],
        )
      ],
    );
    chartTitle = "  我接收的任务";
    chartHeight = 200;
    myChartBottom = Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 100,
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.green),
                ),
                Text(
                  "  完成",
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 180),
              child: Text(
                "$finished个",
                style: TextStyle(color: Colors.green),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 225, top: 3.5),
              child: Text(
                "|  $a%",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
        Container(
          height: 20,
        ),
        Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 100,
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.red),
                ),
                Text(
                  "  取消",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 180),
              child: Text(
                "${acount == 9999999999 ? 0 : cancel}个",
                style: TextStyle(color: Colors.red),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 225, top: 3.5),
              child: Text(
                "|  $b%",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
        Container(
          height: 20,
        ),
        Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 100,
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.yellow),
                ),
                Text(
                  "  超时",
                  style: TextStyle(color: Colors.yellow),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 180),
              child: Text(
                "$timeout个",
                style: TextStyle(color: Colors.yellow),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 225, top: 3.5),
              child: Text(
                "|  $c%",
                style: TextStyle(color: Colors.yellow),
              ),
            ),
          ],
        ),
        Container(
          height: 20,
        ),
        Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 100,
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.blue),
                ),
                Text(
                  "  未处理",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 180),
              child: Text(
                "$proccesed个",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 225, top: 3.5),
              child: Text(
                "|  $d%",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            Container(
              height: 50,
            )
          ],
        ),
        Container(
          height: 20,
        ),
      ],
    );

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
