import 'package:flutter/material.dart';
import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/model/plan_list_input.dart';
import 'package:intelligent_check_new/model/plan_list_output.dart';
import 'package:intelligent_check_new/pages/navigation_keep_alive.dart';
import 'package:intelligent_check_new/pages/plan_inspection/filter_page.dart';
import 'package:intelligent_check_new/pages/plan_inspection/global_search.dart';
import 'package:intelligent_check_new/pages/plan_inspection/plan_list_content.dart';
import 'package:intelligent_check_new/services/plan_inspection_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/constants/color.dart';

class PlanListScreen extends StatefulWidget {
  @override
  _PlanListScreenState createState() => _PlanListScreenState();
}

class _PlanListScreenState extends State<PlanListScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  bool isAnimating = false;

  String myUserId;

  List<PlanListOutput> initData = List();

  PlanListInput planListInput = new PlanListInput();

  String theme="";

  // 当前页码
  int pageIndex=0;
  // 是否有下一页
  bool hasNext=false;
  // 分页所需控件
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getInitInfo();
  }

  void getInitInfo() async{
    await SharedPreferences.getInstance().then((data){
      if(data != null){
        setState(() {

          myUserId = LoginResult(data.get('LoginResult')).user.id;
          planListInput.userId = myUserId;
          planListInput.finishStatus = -1;
          planListInput.departmentId = null;
          planListInput.routeId = -1;
          planListInput.orderBy = "beginTime asc";
          DateTime now = new DateTime.now();
          planListInput.startTime = now.toString().substring(0,10) + " 00:00:00";
          planListInput.endTime = now.toString().substring(0,10) + " 23:59:59";
          this.theme = data.getString("theme")??KColorConstant.DEFAULT_COLOR;
        });
      }
    }).then((data){
      loadData();
    });
  }

  void loadData () async{
    setState(() {
      isAnimating = true;
    });
    await getPlanListOutputList(planListInput,pageIndex).then((data){
      if(!mounted)return;
      setState(() {
        if(data != null && data.content.length>0){
          for(dynamic p in data.content){
            initData.add(PlanListOutput.fromJson(p));
          }
          hasNext = !data.last;
        }
        isAnimating = false;
      });
    });
  }

  searchData(){
    DropdownMenuController controller = DefaultDropdownMenuController.of(globalKey2.currentContext);

    this.initData = [];

    loadData();
  }

  _searchData(PlanListInput filter){
    if (filter.startTime != "") {
      planListInput.startTime = filter.startTime;
    }
    if (filter.endTime != "") {
      planListInput.endTime = filter.endTime;
    }
    planListInput.departmentId = filter.departmentId;
    planListInput.routeId = filter.routeId;
    if (filter.userId != -1) {
      planListInput.userId = filter.userId;
    }
    searchData();
  }

  @override
  Widget build(BuildContext context) {

    if(this.theme.isEmpty){
      return WillPopScope(child: Scaffold(
          body:Text("")
      ),onWillPop: (){
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => NavigationKeepAlive()),
                (route) => route == null) ;
      },);
    }

    return WillPopScope(child: Scaffold(
      backgroundColor: Color.fromRGBO(242, 246, 249, 1),
      appBar: AppBar(
        title: Text("计划巡检",style: TextStyle(color: Colors.black,fontSize: 19),),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading:new Container(
          child: GestureDetector(
            onTap: () =>  Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (context) => NavigationKeepAlive()),
                    (route) => route == null) ,
            child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              child: Image.asset("assets/images/search_"+theme+".png",width: 22,),
              padding: EdgeInsets.only(right: 20),
            ),
            onTap: (){
              Navigator.push( context,
                  new MaterialPageRoute(builder: (context) {
                    return GlobalSearch(0,this.planListInput);
                  }));
            },
          )
        ],
      ),
      body: ModalProgressHUD(
        child:_getWidget(),
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
//        content: '加载中...',
      ),
      resizeToAvoidBottomPadding: false,
    ),onWillPop: (){
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => NavigationKeepAlive()),
              (route) => route == null);
    },);
  }

  Color getBgColor(int finishStatus){
    if(finishStatus == 0) { // 未开始
      return Colors.grey;
    }else if(finishStatus == 1) { // 进行中
      return Colors.orange;
    }else if(finishStatus == 2) { // 已结束
      return Colors.red[800];
    }else if(finishStatus == 3) { // 已超时
      return Colors.redAccent;
    }else{
      return Colors.white;
    }
  }

  String getStatus(int finishStatus){
    if(finishStatus == 0) { // 未完成
      return "未开始";
    }else if(finishStatus == 1) { // 进行中
      return "进行中";
    }else if(finishStatus == 2) { // 未开始
      return "已结束";
    }else if(finishStatus == 3) { // 已超时
      return "已超时";
    }else{
      return "";
    }
  }

  Widget _getWidget(){
    return buildInnerListHeaderDropdownMenu();
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
                planListInput.userId = id.toString();
              } else {
                planListInput.userId = myUserId;
              }
            });
            searchData();
          }
          if(menuIndex == 1){
            setState(() {
              var id = data["id"] as int;
              if (id == 0) { // 今天
                DateTime now = new DateTime.now();
                planListInput.startTime = now.toString().substring(0,10) + " 00:00:00";
                planListInput.endTime = now.toString().substring(0,10) + " 23:59:59";
              } else if (id == 1){ // 昨天
                DateTime now = new DateTime.now();
                planListInput.startTime = (now.add(new Duration(days: -1))).toString().substring(0,10) + " 00:00:00";
                planListInput.endTime = (now.add(new Duration(days: -1))).toString().substring(0,10) + " 23:59:59";
              } else if (id == 2){ // 本周
                DateTime now = new DateTime.now();
                DateTime firstDayOfWeek = Utils.firstDayOfWeek(now);
                firstDayOfWeek = DateTime(firstDayOfWeek.year,firstDayOfWeek.month,firstDayOfWeek.day+1,firstDayOfWeek.hour,firstDayOfWeek.second);
                planListInput.startTime = firstDayOfWeek.toString().substring(0,10) + " 00:00:00";
                planListInput.endTime = now.toString().substring(0,10) + " 23:59:59";
              } else if (id == 3){ // 上周
                DateTime now = new DateTime.now();
                DateTime firstDayOfWeek = Utils.firstDayOfWeek(now);
                firstDayOfWeek = DateTime(firstDayOfWeek.year,firstDayOfWeek.month,firstDayOfWeek.day+1,firstDayOfWeek.hour,firstDayOfWeek.second);
                planListInput.startTime = (firstDayOfWeek.add(new Duration(days: -7))).toString().substring(0,10) + " 00:00:00";
                planListInput.endTime = (firstDayOfWeek.add(new Duration(days: -1))).toString().substring(0,10) + " 23:59:59";
              } else if (id == 4){ // 本月
                DateTime now = new DateTime.now();
                DateTime firstDayOfMonth = Utils.firstDayOfMonth(now);
                DateTime lastDayOfMonth = Utils.lastDayOfMonth(now);
                planListInput.startTime = firstDayOfMonth.toString().substring(0,10) + " 00:00:00";
                planListInput.endTime = lastDayOfMonth.toString().substring(0,10) + " 23:59:59";
              } else if (id == 5){ // 上月
                DateTime now = new DateTime.now();
                // 当前月第一天
                DateTime firstDayOfMonth = Utils.firstDayOfMonth(now);
                // 当前月第一天，减一天，是上个月最后一天
                DateTime preLastDayOfMonth = firstDayOfMonth.add(new Duration(days: -1));
                // 用上个月最后一天，获取上个月第一天
                DateTime preFirstDayOfMonth = Utils.firstDayOfMonth(preLastDayOfMonth);
                planListInput.startTime = preFirstDayOfMonth.toString().substring(0,10) + " 00:00:00";
                planListInput.endTime = preLastDayOfMonth.toString().substring(0,10) + " 23:59:59";
              }
            });
            searchData();
          }
          if(menuIndex == 2){
            setState(() {
              planListInput.finishStatus = data["id"] as int;
            });
            searchData();
          }
          if(menuIndex == 3){
            setState(() {
              var id = data["id"] as int;
              if (id == 0) {
                planListInput.orderBy = "beginTime asc";
              } else if (id == 1){
                planListInput.orderBy = "beginTime desc";
              } else if (id == 2){
                planListInput.orderBy = "taskPlanNum asc";
              } else if (id == 3){
                planListInput.orderBy = "taskPlanNum desc";
              } else if (id == 4){
                planListInput.orderBy = "finshNum asc";
              } else if (id == 5){
                planListInput.orderBy = "finshNum desc";
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
                padding: new EdgeInsets.only(top: 50.0),
                child: new Column(
                  children: <Widget>[
                    new Expanded(
                        child: new Stack(
                          children: <Widget>[
                            EasyRefresh(
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
                              child: new ListView.builder(
                                //ListView的Item
                                itemCount: initData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return  GestureDetector(
                                    onTap: (){
                                      Navigator.push( context,
                                          new MaterialPageRoute(builder: (context) {
                                            return new PlanListContent(initData[index].planTaskId,true);
                                          })).then((v){
                                        pageIndex = 0;
                                        initData = [];
                                        loadData();
                                      });
                                    },
                                    child: Container(
                                      height: 130.0,
                                      margin: EdgeInsets.only(left: 16,right: 16),
                                      child: Card(
                                          elevation:0.2,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: 8,
                                                height: 130,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(4),bottomLeft:  Radius.circular(4)),
                                                    color: getBgColor(initData[index].finishStatus)
                                                ),
//                                              color: getBgColor(initData[index].finishStatus),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(padding: EdgeInsets.only(top: 3),),
                                                  Container(
                                                    width:280,
                                                    height: 25,
                                                    padding: EdgeInsets.only(left: 10),
                                                    child: Text(initData[index].taskName??"",style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),
                                                  ),
                                                  Padding(padding: EdgeInsets.only(top: 5),),
                                                  Container(
                                                      padding: EdgeInsets.only(left: 10),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Column(
                                                            children: <Widget>[
                                                              Row(
                                                                children: <Widget>[
                                                                  Container(
                                                                    width: 140,
                                                                    child: Text("计划批号:" + initData[index].batchNo.toString(),
                                                                      style: TextStyle(color:Colors.grey,fontSize: 12),),
                                                                  ),
                                                                  Container(
                                                                    width: 100,
                                                                    child: Text(getStatus(initData[index].finishStatus),
                                                                      style: TextStyle(color: getBgColor(initData[index].finishStatus),fontSize: 12),),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <Widget>[
                                                                  Container(
                                                                    width: 140,
                                                                    child: Text("计划巡检:" + initData[index].taskPlanNum.toString(),
                                                                        style: TextStyle(color:Colors.grey,fontSize: 12)),
                                                                  ),
                                                                  Container(
                                                                    width: 100,
                                                                    child:Text("剩余:" + (initData[index].taskPlanNum - initData[index].finshNum).toString(),
                                                                        style: TextStyle(color:Colors.grey,fontSize: 12)),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <Widget>[
                                                                  Container(
                                                                    width: 240,
                                                                    child: initData[index].executiveName == null?Text("执行人:",style: TextStyle(color:Colors.grey,fontSize: 12))
                                                                        :Text("执行人:" + initData[index].executiveName,
                                                                        style: TextStyle(color:Colors.grey,fontSize: 12)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                              width: MediaQuery.of(context).size.width-310,
//                                                          height: 140,
                                                              child: Icon(Icons.keyboard_arrow_right,color:  GetConfig.getColor(theme),),
                                                              alignment: Alignment.centerRight
                                                          ),
                                                        ],
                                                      )
                                                  )
                                                  ,
                                                  Padding(padding: EdgeInsets.only(top: 10),),
                                                  Container(
                                                    height: 25,
                                                    width: MediaQuery.of(context).size.width-48,
                                                    color: Colors.grey[100],
                                                    padding: EdgeInsets.only(left: 10),
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(initData[index].beginTime + " - " + initData[index].endTime,style: TextStyle(color: Colors.grey[500],fontSize: 12),),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
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
    {"title": "未开始", "id": 0},
    {"title": "进行中", "id": 1},
    {"title": "已结束", "id": 2},
    {"title": "已超时", "id": 3},
  ];

  static const List<Map<String, dynamic>> TITLE_TIME_CONTENT = [
    {"title": "按时间正序", "id": 0},
    {"title": "按时间倒序", "id": 1},
    {"title": "计划数正序", "id": 2},
    {"title": "计划数倒序", "id": 3},
    {"title": "完成数正序", "id": 4},
    {"title": "完成数倒序", "id": 5},
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

}