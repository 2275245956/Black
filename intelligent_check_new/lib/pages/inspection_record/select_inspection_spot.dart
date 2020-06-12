import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckPoint.dart';
import 'package:intelligent_check_new/model/name_value.dart';
import 'package:intelligent_check_new/pages/plan_inspection/select_route.dart';
import 'package:intelligent_check_new/services/check_point_service.dart';
import 'package:intelligent_check_new/services/route_list_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectInspectionSpot extends StatefulWidget {
  @override
  _SelectInspectionSpotState createState() => _SelectInspectionSpotState();
}

class _SelectInspectionSpotState extends State<SelectInspectionSpot>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 线路数据
  List<NameValue> routeList = List();

  // 当前选择的线路数据
  NameValue selectRoute;

  // 根据线路查询点列表数据
  List<CheckPoint> pointList = List();

  bool isAnimating = false;

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
        routeList = data;
        if(null != data && data.length > 0){
          selectRoute = data[0];
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
    await queryPointPage(this.selectRoute.value, this.pageIndex, this.pageSize).then((data) {
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
    if (null == routeList || routeList.length == 0) {
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
            child: Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
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
            child: Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
          ),
        ),
      ),
      body: ModalProgressHUD(
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 50,
                    child: Text(selectRoute.name),
                    padding: EdgeInsets.only(right: 10,left: 10),
                    alignment: Alignment.center,
                  ),
                  Container(
                      height: 50,
                    child: Icon(Icons.chevron_right,color: GetConfig.getColor(theme),),
                    alignment: Alignment.centerRight
                  ),
                ],
              ),
              onTap: (){
                Navigator.push( context,
                    new MaterialPageRoute(builder: (context) {
                      return SelectRoutePage();
                    })).then((value){
                  if(value != null){
                    setState(() {
                      selectRoute = value;
                      loadData();
                    });
                  }
                });
              },
            ),
            Expanded(
              child: _getWidget(),flex:1,
            )
          ],
        ),
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }

  Widget _getWidget() {
    return EasyRefresh(
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
                            pointList[index].pointNo,
                        style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey),
                      ),
                    ],
                  ),
//                  trailing: new Padding(
//                    child: new Icon(
//                        Icons.keyboard_arrow_right),
//                    padding: EdgeInsets.only(top: 15),
//                  ),
                  onTap: () {
                    print(pointList[index].name);
                    print(pointList[index].id);
                    Navigator.pop(context,NameValue(pointList[index].name,pointList[index].id));
                  })
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
    );
  }
}
