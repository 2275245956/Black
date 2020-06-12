import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckPoint.dart';
import 'package:intelligent_check_new/pages/move_inspection/move_point_search.dart';
import 'package:intelligent_check_new/pages/move_inspection/move_spot_add.dart';
import 'package:intelligent_check_new/pages/CheckExecute/navigation_checkexec.dart';
import 'package:intelligent_check_new/services/move_inspection.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoveSpotListScreen extends StatefulWidget {
  @override
  _MoveSpotListScreenState createState() => _MoveSpotListScreenState();
}

class _MoveSpotListScreenState extends State<MoveSpotListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isAnimating = false;

  List<CheckPoint> initData = List();

  int pageIndex = 0;
  bool hasNext = false;

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  String theme="";

  @override
  Widget build(BuildContext context) {
    if(this.theme.isEmpty){
      return Scaffold(
          body:Text("")
      );
    }
    /*if (null == initData || initData.length == 0) {
      return Scaffold(
          backgroundColor: Color.fromRGBO(242, 246, 249, 1),
          appBar: AppBar(
        title: Text(
          "安全执行",
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        centerTitle: true,
        elevation: 0.7,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              child: Image.asset("assets/images/search_"+theme+".png",width: 22,),
              padding: EdgeInsets.only(right: 5),
            ),
            onTap: (){

            },
          ),
          IconButton(
            icon: Icon(
              Icons.note_add,
              color:   GetConfig.getColor(theme),
            ),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return new MoveSpotAdd();
              }));
            },
          )
        ],
      ));
    }*/

    return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: AppBar(
          title: Text(
            "安全执行",
            style: TextStyle(color: Colors.black, fontSize: 19),
          ),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child:
                  Icon(Icons.keyboard_arrow_left, color:   GetConfig.getColor(theme), size: 32),
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              child: Container(
                child: Image.asset("assets/images/search_"+theme+".png",width: 22,),
                padding: EdgeInsets.only(right: 5),
              ),
              onTap: (){
                Navigator.push( context,
                    new MaterialPageRoute(builder: (context) {
                      return MovePointSearch();
                    }));
              },
            ),
            Padding(padding: EdgeInsets.only(right: 10),),
            GestureDetector(
              child: Container(
                child: Image.asset("assets/images/icons/menu_add_"+theme+".png",width: 22,),
                padding: EdgeInsets.only(right: 5),
              ),
              onTap: (){
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) {
                  return new MoveSpotAdd();
                })).then((result) {
                  if (null != result && result) {
                    setState(() {
                      pageIndex = 0;
                      initData = [];
                    });
                    getData();
                  }
                });
              },
            ),
            Padding(padding: EdgeInsets.only(right: 6),)
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: isAnimating,
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
            child: new ListView.builder(
              padding: EdgeInsets.only(top: 4),
              //ListView的Item
              itemCount: initData.length,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                    height: 72,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                        elevation:0.2,
                        child: new ListTile(
                            isThreeLine: true,
                            dense: false,
                            subtitle: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  (index + 1).toString() +
                                      "." +
                                      initData[index].name,
                                  style: new TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                ),
                                Text(
                                  "编号:" + initData[index].pointNo,
                                  style: new TextStyle(
                                      fontSize: 14.0, color: Colors.grey),
                                ),
                              ],
                            ),
                            trailing: new Icon(Icons.keyboard_arrow_right,color:   GetConfig.getColor(theme),),
                            onTap: () {
                              Navigator.push(context,
                                  new MaterialPageRoute(builder: (context) {
                                return new NavigationCheckExec(
                                    initData[index].id,pointName:initData[index].name);
                              }));
                            })));
              },
            ),
            onRefresh: () async {
              await new Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  pageIndex = 0;
                  initData = [];
                });
                getData();
              });
            },
            loadMore: () async {
              await new Future.delayed(const Duration(seconds: 1), () {
                if (hasNext) {
                  setState(() {
                    pageIndex = pageIndex + 1;
                  });
                  getData();
                }
              });
            },
          ),
          // demo of some additional parameters
          opacity: 0.2,
          progressIndicator: CircularProgressIndicator(),
        ));
  }

  @override
  initState() {
    super.initState();
    getData();
    initConfig();
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  getData() async {
    setState(() {
      isAnimating = true;
    });
    await getMoveInspectionList(this.pageIndex).then((data) {
      setState(() {
        if (null != data) {
          for (var p in data.content) {
            initData.add(CheckPoint.fromJson(p));
          }
        }
        isAnimating = false;
        hasNext = !data.last;
      });
    });
  }
}
