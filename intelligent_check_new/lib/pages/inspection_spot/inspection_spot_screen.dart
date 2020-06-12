import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/APIResponse.dart';
import 'package:intelligent_check_new/model/CheckPoint.dart';
import 'package:intelligent_check_new/pages/inspection_spot/inspection_spot_detail.dart';
import 'package:intelligent_check_new/pages/inspection_spot/inspection_spot_search.dart';
import 'package:intelligent_check_new/services/check_point_service.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InspectionSpotScreen extends StatefulWidget {
  @override
  _InspectionSpotScreenState createState() => _InspectionSpotScreenState();
}

class _InspectionSpotScreenState extends State<InspectionSpotScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isAnimating = false;

  // 线路数据
//  List<NameValue> routeList = List();
  List<Map<String, dynamic>> levelList = List();
  // 当前选择的线路数据



  List<QueryPoint> pointList = List();

  // 当前页码
  int pageIndex = 0;

  // 每页条数
  int pageSize=10;

  // 是否有下一页
  bool hasNext = false;

  // 分页所需控件
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  String theme="";
 // TextEditingController _controller = new TextEditingController();
//  FocusNode _focusNode = new FocusNode();


  @override
  void initState() {
    super.initState();
   // getInitInfo();
    initConfig();
  }

  initConfig() async{
    await queryPointLevel().then((data){
      Map<String, dynamic> _allMap = Map();
      _allMap["title"] = "全部";
      _allMap["id"] = 0;
      levelList.insert(0, _allMap);
      if(data.success){
        for(var jsonstr in data.dataList["dataList"]){
          Map<String, dynamic> _levelMap = Map();
          _levelMap["title"] =jsonstr["level"];
          _levelMap["id"] = jsonstr["code"];
          levelList.add(_levelMap);
        }
      }
    });

    await SharedPreferences.getInstance().then((preferences){
      if(!mounted)return;
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    }).then((data){
      loadDatas();
    });
  }

//  void getInitInfo() async {
//    // 获取线路数据
//    await getRouteList().then((data) {
//      setState(() {
////        routeList = data;
////        NameValue all = NameValue("全部",-1);
////        routeList.insert(0, all);
////        List<Map<String, dynamic>> _routes = List();
////        data.forEach((f){
//////          print(f.name + "/" + f.value.toString());
////          Map<String, dynamic> _map = Map();
////          _map["title"] = f.name;
////          _map["id"] = f.value;
////          routeList.add(_map);
////        });
//      for(var i=1;i<=7;i++){
//        Map<String, dynamic> _map = Map();
//        _map["title"] = "$i级";
//        _map["id"] = i;
//        levelList.add(_map);
//      }
//
//
//        Map<String, dynamic> _allMap = Map();
//        _allMap["title"] = "全部";
//        _allMap["id"] = -1;
//        levelList.insert(0, _allMap);
//
////        if(null != data && data.length > 0){
////          setState(() {
////            selectlevel = NameValue("level", -1);//data[0];
////          });
//        //  loadData();
//       // }
//      });
//    });
//  }

/*  void loadData() async {
    setState(() {
      isAnimating = true;
    });
    // 根据routeid，查询点列表
    await queryPointPage(this.selectRoute.value, this.pageIndex, this.pageSize,keywords: this._controller.text).then((data) {
      setState(() {
        for (dynamic p in data.content) {
          pointList.add(QueryPoint.fromJson(p));
        }
        // 是否有下一页
        hasNext = !data.last;
        isAnimating = false;
      });
    });
  }*/
  void loadDatas({String level}) async {
    if(!mounted)return;
    setState(() {
      isAnimating = true;
    });
    // 根据routeid，查询点列表
    await queryPointPages(this.pageIndex, this.pageSize,level: level).then((data) {
      if(!mounted)return ;
      setState(() {
        for (dynamic p in data.content) {
          pointList.add(QueryPoint.fromJson(p));
        }
        // 是否有下一页
        hasNext = !data.last;
        isAnimating = false;
      });
    });
  }

  _searchData(String lv){

    this.pointList=[];
    loadDatas(level:lv);
   //  controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (this.theme.isEmpty) {
      return Scaffold(body: Text(""));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("固有风险点",style: TextStyle(color: Colors.black,fontSize: 19),),
        actions: <Widget>[
          Align(
              child:Padding(padding: EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push( context,
                        new MaterialPageRoute(builder: (context) {
                          return new InspectionSpotSearchPage();
                        }));
                  },
                  child:Image.asset("assets/images/search_"+theme+".png",width: 20,color: GetConfig.getColor(theme)),
                ),
              )
          )
        ],
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
        child:_getWidget(),
        inAsyncCall: isAnimating,
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _getWidget() {
    return buildInnerListHeaderDropdownMenu();
  }

  ScrollController scrollController = new ScrollController();
  GlobalKey globalKey2 = new GlobalKey();

  Widget buildInnerListHeaderDropdownMenu() {
    return new DefaultDropdownMenuController(
        onSelected: ({int menuIndex, int index, int subIndex, dynamic data}) {
          if (menuIndex == 0) {
              setState(() {
                pageSize=10;
                pageIndex=0;
            });
             var level=data["id"].toString()=="0"?null:data["title"];
            _searchData(level);
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
                          }, childCount: this.levelList.length)),

                ]),

            new Padding(

                padding: new EdgeInsets.only(top: 46.0),
                child: new Stack(children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Expanded(child: new Container(
                        color:Color.fromRGBO(242, 246, 249, 1),
                        child: GestureDetector(
                          child: Center(
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
                              child:
                              new ListView.builder(
                                //ListView的Item
                                itemCount: pointList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: EdgeInsets.only(left: 10,right: 10),
                                    child: Card(

                                        elevation:0.2,
                                        child: new ListTile(
                                            isThreeLine: true,
                                            dense: false,
                                            subtitle: new Column(

                                              crossAxisAlignment:CrossAxisAlignment.start,

                                              children: <Widget>[
                                                new Text(
                                                  (index + 1).toString() +
                                                      "." +
                                                      pointList[index].name,
                                                  style: new TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                      FontWeight.w600),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(top: 5),
                                                ),
                                                Container(
                                                  padding:    EdgeInsets.only(left: 10),
                                                  child:  Row(

                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 7,
                                                        child:  Text(
                                                          "编号：" +
                                                              pointList[index].pointNo,
                                                          style: new TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors.grey),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child:  Text(
                                                          "等级："+ (pointList[index].pointLevel==null?" - 级":pointList[index].pointLevel).toString(),
                                                          style: new TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors.grey),
                                                        ),
                                                      ),
                                                    ],
                                                  ),),


                                              ],
                                            ),
                                            trailing: new Padding(
                                              child: new Icon(
                                                Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),),
                                              padding: EdgeInsets.only(top: 15),
                                            ),
                                            onTap: () {
                                              Navigator.push(context,
                                                  new MaterialPageRoute(
                                                      builder: (context) {
                                                        return new InspectionSpotDetail(
                                                            pointList[index].id,true);
                                                      }));
                                            })),
                                  );
                                },
                              ),
                              onRefresh: () async {
                                await new Future.delayed(
                                    const Duration(seconds: 1), () {
                                  setState(() {
                                    pageIndex = 0;
                                    pointList = [];
                                  });
                                  loadDatas();
                                });
                              },
                              loadMore: () async {
                                await new Future.delayed(
                                    const Duration(seconds: 1), () {
                                  if (hasNext) {
                                    setState(() {
                                      pageIndex = pageIndex + 1;
                                    });
                                    loadDatas();
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                  buildDropdownMenu(),
                ])),

          ],
        ));
  }

  void _onTapHead(int index) {
    RenderObject renderObject = globalKey2.currentContext.findRenderObject();
    DropdownMenuController controller =
    DefaultDropdownMenuController.of(globalKey2.currentContext);
    scrollController
          .animateTo(
          scrollController.offset + renderObject.semanticBounds.height,
          duration: new Duration(milliseconds: 150),
          curve: Curves.ease)
          .whenComplete(() {
        controller.show(index);

      });



  }

  static const int TYPE_INDEX = 0;
  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    return new DropdownHeader(
      onTap: onTap,
      titles: ['全部'],
    );
  }

  DropdownMenu buildDropdownMenu() {
    return new DropdownMenu(
        maxMenuHeight: kDropdownMenuItemHeight * 10,
        menus: [
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: TYPE_INDEX,
                  data: this.levelList,
                  itemBuilder: (BuildContext context, dynamic data, bool selected){
                    return new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                              child:     new Text(
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
              height: kDropdownMenuItemHeight * this.levelList.length),
        ]);
  }
}
