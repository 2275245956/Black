import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/tools/DateUtil.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/widget/touch_callback.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intelligent_check_new/services/TaskServices.dart';
import 'package:intelligent_check_new/model/Task/TaskContentResult.dart';
import 'package:intelligent_check_new/model/Task/TaskContentInput.dart';
import 'package:intelligent_check_new/model/Task/ChartResult.dart';
import 'package:intelligent_check_new/pages/task_detail/task_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HiderManageMySendPage extends StatefulWidget {

  final TaskContentInput taskContentInput;
//  final num userId;
  HiderManageMySendPage(this.taskContentInput);

  @override
  State<StatefulWidget> createState() {
    return _HiderManageMySendPageState();
  }
}

class _HiderManageMySendPageState extends State<HiderManageMySendPage>
   /* with AutomaticKeepAliveClientMixin*/ {

  List<TaskContent> initData = new List();
  ChartResult chartResult;
//  = new ChartResult(
//      '{"processed": 0, "total": 0, "cancelled": 0, "completed": 0, "timeout": 0}');
  String theme="";

  @override
  void didUpdateWidget(HiderManageMySendPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.taskContentInput.toString() == this.widget.taskContentInput.toString()){

    }else{
      initData=[];
      getData();
    }
  }

  @override
  void initState() {
    super.initState();

    initData=[];
    getData();
  }

  getData() async {
    await SharedPreferences.getInstance().then((sp) {
      String str = sp.get('LoginResult');
      this.theme = sp.getString("theme")??KColorConstant.DEFAULT_COLOR;
      return LoginResult(str).user.id;
    }).then((userId){
      getAllTaskList(this.widget.taskContentInput,userId,2).then((data) {
        setState(() {
          initData = data;
        });
      });
      getChart(this.widget.taskContentInput,userId,2).then((data) {
        setState(() {
          chartResult = data;
        });
      });
    });
//    await getAllTaskList(this.widget.taskContentInput,this.widget.userId,2).then((data) {
//      setState(() {
//        initData = data;
//      });
//    });
//    await getChart(this.widget.taskContentInput,this.widget.userId,2).then((data) {
//      setState(() {
//        chartResult = data;
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        body: Container(
            child: Column(children: <Widget>[
      Expanded(
        child:chartResult==null || chartResult.total<=0?Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.only(left: 50),
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
                left: 100,
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
                width: double.infinity,
                color: Colors.white,
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
                  left: 150,
                  child: Column(
                    children: <Widget>[
                      Text(
                        //chartResult.total.toString(),
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
                          return MyBar(initData[index],()=>refreshPage(),theme);
                        })))),
        flex: 4,
      )
    ])));
  }

  List<charts.Series<LinearSales, String>> _createSampleData() {
    List<LinearSales> data = List();
    if (chartResult != null && chartResult.total > 0) {
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
    }else{
      data.add(new LinearSales("", -1,charts.MaterialPalette.gray.shadeDefault));
    }

    return [
      new charts.Series<LinearSales, String>(
        id: 'Sales',
        colorFn: (LinearSales data, _) => data.color,
        domainFn: (LinearSales data, _) => data.year,
        measureFn: (LinearSales data, _) => data.sales,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => row.sales == -1 ? "" : '${row.year}: ${row.sales}',
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
  String theme;
  MyBar(this.taskContent,this.refreshFatherWidget,this.theme);

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
        margin: EdgeInsets.only(top: 5, left: 16, right: 16),
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
                            width: 280,
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
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Container(
                              width: 150,
                              child: Text(
                                //"执行人:" + getExecutive(task),
                                taskContent.executor == null
                                    ? "执行人:"
                                    : "执行人:" + taskContent.executor,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[500]),
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
                                fontSize: 12,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 80),
                            ),
                            new Icon(
                              Icons.keyboard_arrow_right,
                              color: GetConfig.getColor(theme),
                              size: 25,
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Text(
                              //"创建时间：" + getTime(task),
                              taskContent.publish_time.toString() == null
                                  ? "创建时间:"
                                  : "创建时间:" +
                                  DateUtil.timestampToDate(taskContent.publish_time),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[500]),
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
