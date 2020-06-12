import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/model/Task/TaskContentResult.dart';
import 'package:intelligent_check_new/model/Task/TaskModel.dart';
import 'package:intelligent_check_new/pages/task_detail/task_detail_process/no_plan_inspection.dart';
import 'package:intelligent_check_new/pages/task_process/forward_screen.dart';
import 'package:intelligent_check_new/pages/task_process/processing_information_screen.dart';
import 'package:intelligent_check_new/pages/task_process/task_process_screen.dart';
import 'package:intelligent_check_new/services/TaskServices.dart';
import 'package:intelligent_check_new/tools/DateUtil.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/tools/MessageBox.dart';
import 'package:intelligent_check_new/widget/touch_callback.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';



class TaskDetailPage extends StatefulWidget {
  final TaskContent task;
  TaskDetailPage({Key key, @required this.task}) : super(key: key);
  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  num state = 1;
  TaskModel initData;
  String userId;

  // 是否显示取消，处理按钮
  bool showProcessBtn = false;
  bool showCancelBtn = false;

  // 是否显示遮罩
  bool isAnimating = false;
  String theme="";

  void initState() {
    super.initState();
    getData();
  }
  getData() async {

    await SharedPreferences.getInstance().then((sp) {
      String str = sp.get('LoginResult');
      setState(() {
        userId = LoginResult(str).user.id;
        this.theme = sp.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
      return userId;
    }).then((uid){
      getTask(widget.task.id.toString()).then((data) {
        setState(() {
          initData = data;
          if(null != initData){
            showProcessBtn = (initData.taskInfo.executorId == this.userId && initData.taskInfo.status == 0);
            showCancelBtn = (initData.taskInfo.publisher == this.userId && initData.taskInfo.status == 0);
          }
        });
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

  Color getColor(num) {
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

  String getState(num) {
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
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
            ),
          ),
        ),
      );
    }
    return ModalProgressHUD(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "任务详情",
            style: TextStyle(color: Colors.black, fontSize: 19),
          ),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
            ),
          ),
          actions: <Widget>[
            showCancelBtn ?
            IconButton(
              icon: Text(
                '取消',
                style: new TextStyle(
                  color: GetConfig.getColor(theme),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              onPressed: () {
                cancelTaskInfo();
              },
            ):Container(),
          ],
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
                        color: Colors.black, fontWeight: FontWeight.bold),
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
            onPressed: () {
              //执行人转发页面
              if(initData.taskInfo.status == 0){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ForwardPage(
                          taskid: initData.taskInfo.id,
                        ))).then((v){
                  getData();
                });
              }
            },
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
                  child: new Text(DateUtil.timestampToDate(initData.taskInfo.finishTime)),
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
//            height: 50.0,
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height:50,
                    child: new Text(
                      '任务说明',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    padding: const EdgeInsets.only(left: 10.0),
                    alignment: Alignment.centerLeft,
                  ),
                  flex: 1,
                ),
                Expanded(
                  //child: new Text("任务说明"),
                  //child: new Text(taskList.list[0].description),
//                  padding: const EdgeInsets.only(left: 10.0,right: 10),
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
          Container(
            child: Column(
              children: <Widget>[
                TouchCallBack(
                    child: Container(
                      color: Colors.white,
                      height: 50.0,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: new Text(
                                '处理信息',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              padding: const EdgeInsets.only(left: 10.0),
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: new Icon(
                              Icons.chevron_right,
                              color: GetConfig.getColor(theme),
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new ProcessingInfoPage(
                              taskid: initData.taskInfo.id,
                              taskData: initData,
                            ),
                          ));
                    }),
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
              ],
            ),
          ),
        ]),
        floatingActionButton: new Builder(
            builder: (BuildContext context) {
              if(showProcessBtn){
                return new FloatingActionButton(
                  child: Icon(
                    Icons.phone_android,
                    color: GetConfig.getColor(theme),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white,
                  heroTag: null,
                  elevation: 8.0,
                  highlightElevation: 10.0,
                  onPressed: () {
//                    print(this.initData.taskInfo.isScan);
                    this.initData.taskInfo.checkId != null && this.initData.taskInfo.checkId > 0
                        && this.initData.taskInfo.isScan?
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new NoPlanInspection(widget.task,this.initData.taskDetails[0].pointNo)
                        )
                    ).then((v){
                      getData();
                    }):
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new TaskProcessPage(task: widget.task)
                        )
                    ).then((v){
                      getData();
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
      ),
      inAsyncCall: isAnimating,
      opacity: 0.7,
      progressIndicator: CircularProgressIndicator(),
    );
  }

  cancelTaskInfo() async{
    setState(() {
      isAnimating = true;
    });
    await cancelTask(this.widget.task.id).then((data){
      setState(() {
        isAnimating = false;
      });
      if(data){
        MessageBox.showMessageAndExitCurrentPage("任务取消成功！",true, context);
      }else{
        MessageBox.showMessageAndExitCurrentPage("任务取消失败！",false, context);
      }
    });
  }
}
