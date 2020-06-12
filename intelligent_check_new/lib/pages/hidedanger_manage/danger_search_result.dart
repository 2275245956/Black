import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_check.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_procedded_hasChecked.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_processed_details_rescinded.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_rectification.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_review.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidedanger_pending.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/services/HiddenDanger.dart';
import 'package:intelligent_check_new/model/Hidden_Danger/hidden_danger_model.dart';



class HiddenSearchSearchResultPage extends StatefulWidget{

  final String searchText;
  final bool isHandle;
  HiddenSearchSearchResultPage(this.searchText,this.isHandle);

  @override
  State<StatefulWidget> createState() => new _HiddenSearchSearchResultPage();
}

class _HiddenSearchSearchResultPage extends State<HiddenSearchSearchResultPage>{


  @override
  bool get wantKeepAlive => true;

  bool isAnimating = false;

  String myUserId;

  List<HiddenDangerModel> initData = List();

  HiddenDangerFilter modelfilter = new HiddenDangerFilter();

  String theme="";
  FocusNode _focusNode = new FocusNode();
  // 当前页码
  int pageIndex=0;
  // 是否有下一页
  bool hasNext=false;
  // 分页所需控件
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();



  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    }).then((data){
      modelfilter.dangerName=this.widget.searchText;
      modelfilter.pageSize=10;
      modelfilter.pageIndex=0;
      modelfilter.belongType=0;
      modelfilter.dangerState=0;
      modelfilter.dangerLevel=0;
      modelfilter.isHandle=this.widget.isHandle;
      loadData();
    });
  }
  void loadData () async{
    setState(() {
      isAnimating = true;
    });
    await getHiddenDangerByLikeName(modelfilter).then((data){
      setState(() {
        if(data != null && data.content.length>0){
          for(dynamic p in data.content){
            print(p);
            initData.add(HiddenDangerModel.fromParams(
                dangerId: p["dangerId"],
                level: p["level"],
                dangerName: p["dangerName"],
                discovererUserName: p["discovererUserName"],
                stateDesc: p["stateDesc"],
                limitDesc: p["limitDesc"],
                state: p["state"],
                levelDesc: p["levelDesc"]
            ));
          }
          hasNext = !data.last;
        }
        isAnimating = false;
      });
    });
  }
  Color getLevelTextBgColor(int level)
  {
    if(level==1)
      return Colors.orange;
    if(level==2)
      return Colors.red;
    return Colors.black;
  }


  @override
  Widget build(BuildContext context) {
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
//      ),
      body:EasyRefresh(
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
          itemCount: initData.length,
          itemBuilder: (BuildContext context, int index) {
            return  GestureDetector(
              onTap: (){

                Navigator.push( context,
                    new MaterialPageRoute(builder: (context) {
                      switch (initData[index].state) {
                        case 1: //待评审

                          return new HiddenDangerReview(initData[index].dangerId,state: initData[index].state,);
                          break;
                        case 2: //待治理
                          return new HiddenDangerRectification( initData[index].dangerId,state: initData[index].state);                                         break;
                        case 3: //安措计划中
                          return new HiddenDangerProcessedDetailsRescinded(initData[index].dangerId,state: initData[index].state);
                          break;
                        case 4:
                        //待验证
                          return new HiddenDangerProcessedDetailsChecked(initData[index].dangerId,state: initData[index].state);                                        break;
                        case 5: //治理完毕
                          return new HiddenDangerProcessedCheckedDetail(initData[index].dangerId,);
                          break;
                        case 6: //已撤销
                          return new HiddenDangerProcessedDetailsRescinded( initData[index].dangerId);
                          break;
                        default:
                          return new HiddenDangerProcessedDetailsRescinded(
                              initData[index].dangerId);
                          break;
                      }

                    })).then((v){
                  pageIndex = 0;
                  initData = [];
                  loadData();
                });
              },
              child: Container(
                height: 130.0,
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Card(
                    elevation:0.2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  alignment: Alignment
                                      .bottomCenter,
                                  child:Image.asset(PendingHideDanger.getDangerStateIcon(initData[index].state),height: 30,) ,),
                              ),
                              Expanded(
                                child: Container(
                                    alignment:
                                    Alignment.topCenter,
                                    child: Text(
                                      initData[index].stateDesc,
                                      style: TextStyle(
                                          color:Color.fromRGBO(154,154,154, 1)),
                                    )),
                              ),
                            ],
                          ),
                          flex: 2,
                        ),
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
                                        left: 0, top: 8),
                                    child: Text(
                                      initData[index]
                                          .dangerName ??
                                          "",
                                      style: new TextStyle(
                                          fontSize: 16.0,
                                          fontWeight:
                                          FontWeight
                                              .w500),
                                    ),
                                  ),
                                ]),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding:
                                      EdgeInsets.only(
                                          left: 10,
                                          top: 6),
                                      child: Text(
                                        "发现人：" +
                                            initData[index]
                                                .discovererUserName,
                                        style: TextStyle(
                                            color:
                                            Colors.grey,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding:
                                      EdgeInsets.only(
                                          left: 10,
                                          top: 5),
                                      child: Text("隐患等级：",
                                          style: TextStyle(
                                              color:
                                              Colors.grey,
                                              fontSize: 14)),
                                    ),
                                    Container(
                                      child: Text(
                                          initData[index]
                                              .levelDesc,
                                          style: TextStyle(
                                              color: getLevelTextBgColor(
                                                  initData[index] .level),
                                              fontSize: 14)),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                        padding:
                                        EdgeInsets.only(
                                            left: 10,
                                            top: 5),
                                        child:  Text("治理期限：",style: TextStyle(color:Colors.grey,fontSize:14))),

                                    Container(
                                        padding:
                                        EdgeInsets.only(
                                            left: 0,
                                            top: 5),
                                        child: Text(initData[index].limitDesc,
                                            style: TextStyle( color:initData[index].overtimeState==1?Colors.red:Colors.grey,fontSize:14))),
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
                    )
                ),
              ),
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
      resizeToAvoidBottomPadding: false,
    );
  }

  @override
  void initState() {
    super.initState();
    initConfig();
  }
}