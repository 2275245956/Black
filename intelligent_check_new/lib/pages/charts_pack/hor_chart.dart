/// Horizontal bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

class HorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  HorizontalBarChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(desiredTickCount: 4)),
    );
  }
  /// Create one series with sample hard coded data.
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;
  final charts.Color color;

  OrdinalSales(this.year, this.sales, this.color);
}

class C2ChartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 20,
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.green
                  ),
                  margin: EdgeInsets.only(right: 5),
                ),
                Text("合格"),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 15,
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.red
                  ),
                  margin: EdgeInsets.only(right: 5),
                ),
                Text("不合格"),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 15,
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.yellow
                  ),
                  margin: EdgeInsets.only(right: 5),
                ),
                Text("漏检"),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 15,
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.blue
                  ),
                  margin: EdgeInsets.only(right: 5),
                ),
                Text("未计划"),
              ],
            ),
            Container(
              height: 50,
            ),
          ],
        ),
        Container(
          height: 20,
        ),
      ],
    );
  }
}


class ItemChart2 extends StatefulWidget {


  @override
  _ItemChart2State createState() => _ItemChart2State();
}

class _ItemChart2State extends State<ItemChart2> {

  var list;
  List<OrdinalSales> data1=List(),data2=List(),data3=List(),data4=List();

  getData() async {
    var data = await HttpUtil().get(ApiAddress.POINT_STATE_COUNT2);
    if (data["result"]=="SUCCESS") {
      list = data["dataList"];
      print(list.toString());

      for (var item in list) {
          print(item);
          data1.add(OrdinalSales(item["departmentName"], item["qualified"], charts.MaterialPalette.green.shadeDefault));
          data2.add(OrdinalSales(item["departmentName"], item["unqualified"], charts.MaterialPalette.red.shadeDefault));
          data3.add(OrdinalSales(item["departmentName"], item["omission"], charts.MaterialPalette.yellow.shadeDefault));
          data4.add(OrdinalSales(item["departmentName"], item["unplan"], charts.MaterialPalette.blue.shadeDefault));
        }
      setState(() {
        
      });
    }
  }
  
  List<charts.Series<OrdinalSales, String>> _createSampleData() {
    data1 = data1;
    data2 = data2;
    data3 = data3;
    data4 = data4;

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (OrdinalSales data, _) => data.color,
        labelAccessorFn: (OrdinalSales sales, _) => '${sales.sales}',
        data: data1,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (OrdinalSales data, _) => data.color,
        labelAccessorFn: (OrdinalSales sales, _) => '${sales.sales}',
        data: data2,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (OrdinalSales data, _) => data.color,
        labelAccessorFn: (OrdinalSales sales, _) => '${sales.sales}',
        data: data3,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        colorFn: (OrdinalSales data, _) => data.color,
        labelAccessorFn: (OrdinalSales sales, _) => '${sales.sales}',
        data: data4,
      ),
    ];
  }


  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget mychart;
    String chartTitle;
    Widget myChartBottom;
    double chartHeight;
    
    mychart = HorizontalBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
    chartTitle = "  按计划部门统计";
    chartHeight = 450;
    myChartBottom = C2ChartBottom();
    // } else if (type == 2) {
    //   mychart = HorizontalBarChart.withSampleData();
    //   chartTitle = "  按计划部门统计";
    //   chartHeight = 450;
    //   myChartBottom = C2ChartBottom();
    // } else if (type == 3) {
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
    //   chartTitle = "  公司计划";
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