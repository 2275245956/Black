import 'package:flutter/material.dart';
import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intelligent_check_new/model/SecurityRiskJudgement/SecurityRiskModel.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/navigation_keep_alive.dart';
import 'package:intelligent_check_new/pages/security_risk_judgment/security_risk_judegment_detail.dart';
import 'package:intelligent_check_new/services/Security_Risk_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/constants/color.dart';

class SecurityRiskJudegmentList extends StatefulWidget {
  @override
  _SecurityRiskJudegmentList createState() => _SecurityRiskJudegmentList();
}

class _SecurityRiskJudegmentList extends State<SecurityRiskJudegmentList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isAnimating = false;

  String theme = "";

  int pageNumber = 0;
  int pageSize = 10;
  int executorType = 1;//默认 我的
  String beginTime = new DateFormat("yyyy-MM-dd").format(DateTime.now());
  String endTime = new DateFormat("yyyy-MM-dd").format(DateTime.now());
  int status = 1;//默认进行中

  // 是否有下一页
  bool hasNext = false;
  List<SecurityRiskListModel> initData = new List();

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
    if (mounted) {
      setState(() {
        isAnimating = true;
      });
    }

    await getSecurityRiskList(this.pageNumber, this.pageSize, this.executorType,
            this.beginTime, this.endTime, this.status)
        .then((date) {
      if (mounted) {
        setState(() {
          if (date.content != null) {
            for (var p in date.content) {
              initData.add(new SecurityRiskListModel.fromJson(p));
            }

          } else {
            if (date.message != null) HiddenDangerFound.popUpMsg(date.message);
          }

          hasNext = (date.totalElements+this.pageSize-1)/this.pageSize>=(this.pageNumber+1);
          isAnimating = false;

        });
      }
    });
  }

  searchData() {
    this.initData = [];
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if(theme==""){
      return WillPopScope(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(242, 246, 249, 1),
          appBar: AppBar(
            title: Text(
              "安全风险研判",
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

            ],
          ),
          body: Container(),
          resizeToAvoidBottomPadding: false,
        ),
        onWillPop: () => Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(
                builder: (context) => NavigationKeepAlive()),
                (route) => route == null),
      );
    }
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: AppBar(
          title: Text(
            "安全风险研判",
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
      onWillPop: () => Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (context) => NavigationKeepAlive()),
              (route) => route == null),
    );
  }

  Color getBgColor(int finishStatus) {
    if (finishStatus == 1) {
      // 进行中
      return Colors.orange;
    } else if (finishStatus == 2) {
      // 已超时
      return Colors.red[800];
    } else if (finishStatus == 3) {
      // 已提交
      return Colors.green;
    } else if (finishStatus == 4) {
      // 已审核
      return Colors.teal;
    } else if (finishStatus == 5) {
      // 已汇总
      return Colors.purple;
    }
    return Colors.grey;
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
              var id = data["id"] as int;
              this.executorType = id;
            });
            searchData();
          }
          if (menuIndex == 1) {
            setState(() {
              var id = data["id"] as int;
              if (id == 0) {
                //今天
                beginTime = new DateFormat("yyyy-MM-dd").format(DateTime.now());
              } else if (id == 1) {
                // 本周
                DateTime now = new DateTime.now();
                DateTime firstDayOfWeek =
                    Utils.firstDayOfWeek(now); //默认是星期日    定义成周一 ： +1天
                firstDayOfWeek= firstDayOfWeek.add(new Duration(days: 1));
                beginTime = new DateFormat("yyyy-MM-dd").format(firstDayOfWeek);
              } else if (id == 2) {
                // 本月
                DateTime now = new DateTime.now();
                DateTime firstDayOfMonth = Utils.firstDayOfMonth(now);
                beginTime =
                    new DateFormat("yyyy-MM-dd").format(firstDayOfMonth);
              } else {
                beginTime ="";
              }
            });
            endTime = new DateFormat("yyyy-MM-dd").format(new DateTime.now());
            searchData();
          }
          if (menuIndex == 2) {
            setState(() {
              this.status = data["id"] as int;
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
                        );
                      }, childCount: 1)),
                  new SliverPersistentHeader(
                    delegate: new DropdownSliverChildBuilderDelegate(
                        builder: (BuildContext context) {
                      return Container(
                          color: Colors.white,
                          child: new Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 10,
                                  child: buildDropdownHeader(
                                      onTap: this._onTapHead)),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                    child: Image.asset("assets/images/home/inspection_calendar_$theme.png",
                                      width: 32,
                                      height: 32,
                                    ),
                                    onTap: () {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime(2000, 01, 01),
                                          maxTime: DateTime(2199, 12, 31),
                                          theme: DatePickerTheme(
                                              itemStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              doneStyle: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 16)),
                                          onConfirm: (date) {
                                        if (mounted) {
                                          setState(() {
                                            beginTime =
                                                new DateFormat("yyyy-MM-dd")
                                                    .format(DateTime.parse(
                                                        date.toString()));
                                            endTime =
                                                new DateFormat("yyyy-MM-dd")
                                                    .format(DateTime.parse(
                                                        date.toString()));
                                          });
                                          searchData();
                                        }
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.zh);
                                    }),
                              ),
                            ],
                          ));
                    }),
                    pinned: true,
                    floating: true,
                  ),
                  new SliverList(
                      delegate: new SliverChildBuilderDelegate(
                          (BuildContext context, int index) {},
                          childCount: 10)),
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
                            itemCount: initData == null ? 0 : initData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              new SecurityRiskJudegmentDetail(
                                                  this.initData[index].id)));
                                },
                                child: Container(
                                  height: 100.0,
                                  margin: EdgeInsets.only(left: 16, right: 16),
                                  child: Card(
                                      elevation: 0.2,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 8,
                                            height: 100,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    bottomLeft:
                                                        Radius.circular(4)),
                                                color: getBgColor(
                                                    initData[index].status)),
//                                              color: getBgColor(initData[index].finishStatus),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      50,
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    initData[index]
                                                            .judgmentName ??
                                                        "",
                                                    style: new TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            50,
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          flex: 9,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Text(
                                                                        initData[index].departmentName ??
                                                                            "--",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                            fontSize: 14),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                      flex: 5,
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                50),
                                                                        child:
                                                                            Text(
                                                                          initData[index].statusDesc ??
                                                                              "--",
                                                                          style: TextStyle(
                                                                              color: getBgColor(initData[index].status),
                                                                              fontSize: 14),
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                              child: Icon(
                                                                Icons
                                                                    .keyboard_arrow_right,
                                                                color: GetConfig
                                                                    .getColor(
                                                                        theme),
                                                              ),
                                                              alignment: Alignment
                                                                  .centerRight),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                height: 25,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    50,
                                                color: Colors.white,
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  initData[index].date,
                                                  style: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontSize: 15),
                                                ),
                                              )),
                                            ],
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
                                initData = [];
                                pageNumber = 0;
                              });
                              loadData();
                            });
                          },
                          loadMore: () async {
                            await new Future.delayed(const Duration(seconds: 1),
                                () {
                              if (hasNext) {
                                setState(() {
                                  pageNumber = pageNumber + 1;
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
  String titleToday = '今天';
  String titleAll = '所有';

  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    return new DropdownHeader(
      onTap: onTap,
      titles: [titleMy, titleToday, titleAll],
    );
  }

  static const int TYPE_INDEX = 0;
  static const List<Map<String, dynamic>> TITLE_MY_CONTENT = [
    {"title": "我的", "id": 1},
    {"title": "全部", "id": 0},

  ];

  static const List<Map<String, dynamic>> TITLE_TODAY_CONTENT = [
    {"title": "今天", "id": 0},
    {"title": "本周", "id": 1},
    {"title": "本月", "id": 2},
    {"title": "全部", "id": 3},
  ];

  static const List<Map<String, dynamic>> TITLE_ALL_CONTENT = [
    {"title": "进行中", "id": 1},
    {"title": "已超时", "id": 2},
    {"title": "已提交", "id": 3},
    {"title": "已审核", "id": 4},
    {"title": "已汇总", "id": 5},
    {"title": "全部", "id": 0},

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
              height: kDropdownMenuItemHeight * TITLE_MY_CONTENT.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: TYPE_INDEX,
                  data: TITLE_TODAY_CONTENT,
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
              height: kDropdownMenuItemHeight * TITLE_TODAY_CONTENT.length),
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
        ]);
  }
}
