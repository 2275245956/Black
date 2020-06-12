import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/offline/offline_plan_list_output.dart';
import 'package:intelligent_check_new/pages/offline/CheckExecute/checkexec_spot_detail.dart';
import 'package:intelligent_check_new/services/offline/dbAccess.dart';
import 'package:intelligent_check_new/services/offline/offline_plan_inspection_services.dart';
import 'package:sqflite/sqlite_api.dart';

class OfflineInspectionSpotScreen extends StatefulWidget {
  @override
  _OfflineInspectionSpotScreenState createState() => _OfflineInspectionSpotScreenState();
}

class _OfflineInspectionSpotScreenState extends State<OfflineInspectionSpotScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 根据线路查询点列表数据
  List<Point> pointList = List();

  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }


  void loadData() async {
    setState(() {
      isAnimating = true;
    });
    Database db = await dbAccess().openDb();
    // 从本地数据库查询点信息
    List<Map<String, dynamic>> lst = await dbAccess().getPoints(db);

    await dbAccess().closeDb(db);

    // 转换数据
    await getOfflinePointList(lst).then((data){
      setState(() {
        this.pointList = data;
        isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (null == pointList || pointList.length == 0) {
      return Scaffold(
          appBar: AppBar(
        title: Text(
          "巡检点",
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
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "巡检点",
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
      ),
      body: _getWidget(),
    );
  }

  Widget _getWidget() {
    return new Padding(
        padding: new EdgeInsets.only(top: 5.0),
        child: new Stack(children: <Widget>[
          new Column(
            children: <Widget>[
              new Expanded(child: new Container(
                child: GestureDetector(
                  child: Center(
                    child:
                    new ListView.builder(
                      //ListView的Item
                      itemCount: pointList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
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
                                          pointList[index].pointNO,
                                      style: new TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                                trailing: new Padding(
                                  child: new Icon(
                                      Icons.keyboard_arrow_right),
                                  padding: EdgeInsets.only(top: 15),
                                ),
                                onTap: () {
                                  Navigator.push(context,
                                      new MaterialPageRoute(
                                          builder: (context) {
                                            return new OfflineCheckExecSpotDetail(
                                                pointList[index]);
                                          }));
                                }));
                      },
                    ),
                  ),
                ),
              ))
            ],
          ),
        ]));
  }

  ScrollController scrollController = new ScrollController();
  GlobalKey globalKey2 = new GlobalKey();

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
}
