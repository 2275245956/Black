import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intelligent_check_new/model/task_calendar/calendar_main_model.dart';
import 'package:intelligent_check_new/pages/inspection_record/record_list_screen.dart';
import 'package:intelligent_check_new/pages/plan_inspection/select_route.dart';
import 'package:intelligent_check_new/services/calendar_main_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';


class CalendarMainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CalendarMainPageState();

}

class _CalendarMainPageState extends State<CalendarMainPage>{

  CalendarCarousel  _calendarCarouselNoHeader;
  EventList<Event> _markedDateMap = new EventList<Event>();
  DateTime _currentDate = DateTime.now();
  String _routeName="安全检查表";
  int _routeId = -1;
  String titleYear = DateTime.now().toString().substring(0,4);
  String titleMonth = DateTime.now().toString().substring(5,7);
  bool isAnimating = false;
  CalendarModel initData;
  String theme="";

  @override
  void initState() {
    super.initState();
    loadData();
    initConfig();
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  List<Widget> getContainer(CalendarDataModel calendarDataModel){
    List<Container> container= List();
    if (calendarDataModel.omission > 0 ) {
      container.add(Container(
        height: 3,
        color: Colors.yellow,
      ));
    }
    if (calendarDataModel.qualified > 0 ) {
      container.add(Container(
        height: 3,
        color: Colors.green,
      ));
    }
    if (calendarDataModel.unqualified > 0 ) {
      container.add(Container(
        height: 3,
        color: Colors.red,
      ));
    }

    return container;
  }
  void loadData () async{
    setState(() {
      isAnimating = true;
    });
    await checkCalendar(titleYear + "-" + titleMonth, _routeId).then((data){
      setState(() {
        initData = data;
        isAnimating = false;

        _markedDateMap.clear();
        for(var _detail in initData.calendarData){
          Widget _eventIcon = new Container(
            child:Column(
              children: getContainer(_detail),
            ),
          );

          _markedDateMap.add(
              DateTime.parse(_detail.date),
              new Event(
                  date: DateTime.parse(_detail.date),
                  title: _detail.date,
                  icon: _eventIcon
              ));
        }

      });
    });

    /*DefaultAssetBundle.of(context).loadString("assets/data/plan_inspection.json").then((data){
      setState(() {
        var items =  json.decode(data);
        print(items);
        List<Point> points = List();
        if(items["result"] == "SUCCESS"){
          var dataList = items["dataList"];
          var _points = dataList["points"];
          for(var d in _points){
            points.add(Point.fromJson(d));
          }
          initData = PlanTaskDetail.fromJson(dataList["planTask"]);
          initData.points = points;
          isAnimating = false;
        }
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    if(this.theme.isEmpty){
      return Scaffold(
          body:Text("")
      );
    }

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() {
          _currentDate = date;
          if (titleYear != date.toString().substring(0,4) || titleMonth != date.toString().substring(5,7)) {
            titleYear = date.toString().substring(0,4);
            titleMonth = date.toString().substring(5,7);
            loadData();
          }
        });
        events.forEach((event){
          Navigator.push(context,
                new MaterialPageRoute(builder: (context) {
                  return new RecordListScreen(currentDate : _currentDate);
                })
            );
        });
      },
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
//      thisMonthDayBorderColor: Colors.grey[100],
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 3,
      markedDateMoreShowTotal: false, // null for not showing hidden events indicator
      showHeader: false,
      daysHaveCircularBorder: false,
      isScrollable: false,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
//      todayTextStyle: TextStyle(
//        color: Colors.blue,
//      ),
//      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.red,
      ),
      selectedDayBorderColor: Colors.grey[100],
      selectedDayButtonColor: Colors.grey[100],
      todayBorderColor: Colors.greenAccent,
      todayButtonColor: Colors.greenAccent,
      todayTextStyle:TextStyle(
        color: Colors.black,
      ),
//      minSelectedDate: _currentDate,
//      maxSelectedDate: _currentDate.add(Duration(days: 60)),
//      inactiveDateColor: Colors.black12,
      onCalendarChanged: (DateTime date) {
      this.setState(() {
        if (titleYear != date.toString().substring(0,4) || titleMonth != date.toString().substring(5,7)) {
          titleYear = date.toString().substring(0,4);
          titleMonth = date.toString().substring(5,7);
          loadData();
        }
      });
    },
      locale: "zh",
    );
    if (initData == null) {
      return Scaffold(
        backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              titleYear + "年" + titleMonth + "月",
              style: TextStyle(color: Colors.black, fontSize: 19),
            ),
            centerTitle: true,
            elevation: 0.2,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            leading: new Container(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: ImageIcon(AssetImage("assets/images/calendar/calendar_change_"+theme+".png"),color: GetConfig.getColor(theme),),
                onPressed: (){
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      theme: DatePickerTheme(),
                      onChanged: (date) {
                      }, onConfirm: (date) {
                        setState(() {
                          _currentDate = date;
                          if (titleYear != date.toString().substring(0,4) || titleMonth != date.toString().substring(5,7)) {
                            titleYear = date.toString().substring(0,4);
                            titleMonth = date.toString().substring(5,7);
                            loadData();
                          }
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.zh);
                },
              )
            ],
          ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            titleYear + "年" + titleMonth + "月",
            style: TextStyle(color: Colors.black, fontSize: 19),
          ),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: ImageIcon(AssetImage("assets/images/calendar/calendar_change_"+theme+".png"),color: GetConfig.getColor(theme)),
              onPressed: (){
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    theme: DatePickerTheme(),
                    onChanged: (date) {
                    }, onConfirm: (date) {
                      setState(() {
                        _currentDate = date;
                        if (titleYear != date.toString().substring(0,4) || titleMonth != date.toString().substring(5,7)) {
                          titleYear = date.toString().substring(0,4);
                          titleMonth = date.toString().substring(5,7);
                          loadData();
                        }
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.zh);
              },
            )
          ],
        ),
      body:ModalProgressHUD(
          child:  Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 20,bottom: 10),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push( context,
                          new MaterialPageRoute(builder: (context) {
                            return SelectRoutePage();
                          })).then((value){
                        if(value!=null){
                          setState(() {
                            _routeName = value.name;
                            _routeId = value.value;
                          });
                          loadData();
                        }
                      });
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Text(_routeName,style: TextStyle(color: Colors.grey),),
                          alignment: Alignment.center,
                        ),
                        Container(
                          child: Icon(Icons.chevron_right,color: GetConfig.getColor(theme)),
                          alignment: Alignment.centerRight,
                        )
                      ],
                    )
                  )
              ),
              Divider(height: 1,),
//          Stack(
//            children: <Widget>[
//              Positioned(
//                top:100,
//              )
//            ],
//          ),
              Expanded(
                child:initData.count == 0 ?
                Container(
                  width: 200,
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
                        holeRadius:60,
                        percentageValues: true,
                      ),
                      Positioned(
                        top: 70,
                        left: 70,
                        child: Column(
                          children: <Widget>[
                            Text(initData.count.toString(),style: TextStyle(fontSize: 18),),
                            Text("计划巡检")
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
                              Text(initData.count.toString(),style: TextStyle(fontSize: 18),),
                              Text("计划巡检")
                            ],
                          ),
                        )
                      ],
                    )
                ),
                flex: 3,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  padding: EdgeInsets.only(top: 20),
                  child: _calendarCarouselNoHeader,
                ),
                flex:5,
              )
            ],
          ),
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
      )
    );
  }

  //=========================================================
  List<charts.Series<LinearSales, String>> _createSampleData(CalendarModel initData) {
    var data = [
      new LinearSales("异常", initData.unqualified,charts.MaterialPalette.red.shadeDefault),
      new LinearSales("漏检", initData.omission,charts.MaterialPalette.yellow.shadeDefault),
      new LinearSales("正常", initData.qualified,charts.MaterialPalette.green.shadeDefault),
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
}

class LinearSales {
  final String year;
  final int sales;
  final charts.Color color;

  LinearSales(this.year, this.sales,this.color);
}