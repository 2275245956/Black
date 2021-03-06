import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:intelligent_check_new/common/JunCommon.dart';
import 'package:intelligent_check_new/services/offline/dbAccess.dart';
import 'package:intelligent_check_new/tools/DateUtil.dart';
import 'package:intelligent_check_new/widget/touch_callback.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intelligent_check_new/model/Task/TaskContentResult.dart';
import 'package:intelligent_check_new/model/Task/ChartResult.dart';
import 'package:intelligent_check_new/pages/offline/task_detail/task_detail_screen.dart';

import '../../navigation_keep_alive.dart';

class OfflineHiderManageMyTaskPage extends StatefulWidget {

//  final TaskContentInput taskContentInput;
//  final num userId;
  OfflineHiderManageMyTaskPage();

  @override
  State<StatefulWidget> createState() {
    return _HiderManageMyTaskPageState();
  }

}

class _HiderManageMyTaskPageState extends State<OfflineHiderManageMyTaskPage>
   /* with AutomaticKeepAliveClientMixin*/ {


  List<TaskContent> initData = new List();

  ChartResult chartResult;

//  = new ChartResult(
//      '{"processed": 0, "total": 0, "cancelled": 0, "completed": 0, "timeout": 0}');

//--离线删除---------Start-----------------------------
//  @override
//  void didUpdateWidget(OfflineHiderManageMyTaskPage oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if(oldWidget.taskContentInput.toString() == this.widget.taskContentInput.toString()){
//
//    }else{
//      initData=[];
//      getData();
//    }
//  }
//--离线删除---------End--------------------------------
  @override
  void initState() {
    super.initState();
    initData=[];
    getData();
  }

  getData() async {
    var chart = new ChartResult.fromParams(cancelled: 0,completed: 0,processed: 0,timeout: 0,total: 0);
    dbAccess().queryData("select * from Tasks").then((lst){
      var lstMdl = new List<TaskContent>();
      for(var map in lst){
        var mdl = TaskContent.fromParams(
            id: JunMath.parseInt(map['id'].toString()),
            STATUS: map['status'],
            executor:map['executor'],
            publish_time: JunMath.parseInt(json.decode(map['jsonTask'])['publishTime'].toString()),
            title:map['title']
        );
        switch(json.decode(map['jsonTask'])['status'].toString()){
          //0:处理中
          case '0':
            chart.processed++;
            break;
            //1.已完成
          case '1':
            chart.completed++;
            break;
            //2.已取消
          case '2':
            chart.cancelled++;
            break;
            //3.已超时
          case '3':
            chart.timeout++;
            break;
        }
        lstMdl.add(mdl);
      }
      setState(() {
        initData = lstMdl;
        chart.total = lstMdl.length;
        chartResult = chart;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "我接收的任务",
            style: TextStyle(color: Colors.black, fontSize: 19),
          ),
          centerTitle: true,
          elevation: 0.7,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              //onTap: () => Navigator.pop(context),
              onTap: (){

                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new NavigationKeepAlive())
                );
              },
              child:
              Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
            ),
          ),
        ),
        body: Container(
            child: Column(children: <Widget>[
      Expanded(
        child:chartResult==null || chartResult.total<=0?Container(
          width: 180,
          child: Stack(
            children: <Widget>[
              AnimatedCircularChart(
//                    key: _chartKey,
                size: const Size(260.0, 260.0),
                initialChartData: <CircularStackEntry>[
                  new CircularStackEntry(
                    <CircularSegmentEntry>[
                      new CircularSegmentEntry(
                        100.0,
                        Colors.grey,
                        rankKey: 'completed',
                      ),
                    ],
                  ),
                ],
                chartType: CircularChartType.Radial,
                edgeStyle: SegmentEdgeStyle.round,
                holeRadius:40,
                percentageValues: true,
              ),
              Positioned(
                top: 80,
                left: 60,
                child: Column(
                  children: <Widget>[
                    Text("0",style: TextStyle(fontSize: 18),),
                    Text("全部任务")
                  ],
                ),
              )
            ],
          ),
        ):
            Container(
            width: 300,
            child: Stack(
              children: <Widget>[
                new charts.PieChart(_createSampleData(),
                    animate: false,
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 20,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator()
                        ])),
                Positioned(
                  top: 80,
                  left: 120,
                  child: Column(
                    children: <Widget>[
                      Text(
                        chartResult != null
                            ? chartResult.total.toString()
                            : "0",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text("全部任务")
                    ],
                  ),
                )
              ],
            )),
        flex: 2,
      ),
      Expanded(
        child: Container(
            child: GestureDetector(
                child: Center(
                    child: new ListView.builder(
                        //ListView的Item
                        //itemCount: items.list.length,
                        //itemCount: taskContentList.list.length,
                        itemCount: initData.length,
                        itemBuilder: (BuildContext context, int index) {
                          //return MyBar(items.list[index]);
                          //return MyBar(taskContentList.list[index]);
                          return MyBar(initData[index],()=>refreshPage());
                        })))),
        flex: 4,
      )
    ])));
  }

  List<charts.Series<LinearSales, String>> _createSampleData() {
//    var data;
//    if (chartResult != null) {
//      data = [
//        new LinearSales("已超时", chartResult.timeout,
//            charts.MaterialPalette.red.shadeDefault),
//        new LinearSales("待处理", chartResult.processed,
//            charts.MaterialPalette.yellow.shadeDefault),
//        new LinearSales("已取消", chartResult.cancelled,
//            charts.MaterialPalette.gray.shadeDefault),
//        new LinearSales("已完成", chartResult.completed,
//            charts.MaterialPalette.green.shadeDefault),
//      ];
//    } else {
//      data = [
//        new LinearSales("已超时", 0, charts.MaterialPalette.red.shadeDefault),
//        new LinearSales("待处理", 0, charts.MaterialPalette.yellow.shadeDefault),
//        new LinearSales("已取消", 0, charts.MaterialPalette.gray.shadeDefault),
//        new LinearSales("已完成", 0, charts.MaterialPalette.green.shadeDefault),
//      ];
//    }
    List<LinearSales> data = List();
    if (chartResult != null) {
      if(chartResult.timeout > 0){
        data.add(
            new LinearSales("已超时", chartResult.timeout,
                charts.MaterialPalette.red.shadeDefault)
        );
      }
      if(chartResult.processed > 0){
        data.add(
          new LinearSales("待处理", chartResult.processed,
              charts.MaterialPalette.yellow.shadeDefault),
        );
      }
      if(chartResult.cancelled > 0){
        data.add(
          new LinearSales("已取消", chartResult.cancelled,
              charts.MaterialPalette.gray.shadeDefault),
        );
      }
      if(chartResult.completed > 0){
        data.add(
          new LinearSales("已完成", chartResult.completed,
              charts.MaterialPalette.green.shadeDefault),
        );
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
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      )
    ];
  }

  refreshPage(){
    initData=[];
    getData();
  }
}

class LinearSales {
  final String year;
  final int sales;
  final charts.Color color;

  LinearSales(this.year, this.sales, this.color);
}

class MyBar extends StatelessWidget {
  //Task task;
  TaskContent taskContent;
  Function refreshFatherWidget;
  //MyBar(this.task);
  MyBar(this.taskContent,this.refreshFatherWidget);

  Color getColor(String str) {
    switch (str) {
      case '待处理':
        return Colors.yellow;
        break;
      case '已完成':
        return Colors.green;
        break;
      case '已超时':
        return Colors.red;
        break;
      case '已取消':
        return Colors.grey;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation:0.2,
        margin: EdgeInsets.only(top: 5, left: 10, right: 10),
        child: TouchCallBack(
          child: new Container(
              height: 100.0,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 8,
                    height: 100,
                    //color: getColor(task.taskState),
//                    color: taskContent.STATUS == null? Colors.grey:getColor(taskContent.STATUS),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4)),
                      color: taskContent.STATUS == null
                          ? Colors.grey
                          : getColor(taskContent.STATUS),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: 300,
                            padding: EdgeInsets.only(top: 3),
                            child: new Text(
                              //getName(task),
                              taskContent.title == null
                                  ? ""
                                  : taskContent.title,
                              style: new TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 120,
                              child: Text(
                                //"执行人:" + getExecutive(task),
                                taskContent.executor == null
                                    ? "执行人:"
                                    : "执行人:${taskContent.executor}",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[500]),
                              ),
                            ),
                            Text(
                              //getState(task.taskState),
                              taskContent.STATUS == null
                                  ? ""
                                  : taskContent.STATUS,
                              style: TextStyle(
                                color: taskContent.STATUS == null
                                    ? Colors.grey
                                    : getColor(taskContent.STATUS),
                                fontSize: 14,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 120),
                            ),
                            new Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.red,
                              size: 25,
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              //"创建时间：" + getTime(task),
                              taskContent.publish_time.toString() == null
                                  ? "创建时间:"
                                  : "创建时间:" +
                                  DateUtil.timestampToDate(taskContent.publish_time??0),
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[500]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 120),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )),
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new TaskDetailPage(
                        task: taskContent,
                      )),
            ).then((v){
              refreshFatherWidget();
            });
            //点击进入信息详细页面
          },
        ));
  }
}
