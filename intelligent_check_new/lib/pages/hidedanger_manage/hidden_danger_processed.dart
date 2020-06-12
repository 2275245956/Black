import 'package:flutter/material.dart';
import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:intelligent_check_new/model/Hidden_Danger/hidden_danger_model.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_procedded_hasChecked.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_processed_details_rescinded.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_search.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidedanger_pending.dart';
import 'package:intelligent_check_new/pages/navigation_keep_alive.dart';
import 'package:intelligent_check_new/pages/plan_inspection/filter_page.dart';
import 'package:intelligent_check_new/services/HiddenDanger.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/constants/color.dart';

class ProcessedHiddenDanger extends StatefulWidget {
  @override
  _ProcessedHiddenDanger createState() => _ProcessedHiddenDanger();
}

class _ProcessedHiddenDanger extends State<ProcessedHiddenDanger>
with AutomaticKeepAliveClientMixin {

@override
bool get wantKeepAlive => true;

bool isAnimating = false;

String myUserId;

List<HiddenDangerModel> initData = List();

HiddenDangerFilter modelfilter = new HiddenDangerFilter();

String theme="";

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

        modelfilter.dangerName="";
        modelfilter.pageSize=10;
        modelfilter.pageIndex=0;
        modelfilter.belongType=0;
        modelfilter.dangerState=0;
        modelfilter.dangerLevel=0;
        modelfilter.isHandle=true;
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
  await getHiddenDangerList(modelfilter).then((data){
    if(mounted){
      setState(() {
        if(data.content != null && data.content.length>0){
          for(dynamic p in data.content){

            initData.add(HiddenDangerModel.fromParams(
                dangerId: p["dangerId"],
                level: p["level"],
                dangerName: p["dangerName"],
                discovererUserName: p["discovererUserName"],
                stateDesc: p["stateDesc"],
                limitDesc: p["limitDesc"],
                state: p["state"],
                levelDesc: p["levelDesc"]
            ));
          }
          hasNext = !data.last;
        }
        isAnimating = false;
      });
    }

  });
}

searchData(){
  // DropdownMenuController controller = DefaultDropdownMenuController.of(globalKey2.currentContext);

  this.initData = [];

  loadData();
}

_searchData(HiddenDangerFilter filter){
  if (filter.dangerLevel != -1) {
    modelfilter.dangerLevel = filter.dangerLevel;
  }
  if (filter.belongType != -1) {
    modelfilter.belongType = filter.belongType;
  }
  if (filter.dangerState != -1) {
    modelfilter.dangerState = filter.dangerState;
  }


  modelfilter.pageIndex =0;
  modelfilter.pageSize = filter.pageSize;
  modelfilter.isHandle=true;
  searchData();
}

@override
Widget build(BuildContext context) {

  if(this.theme.isEmpty){
    return Scaffold(
        body:Text("")
    );
  }

  return Scaffold(
    backgroundColor: Color.fromRGBO(242, 246, 249, 1),
    appBar: AppBar(
      title: Text("已处理",style: TextStyle(color: Colors.black,fontSize: 19),),
      centerTitle: true,
      elevation: 0.2,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      leading:new Container(
        child: GestureDetector(
          onTap:() =>  Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => NavigationKeepAlive()),
                  (route) => route == null),
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
                  return HiddenDangerSearchPage(true);
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
  );
}




Color getLevelTextBgColor(int level)
{
  if(level==1)
    return Colors.orange;
  if(level==2)
    return Colors.red;
  return Colors.black;
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
            var id = data["id"] as int;
            modelfilter.belongType=id;
          });
          _searchData(modelfilter);
        }
        if(menuIndex == 1){
          setState(() {
            var id = data["id"] as int;
            modelfilter.dangerState=id;
          });
          _searchData(modelfilter);
        }
        if(menuIndex == 2){
          setState(() {
            var id = data["id"] as int;
            modelfilter.dangerLevel=id;
          });
          _searchData(modelfilter);
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
                                          switch (initData[index].state){

                                            case 5://治理完毕

                                              return new HiddenDangerProcessedCheckedDetail(initData[index].dangerId);
                                              break;
                                            case 6://已撤销
                                              return new HiddenDangerProcessedDetailsRescinded(initData[index].dangerId);
                                              break;

                                            default:
                                              return new HiddenDangerProcessedDetailsRescinded(initData[index].dangerId);
                                              break;
                                          }
                                          // return new PlanListContent(initData[index].planTaskId);
                                        })).then((v){
                                      modelfilter.pageIndex = 0;
                                      initData = [];
                                      loadData();
                                    });
                                  },
                                  child: Container(
                                    height: 130.0,
                                    margin: EdgeInsets.only(left: 10,right: 10),
                                    child: Card(
                                        elevation:0.2,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            //任务类型
                                            Expanded(
                                              child: Column(

                                                children: <Widget>[
                                                  Expanded(
                                                    child:Container(
                                                        alignment: Alignment.bottomCenter,
                                                        child:Image.asset(PendingHideDanger.getDangerStateIcon(initData[index].state),height: 30,)
                                                    ),
                                                  ),

                                                  Expanded(
                                                    child:Container(
                                                        alignment: Alignment.topCenter,
                                                        child:Text(initData[index].stateDesc,style:TextStyle(color:Color.fromRGBO(154, 154, 154, 1) ),)
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              flex: 2,
                                            ),
                                            Expanded(
                                              child: SingleChildScrollView(child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  //  隐患信息
                                                  Row(
                                                      children: <Widget>[
                                                        Container(
                                                          padding: EdgeInsets.only(left: 0,top: 8),
                                                          child: Text(initData[index].dangerName??"",style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),
                                                        ) ,
                                                      ]
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(

                                                        padding: EdgeInsets.only(left: 10,top:6),
                                                        child: Text("发现人：" +initData[index].discovererUserName,
                                                          style: TextStyle(color:Colors.grey,fontSize: 14),),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(

                                                        padding: EdgeInsets.only(left: 10,top: 5),
                                                        child: Text("隐患等级：",
                                                            style: TextStyle(color:Colors.grey,fontSize: 14)),
                                                      ),
                                                      Container(

                                                        child:Text(initData[index].levelDesc ,
                                                            style: TextStyle(color:getLevelTextBgColor(initData[index].level),fontSize: 14)),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(

                                                          padding: EdgeInsets.only(left: 10,top: 5),
                                                          child:Text("治理期限："+initData[index].limitDesc
                                                              ,style: TextStyle(color:Colors.grey,fontSize: 14))

                                                      ),
                                                    ],
                                                  ),


                                                  //  Padding(padding: EdgeInsets.only(top: 10),),

                                                ],
                                              ),),
                                              flex: 7,

                                            ),
                                            Expanded(
                                              child:  Container(
                                                  child: Icon(Icons.keyboard_arrow_right,color:  GetConfig.getColor(theme),),
                                                  alignment: Alignment.centerRight
                                              ),
                                              flex: 1,
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
                                  modelfilter.pageIndex = 0;
                                  initData = [];
                                });
                                loadData();
                              });
                            },
                            loadMore: () async {
                              await new Future.delayed(const Duration(seconds: 1), () {
                                if(hasNext){
                                  setState(() {
                                    modelfilter.pageIndex =  modelfilter.pageIndex + 1;
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
String titleAll = '全部';
String titleGrade= '等级';

DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
  return new DropdownHeader(
    onTap: onTap,
    titles: [titleMy,titleAll,titleGrade],
  );
}

static const int TYPE_INDEX = 0;
static const List<Map<String, dynamic>> TITLE_MY_CONTENT= [

  {"title": "全部", "id": 0},
  {"title": "我的", "id": 1}


];



static const List<Map<String, dynamic>> TITLE_ALL_CONTENT = [
    {"title": "全部", "id": 0},

  {"title": "治理完毕", "id": 5},
  {"title": "已撤销", "id": 6},
];

static const List<Map<String, dynamic>> TITLE_GRADE_CONTENT = [
  {"title": "全部", "id": 0},
  {"title": "一般隐患", "id": 1},
  {"title": "重大隐患", "id": 2},

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
                          new Expanded(
                            child:  new Text(
                              defaultGetItemLabel(data),
                              textAlign: TextAlign.center,
                              style: selected
                                  ? new TextStyle(
                                  fontSize: 14.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400)
                                  : new TextStyle(fontSize: 14.0),
                            ),

                          ),



                        ],
                      ));
                },
              );
            },
            height: kDropdownMenuItemHeight * TITLE_MY_CONTENT.length
        ),
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
                          Expanded(
                            child:new Text(
                              defaultGetItemLabel(data),
                              textAlign: TextAlign.center,
                              style: selected
                                  ? new TextStyle(
                                  fontSize: 14.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400)
                                  : new TextStyle(fontSize: 14.0),
                            ),

                          ),


                        ],
                      ));
                },
              );
            },
            height: kDropdownMenuItemHeight * TITLE_ALL_CONTENT.length
        ),

        new DropdownMenuBuilder(
            builder: (BuildContext context) {
              return new DropdownListMenu(
                selectedIndex: TYPE_INDEX,
                data: TITLE_GRADE_CONTENT,
                itemBuilder: (BuildContext context, dynamic data, bool selected){
                  return new Padding(
                      padding: new EdgeInsets.all(10.0),
                      child: new Row(
                        children: <Widget>[
                          Expanded(
                            child:   new Text(
                              defaultGetItemLabel(data),
                              textAlign: TextAlign.center,
                              style: selected
                                  ? new TextStyle(
                                  fontSize: 14.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400)
                                  : new TextStyle(fontSize: 14.0),
                            ),
                          ),

                        ],
                      ));
                },
              );
            },
            height: kDropdownMenuItemHeight * TITLE_GRADE_CONTENT.length),
      ]);
}

}