import 'package:flutter/material.dart';
import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityModel.dart';
import 'package:intelligent_check_new/pages/Activity/actiivty_SiteConfirm.dart';
import 'package:intelligent_check_new/pages/Activity/actiivty_environmentConfirm.dart';
import 'package:intelligent_check_new/pages/Activity/activility_check&acceptance.dart';
import 'package:intelligent_check_new/pages/Activity/activility_company_review.dart';
import 'package:intelligent_check_new/pages/Activity/activility_department_review.dart';
import 'package:intelligent_check_new/pages/Activity/activility_finished_detail.dart';
import 'package:intelligent_check_new/pages/Activity/activility_ready2run.dart';
import 'package:intelligent_check_new/pages/Activity/activility_search.dart';
import 'package:intelligent_check_new/pages/Activity/activility_team_review.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/navigation_keep_alive.dart';
import 'package:intelligent_check_new/services/Activility_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/constants/color.dart';

class ActivilityList extends StatefulWidget {
  @override
  _ActivilityList createState() => _ActivilityList();
}

class _ActivilityList extends State<ActivilityList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isAnimating = false;

  String theme = "blue";

  // 是否有下一页
  bool hasNext = false;

  ///初始化查询条件
  int pageNumber = 0;
  int pageSize = 10;
  int canExecuteType =1;
  int status = 0;
  int level = 0;
  String taskworkName = "";

  List<ActiviList> initData = new List();

  // 分页所需控件
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitInfo();
  }

  void getInitInfo() async {
    await SharedPreferences.getInstance().then((data) {
      if (data != null) {
        setState(() {
          this.theme = data.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
        });
      }
    }).then((data) {
      loadData();
    });
  }

  void loadData() async {
    setState(() {
      isAnimating = true;
    });
    await getActivilityList(this.pageNumber, this.pageSize, this.canExecuteType,
            this.status, this.level, "")
        .then((data) {
      setState(() {
        if (data.content != null && data.content.length > 0) {
          for (dynamic p in data.content) {
            this.initData.add(new ActiviList.fromJson(p));
          }
        } else {
          if (data.message != null) {
            HiddenDangerFound.popUpMsg(data.message);
          }
        }
        hasNext = hasNext =
            (data.totalElements + this.pageSize - 1) / this.pageSize >=
                (this.pageNumber + 1);
        isAnimating = false;
      });
    });
  }

  searchData() {
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (theme.isEmpty) {
      return WillPopScope(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(242, 246, 249, 1),
          appBar: AppBar(
            title: Text(
              "作业活动",
              style: TextStyle(color: Colors.black, fontSize: 19),
            ),
            centerTitle: true,
            elevation: 0.2,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            leading: new Container(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(
                        builder: (context) => NavigationKeepAlive()),
                    (route) => route == null),
                child: Icon(Icons.keyboard_arrow_left,
                    color: GetConfig.getColor(theme), size: 32),
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                child: Container(
                  child: Image.asset(
                    "assets/images/search_" + theme + ".png",
                    width: 22,
                  ),
                  padding: EdgeInsets.only(right: 20),
                ),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) {
                    return ActivilitySearchPage();
                  }));
                },
              )
            ],
          ),
          body: Container(),
          resizeToAvoidBottomPadding: false,
        ),
        onWillPop: () {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(
                  builder: (context) => NavigationKeepAlive()),
              (route) => route == null);
        },
      );
    }

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: AppBar(
          title: Text(
            "作业活动",
            style: TextStyle(color: Colors.black, fontSize: 19),
          ),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(
                      builder: (context) => NavigationKeepAlive()),
                  (route) => route == null),
              child: Icon(Icons.keyboard_arrow_left,
                  color: GetConfig.getColor(theme), size: 32),
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              child: Container(
                child: Image.asset(
                  "assets/images/search_" + theme + ".png",
                  width: 22,
                ),
                padding: EdgeInsets.only(right: 20),
              ),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) {
                  return ActivilitySearchPage();
                }));
              },
            )
          ],
        ),
        body: ModalProgressHUD(
          child: _getWidget(),
          inAsyncCall: isAnimating,
          // demo of some additional parameters
          opacity: 0.7,
          progressIndicator: CircularProgressIndicator(),
//        content: '加载中...',
        ),
        resizeToAvoidBottomPadding: false,
      ),
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => NavigationKeepAlive()),
            (route) => route == null);
      },
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
            //我的查询
            setState(() {
              var id = data["id"] as int;
              this.canExecuteType = id;
              this.initData = new List();
            });
            searchData();
          }
          if (menuIndex == 1) {
            //按状态查询
            setState(() {
              var id = data["id"] as int;
              this.status = id;
              this.initData = new List();
            });
            searchData();
          }
          if (menuIndex == 2) {
            //按等级查询
            setState(() {
              var id = data["id"] as int;
              this.level = id;
              this.initData = new List();
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
                          (BuildContext context, int index) {},
                          childCount: 10)),
                ]),
            Padding(
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
                            itemCount: initData == null ? 0 : initData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  ///  状态（0：全部；1：待班组审核；2：待车间/部门审核；3：待公司审核；
                                  ///  4：待环境确认；5：待执行；6：待现场确认；7：完成）

                                  Navigator.push(context,
                                      new MaterialPageRoute(builder: (context) {
                                    switch (initData[index].taskworkState) {
                                      case 1: //待班组审核

                                        return ActivilityTeamReview(
                                            initData[index].id);
                                      case 2: //待车间部门审核
                                        return ActivilityDepartmentReview(
                                            initData[index].id);
                                        break;
                                      case 3: //待公司审核
                                        return ActivilityCompanyReview(
                                            initData[index].id);

                                      case 4: //待环境确认
                                        return ActivilityEnvironmentConfirm(
                                            initData[index].id);
                                        break;
                                      case 5: //待执行
                                        return ActivilityReady2Run(
                                            initData[index].id);
                                        break;
                                      case 6: //待现场确认
                                        return ActivilitySiteConfirm(
                                            initData[index].id);
                                        break;
                                      case 7: //完成
                                        return ActivilityFinishDetail(
                                            initData[index].id);
                                        break;
                                      default:
                                        return ActivilityFinishDetail(
                                            initData[index].id);
                                        break;
                                    }

                                  })).then((v) {});
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: 0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    /* getBgColor(initData[index].finishStatus)*/
                                  ),
                                  height: 120.0,
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Card(
                                      elevation: 0.2,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          //任务类型

                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  //  隐患信息
                                                  Row(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 15, top: 8),
                                                      child: Text(
                                                        initData[index]
                                                                .taskworkName ??
                                                            "",
                                                        style: new TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                  ]),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 15,
                                                                  top: 6),
                                                          child: Text(
                                                            ("等级：" +
                                                                (initData[index]
                                                                        .levelDesc ??
                                                                    "--")),
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 7,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  top: 6),
                                                          child: Text(
                                                            ("状态：" +
                                                                (initData[index]
                                                                        .taskworkStateDesc ??
                                                                    "--")),
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15,
                                                                top: 5),
                                                        child: Text(
                                                            ("所属部门/车间：" +
                                                                (initData[index]
                                                                        .belongDepartmentAndGroupName ??
                                                                    "-")),
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 14)),
                                                      ),
                                                    ],
                                                  ),

                                                  //  Padding(padding: EdgeInsets.only(top: 10),),
                                                ],
                                              ),
                                            ),
                                            flex: 5,
                                          ),

                                          Expanded(
                                            child: Container(
                                                child: Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color:
                                                      GetConfig.getColor(theme),
                                                ),
                                                alignment:
                                                    Alignment.centerRight),
                                            flex: 1,
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            },
                          ),
                          onRefresh: () async {
                            await new Future.delayed(const Duration(seconds: 1),
                                () {
                              setState(() {
                                pageNumber = 0;
                                initData = [];
                              });
                              loadData();
                            });
                          },
                          loadMore: () async {
                            await new Future.delayed(const Duration(seconds: 1),
                                () {
                              if (hasNext) {
                                setState(() {
                                  this.pageNumber = this.pageNumber + 1;
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
                )),
          ],
        ));
  }

  void _onTapHead(int index) {
    RenderObject renderObject = globalKey2.currentContext.findRenderObject();
    DropdownMenuController controller =
        DefaultDropdownMenuController.of(globalKey2.currentContext);

    scrollController
        .animateTo(scrollController.offset + renderObject.semanticBounds.height,
            duration: new Duration(milliseconds: 150), curve: Curves.ease)
        .whenComplete(() {
      controller.show(index);
    });
  }

  String titleMy = '我的';
  String titleAll = '全部';
  String titleGrade = '等级';

  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    return new DropdownHeader(
      onTap: onTap,
      titles: [titleMy, titleAll, titleGrade],
    );
  }

  static const int TYPE_INDEX = 0;
  static const List<Map<String, dynamic>> TITLE_MY_CONTENT = [
    {"title": "我的", "id": 1},
    {"title": "全部", "id": 0},

  ];

 static const List<Map<String, dynamic>> TITLE_ALL_CONTENT = [
    {"title": "全部", "id": 0},
    {"title": "待班组审核", "id": 1},
    {"title": "待车间/部门审核", "id": 2},
    {"title": "待公司审核", "id": 3},
    {"title": "待环境确认", "id": 4},
    {"title": "待执行", "id": 5},
    {"title": "待现场确认", "id": 6},
    {"title": "完成", "id": 7},
  ];

  static const List<Map<String, dynamic>> TITLE_GRADE_CONTENT = [
    {"title": "全部", "id": 0},
    {"title": "1级", "id": 1},
    {"title": "2级", "id": 2},
    {"title": "3级", "id": 3},
    {"title": "4级", "id": 4},
    {"title": "5级", "id": 5},
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
                  itemBuilder:
                      (BuildContext context, dynamic data, bool selected) {
                    return new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new Text(
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
              height: kDropdownMenuItemHeight * TITLE_MY_CONTENT.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: TYPE_INDEX,
                  data: TITLE_ALL_CONTENT,
                  itemBuilder:
                      (BuildContext context, dynamic data, bool selected) {
                    return new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                              child: new Text(
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
              height: kDropdownMenuItemHeight * TITLE_ALL_CONTENT.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: TYPE_INDEX,
                  data: TITLE_GRADE_CONTENT,
                  itemBuilder:
                      (BuildContext context, dynamic data, bool selected) {
                    return new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                              child: new Text(
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

                            /*  new Expanded(
                                child: new Align(
                                  alignment: Alignment.centerRight,
                                  child: selected
                                      ? new Icon(
                                    Icons.check,
                                    color: Theme.of(context).primaryColor,
                                  )
                                      : null,
                                )),*/
                          ],
                        ));
                  },
                );
              },
              height: kDropdownMenuItemHeight * TITLE_GRADE_CONTENT.length),
        ]);
  }
}
