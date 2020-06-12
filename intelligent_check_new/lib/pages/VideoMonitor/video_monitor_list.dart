import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/VideoMonitor.dart';
import 'package:intelligent_check_new/pages/VideoMonitor/video_play.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/navigation_keep_alive.dart';
import 'package:intelligent_check_new/services/VideoMonitorService.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoMonitorList extends StatefulWidget {
  @override
  _VideoMonitorListState createState() => _VideoMonitorListState();
}

class _VideoMonitorListState extends State<VideoMonitorList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String theme = "";
  bool isAnimating = false;
  bool hasNext = false;
  int pageIndex = 1;
  int pageSize = 10;

  List<VideoMonitorListModel> initData = new List();

  // 分页所需控件
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
    initConfig();
  }

  List<Widget> _getVideoList() {
    List<Widget> lsW = new List();
    for (VideoMonitorListModel vm in initData) {
      lsW.add(Container(
        child: GestureDetector(
          child: Column(
            children: <Widget>[
              Container(
                child: Image.asset(
                  "assets/images/videoPic.png",

                ),
              ),
              Container(
                height: ((((MediaQuery.of(context).size.width / 2 - 10) * 119) /
                            100) -
                        MediaQuery.of(context).size.width / 2 +
                        15)
                    .floorToDouble(),
                width: MediaQuery.of(context).size.width / 2 - 10,
                // height: MediaQuery.of(context).size.width/2 -10 ,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text("${vm.name}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${vm.text}",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                color: Colors.black,
              )
            ],
          ),
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return VideoPlay(
                initData: initData,
                videoToken: vm.token,
                Title: vm.name,
              );
            }));
          },
        ),
      ));
    }

    return lsW;
  }

  void initConfig() async {
    var sp = await SharedPreferences.getInstance();
    setState(() {
      this.theme = sp.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
    });
    LoadData();
  }

  void LoadData() async {
    setState(() {
      isAnimating = true;
    });
    var data = await getMonitorList(pageIndex, pageSize, "9");
    if (data.success) {
      var dataList = data.dataList;
      setState(() {
        hasNext = !(dataList["totalPage"] - 1 == pageIndex);
        for (var str in dataList["dataList"]) {
          initData.add(new VideoMonitorListModel.fromJson(str));
        }
      });
    }else{
      HiddenDangerFound.popUpMsg(data.message);
    }
    setState(() {
      isAnimating = false;
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    //获取统计数据
//    StatisticsPage.queryAuthCompanyLeaves();
    if (initData == null || initData.length == 0) {
      return WillPopScope(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(242, 246, 249, 1),
          appBar: AppBar(
            title: Text(
              '视频监控',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
            ),
            leading: GestureDetector(
              child: Icon(
                Icons.keyboard_arrow_left,
                color: GetConfig.getColor(theme ?? "blue"),
                size: 32,
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(
                        builder: (context) => NavigationKeepAlive()),
                    (route) => route == null);
              },
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Center(),
        ),
        onWillPop: () {
          Navigator.pop(context);
        },
      );
    }

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: AppBar(
          title: Text(
            '视频监控',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
            ),
          ),
          leading: GestureDetector(
            child: Icon(
              Icons.keyboard_arrow_left,
              color: GetConfig.getColor(theme ?? "blue"),
              size: 32,
            ),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(
                      builder: (context) => NavigationKeepAlive()),
                  (route) => route == null);
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: ModalProgressHUD(
          child: new Padding(
              padding: new EdgeInsets.only(top: 5.0),
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
                        child: GridView(
                          //构造 GridView 的委托者，GridView.count 就相当于指定 gridDelegate 为 SliverGridDelegateWithFixedCrossAxisCount，
                          //GridView.extent 就相当于指定 gridDelegate 为 SliverGridDelegateWithMaxCrossAxisExtent，它们相当于对普通构造方法的一种封装
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            //必传参数，Cross 轴（在 GridView 中通常是横轴，即每一行）子组件个数
                            crossAxisCount: 2,
                            //子组件宽高比，如 2 表示宽：高=2:1,如 0.5 表示宽：高=0.5:1=1:2，简单来说就是值大于 1 就会宽大于高，小于 1 就会宽小于高
                            childAspectRatio: 1.2,
                            //Cross 轴子组件的间隔，一行中第一个子组件左边不会添加间隔，最后一个子组件右边不会添加间隔，这一点很棒
                            crossAxisSpacing: 3,
                            //Main 轴（在 GridView 中通常是纵轴，即每一列）子组件间隔，也就是每一行之间的间隔，同样第一行的上边和最后一行的下边不会添加间隔
                            mainAxisSpacing: 3,
                          ),

                          cacheExtent: 0,

                          padding: EdgeInsets.all(5),

                          physics: new BouncingScrollPhysics(),
                          //Item 的顺序是否反转，若为 true 则反转，这个翻转只是行翻转，即第一行变成最后一行，但是每一行中的子组件还是从左往右摆放的
//      reverse: true,
                          //GirdView 的方向，为 Axis.vertical 表示纵向，为 Axis.horizontal 表示横向，横向的话 CrossAxis 和 MainAxis 表示的轴也会调换
                          scrollDirection: Axis.vertical,
                          children: _getVideoList(),
                        ),

//                        new ListView.builder(
//                          //ListView的Item
//                          itemCount: initData.length,
//                          itemBuilder: (BuildContext context, int index) {
//                            return GestureDetector(
//                              onTap: () {
//                                Navigator.push(context,
//                                    MaterialPageRoute(builder: (context) {
//                                  return VideoPlay(
//                                    initData: initData,
//                                    videoToken: initData[index].token,
//                                    Title: initData[index].name,
//                                  );
//                                }));
//                              },
//                              child: Container(
//                                height: 80.0,
//                                margin: EdgeInsets.only(left: 10, right: 10),
//                                child: Card(
//                                    elevation: 0.2,
//                                    child: Row(
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.start,
//                                      children: <Widget>[
//                                        //任务类型
//                                        Expanded(
//                                          child: Column(
//                                            children: <Widget>[
//                                              Expanded(
//                                                  child: Container(
//                                                child: Icon(
//                                                  Icons.videocam,
//                                                  size: 32,
//                                                  color: Color.fromRGBO(
//                                                      50, 89, 206, 1),
//                                                ),
//                                              )),
//                                            ],
//                                          ),
//                                          flex: 2,
//                                        ),
//                                        Expanded(
//                                          child: SingleChildScrollView(
//                                            child: Column(
//                                              crossAxisAlignment:
//                                                  CrossAxisAlignment.start,
//                                              children: <Widget>[
//                                                //  隐患信息
//                                                Row(children: <Widget>[
//                                                  Container(
//                                                    padding: EdgeInsets.only(
//                                                        left: 0, top: 8),
//                                                    child: Text(
//                                                      "${index + 1}.${initData[index].name}",
//                                                      style: new TextStyle(
//                                                          fontSize: 16.0,
//                                                          fontWeight:
//                                                              FontWeight.w500),
//                                                    ),
//                                                  ),
//                                                ]),
//                                                Row(
//                                                  children: <Widget>[
//                                                    Container(
//                                                      padding: EdgeInsets.only(
//                                                          left: 10, top: 6),
//                                                      child: Text(
//                                                        "${initData[index].text}",
//                                                        style: TextStyle(
//                                                            color: Colors.grey,
//                                                            fontSize: 14),
//                                                      ),
//                                                    ),
//                                                  ],
//                                                ),
//                                                Padding(
//                                                  padding:
//                                                      EdgeInsets.only(top: 10),
//                                                ),
//                                              ],
//                                            ),
//                                          ),
//                                          flex: 5,
//                                        ),
//
//                                        Expanded(
//                                          child: Container(
//                                              child: Icon(
//                                                Icons.keyboard_arrow_right,
//                                                color:
//                                                    GetConfig.getColor(theme),
//                                              ),
//                                              alignment: Alignment.centerRight),
//                                          flex: 1,
//                                        ),
//                                      ],
//                                    )),
//                              ),
//                            );
//                          },
//                        ),
                        onRefresh: () async {
                          await new Future.delayed(const Duration(seconds: 1),
                              () {
                            setState(() {
                              pageIndex = 0;
                            });
                            initData = [];
                            LoadData();
                          });
                        },
                        loadMore: () async {
                          await new Future.delayed(const Duration(seconds: 1),
                              () {
                            if (hasNext) {
                              setState(() {
                                pageIndex += 1;
                              });
                              LoadData();
                            }
                          });
                        },
                      ),
                    ],
                  ))
                ],
              )),
          inAsyncCall: isAnimating,
          // demo of some additional parameters
          opacity: 0.7,
          progressIndicator: CircularProgressIndicator(),
//        content: '加载中...',
        ),
        resizeToAvoidBottomPadding: false,
      ),
      onWillPop: () {
        Navigator.pop(context);
      },
    );
  }
}

//
//
//import 'package:flutter/material.dart';
//import 'package:intelligent_check_new/pages/VideoMonitor/video_play.dart';
//import 'package:intelligent_check_new/pages/navigation_keep_alive.dart';
//import 'package:intelligent_check_new/tools/GetConfig.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';
//
//
//class VideoMonitorList extends StatefulWidget {
//  @override
//  _VideoMonitorListState createState() => _VideoMonitorListState();
//}
//
//class _VideoMonitorListState extends State<VideoMonitorList>
//    with AutomaticKeepAliveClientMixin {
//  @override
//  bool get wantKeepAlive => true;
//  String theme = "";
//  bool isAnimating = false;
//
//  @override
//  void initState() {
//    super.initState();
////    initConfig();
//  }
//
//  void initConfig() async {}
//
//  void loadData() async {}
//
//  @override
//  // ignore: must_call_super
//  Widget build(BuildContext context) {
//    //获取统计数据
////    StatisticsPage.queryAuthCompanyLeaves();
//    return WillPopScope(
//      child: Scaffold(
//        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
//
//        appBar: AppBar(
//          title: Text(
//            '视频监控',
//            style: TextStyle(
//              color: Colors.black,
//              fontSize: 22,
//            ),
//          ),
//          leading: GestureDetector(
//            child: Icon(Icons.keyboard_arrow_left,color: GetConfig.getColor(theme==""?"blue":"red"),size: 32,),
//            onTap: (){
//              Navigator.of(context).pushAndRemoveUntil(
//                  new MaterialPageRoute(builder: (context) => NavigationKeepAlive()),
//                      (route) => route == null);
//            },
//          ),
//          centerTitle: true,
//          backgroundColor: Colors.white,
//          elevation: 0,
//        ),
//        body: ModalProgressHUD(
//          child: Container(
//              child: GridView(
//                //构造 GridView 的委托者，GridView.count 就相当于指定 gridDelegate 为 SliverGridDelegateWithFixedCrossAxisCount，
//                //GridView.extent 就相当于指定 gridDelegate 为 SliverGridDelegateWithMaxCrossAxisExtent，它们相当于对普通构造方法的一种封装
//                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                  //必传参数，Cross 轴（在 GridView 中通常是横轴，即每一行）子组件个数
//                  crossAxisCount: 2,
//                  //子组件宽高比，如 2 表示宽：高=2:1,如 0.5 表示宽：高=0.5:1=1:2，简单来说就是值大于 1 就会宽大于高，小于 1 就会宽小于高
//                  childAspectRatio: 0.75,
//                  //Cross 轴子组件的间隔，一行中第一个子组件左边不会添加间隔，最后一个子组件右边不会添加间隔，这一点很棒
//                  crossAxisSpacing: 3,
//                  //Main 轴（在 GridView 中通常是纵轴，即每一列）子组件间隔，也就是每一行之间的间隔，同样第一行的上边和最后一行的下边不会添加间隔
//                  mainAxisSpacing: 3,
//                ),
//
//                cacheExtent: 0,
//
//                padding: EdgeInsets.all(5),
//
//                physics: new BouncingScrollPhysics(),
//                //Item 的顺序是否反转，若为 true 则反转，这个翻转只是行翻转，即第一行变成最后一行，但是每一行中的子组件还是从左往右摆放的
////      reverse: true,
//                //GirdView 的方向，为 Axis.vertical 表示纵向，为 Axis.horizontal 表示横向，横向的话 CrossAxis 和 MainAxis 表示的轴也会调换
//                scrollDirection: Axis.vertical,
//                children: <Widget>[
//                  Container(
//                    child:GestureDetector(
//                      child:  Column(
//                        children: <Widget>[
//                          Container(
//                            child: Image.asset(
//                              "assets/images/scene1.png",
//                              height: MediaQuery.of(context).size.width / 2 - 10,
//                            ),
//                          ),
//                          Container(
//                            height:((((MediaQuery.of(context).size.width / 2 - 10)*100)/75)-  MediaQuery.of(context).size.width / 2 + 15).floorToDouble(),
//                            width: MediaQuery.of(context).size.width / 2 - 10,
//                            // height: MediaQuery.of(context).size.width/2 -10 ,
//                            child: Column(
//                              children: <Widget>[
//                                Container(
//                                  margin: EdgeInsets.only(left: 5),
//                                  alignment:Alignment.centerLeft,
//                                  child: Text("监控视频",
//
//                                      style: TextStyle(
//                                        fontSize: 14,
//                                        color: Colors.white,
//                                      )),
//                                ),
//                                Container(
//                                  margin: EdgeInsets.only(left:8),
//                                  alignment:Alignment.centerLeft,
//                                  child: Text(
//                                    "aaadakjdkasdhaaadakjdkasdhaaadakjdkasdhaaadakjdkasdh",
//                                    style: TextStyle(fontSize: 12, color: Colors.white),
//                                  ),
//                                ),
//                              ],
//                            ),
//                            color: Colors.black,
//                          )
//                        ],
//                      ),
//                      onTap: (){
//                        Navigator.push(context, new MaterialPageRoute(builder: (context){
//                          return VideoPlay();
//                        }));
//                      },
//                    ),
//                  ),
//                  Container(
//                    child: Column(
//                      children: <Widget>[
//                        Container(
//                            child: Image.asset(
//                              "assets/images/scene2.png",
//                              width: MediaQuery.of(context).size.width / 2 - 10,
//                            )),
//                        Container(
//                          height:((((MediaQuery.of(context).size.width / 2 - 10)*100)/75)-  MediaQuery.of(context).size.width / 2 + 15).floorToDouble(),
//                          width: MediaQuery.of(context).size.width / 2 - 10,
//                          // height: MediaQuery.of(context).size.width/2 -10 ,
//                          child: Column(
//                            children: <Widget>[
//                              Container(
//                                margin: EdgeInsets.only(left: 5),
//                                alignment:Alignment.centerLeft,
//                                child: Text("监控视频",
//
//                                    style: TextStyle(
//                                      fontSize: 14,
//                                      color: Colors.white,
//                                    )),
//                              ),
//                              Container(
//                                margin: EdgeInsets.only(left:8),
//                                alignment:Alignment.centerLeft,
//                                child: Text(
//                                  "aaadakjdkasdhaaadakjdkasdhaaadakjdkasdhaaadakjdkasdh",
//                                  style: TextStyle(fontSize: 12, color: Colors.white),
//                                ),
//                              ),
//                            ],
//                          ),
//                          color: Colors.black,
//                        )
//                      ],
//                    ),
//                  ),
//                  Container(
//                    child: Column(
//                      children: <Widget>[
//                        Container(
//                          child: Image.asset(
//                            "assets/images/scene1.png",
//                            width: MediaQuery.of(context).size.width / 2 - 10,
//                          ),
//                        ),
//                        Container(
//                          height:((((MediaQuery.of(context).size.width / 2 - 10)*100)/75)-  MediaQuery.of(context).size.width / 2 + 15).floorToDouble(),
//                          width: MediaQuery.of(context).size.width / 2 - 10,
//                          // height: MediaQuery.of(context).size.width/2 -10 ,
//                          child: Column(
//                            children: <Widget>[
//                              Container(
//                                margin: EdgeInsets.only(left: 5),
//                                alignment:Alignment.centerLeft,
//                                child: Text("监控视频",
//
//                                    style: TextStyle(
//                                      fontSize: 14,
//                                      color: Colors.white,
//                                    )),
//                              ),
//                              Container(
//                                margin: EdgeInsets.only(left:8),
//                                alignment:Alignment.centerLeft,
//                                child: Text(
//                                  "aaadakjdkasdhaaadakjdkasdhaaadakjdkasdhaaadakjdkasdh",
//                                  style: TextStyle(fontSize: 12, color: Colors.white),
//                                ),
//                              ),
//                            ],
//                          ),
//                          color: Colors.black,
//                        )
//                      ],
//                    ),
//                  ),
//                  Container(
//                    child: Column(
//                      children: <Widget>[
//                        Container(
//                          child: Image.asset(
//                            "assets/images/scene2.png",
//                            width: MediaQuery.of(context).size.width / 2 - 10,
//                          ),
//                        ),
//                        Container(
//                          height:((((MediaQuery.of(context).size.width / 2 - 10)*100)/75)-  MediaQuery.of(context).size.width / 2 + 15).floorToDouble(),
//                          width: MediaQuery.of(context).size.width / 2 - 10,
//                          // height: MediaQuery.of(context).size.width/2 -10 ,
//                          child: Column(
//                            children: <Widget>[
//                              Container(
//                                margin: EdgeInsets.only(left: 5),
//                                alignment:Alignment.centerLeft,
//                                child: Text("监控视频",
//
//                                    style: TextStyle(
//                                      fontSize: 14,
//                                      color: Colors.white,
//                                    )),
//                              ),
//                              Container(
//                                margin: EdgeInsets.only(left:8),
//                                alignment:Alignment.centerLeft,
//                                child: Text(
//                                  "aaadakjdkasdhaaadakjdkasdhaaadakjdkasdhaaadakjdkasdh",
//                                  style: TextStyle(fontSize: 12, color: Colors.white),
//                                ),
//                              ),
//                            ],
//                          ),
//                          color: Colors.black,
//                        )
//                      ],
//                    ),
//                  ),
//                  Container(
//                    child: Column(
//                      children: <Widget>[
//                        Container(
//                          child: Image.asset(
//                            "assets/images/scene2.png",
//                            width: MediaQuery.of(context).size.width / 2 - 10,
//                          ),
//                        ),
//                        Container(
//                          height:((((MediaQuery.of(context).size.width / 2 - 10)*100)/75)-  MediaQuery.of(context).size.width / 2 + 15).floorToDouble(),
//                          width: MediaQuery.of(context).size.width / 2 - 10,
//                          // height: MediaQuery.of(context).size.width/2 -10 ,
//                          child: Column(
//                            children: <Widget>[
//                              Container(
//                                margin: EdgeInsets.only(left: 5),
//                                alignment:Alignment.centerLeft,
//                                child: Text("监控视频",
//
//                                    style: TextStyle(
//                                      fontSize: 14,
//                                      color: Colors.white,
//                                    )),
//                              ),
//                              Container(
//                                margin: EdgeInsets.only(left:8),
//                                alignment:Alignment.centerLeft,
//                                child: Text(
//                                  "aaadakjdkasdhaaadakjdkasdhaaadakjdkasdhaaadakjdkasdh",
//                                  style: TextStyle(fontSize: 12, color: Colors.white),
//                                ),
//                              ),
//                            ],
//                          ),
//                          color: Colors.black,
//                        )
//                      ],
//                    ),
//                  ),
//                  Container(
//                    child: Column(
//                      children: <Widget>[
//                        Container(
//                          child: Image.asset(
//                            "assets/images/scene1.png",
//                            width: MediaQuery.of(context).size.width / 2 - 10,
//                          ),
//                        ),
//                        Container(
//                          height:((((MediaQuery.of(context).size.width / 2 - 10)*100)/75)-  MediaQuery.of(context).size.width / 2 + 15).floorToDouble(),
//                          width: MediaQuery.of(context).size.width / 2 - 10,
//                          // height: MediaQuery.of(context).size.width/2 -10 ,
//                          child: Column(
//                            children: <Widget>[
//                              Container(
//                                margin: EdgeInsets.only(left: 5),
//                                alignment:Alignment.centerLeft,
//                                child: Text("监控视频",
//
//                                    style: TextStyle(
//                                      fontSize: 14,
//                                      color: Colors.white,
//                                    )),
//                              ),
//                              Container(
//                                margin: EdgeInsets.only(left:8),
//                                alignment:Alignment.centerLeft,
//                                child: Text(
//                                  "aaadakjdkasdhaaadakjdkasdhaaadakjdkasdhaaadakjdkasdh",
//                                  style: TextStyle(fontSize: 12, color: Colors.white),
//                                ),
//                              ),
//                            ],
//                          ),
//                          color: Colors.black,
//                        )
//                      ],
//                    ),
//                  ),
//                  Container(
//                    child: Column(
//                      children: <Widget>[
//                        Container(
//                          child: Image.asset(
//                            "assets/images/scene1.png",
//                            width: MediaQuery.of(context).size.width / 2 - 10,
//                          ),
//                        ),
//                        Container(
//                          height:((((MediaQuery.of(context).size.width / 2 - 10)*100)/75)-  MediaQuery.of(context).size.width / 2 + 15).floorToDouble(),
//                          width: MediaQuery.of(context).size.width / 2 - 10,
//                          // height: MediaQuery.of(context).size.width/2 -10 ,
//                          child: Column(
//                            children: <Widget>[
//                              Container(
//                                margin: EdgeInsets.only(left: 5),
//                                alignment:Alignment.centerLeft,
//                                child: Text("监控视频",
//
//                                    style: TextStyle(
//                                      fontSize: 14,
//                                      color: Colors.white,
//                                    )),
//                              ),
//                              Container(
//                                margin: EdgeInsets.only(left:8),
//                                alignment:Alignment.centerLeft,
//                                child: Text(
//                                  "aaadakjdkasdhaaadakjdkasdhaaadakjdkasdhaaadakjdkasdh",
//                                  style: TextStyle(fontSize: 12, color: Colors.white),
//                                ),
//                              ),
//                            ],
//                          ),
//                          color: Colors.black,
//                        )
//                      ],
//                    ),
//                  ),
//                  Container(
//                    child: Column(
//                      children: <Widget>[
//                        Container(
//                          child: Image.asset(
//                            "assets/images/scene2.png",
//                            width: MediaQuery.of(context).size.width / 2 - 10,
//                          ),
//                        ),
//                        Container(
//                          height:((((MediaQuery.of(context).size.width / 2 - 10)*100)/75)-  MediaQuery.of(context).size.width / 2 + 15).floorToDouble(),
//                          width: MediaQuery.of(context).size.width / 2 - 10,
//                          // height: MediaQuery.of(context).size.width/2 -10 ,
//                          child: Column(
//                            children: <Widget>[
//                              Container(
//                                margin: EdgeInsets.only(left: 5),
//                                alignment:Alignment.centerLeft,
//                                child: Text("监控视频",
//
//                                    style: TextStyle(
//                                      fontSize: 14,
//                                      color: Colors.white,
//                                    )),
//                              ),
//                              Container(
//                                margin: EdgeInsets.only(left:8),
//                                alignment:Alignment.centerLeft,
//                                child: Text(
//                                  "aaadakjdkasdhaaadakjdkasdhaaadakjdkasdhaaadakjdkasdh",
//                                  style: TextStyle(fontSize: 12, color: Colors.white),
//                                ),
//                              ),
//                            ],
//                          ),
//                          color: Colors.black,
//                        )
//                      ],
//                    ),
//                  ),
//                ],
//              )),
//          inAsyncCall: isAnimating,
//          // demo of some additional parameters
//          opacity: 0.7,
//          progressIndicator: CircularProgressIndicator(),
//        ),
//      ),
//      onWillPop: (){
//        Navigator.pop(context);
//      },
//    ) ;
//
//  }
//}
//
