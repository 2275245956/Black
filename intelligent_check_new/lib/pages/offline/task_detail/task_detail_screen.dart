import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/common/JunCommon.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/pages/offline/hidedanger_manage/hide_danger_page_mytask.dart';
import 'package:intelligent_check_new/pages/offline/task_detail/task_detail_process/no_plan_inspection.dart';
import 'package:intelligent_check_new/pages/offline/task_process/task_process_screen.dart';
import 'package:intelligent_check_new/services/offline/dbAccess.dart';
import 'package:intelligent_check_new/tools/DateUtil.dart';
import 'package:intelligent_check_new/widget/touch_callback.dart';
import 'package:intelligent_check_new/model/Task/TaskContentResult.dart';
import 'package:intelligent_check_new/model/Task/TaskModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskContent task;
  TaskDetailPage({Key key, @required this.task}) : super(key: key);
  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  TextEditingController _controller = new TextEditingController();
  String feedbackstr = '';
  num state = 1;
  TaskModel initData;
  String userId;
  String userName;

  @override
  void initState() {
    super.initState();
     getUserData().then((data){
      getData();
     });
  }
  getData() async {
//    await getTask(widget.task.id.toString()).then((data) {
//      setState(() {
//        initData = data;
//      });
//    });
    var taskId = widget.task.id.toString();
    var sql = new StringBuffer();
    sql.write("SELECT * ");
    sql.write("FROM Tasks ");
    sql.write("WHERE id = ?");
    dbAccess().queryData(sql.toString(),[taskId]).then((lstMpa){
      if(lstMpa.length>0){
        var jsonTasksDetail = json.decode(lstMpa[0]["jsonTaskDetail"].toString());
        var jsonTaskDetail = jsonTasksDetail.length>0?jsonTasksDetail[0]:[];
        var jsonTask = json.decode(lstMpa[0]["jsonTask"].toString());
        var mdlTaskDetail = new TaskDetails();
        if(jsonTaskDetail != null && jsonTaskDetail.length>0) {
          mdlTaskDetail.createDate = '';
          mdlTaskDetail.itemName = jsonTaskDetail['inputName'].toString();
          mdlTaskDetail.remark = jsonTaskDetail['remark'].toString();
          mdlTaskDetail.checkId =
              JunMath.parseInt(jsonTaskDetail['checkId'].toString());
          mdlTaskDetail.id = widget.task.id;
          mdlTaskDetail.itemId =
              JunMath.parseInt(jsonTaskDetail['checkInputId'].toString());
          mdlTaskDetail.pointId = JunMath.parseInt(jsonTaskDetail['pointId'].toString());
          mdlTaskDetail.routeId = 0;
          mdlTaskDetail.status =
              JunMath.parseInt(jsonTaskDetail['inputStatus'].toString());
          mdlTaskDetail.taskId = widget.task.id;
          mdlTaskDetail.pointName = jsonTaskDetail['pointName'].toString();
          mdlTaskDetail.pointNo = jsonTaskDetail['pointNo'].toString();
        }
        var task = new TaskInfo();
        task.factFinishTime = JunMath.parseInt(jsonTask['finishTime'].toString());
        task.createDate = JunMath.parseInt(jsonTask['publishTime'].toString());
        task.depth = JunMath.parseInt(jsonTask['depth'].toString());
        task.executorId = userId;
        task.feedbackNum = 0;
        task.finishTime = JunMath.parseInt(jsonTask['finishTime'].toString());
        task.id = widget.task.id;
        task.maxDepth = JunMath.parseInt(jsonTask['maxDepth'].toString());
        task.publishTime = JunMath.parseInt(jsonTask['publishTime'].toString());
        task.publisher = 0;
        task.status = JunMath.parseInt(jsonTask['status'].toString());
        task.warnTime = 0;
        task.config = null;
        task.executor = userName;
        task.isWarn = '';
        task.orgCode = '';
        task.publisherName = jsonTask['publisherName'];
        task.remark = jsonTask['remark'].toString();
        task.title = jsonTask['title'].toString();
        if(jsonTaskDetail!=null && jsonTaskDetail.length>0){
          task.checkId = JunMath.parseInt(jsonTaskDetail['checkId'].toString());
        }

        setState(() {
          initData = TaskModel.fromParams(feedback: [],taskDetails:[mdlTaskDetail],taskInfo:task);
        });
      }else{
        setState(() {
          initData = TaskModel.fromJson({});
        });
      }
    });
  }

  Future<void> getUserData() async {
    await SharedPreferences.getInstance().then((sp) {
      String str = sp.get('LoginResult');
      setState(() {
        userId = LoginResult(str).user.id;
        userName = LoginResult(str).user.userName;
      });
    });
  }
  List<Image> convertBase642File(List<String> picBase64List){
    List<Image> result = new List();
    picBase64List.forEach((s){
      result.add(Image.memory(base64Decode(s)));
    });
    return result;
  }

  getColor(num) {
    switch (num) {
      case 0:
        return Colors.yellow;
        break;
      case 1:
        return Colors.green;
        break;
      case 2:
        return Colors.red;
        break;
      case 3:
        return Colors.grey;
        break;
    }
  }

   getState(num) {
    switch (num) {
      case 0:
        return '待处理';
        break;
      case 1:
        return '已完成';
        break;
      case 2:
        return '已超时';
        break;
      case 3:
        return '已取消';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if(initData == null){
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "任务详情",
            style: TextStyle(color: Colors.black, fontSize: 19),
          ),
          centerTitle: true,
          elevation: 0.7,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: (){                 //Navigator.pop(context),
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                  builder: (context) => new OfflineHiderManageMyTaskPage()
              )
                );
              },
              child: Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "任务详情",
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        centerTitle: true,
        elevation: 0.7,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: (){                 //Navigator.pop(context),
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new OfflineHiderManageMyTaskPage()
                  )
              );
            },
            child: Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
          ),
        ),
//        actions: <Widget>[
//          initData.taskInfo.publisher== userId&&initData.taskInfo.status==0?
//          IconButton(
//            icon: Text(
//              '取消',
//              style: new TextStyle(
//                color: Colors.red,
//                fontWeight: FontWeight.bold,
//                fontSize: 16.0,
//              ),
//            ),
//            onPressed: () {
//              cancelTaskInfo();
////              Navigator.pop(context);
//            },
//          ):Container(),
//        ],
      ),
      body: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(
            height: 0.5,
            color: Color(0XFFd9d9d9),
          ),
        ),
        Container(
          color: Colors.white,
          height: 50.0,
          child: new Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: new Text(
                    '任务名称',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                flex: 1,
              ),
              Expanded(
                //child: new Text(taskList.list[0].taskName),
                child: new Text(initData.taskInfo.title??""),
                flex: 2,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(
            height: 0.5,
            color: Color(0XFFd9d9d9),
          ),
        ),
        Container(
          color: Colors.white,
          height: 50.0,
          child: new Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: new Text(
                    '发起人',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                flex: 1,
              ),
              Expanded(
                child: new Text(
                  //taskList.list[0].sponsor,
                  initData.taskInfo.publisherName??"",
                  style: new TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                flex: 2,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(
            height: 0.5,
            color: Color(0XFFd9d9d9),
          ),
        ),
        TouchCallBack(
          child: Container(
            color: Colors.white,
            height: 50.0,
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: new Text(
                      '执行人',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    padding: const EdgeInsets.only(left: 10.0),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: new Text(
                    //taskList.list[0].executive,
                    initData.taskInfo.executor??"",
                    style: new TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  flex: 2,
                ),
              ],
            ),
          ),
//          onPressed: () {
//            //执行人转发页面
//            Navigator.push(
//                context,
//                new MaterialPageRoute(
//                    builder: (context) => new ForwardPage(
//                          taskid: initData.taskInfo.id,
//                        ))).then((v){
//              getData();
//            });
//          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(
            height: 0.5,
            color: Color(0XFFd9d9d9),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        ),
        Container(
          color: Colors.white,
          height: 50.0,
          child: new Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: new Text(
                    '可转发次数',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                flex: 1,
              ),
              Expanded(
                //child: new Text('不限制/4' ),//+ taskList.list[0].forwardsTimes.toString()),
                child: new Text(initData.taskInfo.maxDepth == 0
                    ? "无限制"
                    : initData.taskInfo.maxDepth.toString()),
                flex: 2,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(
            height: 0.5,
            color: Color(0XFFd9d9d9),
          ),
        ),
        Container(
          color: Colors.white,
          height: 50.0,
          child: new Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: new Text(
                    '状态',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                flex: 1,
              ),
              Expanded(
                child: new Text(
                  //getState(taskList.list[0].taskState),
                  //style: TextStyle(color: getColor(taskList.list[0].taskState)),
                  getState(initData.taskInfo.status),
                  style: TextStyle(color: getColor(initData.taskInfo.status)),
                ),
                flex: 2,
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          height: 50.0,
          child: new Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: new Text(
                    '发送时间',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                flex: 1,
              ),
              Expanded(
                //child: new Text(taskList.list[0].creationTime),
                child: new Text(DateUtil.timestampToDate(initData.taskInfo.publishTime)),
                flex: 2,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(
            height: 0.5,
            color: Color(0XFFd9d9d9),
          ),
        ),
        Container(
          color: Colors.white,
          height: 50.0,
          child: new Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: new Text(
                    '要求完成时间',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                flex: 1,
              ),
              Expanded(
                //child: new Text(taskList.list[0].requestTime),
                child: new Text(DateUtil.timestampToDate(initData.taskInfo.finishTime??0)),
                flex: 2,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(
            height: 0.5,
            color: Color(0XFFd9d9d9),
          ),
        ),
        //巡检点处画面出现分支

        Offstage(
          offstage: initData.taskDetails.length != 0 ? false : true,
          child: Container(
            color: Colors.white,
            height: 50.0,
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: new Text(
                      '巡检点',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    padding: const EdgeInsets.only(left: 10.0),
                  ),
                  flex: 1,
                ),
                Expanded(
                  //child: new Text(taskList.list[0].patrolPoint),
                  child: new Text(initData.taskDetails!= null && initData.taskDetails.length != 0
                      ? initData.taskDetails[0].pointName??""
                      : ""),
                  flex: 2,
                ),
              ],
            ),
          ),
        ),

        Offstage(
          offstage: initData.taskDetails.length != 0 ? false : true,
          child:Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          ),
        ),

      Offstage(
        offstage: initData.taskDetails.length != 0 ? false : true,
        child:  Container(
          color: Colors.white,
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: new Text(
                    '关联检查项',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                flex: 1,
              ),
              Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(padding: EdgeInsets.only(top: 10.0)),
                    new ListView.builder(
                        shrinkWrap: true,
                        itemCount: initData.taskDetails.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new Text(
                            initData.taskDetails[index].itemName == null
                                ? ""
                                : initData.taskDetails[index].itemName,
                            style: TextStyle(color: Colors.red[500]),
                          );
                        })
                  ],
                ),
                flex: 2,
              ),
            ],
          ),
        ),
      ),

        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(
            height: 0.5,
            color: Color(0XFFd9d9d9),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        ),
        Container(
          color: Colors.white,
          height: 50.0,
          child: new Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: new Text(
                    '任务说明',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                flex: 1,
              ),
              Expanded(
                //child: new Text("任务说明"),
                //child: new Text(taskList.list[0].description),
//                child: new Text(initData.taskInfo.remark == null
//                    ? ""
//                    : initData.taskInfo.remark),
                child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  child: new Text(initData.taskInfo.remark == null
                      ? ""
                      : initData.taskInfo.remark),
                ),
                flex: 2,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(
            height: 0.5,
            color: Color(0XFFd9d9d9),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        ),
//        Container(
//          child: Column(
//            children: <Widget>[
//              TouchCallBack(
//                  child: Container(
//                    color: Colors.white,
//                    height: 50.0,
//                    child: new Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Expanded(
//                          child: Container(
//                            child: new Text(
//                              '处理信息',
//                              style: TextStyle(
//                                  fontSize: 15.0,
//                                  fontWeight: FontWeight.bold,
//                                  color: Colors.black),
//                            ),
//                            padding: const EdgeInsets.only(left: 10.0),
//                          ),
//                          flex: 5,
//                        ),
//                        Expanded(
//                          child: new Icon(
//                            Icons.chevron_right,
//                            color: Colors.red,
//                          ),
//                          flex: 1,
//                        ),
//                      ],
//                    ),
//                  ),
//                  onPressed: () {
//                    Navigator.push(
//                        context,
//                        new MaterialPageRoute(
//                          builder: (context) => new ProcessingInfoPage(
//                            taskid: initData.taskInfo.id,
//                            taskData: initData,
//                          ),
//                        ));
//                  }),
//              Padding(
//                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                child: Divider(
//                  height: 0.5,
//                  color: Color(0XFFd9d9d9),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
//              ),
//            ],
//          ),
//        ),
      ]),
      floatingActionButton: new Builder(
        builder: (BuildContext context) {
          if(initData.taskInfo.status ==0){
            return new FloatingActionButton(
              child: Icon(
                Icons.phone_android,
                color: Colors.red,
              ),
              foregroundColor: Colors.white,
              backgroundColor: Colors.white,
              heroTag: null,
              elevation: 8.0,
              highlightElevation: 10.0,
              onPressed: () {
                this.initData.taskInfo.checkId != null && this.initData.taskInfo.checkId > 0?
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new NoPlanInspection(widget.task,this.initData)
                  )
                ).then((v){
                  getData();
                  getUserData();
                }):
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new TaskProcessPage(task: widget.task,taskModel: this.initData)
                  )
                ).then((v){
                  getData();
                  getUserData();
                });
              },
              mini: false,
              shape: new CircleBorder(),
              isExtended: true,
            );
          }else{
            return Container();
          }
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

//  cancelTaskInfo() async{
//    cancelTask(this.widget.task.id).then((data){
//      if(data){
//        showAlertMessageOnly("任务取消成功！","success");
//      }else{
//        showAlertMessageOnly("任务取消失败！","fail");
//      }
//    });
//  }

  showAlertMessageOnly(String text,String status) async{
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
            title: Column(
              children: <Widget>[
                new Text("信息"),
                Divider(height: 2),
              ],
            ),
            content: Text(text),
            actions:<Widget>[
              new FlatButton(
                child:new Text("关闭",style: TextStyle(fontSize: 20,color: Colors.grey)), onPressed: (){
                Navigator.of(context).pop();
                if(status=="success"){
                  Navigator.of(context).pop();
                }
              },
              ),
            ]
        )
    ).then((v){
      return v;
    });
  }
}
