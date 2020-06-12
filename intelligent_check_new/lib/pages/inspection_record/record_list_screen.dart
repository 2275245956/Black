import 'package:flutter/material.dart';
import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_list_content.dart';
import 'package:intelligent_check_new/pages/inspection_record/filter_page.dart';
import 'package:intelligent_check_new/model/InspectionRecordModel.dart';
import 'package:intelligent_check_new/services/inspection_record.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_utils/date_utils.dart';

class RecordListScreen extends StatefulWidget {

  final DateTime currentDate;
  final String pointNo;
  RecordListScreen({this.currentDate,this.pointNo});
  @override
  _RecordListScreenState createState() => _RecordListScreenState(currentDate);
}

class _RecordListScreenState extends State<RecordListScreen>
    with AutomaticKeepAliveClientMixin {

  // 页面接受参数
  DateTime currentDate;
  // 构造方法
  _RecordListScreenState(this.currentDate);

  @override
  bool get wantKeepAlive => true;

  // 当前页码
  int pageIndex=0;
  // 是否有下一页
  bool hasNext=false;
  // 分页所需控件
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  bool isAnimating = false;

  List<InspectionRecord> initData = List();

  String myUserId;
  String theme="";
  InspectionRecordFilter inspectionRecordFilter = new InspectionRecordFilter();
  @override
  void initState() {
    super.initState();
    //调用接口
    getInitInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: AppBar(
          title: Text("巡检记录",style: TextStyle(color: Colors.black,fontSize: 19),),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading:new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
            ),
          ),
        ),
        body: ModalProgressHUD(
          child: _getWidget(),
          inAsyncCall: isAnimating,
          opacity: 0.7,
          progressIndicator: CircularProgressIndicator(),
        )
    );
  }

  Widget _getWidget(){
    return buildInnerListHeaderDropdownMenu();
  }

  searchData(){
    DropdownMenuController controller = DefaultDropdownMenuController.of(globalKey2.currentContext);
//    if(controller!=null){
//      controller.hide();
//    }
    this.initData = [];

    loadData();
  }

  _searchData(InspectionRecordFilter filter){
    if (filter.beginDate != "") {
      inspectionRecordFilter.beginDate = filter.beginDate;
    }
    if (filter.endDate != "") {
      inspectionRecordFilter.endDate = filter.endDate;
    }
    inspectionRecordFilter.departmentId = filter.departmentId;
    inspectionRecordFilter.planTaskId = filter.planTaskId;
    inspectionRecordFilter.pointId = filter.pointId;
    if (filter.userId != -1) {
      inspectionRecordFilter.userId = filter.userId;
    }
    if (filter.isOnlyMyInspection) {
      inspectionRecordFilter.userId = myUserId;
    }
    searchData();
  }
  
  ScrollController scrollController = new ScrollController();
  GlobalKey globalKey2 = new GlobalKey();
  Widget buildInnerListHeaderDropdownMenu() {
    return new DefaultDropdownMenuController(
        onSelected: ({int menuIndex, int index, int subIndex, dynamic data}) {
          if(menuIndex == 0){
            setState(() {
              var id = data["id"];
              if (id == -1) {
                inspectionRecordFilter.userId = id.toString();
              } else {
                inspectionRecordFilter.userId = myUserId;
              }
            });
            searchData();
          }
          if(menuIndex == 1){
            setState(() {
              var id = data["id"] as int;
              if (id == 0) { // 今天
                DateTime now = new DateTime.now();
                inspectionRecordFilter.beginDate = now.toString().substring(0,10) + " 00:00:00";
                inspectionRecordFilter.endDate = now.toString().substring(0,10) + " 23:59:59";
              } else if (id == 1){ // 昨天
                DateTime now = new DateTime.now();
                inspectionRecordFilter.beginDate = (now.add(new Duration(days: -1))).toString().substring(0,10) + " 00:00:00";
                inspectionRecordFilter.endDate = (now.add(new Duration(days: -1))).toString().substring(0,10) + " 23:59:59";
              } else if (id == 2){ // 本周
                DateTime now = new DateTime.now();
                DateTime firstDayOfWeek = Utils.firstDayOfWeek(now);
                firstDayOfWeek = DateTime(firstDayOfWeek.year,firstDayOfWeek.month,firstDayOfWeek.day+1,firstDayOfWeek.hour,firstDayOfWeek.second);
                inspectionRecordFilter.beginDate = firstDayOfWeek.toString().substring(0,10) + " 00:00:00";
                inspectionRecordFilter.endDate = now.toString().substring(0,10) + " 23:59:59";
              } else if (id == 3){ // 上周
                DateTime now = new DateTime.now();
                DateTime firstDayOfWeek = Utils.firstDayOfWeek(now);
                firstDayOfWeek = DateTime(firstDayOfWeek.year,firstDayOfWeek.month,firstDayOfWeek.day+1,firstDayOfWeek.hour,firstDayOfWeek.second);
                inspectionRecordFilter.beginDate = (firstDayOfWeek.add(new Duration(days: -7))).toString().substring(0,10) + " 00:00:00";
                inspectionRecordFilter.endDate = (firstDayOfWeek.add(new Duration(days: -1))).toString().substring(0,10) + " 23:59:59";
              } else if (id == 4){ // 本月
                DateTime now = new DateTime.now();
                DateTime firstDayOfMonth = Utils.firstDayOfMonth(now);
                DateTime lastDayOfMonth = Utils.lastDayOfMonth(now);
                inspectionRecordFilter.beginDate = firstDayOfMonth.toString().substring(0,10) + " 00:00:00";
                inspectionRecordFilter.endDate = lastDayOfMonth.toString().substring(0,10) + " 23:59:59";
              } else if (id == 5){ // 上月
                DateTime now = new DateTime.now();
                // 当前月第一天
                DateTime firstDayOfMonth = Utils.firstDayOfMonth(now);
                // 当前月第一天，减一天，是上个月最后一天
                DateTime preLastDayOfMonth = firstDayOfMonth.add(new Duration(days: -1));
                // 用上个月最后一天，获取上个月第一天
                DateTime preFirstDayOfMonth = Utils.firstDayOfMonth(preLastDayOfMonth);
                inspectionRecordFilter.beginDate = preFirstDayOfMonth.toString().substring(0,10) + " 00:00:00";
                inspectionRecordFilter.endDate = preLastDayOfMonth.toString().substring(0,10) + " 23:59:59";
              }
            });
            searchData();
          }
          if(menuIndex == 2){
            setState(() {
              inspectionRecordFilter.isOK = data["id"] as int;
            });
            searchData();
          }
          if(menuIndex == 3){
            setState(() {
              var id = data["id"] as int;
              if (id == 0) {
                inspectionRecordFilter.orderBy = "checkDate asc";
              } else if (id == 1){
                inspectionRecordFilter.orderBy = "checkDate desc";
              } else if (id == 2){
                inspectionRecordFilter.orderBy = "pointNo asc";
              } else if (id == 3){
                inspectionRecordFilter.orderBy = "pointNo desc";
              }
            });
            searchData();
          }
        },
        child: new Stack(
          children: <Widget>[
            new CustomScrollView(
                controller: scrollController,
                slivers: <Widget>[
                  new SliverList(
                      key: globalKey2,
                      delegate: new SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return new Container(
                              color: Colors.black26,
//                              child: new Image.asset(
//                                "images/header.jpg",
//                                fit: BoxFit.fill,
//                              ),
                            );
                          }, childCount: 1)),
                  new SliverPersistentHeader(
                    delegate: new DropdownSliverChildBuilderDelegate(
                        builder: (BuildContext context) {
                          return new Container(
                              color: Colors.white,
                              child: buildDropdownHeader(onTap: this._onTapHead));
                        }),
                    pinned: true,
                    floating: true,
                  ),
                  new SliverList(
                      delegate: new SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
//                            return new Container(
//                              color: Theme.of(context).scaffoldBackgroundColor,
//                              child: new Image.asset(
//                                "images/body.jpg",
//                                fit: BoxFit.fill,
//                              ),
//                            );
                          }, childCount: 10)),

                ]),
            new Padding(
                padding: new EdgeInsets.only(top: 46.0),
                child: new Column(
                  children: <Widget>[
                    new Expanded(
                        child: new Stack(
                          children: <Widget>[
                            Center(
                                child: EasyRefresh(
                                  key: _easyRefreshKey,
                                  behavior: ScrollOverBehavior(),
                                  refreshHeader: ClassicsHeader(
                                    key: _headerKey,
                                    bgColor: Colors.transparent,
                                    textColor: Colors.black87,
                                    moreInfoColor: Colors.black54,
                                    showMore: true,
                                  ),
                                  refreshFooter: ClassicsFooter(
                                    key: _footerKey,
                                    bgColor: Colors.transparent,
                                    textColor: Colors.black87,
                                    moreInfoColor: Colors.black54,
                                    showMore: true,
                                  ),
                                  child: ListView.builder(
                                    //ListView的Item
                                    itemCount: initData.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.push( context,
                                              new MaterialPageRoute(builder: (context) {
                                                return new CheckExecListContent(num.tryParse(initData[index].CheckId));
                                              })
                                          );
                                        },
                                        child: Container(
                                          child: Card(
                                            elevation:0.2,
                                            margin: EdgeInsets.only(top: 5,left: 16,right: 16),
                                            child: new Container(
                                                height: 110.0,
//                                          margin: EdgeInsets.only(top: 5,left: 20,right: 20),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 8,
                                                      height: 110,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(4),bottomLeft:  Radius.circular(4)),
                                                        color: getPointColor(initData[index].IsQualified),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(left: 10,top:5),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          new Text((index+1).toString()+"." + initData[index].InspectionPointName??"",style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),
                                                          Padding(padding: EdgeInsets.only(top: 5),),
                                                          Row(
                                                            children: <Widget>[
                                                              Padding(padding: EdgeInsets.only(left: 10),),
                                                              Text("编号:"+initData[index].Number??"",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                              Padding(padding: EdgeInsets.only(left: 36),),
                                                              Text(getStatusName(initData[index].IsQualified),style: TextStyle(color: getPointColor(initData[index].IsQualified),fontSize: 12),),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Padding(padding: EdgeInsets.only(left: 10),),
                                                              Container(
                                                                width: 260,
                                                                child:Text(initData[index].InspectionPlanName==null?"计划:":"计划:" + initData[index].InspectionPlanName,style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                              ),
                                                              new Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size: 20,),

                                                            ],
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Padding(padding: EdgeInsets.only(left: 10),),
                                                              Container(width: 120,
                                                                child:Text(initData[index].InspecterName==null?"巡检人:":"巡检人:"+initData[index].InspecterName??"",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                              ),
                                                              Container(width: 170,
                                                                child:Text("时间:"+initData[index].InspectedTime??"",style: TextStyle(color: Colors.grey,fontSize: 12),),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),
                                          ),
//                                          margin: EdgeInsets.only(left: 10,right: 10),
                                        )
                                      );
                                    },
                                  ),
                                  onRefresh: () async {
                                    await new Future.delayed(const Duration(seconds: 1), () {
                                      setState(() {
                                        pageIndex = 0;
                                        initData = [];
                                      });
                                      loadData();
                                    });
                                  },
                                  loadMore: () async {
                                    await new Future.delayed(const Duration(seconds: 1), () {
                                      if(hasNext){
                                        setState(() {
                                          pageIndex = pageIndex + 1;
                                        });
                                        loadData();
                                      }
                                    });
                                  },
                                )
                            ),
                            buildDropdownMenu()
                          ],
                        ))
                  ],
                )
            ),
          ],
        ));
  }

  void _onTapHead(int index) {
    RenderObject renderObject = globalKey2.currentContext.findRenderObject();
    DropdownMenuController controller =
    DefaultDropdownMenuController.of(globalKey2.currentContext);
    if(index == 4){
      scrollController
          .animateTo(scrollController.offset + renderObject.semanticBounds.height,
          duration: new Duration(milliseconds: 150), curve: Curves.ease)
          .whenComplete(() {
        //controller.show(index);
        Navigator.push( context,
            new MaterialPageRoute(builder: (context) {
              return new FilterPage(callback: (val)=>_searchData(val));
            }));
      });
    }else{
      scrollController
          .animateTo(scrollController.offset + renderObject.semanticBounds.height,
          duration: new Duration(milliseconds: 150), curve: Curves.ease)
          .whenComplete(() {
        controller.show(index);
      });
    }
  }

  _setData() async{
    return  true;
  }
  
  String titleMy = '我的';
  String titleToday = '今天';
  String titleAll= '所有';
  String titleTime = '时间正序';
  String titleFilter = '筛选';
  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    return new DropdownHeader(
      onTap: onTap,
      titles: [titleMy,titleToday,titleAll,titleTime,titleFilter],
    );
  }

  static const int TYPE_INDEX = 0;
  static const List<Map<String, dynamic>> TITLE_MY_CONTENT= [
    {"title": "我的", "id": 0},
    {"title": "全部", "id": -1},
  ];

  static const List<Map<String, dynamic>> TITLE_TODAY_CONTENT = [
    {"title": "今天", "id": 0},
    {"title": "昨天", "id": 1},
    {"title": "本周", "id": 2},
    {"title": "上周", "id": 3},
    {"title": "本月", "id": 4},
    {"title": "上月", "id": 5},
  ];

  static const List<Map<String, dynamic>> TITLE_ALL_CONTENT = [
    {"title": "所有", "id": -1},
    {"title": "正常", "id": 1},
    {"title": "异常", "id": 2},
    {"title": "漏检", "id": 3},
  ];

  static const List<Map<String, dynamic>> TITLE_TIME_CONTENT = [
    {"title": "时间正序", "id": 0},
    {"title": "时间倒序", "id": 1},
    {"title": "编号正序", "id": 2},
    {"title": "编号倒序", "id": 3},
  ];

  DropdownMenu buildDropdownMenu() {
    return new DropdownMenu(
        maxMenuHeight: kDropdownMenuItemHeight * 10,
        menus: [
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: TYPE_INDEX,
                  data: TITLE_MY_CONTENT,
                  itemBuilder: (BuildContext context, dynamic data, bool selected){
                    return new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Row(
                          children: <Widget>[
                            new Text(
                              defaultGetItemLabel(data),
                              style: selected
                                  ? new TextStyle(
                                  fontSize: 14.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400)
                                  : new TextStyle(fontSize: 14.0),
                            ),
                            new Expanded(
                                child: new Align(
                                  alignment: Alignment.centerRight,
                                  child: selected
                                      ? new Icon(
                                    Icons.check,
                                    color: Theme.of(context).primaryColor,
                                  )
                                      : null,
                                )),
                          ],
                        ));
                  },
                );
              },
              height: kDropdownMenuItemHeight * TITLE_MY_CONTENT.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: TYPE_INDEX,
                  data: TITLE_TODAY_CONTENT,
                  itemBuilder: (BuildContext context, dynamic data, bool selected){
                    return new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Row(
                          children: <Widget>[
                            new Text(
                              defaultGetItemLabel(data),
                              style: selected
                                  ? new TextStyle(
                                  fontSize: 14.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400)
                                  : new TextStyle(fontSize: 14.0),
                            ),
                            new Expanded(
                                child: new Align(
                                  alignment: Alignment.centerRight,
                                  child: selected
                                      ? new Icon(
                                    Icons.check,
                                    color: Theme.of(context).primaryColor,
                                  )
                                      : null,
                                )),
                          ],
                        ));
                  },
                );
              },
              height: kDropdownMenuItemHeight * TITLE_TODAY_CONTENT.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: TYPE_INDEX,
                  data: TITLE_ALL_CONTENT,
                  itemBuilder: (BuildContext context, dynamic data, bool selected){
                    return new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Row(
                          children: <Widget>[
                            new Text(
                              defaultGetItemLabel(data),
                              style: selected
                                  ? new TextStyle(
                                  fontSize: 14.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400)
                                  : new TextStyle(fontSize: 14.0),
                            ),
                            new Expanded(
                                child: new Align(
                                  alignment: Alignment.centerRight,
                                  child: selected
                                      ? new Icon(
                                    Icons.check,
                                    color: Theme.of(context).primaryColor,
                                  )
                                      : null,
                                )),
                          ],
                        ));
                  },
                );
              },
              height: kDropdownMenuItemHeight * TITLE_ALL_CONTENT.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: TYPE_INDEX,
                  data: TITLE_TIME_CONTENT,
                  itemBuilder: (BuildContext context, dynamic data, bool selected){
                    return new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Row(
                          children: <Widget>[
                            new Text(
                              defaultGetItemLabel(data),
                              style: selected
                                  ? new TextStyle(
                                  fontSize: 14.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400)
                                  : new TextStyle(fontSize: 14.0),
                            ),
                            new Expanded(
                                child: new Align(
                                  alignment: Alignment.centerRight,
                                  child: selected
                                      ? new Icon(
                                    Icons.check,
                                    color: Theme.of(context).primaryColor,
                                  )
                                      : null,
                                )),
                          ],
                        ));
                  },
                );
              },
              height: kDropdownMenuItemHeight * TITLE_TIME_CONTENT.length),
        ]);
    
  }

  void getInitInfo() async{
    await SharedPreferences.getInstance().then((data){
      if(data != null){
        setState(() {
          myUserId = LoginResult(data.get('LoginResult')).user.id;
          inspectionRecordFilter.userId = myUserId;
          inspectionRecordFilter.isOK = -1;
          inspectionRecordFilter.departmentId = null;
          inspectionRecordFilter.planTaskId = -1;
          inspectionRecordFilter.pointNo = this.widget.pointNo;
          inspectionRecordFilter.orderBy = "checkDate asc";
          if (currentDate != null) {
            inspectionRecordFilter.beginDate = currentDate.toString().length>10?currentDate.toString().substring(0,10) + " 00:00:00":currentDate.toString()+ " 00:00:00";//.substring(0,19);
            inspectionRecordFilter.endDate = currentDate.toString().length>10?currentDate.toString().substring(0,10) + " 23:59:59":currentDate.toString()+ " 23:59:59";//.substring(0,19);
          } else {
            DateTime now = new DateTime.now();
            inspectionRecordFilter.beginDate = now.toString().substring(0,10) + " 00:00:00";
            inspectionRecordFilter.endDate = now.toString().substring(0,10) + " 23:59:59";
          }
          this.theme = data.getString("theme")??KColorConstant.DEFAULT_COLOR;
        });
      }
    }).then((data){
      loadData();
    });
  }

  loadData() async{
    setState(() {
      isAnimating = true;
    });
    await getInspectionRecordList(inspectionRecordFilter,pageIndex).then((data){
      setState(() {
        if(data.content != null && data.content.length>0){
          for(dynamic p in data.content){
            print(p);
            initData.add(InspectionRecord.fromParams(
                InspectionPointName:p["pointName"],
                Number:p["pointNo"],
                IsQualified:p["isOk"],
                InspectionPlanName:p["planName"],
                InspecterName:p["userName"],
                InspectedTime:p["checkTime"],
                PointId:p["pointId"],
                PlanTaskId:p["planTaskId"],
                CheckId:p["id"]
            ));
          }
          hasNext = !data.last;
        }
        isAnimating = false;
      });
    });
  }

  getPointColor(String statusName){
    if(statusName == "1"){
      return Colors.green;
    }else if(statusName == "2"){
      return Colors.red;
    }else if(statusName == "3"){
      return Colors.orange;
    }else{
      return Colors.black;
    }
  }

  getStatusName(String statusName){
    if(statusName == "1"){
      return "正常";
    }else if(statusName == "2"){
      return "异常";
    }else if(statusName == "3"){
      return "漏检";
    }else{
      return "";
    }
  }
}