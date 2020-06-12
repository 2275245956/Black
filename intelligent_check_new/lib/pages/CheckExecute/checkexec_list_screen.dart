import 'package:flutter/material.dart';
import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckExecute/check_point_record_list.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/model/plan_list_input.dart';
import 'package:intelligent_check_new/pages/CheckExecute/filter_page.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_list_content.dart';
import 'package:intelligent_check_new/services/CheckRecordServices.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_flow/timeline_flow.dart';

class CheckExecListScreen extends StatefulWidget {

  final num pointId;
  final String pointName;
  CheckExecListScreen(this.pointId,this.pointName);
  @override
  _CheckExecListScreenState createState() => _CheckExecListScreenState();
}

class _CheckExecListScreenState extends State<CheckExecListScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;
//  int _selectedIndex = 0;
  List<bool> offStageLst = List();
  List<String> dateKeyVisible = List();
  PlanListInput planListInput = new PlanListInput();
  String myUserId;
  Map<String,List<CheckPointRecordDetail>> pageData = Map();
  String theme="";

  @override
  void initState() {
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
          planListInput.departmentId = -1;
          planListInput.routeId = -1;
          DateTime now = new DateTime.now();
          planListInput.startTime = now.toString().substring(0,10);
          planListInput.endTime = now.toString().substring(0,10);
          this.theme = data.getString("theme")??KColorConstant.DEFAULT_COLOR;
        });
      }
    }).then((data){
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
//    if(offStageLst.length < 1){
//      return Scaffold(
//        appBar: AppBar(
//          title: Text("巡检点名称",style: TextStyle(color: Colors.black,fontSize: 19),),
//          centerTitle: true,
//          elevation: 0.7,
//          brightness: Brightness.light,
//          backgroundColor: Colors.white,
//          leading:new Container(
//            child: GestureDetector(
//              onTap: () => Navigator.pop(context),
//              child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
//            ),
//          ),
////          actions: <Widget>[
////            IconButton(icon: Icon(Icons.search,color: Colors.red,),onPressed: (){},)
////          ],
//        ),
//      );
//    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pointName== null || widget.pointName.isEmpty?"巡检点名称":widget.pointName,style: TextStyle(color: Colors.black,fontSize: 19),),
        centerTitle: true,
        elevation: 0.7,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading:new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
          ),
        ),
      ),

      body: _getWidget(),

//      bottomNavigationBar: BottomNavigationBar( // 底部导航
//        items: <BottomNavigationBarItem>[
//          BottomNavigationBarItem(icon: Icon(Icons.tap_and_play), title: Text('巡检')),
//          BottomNavigationBarItem(icon: Icon(Icons.chrome_reader_mode), title: Text('记录')),
//          BottomNavigationBarItem(icon: Icon(Icons.blur_circular), title: Text('详情')),
//        ],
//        currentIndex: _selectedIndex,
//        fixedColor: Colors.blue,
//        onTap: _onItemTapped,
//      ),
    );

  }

//  void _onItemTapped(int index) {
//    setState(() {
//      _selectedIndex = index;
//    });
//  }

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
                planListInput.userId = id;
              } else {
                planListInput.userId = myUserId;
              }
            });
            searchData();
          }
          if(menuIndex == 1){
            setState(() {
              planListInput.finishStatus = data["id"] as int;
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
//                              child: Text("")
                            );
                          }, childCount: 1)),
                  new SliverPersistentHeader(
                    delegate: new DropdownSliverChildBuilderDelegate(
                        builder: (BuildContext context) {
                          return new Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: buildDropdownHeader(onTap: this._onTapHead));
                        }),
                    pinned: true,
                    floating: true,
                  ),
                  new SliverList(
                      delegate: new SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return new Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
//                              child: new Image.asset(
//                                "images/body.jpg",
//                                fit: BoxFit.fill,
//                              ),
                            );
                          }, childCount: 10)),
                ]
            ),

            new Padding(
                padding: new EdgeInsets.only(top: 46.0),
                child:new Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: 1,
                                      itemBuilder: (context,index){
                                        return Column(
                                          children: pageData.keys.map((k){
                                            return Column(
                                              children: <Widget>[
                                                GestureDetector(
                                                  child:  Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(k,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
                                                        Padding(padding: EdgeInsets.only(right: 200),),
                                                        Icon(dateKeyVisible.indexOf(k)==-1?Icons.keyboard_arrow_right:Icons.keyboard_arrow_down,color: Colors.red,)
                                                      ],
                                                    ),
                                                    height: 50,
                                                    width: double.infinity,
                                                    padding: EdgeInsets.only(left: 20,right: 10,top: 5),
                                                    alignment: Alignment.centerLeft,
                                                  ),
                                                  onTap: (){
                                                    setState(() {
                                                      //offStageLst[index] = !offStageLst[index];
//                                                      print(dateKeyVisible.indexOf(k));
                                                      dateKeyVisible.indexOf(k)==-1?dateKeyVisible.add(k):dateKeyVisible.remove(k);
//                                                      print(dateKeyVisible);
                                                    });
                                                  },
                                                ),
                                                Divider(height: 1,),
                                                Offstage(
                                                  offstage: dateKeyVisible.indexOf(k)==-1?true:false,
                                                  child: Column(
                                                    children: pageData[k].map((v){
                                                      return Column(
                                                        children: <Widget>[
                                                          Container(
                                                            child: TimelineView.builder(left: 30.0, leftLine: 45.0, itemCount: 1, itemBuilder: (index){
                                                              return GestureDetector(
                                                                child: TimelineTile(
                                                                  height: 90,
                                                                  title: Text(getStatusName(v.is_ok),style: TextStyle(color: getPointColor(v.is_ok)),),
                                                                  subTitle: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: <Widget>[
                                                                      Text(v.checkTime??""+" 姓名TODO" /*+ " " + v.userName*/,style: TextStyle(color: Colors.grey)),
                                                                      Row(
                                                                        children: <Widget>[
                                                                          Text('计划名称:',style: TextStyle(color: Colors.grey)),
                                                                          Container(
                                                                            width: 150,
//                                                                            height: 30,
                                                                            child: Text(v.planName??"",style: TextStyle(color: Colors.grey))
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                  dotColor: getPointColor(v.is_ok),
                                                                  gap: 0.0,
                                                                  trailing: Icon(Icons.keyboard_arrow_right,color: Colors.red,size: 18,),
                                                                ),
                                                                onTap: (){
                                                                  Navigator.push( context,
                                                                      new MaterialPageRoute(builder: (context) {
                                                                        return new CheckExecListContent(v.id);
                                                                      }));
                                                                },
                                                              );
                                                            }),
                                                            height: 105.0,
                                                          ),
                                                          Divider(height: 1,),
                                                        ],
                                                      );
                                                    }).toList(),
                                                  ),
                                                )
                                              ],
                                            );
                                          }).toList()
                                        );
                                      }),
                                )
                              ],
                            ),
                            buildDropdownMenu()
                          ],
                        ),
            ),
          ],
        ) );
  }

  void _onTapHead(int index) {
    RenderObject renderObject = globalKey2.currentContext.findRenderObject();
    DropdownMenuController controller =
    DefaultDropdownMenuController.of(globalKey2.currentContext);

    if(index == 2){
      scrollController
          .animateTo(scrollController.offset + renderObject.semanticBounds.height,
          duration: new Duration(milliseconds: 150), curve: Curves.ease)
          .whenComplete(() {
        //controller.show(index);
        Navigator.push( context,
            new MaterialPageRoute(builder: (context) {
              return new FilterPage((data)=>callBack(data));
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
  String titleAll= '所有';
  String titleFilter = '筛选';
  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    return new DropdownHeader(
      onTap: onTap,
      titles: [titleMy,titleAll,titleFilter],
    );
  }

  static const int TYPE_INDEX = 0;
  static const List<Map<String, dynamic>> TITLE_MY_CONTENT= [
    {"title": "我的", "id": 1},
    {"title": "全部", "id": 2},
  ];

  static const List<Map<String, dynamic>> TITLE_ALL_CONTENT = [
    {"title": "所有", "id": -1},
    {"title": "合格", "id": 1},
    {"title": "不合格", "id": 2},
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
                                  alignment: Alignment.center,
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
                                  alignment: Alignment.center,
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

//          new DropdownMenuBuilder(
//              builder: (BuildContext context) {
//                return FilterPage();
//              },
//              height: 800),
        ]);
  }

  // 删选页面回调函数
  callBack(PlanListInput data){
    setState(() {
      planListInput = data;
    });
    searchData();
  }

  searchData(){
    setState(() {
      this.pageData = Map();
    });
    getData();
  }

  getData() async{
    await getCheckPointRecordList(planListInput,this.widget.pointId).then((data){
      setState(() {
        print(data);
        pageData = data;
        pageData.forEach((k,v){
          dateKeyVisible.add(k);
        });
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
      return "合格";
    }else if(statusName == "2"){
      return "不合格";
    }else if(statusName == "3"){
      return "漏检";
    }else{
      return "";
    }
  }
}