import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckPoint.dart';
import 'package:intelligent_check_new/model/name_value.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_spot_detail.dart';
import 'package:intelligent_check_new/services/check_point_service.dart';
import 'package:intelligent_check_new/services/route_list_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RiskSpotScreen extends StatefulWidget {
  @override
  _RiskSpotScreenState createState() => _RiskSpotScreenState();
}

class _RiskSpotScreenState extends State<RiskSpotScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isAnimating = false;

  // 线路数据
//  List<NameValue> routeList = List();
  List<Map<String, dynamic>> routeList = List();
  // 当前选择的线路数据
  NameValue selectRoute;

  // 根据线路查询点列表数据
  List<CheckPoint> pointList = List();

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
  TextEditingController _controller = new TextEditingController();
  FocusNode _focusNode = new FocusNode();


  @override
  void initState() {
    super.initState();
    getInitInfo();
    initConfig();
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  void getInitInfo() async {
    // 获取线路数据
    await getRouteList().then((data) {
      setState(() {
//        routeList = data;
//        NameValue all = NameValue("全部",-1);
//        routeList.insert(0, all);
//        List<Map<String, dynamic>> _routes = List();
        data.forEach((f){
//          print(f.name + "/" + f.value.toString());
          Map<String, dynamic> _map = Map();
          _map["title"] = f.name;
          _map["id"] = f.value;
          routeList.add(_map);
        });
        Map<String, dynamic> _allMap = Map();
        _allMap["title"] = "全部";
        _allMap["id"] = -1;
        routeList.insert(0, _allMap);

        if(null != data && data.length > 0){
          setState(() {
            selectRoute = NameValue("routeId", -1);//data[0];
          });
          loadData();
        }
      });
    });
  }

  void loadData() async {
    setState(() {
      isAnimating = true;
    });
    // 根据routeid，查询点列表
    await queryPointPage(this.selectRoute.value, this.pageIndex, this.pageSize,keywords: this._controller.text).then((data) {
      setState(() {
        for (dynamic p in data.content) {
          pointList.add(CheckPoint.fromJson(p));
        }
        // 是否有下一页
        hasNext = !data.last;
        isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (null == routeList || routeList.length <= 0) {
      return Scaffold(
        appBar: AppBar(
//          title: Text("巡检点",style: TextStyle(color: Colors.black,fontSize: 19),),
          title:new  Container(
              height: 30,
              width: 250,
              padding: EdgeInsets.only(bottom: 5),
              decoration: new BoxDecoration(
                color: Colors.grey[100],
                borderRadius: new BorderRadius.all(Radius.circular(25.0)),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 5,right: 5,top:6),
                    child: Image.asset("assets/images/search_blue.png",width: 20,color: Colors.black26),
                  ),
                  new Container(
                    width: 190,
                    child:TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        decoration: new InputDecoration(
//                    prefixIcon: new Icon(Icons.search,color: Colors.black26,),
                          border: InputBorder.none,
                        )
                    ),
                  )
                ],
              )
          ),
          actions: <Widget>[
            Align(
                child:Padding(padding: EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
//                      searchData();
//                      loadData();
                    },
                    child:Text("搜索",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14.0),),
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
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
//        title: Text("巡检点",style: TextStyle(color: Colors.black,fontSize: 19),),
        title:new  Container(
            height: 30,
            width: 250,
            padding: EdgeInsets.only(bottom: 5),
            decoration: new BoxDecoration(
              color: Colors.grey[100],
              borderRadius: new BorderRadius.all(Radius.circular(25.0)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5,right: 5,top:6),
                  child: Image.asset("assets/images/search_"+theme+".png",width: 20,color: Colors.black26),
                ),
                new Container(
                  width: 190,
                  child:TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: new InputDecoration(
//                    prefixIcon: new Icon(Icons.search,color: Colors.black26,),
                          border: InputBorder.none,
                          contentPadding:EdgeInsets.only(top: 8)
                      )
                  ),
                )
              ],
            )
        ),
        actions: <Widget>[
          Align(
              child:Padding(padding: EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
//                      searchData();
                    pageIndex = 0;
                    pointList = [];
                    loadData();
                  },
                  child:Text("搜索",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16.0),),
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
          setState(() {

            this.selectRoute.name = data["title"];
            this.selectRoute.value = data["id"];
            pageIndex = 0;
            pointList = [];
          });
          loadData();
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
                          }, childCount: this.routeList.length)),

                ]),

            new Padding(
                padding: new EdgeInsets.only(top: 46.0),
                child: new Stack(children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Expanded(child: new Container(
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
                                    margin: EdgeInsets.only(left: 15,right: 15),
                                    child: Card(
                                        elevation:0.2,
                                        child: new ListTile(
                                            isThreeLine: true,
                                            dense: false,
                                            subtitle: new Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                Text(
                                                  "编号:" +
                                                      pointList[index].pointNo,
                                                  style: new TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.grey),
                                                ),
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
                                                        return new CheckExecSpotDetail(
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
                                  loadData();
                                });
                              },
                              loadMore: () async {
                                await new Future.delayed(
                                    const Duration(seconds: 1), () {
                                  if (hasNext) {
                                    setState(() {
                                      pageIndex = pageIndex + 1;
                                    });
                                    loadData();
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
    DropdownMenuController controller = DefaultDropdownMenuController.of(globalKey2.currentContext);

    scrollController
        .animateTo(scrollController.offset + renderObject.semanticBounds.height,
        duration: new Duration(milliseconds: 150), curve: Curves.ease)
        .whenComplete(() {
      controller.show(index);

//      controller.select(selectRoute);
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
                  data: this.routeList,
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
              height: kDropdownMenuItemHeight * this.routeList.length),
        ]);
  }
}
