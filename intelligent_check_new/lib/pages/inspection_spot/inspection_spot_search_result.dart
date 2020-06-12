import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckPoint.dart';
import 'package:intelligent_check_new/pages/inspection_spot/inspection_spot_detail.dart';
import 'package:intelligent_check_new/services/check_point_service.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InspectionSpotSearchResultPage extends StatefulWidget{

  final String searchText;
  InspectionSpotSearchResultPage(this.searchText);

  @override
  State<StatefulWidget> createState() => new _InspectionSpotSearchResultPageState();
}

class _InspectionSpotSearchResultPageState extends State<InspectionSpotSearchResultPage>{

  FocusNode _focusNode = new FocusNode();

  String theme="blue";
  // 根据线路查询点列表数据
  List<QueryPoint> pointList = List();
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  // 当前页码
  int pageIndex = 0;

  // 每页条数
  int pageSize=10;

  // 是否有下一页
  bool hasNext = false;

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    }).then((data){
      loadData();
    });
  }
  void loadData() async{

    // 根据routeid，查询点列表
    await queryPointPages( this.pageIndex, this.pageSize,keywords: this.widget.searchText).then((data) {
      setState(() {
        for (dynamic p in data.content) {
          pointList.add(QueryPoint.fromJson(p));
        }
        // 是否有下一页
        hasNext = !data.last;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if (null == pointList || pointList.length <= 0) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(240, 243, 245, 1),
        appBar: AppBar(
            elevation: 0.2,
            brightness: Brightness.light,
            backgroundColor:  Color(0xFFFFFFFF),
            leading:new Container(
              child: GestureDetector(
                onTap: () {
                  _focusNode.unfocus();
                  Navigator.pop(context);
                },
                child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
              ),
            ),
            title:InkWell(
              child: Container(
                height: 30,
                padding: EdgeInsets.only(top: 7,bottom: 6),
                decoration: new BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0,left: 10.0,top: 2),
                      child: Image.asset("assets/images/search_$theme.png",width: 14,color: Color(0xFF999999)),
                    ),
                    Text(this.widget.searchText, style: TextStyle(fontSize: 14.0,color: Color(0xFF999999))),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            )
        ),

        body:Container(),
        resizeToAvoidBottomPadding: false,
      );
    }
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 243, 245, 1),
          appBar: AppBar(
            elevation: 0.2,
            brightness: Brightness.light,
            backgroundColor:  Color(0xFFFFFFFF),
            leading:new Container(
              child: GestureDetector(
                onTap: () {
                  _focusNode.unfocus();
                  Navigator.pop(context);
                },
                child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
              ),
            ),
            title:InkWell(
              child: Container(
                height: 30,
                padding: EdgeInsets.only(top: 7,bottom: 6),
                decoration: new BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0,left: 10.0,top: 2),
                      child: Image.asset("assets/images/search_"+theme+".png",width: 14,color: Color(0xFF999999)),
                    ),
                    Text(this.widget.searchText, style: TextStyle(fontSize: 14.0,color: Color(0xFF999999))),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ),

        body:Container(
          color: Color.fromRGBO(242, 246, 249, 1),
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
//            itemCount: pointList.length,
              itemCount:pointList.length,
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
                                "${(index + 1).toString()}.${pointList[index].name??"--"}",
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
                                      flex: 4,
                                      child:  Text(
                                        "编号：" +
                                            pointList[index].pointNo,
                                        style: new TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child:  Text(
                                        "等级：${pointList[index].pointLevel??"--"}",
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
//                pointList = [];
                });
//              loadData();
              });
            },
            loadMore: () async {
              await new Future.delayed(
                  const Duration(seconds: 1), () {
                if (hasNext) {
                  setState(() {
                    pageIndex = pageIndex + 1;
                  });
//                loadData();
                }
              });
            },
          ),
        ),
      resizeToAvoidBottomPadding: false,
    );
  }

  @override
  void initState() {
    super.initState();
    initConfig();
  }
}