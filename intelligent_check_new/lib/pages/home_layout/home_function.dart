import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_custom_bottom_tab_bar/eachtab.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CompanyInfo.dart';
import 'package:intelligent_check_new/model/UserAuthModel.dart';
import 'package:intelligent_check_new/model/home_function_model.dart';
import 'package:intelligent_check_new/pages/Activity/activility_list.dart';
import 'package:intelligent_check_new/pages/SelCompanyAndDept.dart';
import 'package:intelligent_check_new/pages/VideoMonitor/video_monitor_list.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_processed.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidedanger_pending.dart';
import 'package:intelligent_check_new/pages/inspection_record/record_list_screen.dart';
import 'package:intelligent_check_new/pages/inspection_spot/inspection_spot_screen.dart';
import 'package:intelligent_check_new/pages/message/message_list.dart';
import 'package:intelligent_check_new/pages/no_plan_inspection/no_plan_inspection.dart';
import 'package:intelligent_check_new/pages/offline/inspection_spot/offline_inspection_spot_screen.dart';
import 'package:intelligent_check_new/pages/offline/no_plan_inspection/no_plan_inspection.dart';
import 'package:intelligent_check_new/pages/offline/plan_inspection/offline_plan_list_screen.dart';
import 'package:intelligent_check_new/pages/plan_inspection/plan_list_screen.dart';
import 'package:intelligent_check_new/pages/risk_spot/risk_spot_screen.dart';
import 'package:intelligent_check_new/pages/security_risk_judgment/security_risk_judgment_list.dart';
import 'package:intelligent_check_new/pages/task_calendar/calendar_main.dart';
import 'package:intelligent_check_new/services/company_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/tools/MessageBox.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeFunction extends StatefulWidget {
  List<CompanyInfo> cqDatas;

  HomeFunction({this.cqDatas});

  @override
  State<StatefulWidget> createState() => new _HomeFunctionState();
}

class _HomeFunctionState extends State<HomeFunction> {
  List<HomeFunctionModel> firstMenu = List();
  List<HomeFunctionModel> secondMenu = List();
  CompanyInfo cqSelect; //公司选择
  List<CompanyInfo> _cqDatas = new List();

  int _unReadCount = 0;

  UserShowAuth auth;
  bool isAnimating = false;
  bool isOffline = false;
  String theme = ""; //主题
  String workLogoChTitle = "";
  String workLogoEnTitle = "";
  String workLogo = "";

  String companyName = "";

  @override
  void initState() {
    super.initState();

    if (!mounted) {
      return;
    }

    //getTaskCount();
    getUnreadCountMessage();
//    getHaveToDo();
    initFunction();

    setState(() {
//      this._cqDatas = this.widget.cqDatas;
//      if (this._cqDatas != null) cqSelect = _cqDatas[0];
      SharedPreferences.getInstance().then((sp) {
        companyName =
        (sp.getString("sel_com") == null || sp.getString("sel_com") == "")
            ? "--"
            : json.decode(sp.getString("sel_com"))["companyName"];
        List<String> needDo = sp.getStringList("userHaveToDo") ?? List();
        var showAuthJson = sp.getString("user_show");
        if (showAuthJson != "" && showAuthJson != null) {
          //拿到工作台下的功能模块权限
          this.auth = new UserShowAuth.fromJson(json.decode(showAuthJson)).children.firstWhere((f)=>f.frontComponent=="operatingFloor");
          List<UserShowAuth> chAuth = auth.children;
          //是否存在为执行任务   添加红点提示
          if (needDo.length > 0 && chAuth!=null) {
            for (UserShowAuth child in chAuth) {
              if(child==null)continue;
              for (UserShowAuth lc in child.children) {
                lc.hasTask = needDo.contains(lc.path);
              }
            }
          }
        }
      });
    });
  }

  cqDialog() {
    if (this.isOffline) {
      MessageBox.showMessageOnly("离线模式，该功能暂不支持。", context);
      return;
    }
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return _cqDatas != null
            ? SimpleDialog(
          children: _cqDatas.map((f) {
            return Column(
              children: <Widget>[
                new SimpleDialogOption(
                  child: new Text(f.label),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      cqSelect = f;
                      // 公司切换
                      selectCompany(this.cqSelect.key);
                    });
                  },
                ),
                Divider(
                  height: 1,
                )
              ],
            );
          }).toList(),
        )
            : Container();
      },
    );
  }

  initFunction() async {
    await SharedPreferences.getInstance().then((sp) {
      if (sp.getBool("offline") != null) {
        setState(() {
          isOffline = sp.getBool("offline");
          this.theme = sp.get("theme") ?? KColorConstant.DEFAULT_COLOR;
          workLogo=sp.getString("sys_workLogo")??"";
          workLogoEnTitle=sp.getString("sys_workLogoEnTitle")??"";
          workLogoChTitle=sp.getString("sys_workLogoChTitle")??"";
          print(this.theme);
          print("isOffline:$isOffline");
        });
      }
    });
  }

  Widget getFuncImg(path) {
    switch (path) {
      case "fixRiskPoint": //固有风险点
        return Image.asset(
          "assets/images/home/inspection_point_" + theme + ".png",
          width: 28,
          height: 28,
          color: GetConfig.getColor(theme),
        );
        break;
      case "planPatrol": //计划巡检
        return Image.asset(
          "assets/images/home/plan_inspection_" + theme + ".png",
          width: 28,
          height: 28,
          color: GetConfig.getColor(theme),
        );
        break;
      case "noPlanPatrol": //无计划巡检
        return Image.asset(
          "assets/images/home/no_plan_" + theme + ".png",
          width: 28,
          height: 28,
          color: GetConfig.getColor(theme),
        );
        break;
      case "dynamicsRisk": //动态风险点
        return
          Image.asset(
            "assets/images/home/move_inspection_" + theme + ".png",
            width: 28,
            height: 28,
            color: GetConfig.getColor(theme),
          );

        break;
      case "patrolRecord": //巡检记录
        return
          Image.asset(
            "assets/images/home/inspection_record_" + theme + ".png",
            width: 28,
            height: 28,
            color: GetConfig.getColor(theme),
          );

        break;
      case "patrolCalendar": //巡检日历
        return
          Image.asset(
            "assets/images/home/inspection_calendar_" + theme + ".png",
            width: 28,
            height: 28,
            color: GetConfig.getColor(theme),
          );

        break;
      case "riskJudgment": //风险研判
        return
          Image.asset(
            "assets/images/jiaoda/safe_danger_judgement_" + theme + ".png",
            width: 28,
            height: 28,
            color: GetConfig.getColor(theme),
          );

        break;
      case "waitHandle": //待处理
        return
          Image.asset(
            "assets/images/jiaoda/wait_do_" + theme + ".png",
            width: 28,
            height: 28,
            color: GetConfig.getColor(theme),
          );

        break;
      case "haveHandle": //已处理
        return
          Image.asset(
            "assets/images/jiaoda/do_over_" + theme + ".png",
            width: 28,
            height: 28,
            color: GetConfig.getColor(theme),
          );

        break;
      case "latentDangerSave": //隐患添加
        return
          Image.asset(
            "assets/images/home/add_task_" + theme + ".png",
            width: 28,
            height: 28,
            color: GetConfig.getColor(theme),
          );

        break;
      case "taskwork": //一般作业活动
        return
          Image.asset(
            "assets/images/jiaoda/generalwork_" + theme + ".png",
            width: 28,
            height: 28,
            color: GetConfig.getColor(theme),
          );

        break;
      case "riskPoint": //风险点
        return
          Image.asset(
            "assets/images/home/inspection_point_" + theme + ".png",
            width: 28,
            height: 28,
            color: GetConfig.getColor(theme),
          );

        break;
      case "monitorVideo": //风险点
        return Icon(Icons.videocam,size: 32,   color: GetConfig.getColor(theme),);
            break;
      default:
        return
          Image.asset(
            "assets/images/jiaoda/wait_do_" + theme + ".png",
            width: 28,
            height: 28,
            color: GetConfig.getColor(theme),
          );

    }
  }

  onTapEventHandlergetFuncImg(path) {
    switch (path) {
      case "fixRiskPoint": //固有风险点
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return isOffline
              ? OfflineInspectionSpotScreen()
              : InspectionSpotScreen();
        }));
        break;
      case "planPatrol": //计划巡检
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return isOffline ? OfflinePlanListScreen() : PlanListScreen();
        }));
        break;
      case "noPlanPatrol": //无计划巡检
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return isOffline ? OfflineNoPlanInspection() : NoPlanInspection();
        }));
        break;
      case "dynamicsRisk": //动态风险点
        print("动态风险");
        break;
      case "patrolRecord": //巡检记录
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return RecordListScreen();
        }));
        break;
      case "patrolCalendar": //巡检日历
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return CalendarMainPage();
        }));
        break;
      case "riskJudgment": //风险研判
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return SecurityRiskJudegmentList();
        }));
        break;
      case "waitHandle": //待处理
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return new PendingHideDanger();
        }));
        break;
      case "haveHandle": //已处理
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return new ProcessedHiddenDanger();
        }));
        break;
      case "latentDangerSave": //隐患添加
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return new HiddenDangerFound();
        }));
        break;
      case "taskwork": //一般作业活动
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return ActivilityList();
        }));
        break;
      case "riskPoint": //风险点
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return RiskSpotScreen();
        }));
        break;
      case "monitorVideo": //风险点
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return VideoMonitorList();
        }));
        break;
      default:
        print("default");
        break;
    }
  }

//获取功能菜单
  List<Widget> getFunctionMenu() {
    List<Widget> funMenus = new List();
    if(this.auth==null || this.auth.children==null) return funMenus;
    for (UserShowAuth au in this.auth.children) {

      funMenus.add(new Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  child: new Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      new Text(
                        au.permissionName ?? "--",
                        style:
                        TextStyle(color: Color.fromRGBO(102, 102, 102, 1)),
                      )
                    ],
                  ),
                  width: double.infinity,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    color: Color.fromRGBO(250, 251, 252, 1),
                    //Colors.grey[100],
                    borderRadius:
                    new BorderRadius.vertical(top: Radius.circular(5.0)),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: GridView.count(
                    crossAxisCount: 4,
                    children: getChildFuns(au.children),
                    shrinkWrap: true,
                  ),
                )
              ],
            ),
            margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
            decoration: new BoxDecoration(
//                      color: Color.fromRGBO(242, 246, 249, 1),
                borderRadius: new BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(242, 246, 249, 1),
                    blurRadius: 5.0,
                  ),
                ]),
          ),
        ],
      ));
    }
    return funMenus;
  }

//获取子功能菜单
  List<Widget> getChildFuns(List<UserShowAuth> childFunc) {
    List<Widget> funs = new List();
    if(childFunc==null)return funs;
    for (UserShowAuth fun in childFunc) {
      funs.add(Container(
          height: 82,
          width: 82,
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(5)),
            color: Colors.white,
            border: new Border.all(width: 0.5, color: Colors.grey[100]),
          ),
          child: GestureDetector(
            child: EachTab(
              width: 80,
              badge: fun.hasTask
                  ? CircleAvatar(
                backgroundColor: Colors.red,
                radius: 3,
              )
                  : Container(),
              badgeColor: Colors.red,
              height: 40,
              padding: EdgeInsets.all(0),
              icon:    getFuncImg(fun.path),
              text: fun.permissionName,
              textStyle: TextStyle(
                  fontSize: 13, color: Color.fromRGBO(153, 153, 153, 1)),
              color: Colors.white,
            ),
            onTap: () {
              onTapEventHandlergetFuncImg(fun.path);
            },
          )));
    }
    return funs;
  }

//获取消息
  getUnreadCountMessage() async {
    await getUnreadCount().then((count) {
      if (mounted) {
        setState(() {
          _unReadCount = count;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.theme == "") {
      return Scaffold(body: Text(""));
    }
    return ModalProgressHUD(
      color: Color.fromRGBO(242, 246, 249, 1),
      child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Container(
                  // padding: EdgeInsets.only(left: ScreenUtil.screenWidthDp/4-2),
                  padding: EdgeInsets.only(top: 15, left: 20, right: 20),
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: SingleChildScrollView(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      companyName == null
                                          ?  cqSelect.label
                                          :companyName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 0),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SelCompanyAndDept(
                                          isSelect: true,
                                        )));
                                //cqDialog();
                              },
                            ),
                            flex: 3,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              alignment: Alignment.center,
                              //padding: EdgeInsets.only(left: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // ignore: null_aware_in_condition
                                  workLogo.isEmpty?Image.asset(
                                    'assets/images/jiaoda/渭化集团@3x.png',
                                    width: 36,
                                    height: 36,
                                  ):Image.network(workLogo,width: 36,height: 36,),
                                  Padding(
                                    padding: EdgeInsets.only(right: 2),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        workLogoChTitle.isEmpty?"陕西渭河煤化工集团":workLogoChTitle,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      Text(
                                        workLogoEnTitle.isEmpty?"Shaanxi Werhe Coal Chemical Corporation Group Ltd.":workLogoEnTitle,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 8),
                                      ),

                                    ],
                                  )
                                ],
                              ),
                            ),
                            flex: 6,
                          ),


                          Expanded(
                            child: GestureDetector(
                              child: Row(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Icon(
                                        Icons.message,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      _unReadCount > 0
                                          ? Container(
                                        padding: EdgeInsets.only(
                                            bottom: 10, left: 15),
                                        child: CircleAvatar(
                                          radius: 3,
                                          backgroundColor: GetConfig.getColor(
                                              theme == "blue"
                                                  ? "red"
                                                  : "blue"),
                                        ),
                                      )
                                          : Container()
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                  ),
                                  Text(
                                    '消息',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.end,
                              ),
                              onTap: () {
                                // MessageListPage
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return new MessageListPage();
                                    })).then((v) {
                                  //                            if(v!=null){
                                  //                              getUnreadCount();
                                  //                            }
                                });
                              },
                            ),
                            flex: 2,
                          ),
//                      Padding(padding: EdgeInsets.only(left: 20),),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                this.auth != null
                    ? Container(
                  child: Column(
                    children: getFunctionMenu(),

                  ),
                )
                    : Container(),
              ],
            );
          }),
      inAsyncCall: isAnimating,
      opacity: 0.7,
      progressIndicator: CircularProgressIndicator(),
    );
  }
}
