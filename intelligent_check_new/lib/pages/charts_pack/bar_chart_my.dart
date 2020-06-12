/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

class SimpleBarChartMy extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChartMy(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(desiredTickCount: 4)),
    );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;
  final charts.Color color;

  OrdinalSales(this.year, this.sales, this.color);
}

class ItemChart3 extends StatefulWidget {
  String activeDate = "今天";

  @override
  _ItemChart3State createState() => _ItemChart3State();
}

class _ItemChart3State extends State<ItemChart3> {
  var total = 0;
  var missed = 0;
  var unfinished = 0;
  var finished = 0;
  var data;

  @override
  void initState() {
    super.initState();
    getData();
//    print('bar_chart_my.getData()');
  }

  getData() async {

    DateTime now = new DateTime.now();
    List<Map> finalParam = List();
    finalParam.add({"name": "startTime", "value" : now.toString().substring(0,10) + " 00:00:00"});
    finalParam.add({"name": "endTime", "value" : now.toString().substring(0,10) + " 23:59:59"});

    switch(widget.activeDate){
      case "今天":
        finalParam = List();
        finalParam.add({"name": "startTime", "value" : now.toString().substring(0,10) + " 00:00:00"});
        finalParam.add({"name": "endTime", "value" : now.toString().substring(0,10) + " 23:59:59"});
        break;
      case "昨天":
        finalParam = List();
        DateTime yesterday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
        finalParam.add({"name": "startTime", "value" : yesterday.toString().substring(0,10) + " 00:00:00"});
        finalParam.add({"name": "endTime", "value" : yesterday.toString().substring(0,10) + " 23:59:59"});
        break;
      case "本周":
        finalParam = List();
        DateTime curWeekday = DateTime.now().add(new Duration(days: 1-DateTime.now().weekday));
        finalParam.add({"name": "startTime", "value" : curWeekday.toString().substring(0,10) + " 00:00:00"});
        finalParam.add({"name": "endTime", "value" : curWeekday.toString().substring(0,10) + " 23:59:59"});
        break;
      case "上周":
        finalParam = List();
        DateTime preWeekday = DateTime.now()
            .add(new Duration(days: 1-DateTime.now().weekday - 7));
        finalParam.add({"name": "startTime", "value" : preWeekday.toString().substring(0,10) + " 00:00:00"});
        finalParam.add({"name": "endTime", "value" : preWeekday.toString().substring(0,10) + " 23:59:59"});
        break;
      case "本年":
        finalParam = List();
        int year = DateTime.now().year;
        finalParam.add({"name": "startTime", "value" : "$year-01-01 00:00:00"});
        finalParam.add({"name": "endTime", "value" : "$year-12-31 23:59:59"});
        break;
      case "上年":
        finalParam = List();
        int year = DateTime.now().year-1;
        finalParam.add({"name": "startTime", "value" : "$year-01-01 00:00:00"});
        finalParam.add({"name": "endTime", "value" : "$year-12-31 23:59:59"});
        break;
      default:
        List<Map> finalParam = List();
        finalParam.add({"name": "startTime", "value" : now.toString().substring(0,10) + " 00:00:00"});
        finalParam.add({"name": "endTime", "value" : now.toString().substring(0,10) + " 23:59:59"});
    }
    var data = await HttpUtil()
        .post(ApiAddress.PLANRUN_STATE_COUNT, data: finalParam);
    var dataList = data["dataList"];
    setState(() {
      if (dataList != null) {
        var user = dataList["user"];
        print(dataList["user"].toString());
        total = user["total"];
        missed = user["missed"];
        unfinished = user["unfinished"];
        finished = user["finished"];
      }
    });
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<OrdinalSales, String>> _createSampleData() {
    data = [
      new OrdinalSales(
          '计划巡检', total, charts.MaterialPalette.purple.shadeDefault),
      new OrdinalSales(
          '实际巡检', missed, charts.MaterialPalette.green.shadeDefault),
      new OrdinalSales(
          '漏检', unfinished, charts.MaterialPalette.yellow.shadeDefault),
      new OrdinalSales(
          '未开始', finished, charts.MaterialPalette.blue.shadeDefault),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (OrdinalSales data, _) => data.color,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        labelAccessorFn: (OrdinalSales sales, _) => '${sales.sales}',
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget mychart;
    String chartTitle;
    Widget myChartBottom;
    double chartHeight;

    mychart = SimpleBarChartMy(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
    chartTitle = "  我的计划";
    chartHeight = 300;
    myChartBottom = Row(
      children: <Widget>[
        Container(
          width: 10,
        ),
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: widget.activeDate == "今天" ? Colors.red : Colors.white,
                border: Border.all(color: Colors.grey[200])),
            child: Text(
              "今天",
              style: widget.activeDate == "今天"
                  ? TextStyle(color: Colors.white)
                  : TextStyle(color: Colors.black),
            ),
            padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
          ),
          onTap: () async {
            widget.activeDate = "今天";
            DateTime now = new DateTime.now();
            List<Map> param = List();
            param.add({"name": "startTime", "value" : now.toString().substring(0,10) + " 00:00:00"});
            param.add({"name": "endTime", "value" : now.toString().substring(0,10) + " 23:59:59"});
            var data = await HttpUtil()
                .post(ApiAddress.PLANRUN_STATE_COUNT, data: param);
            var dataList = data["dataList"];

            setState(() {
              if (dataList != null) {
                var user = dataList["user"];
                print(dataList["user"].toString());
                total = user["total"];
                missed = user["missed"];
                unfinished = user["unfinished"];
                finished = user["finished"];
              } else {
                total = 0;
                missed = 0;
                unfinished = 0;
                finished = 0;
              }
            });
          },
        ),
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: widget.activeDate == "昨天" ? Colors.red : Colors.white,
                border: Border.all(color: Colors.grey[200])),
            child: Text(
              "昨天",
              style: widget.activeDate == "昨天"
                  ? TextStyle(color: Colors.white)
                  : TextStyle(color: Colors.black),
            ),
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          ),
          onTap: () async {
            widget.activeDate = "昨天";
            var param = {
              'startTime': DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day - 1)
                  .toString(),
              'endTime': DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day - 1, 23, 59, 59, 999)
                  .toString(),
            };

            List<Map> yesterdayParam = List();
            DateTime yesterday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
            yesterdayParam.add({"name": "startTime", "value" : yesterday.toString().substring(0,10) + " 00:00:00"});
            yesterdayParam.add({"name": "endTime", "value" : yesterday.toString().substring(0,10) + " 23:59:59"});
            var data = await HttpUtil()
                .post(ApiAddress.PLANRUN_STATE_COUNT, data: yesterdayParam);
            var dataList = data["dataList"];
            setState(() {
              if (dataList != null) {
                var user = dataList["user"];
                print(dataList["user"].toString());
                total = user["total"];
                missed = user["missed"];
                unfinished = user["unfinished"];
                finished = user["finished"];
              } else {
                total = 0;
                missed = 0;
                unfinished = 0;
                finished = 0;
              }
            });
          },
        ),
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: widget.activeDate == "本周" ? Colors.red : Colors.white,
                border: Border.all(color: Colors.grey[200])),
            child: Text(
              "本周",
              style: widget.activeDate == "本周"
                  ? TextStyle(color: Colors.white)
                  : TextStyle(color: Colors.black),
            ),
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          ),
          onTap: () async {
            widget.activeDate = "本周";
            List<Map> weekParam = List();
            DateTime curWeekday = DateTime.now().add(new Duration(days: 1-DateTime.now().weekday));
            weekParam.add({"name": "startTime", "value" : curWeekday.toString().substring(0,10) + " 00:00:00"});
            weekParam.add({"name": "endTime", "value" : curWeekday.toString().substring(0,10) + " 23:59:59"});
            var data = await HttpUtil()
                .post(ApiAddress.PLANRUN_STATE_COUNT, data: weekParam);
            var dataList = data["dataList"];
            setState(() {
              if (dataList != null) {
                var user = dataList["user"];
                print(dataList["user"].toString());
                total = user["total"];
                missed = user["missed"];
                unfinished = user["unfinished"];
                finished = user["finished"];
              } else {
                total = 0;
                missed = 0;
                unfinished = 0;
                finished = 0;
              }
            });
          },
        ),
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: widget.activeDate == "上周" ? Colors.red : Colors.white,
                border: Border.all(color: Colors.grey[200])),
            child: Text(
              "上周",
              style: widget.activeDate == "上周"
                  ? TextStyle(color: Colors.white)
                  : TextStyle(color: Colors.black),
            ),
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          ),
          onTap: () async {
            widget.activeDate = "上周";

            List<Map> lastWeekParam = List();
            DateTime preWeekday = DateTime.now()
                .add(new Duration(days: 1-DateTime.now().weekday - 7));
            lastWeekParam.add({"name": "startTime", "value" : preWeekday.toString().substring(0,10) + " 00:00:00"});
            lastWeekParam.add({"name": "endTime", "value" : preWeekday.toString().substring(0,10) + " 23:59:59"});
            var data = await HttpUtil()
                .post(ApiAddress.PLANRUN_STATE_COUNT, data: lastWeekParam);
            setState(() {
              var dataList = data["dataList"];
              if (dataList != null) {
                var user = dataList["user"];
                print(dataList["user"].toString());
                total = user["total"];
                missed = user["missed"];
                unfinished = user["unfinished"];
                finished = user["finished"];
              } else {
                total = 0;
                missed = 0;
                unfinished = 0;
                finished = 0;
              }
            });
          },
        ),
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: widget.activeDate == "本年" ? Colors.red : Colors.white,
                border: Border.all(color: Colors.grey[200])),
            child: Text(
              "本年",
              style: widget.activeDate == "本年"
                  ? TextStyle(color: Colors.white)
                  : TextStyle(color: Colors.black),
            ),
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          ),
          onTap: () async {
            widget.activeDate = "本年";
            List<Map> yearParam = List();
            int year = DateTime.now().year;
            yearParam.add({"name": "startTime", "value" : "$year-01-01 00:00:00"});
            yearParam.add({"name": "endTime", "value" : "$year-12-31 23:59:59"});
            var data = await HttpUtil()
                .post(ApiAddress.PLANRUN_STATE_COUNT, data: yearParam);
            setState(() {
              var dataList = data["dataList"];
              if (dataList != null) {
              var user = dataList["user"];
              print(dataList["user"].toString());
                total = user["total"];
                missed = user["missed"];
                unfinished = user["unfinished"];
                finished = user["finished"];
              } else {
                total = 0;
                missed = 0;
                unfinished = 0;
                finished = 0;
              }
            });
          },
        ),
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: widget.activeDate == "上年" ? Colors.red : Colors.white,
                border: Border.all(color: Colors.grey[200])),
            child: Text(
              "上年",
              style: widget.activeDate == "上年"
                  ? TextStyle(color: Colors.white)
                  : TextStyle(color: Colors.black),
            ),
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          ),
          onTap: () async {
            widget.activeDate = "上年";
            List<Map> lastYearParam = List();
            int year = DateTime.now().year-1;
            lastYearParam.add({"name": "startTime", "value" : "$year-01-01 00:00:00"});
            lastYearParam.add({"name": "endTime", "value" : "$year-12-31 23:59:59"});
            var data = await HttpUtil()
                .post(ApiAddress.PLANRUN_STATE_COUNT, data: lastYearParam);
            setState(() {
              var dataList = data["dataList"];
              if (dataList != null) {
                var user = dataList["user"];
                print(dataList["user"].toString());
                total = user["total"];
                missed = user["missed"];
                unfinished = user["unfinished"];
                finished = user["finished"];
              } else {
                total = 0;
                missed = 0;
                unfinished = 0;
                finished = 0;
              }
            });
          },
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
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                  "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}"),
            ),
            margin: EdgeInsets.only(right: 20, top: 20),
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
