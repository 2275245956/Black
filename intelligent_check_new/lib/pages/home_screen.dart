import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intelligent_check_new/model/CompanyInfo.dart';
import 'package:intelligent_check_new/model/message/MessageDetail.dart';
import 'package:intelligent_check_new/pages/Activity/activility_check&acceptance.dart';
import 'package:intelligent_check_new/pages/Activity/activility_company_review.dart';
import 'package:intelligent_check_new/pages/Activity/activility_department_review.dart';
import 'package:intelligent_check_new/pages/Activity/activility_finished_detail.dart';
import 'package:intelligent_check_new/pages/Activity/activility_ready2run.dart';
import 'package:intelligent_check_new/pages/Activity/activility_team_review.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_item_content.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_list_content.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_check.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_procedded_hasChecked.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_processed_details_rescinded.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_rectification.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_review.dart';
import 'package:intelligent_check_new/pages/home_layout/home_background_image.dart';
import 'package:intelligent_check_new/pages/inspection_spot/dangerous_factors_detail.dart';
import 'package:intelligent_check_new/pages/message/message_detail.dart';
import 'package:intelligent_check_new/pages/message/message_list.dart';
import 'package:intelligent_check_new/pages/plan_inspection/plan_list_content.dart';
import 'package:intelligent_check_new/pages/plan_inspection/plan_list_content_detail.dart';
import 'package:intelligent_check_new/pages/security_risk_judgment/security_risk_judegment_detail.dart';
import 'package:intelligent_check_new/services/company_services.dart';
import 'package:intelligent_check_new/services/message_service.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final List<CompanyInfo> cqDatas;

  HomeScreen(this.cqDatas);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final JPush jpush = new JPush();
  var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 初始化极光推送
    initPlatformState();
  }

  // 推送相关-极光
  Future<void> initPlatformState() async {
    String platformVersion;

    final prefs = await SharedPreferences.getInstance();
    String registerId="";
    String alias="";
    String userId = prefs.getString("loginUserId");
    String jpushKey=prefs.getString("jpushKey");

    String companyCode = prefs.getString("sel_com") != null
        ? json.decode(prefs.getString("sel_com"))["companyName"]
        : "-";

    List<String> tags = List();
    tags.add(companyCode);

    jpush.setup(
      appKey: "fbd69be942f081fcaacd67ef",
      channel: "developer-default",
      production: false,
      debug: true,
    );

    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));
   await jpush.getRegistrationID().then((rid) {
     registerId=rid;
      print("推送测试getRegistrationID>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + rid);
    });

   ///JPush 多次注册
   var  isRegister=  prefs.getBool("isRegister");
   if(!isRegister){
     await jpush.setAlias(jpushKey).then((_){
       print("注册用户$jpushKey成功>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
     });
     var res=await RegisterJPushUser(registerId,jpushKey);
     if(res.success){
       print("$registerId >>>>>>>>>>>>>>>>>>>>$jpushKey 注册成功！");
       prefs.setBool("isRegister",true);
     }else{
       print("无法创建推送服务>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
     }

   }

    try {
      jpush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
          print("extras info:" + message["extras"]["cn.jpush.android.EXTRA"]);
        },
        onOpenNotification: (Map<String, dynamic> message) async {
          print("flutter onOpenNotification: $message");
          String extrasMsg = message["extras"]["cn.jpush.android.EXTRA"];
          print("extras info:" + extrasMsg);
          Map extras = json.decode(extrasMsg);
          // 页面跳转
          String id = extras["id"] ?? "0";
          String type = extras["type"];
          int state = int.tryParse(extras["state"].toString());
          if (type == "riskFatorApp") {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DangerousFactorsDetail(num.tryParse(id), true);
            }));
          } else if (type == "planBeginApp" ||
              type == "planWarnApp" ||
              type == "planEndApp") {
              Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new PlanListContent(num.tryParse(id))),
            );
          } else if (type == "notifyApp") {
            //通知 公告
            MessageDetail msg = await getMessageById(int.tryParse(id));
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new MessageDetailPage(msg)),
            );
          } else if (type == "latentDangerApp") {

            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              switch (state) {
                case 1: //待评审
                  return new HiddenDangerReview(
                    int.tryParse(id),
                    state: state,
                  );
                  break;
                case 2: //待治理
                  return new HiddenDangerRectification(
                    int.tryParse(id),
                    state: state,
                  );
                  break;
                case 3: //安措计划中
                  return new HiddenDangerProcessedDetailsRescinded(
                    int.tryParse(id),
                    state: state,
                  );
                  break;
                case 4:
                  //待验证
                  return new HiddenDangerProcessedDetailsChecked(
                    int.tryParse(id),
                    state: state,
                  );
                  break;
                case 5: //治理完毕
                  return new HiddenDangerProcessedCheckedDetail(
                      int.tryParse(id));
                  break;
                case 6: //已撤销
                  return new HiddenDangerProcessedDetailsRescinded(
                    int.tryParse(id),
                    state: state,
                  );
                  break;
                default:
                  return new HiddenDangerProcessedDetailsRescinded(
                    int.tryParse(id),
                    state: state,
                  );
                  break;
              }
            }));
          } else if (type == "riskJudgmentApp") {
            //风险研判
            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) =>
                      new SecurityRiskJudegmentDetail(int.tryParse(id)),
                ));
          } else if (type == "taskworkApp") {
            //作业活动
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              switch (state) {
                case 1:
                  break;
                case 2: //待班组审核
                  return ActivilityTeamReview(int.tryParse(id));
                case 3: //待车间部门审核
                  return ActivilityDepartmentReview(int.tryParse(id));
                  break;
                case 4: //待公司审核
                  return ActivilityCompanyReview(int.tryParse(id));
                case 5: //待执行
                  return ActivilityReady2Run(int.tryParse(id));
                  break;
                case 6: //待确认验收
                  return ActivilityCheckAndAcceptance(int.tryParse(id));
                  break;

                case 7: //完成
                  return ActivilityFinishDetail(int.tryParse(id));
                  break;
                default:
                  return ActivilityFinishDetail(int.tryParse(id));
                  break;
              }
            }));
          } else if (type == "checkRecordPushHavaRecordApp") {
            //计划巡检
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new CheckExecItemContent(int.tryParse(id))),
            );
          } else if(type=="checkRecordHaveMissRecordApp"){
              var pointId=num.parse(extras["pointId"] ?? "0") ;
              var planTaskId=num.parse(extras["planTaskId"] ?? "0");
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return PlanListContentDetail(planTaskId,pointId);
              }));
          }else if(type=="alarmNotification"){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {
                  return new MessageListPage();
                }));
          }else if(type=="checkRecordHavaNoPassRecordApp"){
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new CheckExecListContent(int.tryParse(id))),
            );
          }else if(type=="riskAlarmApp"){
            MessageDetail msg = await getMessageById(int.tryParse(id));
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new MessageDetailPage(msg)),
            );
          }else {
            HiddenDangerFound.popUpMsg("无法识别的消息类型：$type");
          }
        },
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
        },
      );
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

  }

  @override
  Widget build(BuildContext context) {
    return HomeBackgroundImage(
        this.widget.cqDatas /*,this.widget.taskCount,this.widget.unReadCount*/);
  }
}
