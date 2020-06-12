import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/common/JunCommon.dart';
import 'package:intelligent_check_new/model/CheckPoint.dart';
import 'package:intelligent_check_new/model/offline/offline_plan_list_output.dart';
import 'package:intelligent_check_new/pages/move_inspection/move_spot_add.dart';
import 'package:intelligent_check_new/pages/offline/CheckExecute/checkexec_inspection.dart';
import 'package:intelligent_check_new/services/offline/dbAccess.dart';
import 'package:intelligent_check_new/services/offline/offline_point_services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class OfflineMoveSpotListScreen extends StatefulWidget {
  @override
  _OfflineMoveSpotListScreenState createState() => _OfflineMoveSpotListScreenState();
}

class _OfflineMoveSpotListScreenState extends State<OfflineMoveSpotListScreen>
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

  @override
  Widget build(BuildContext context) {
    if (null == initData || initData.length == 0) {
      return Scaffold(
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
            child: Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.red,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.note_add,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return new MoveSpotAdd();
              }));
            },
          )
        ],
      ));
    }

    return Scaffold(
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
              child:
                  Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
            ),
          ),
        ),
        body: ModalProgressHUD(
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
              //ListView的Item
              itemCount: initData.length,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                    height: 80.0,
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
                            trailing: new Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              preExecute(initData[index].offlinePoint);
                            })
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
          inAsyncCall: isAnimating,
          // demo of some additional parameters
          opacity: 0.7,
          progressIndicator: CircularProgressIndicator(),
        ));
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  preExecute(Point offlinePoint) async {
    /*Database db = await dbAccess().openDb();
    List<Map<String, dynamic>> checks = await dbAccess().getCheckRecords(db);
    for(var ckdItem in checks) {
      var itemJson = json.decode(ckdItem['recordJson'].toString());
      var didPointNo = itemJson["pointNo"].toString();
      if (didPointNo == offlinePoint.pointNO) {
        Fluttertoast.showToast(
          msg: '该巡检点已经进行过巡检！',
          toastLength: Toast.LENGTH_SHORT,
        );
        return;
      }
    }*/
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) {
          return new CheckExecInspection(offlinePoint,null);
        })
    );
  }

  getData() async {
    setState(() {
      isAnimating = true;
    });
    List<dynamic> params = new List();
    params.add("0");
    List<Map<String, dynamic>> lst =
    await dbAccess().queryData("select * from Point where isFiexed=?;",params);
    setState(() {
      for(var p in lst){
        CheckPoint checkPoint  = CheckPoint.fromParams();
        checkPoint.id = JunMath.parseInt(p["pointId"].toString());
        checkPoint.name = p["pointName"];
        checkPoint.pointNo = p["pointNo"];
        checkPoint.offlinePoint =getOfflinePointFromJson(p);
        initData.add(checkPoint);
      }
      isAnimating = false;
      hasNext = false;
    });
  }
}
