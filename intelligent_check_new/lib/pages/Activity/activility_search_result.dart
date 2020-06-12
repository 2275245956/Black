import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityModel.dart';
import 'package:intelligent_check_new/pages/Activity/activility_check&acceptance.dart';
import 'package:intelligent_check_new/pages/Activity/activility_company_review.dart';
import 'package:intelligent_check_new/pages/Activity/activility_department_review.dart';
import 'package:intelligent_check_new/pages/Activity/activility_finished_detail.dart';
import 'package:intelligent_check_new/pages/Activity/activility_ready2run.dart';
import 'package:intelligent_check_new/pages/Activity/activility_team_review.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/services/Activility_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/constants/color.dart';

class ActivilitySearchSearchResultPage extends StatefulWidget{

  final String searchText;

  ActivilitySearchSearchResultPage(this.searchText);

  @override
  State<StatefulWidget> createState() => new _ActivilitySearchSearchResultPage();
}

class _ActivilitySearchSearchResultPage extends State<ActivilitySearchSearchResultPage>{


  @override
  bool get wantKeepAlive => true;

  bool isAnimating = false;

  String myUserId;

  List<ActiviList> initData = List();

  ///初始化查询条件
  int pageNumber = 0;
  int pageSize = 10;
  int canExecuteType = 0;
  int status = 0;
  int level = 0;
  String taskworkName = "";


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

      loadData();
    });
  }
  void loadData() async {
    await getActivilityList(this.pageNumber, this.pageSize, this.canExecuteType,
        this.status, this.level, this.widget.searchText)
        .then((data) {
      setState(() {
        if (data.content != null && data.content.length > 0) {
          for (dynamic p in data.content) {
            this.initData.add(new ActiviList.fromJson(p));
          }
          hasNext = !data.last;
        } else {
          if (data.message != null) {
            HiddenDangerFound.popUpMsg(data.message);
          }
        }
        isAnimating = false;
      });
    });
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
                color: Color.fromRGBO(242, 246, 249, 1),
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
        child: new ListView.builder(
          //ListView的Item
          itemCount: initData == null ? 0 : initData.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) {
                      switch (initData[index].taskworkState) {
                        case 1://未启动
//                                        return ActivilityTeamReview(
//                                            initData[index].id);
                          break;
                        case 2://待班组审核
                          return ActivilityTeamReview(
                              initData[index].id);
                        case 3://待车间部门审核
                          return ActivilityDepartmentReview(
                              initData[index].id);
                          break;
                        case 4://待公司审核
                          return  ActivilityCompanyReview (
                              initData[index].id);
                        case 5://待执行
                          return ActivilityReady2Run (
                              initData[index].id);
                          break;
                        case 6://待确认验收
                          return ActivilityCheckAndAcceptance (initData[index].id);
                          break;
                        case 7://完成
                          return ActivilityFinishDetail (
                              initData[index].id);
                          break;
                        default:
                          return ActivilityFinishDetail(initData[index].id);
                          break;
                      }
                      // return new PlanListContent(initData[index].planTaskId);
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
                height: 110.0,
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
                                      child: Container(
                                        padding:
                                        EdgeInsets.only(
                                            left: 15,
                                            top: 6),
                                        child: Text(
                                          ("等级：" +
                                              initData[index]
                                                  .levelDesc),
                                          style: TextStyle(
                                              color:
                                              Colors.grey,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding:
                                        EdgeInsets.only(
                                            left: 10,
                                            top: 6),
                                        child: Text(
                                          ("状态：" +
                                              initData[index]
                                                  .taskworkStateDesc),
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
                                      child: Text("所属部门/车间：",
                                          style: TextStyle(
                                              color:
                                              Colors.grey,
                                              fontSize: 14)),
                                    ),
                                    Container(
                                      child: Text(
                                          initData[index]
                                              .belongDepartmentAndGroupName,
                                          style: TextStyle(
                                              color:
                                              Colors.grey,
                                              fontSize: 14)),
                                    )
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
      resizeToAvoidBottomPadding: false,
    );
  }

  @override
  void initState() {
    super.initState();
    initConfig();
  }
}