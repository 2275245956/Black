import 'dart:convert' show json;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/Task/FeedbackDto.dart';
import 'package:intelligent_check_new/pages/offline/CheckExecute/ImageList.dart';
import 'package:intelligent_check_new/services/offline/dbAccess.dart';
import 'package:intelligent_check_new/tools/DateUtil.dart';
import 'package:intelligent_check_new/tools/MessageBox.dart';
import 'package:intelligent_check_new/widget/touch_callback.dart';
import 'package:intelligent_check_new/pages/offline/task_process/feedback_screen.dart';
import 'package:intelligent_check_new/model/TaskList.dart';
import 'package:intelligent_check_new/model/Task/TaskContentResult.dart';
import 'package:intelligent_check_new/model/Task/TaskModel.dart';

class TaskProcessPage extends StatefulWidget {
  final TaskContent task;
  final TaskModel taskModel;

  TaskProcessPage({Key key, @required this.task, @required this.taskModel})
      : super(key: key);

  @override
  _TaskProcessPageState createState() => _TaskProcessPageState();
}

class _TaskProcessPageState extends State<TaskProcessPage> {
  TaskList taskList = new TaskList(); //假数据
  TextEditingController _controller = new TextEditingController();

  // 当前处理反馈信息
  String feedbackstr = '';

  // 当前处理附件
  List<File> imageList = List();
  num state = 1;
  TaskModel initData;

  bool btnSaveVisible = true;
  @override
  void initState() {
    super.initState();
    btnSaveVisible = true;
    getData();
  }

  getData() async {
//    await getTask(widget.task.id.toString()).then((data) {
//      setState(() {
//        initData = data;
//      });
//    });

    setState(() {
      initData = this.widget.taskModel;
    });
  }

  saveData() async {
    FeedbackDto dto = FeedbackDto.fromParams(
        taskID: this.initData.taskInfo.id, imgbase64: []);
    if (null == this.feedbackstr) {
      // 必须填写反馈信息
      MessageBox.showMessageOnly("必须填写反馈信息", context);
      return;
    }
    dto.message = this.feedbackstr;
    List c = json.decode(this.initData.taskInfo.config ?? "[]");
    // 存在配置信息
    if (c.length > 0) {
      TaskConfig taskConfig = TaskConfig.fromJson(c[0]);
      // 是否必须上传图片
      if (taskConfig.isMust == '是') {
        if (this.imageList.length == 0) {
          // 必须上传图片提示
          MessageBox.showMessageOnly(
              "图片数量不正确，（" +
                  taskConfig.start.toString() +
                  "到" +
                  taskConfig.end.toString() +
                  "张）",
              context);
          return;
        }
        // 数量控制
        if (taskConfig.start != null &&
            this.imageList.length < taskConfig.start) {
          MessageBox.showMessageOnly(
              "图片数量不正确，最少需要（" + taskConfig.start.toString() + "张）", context);
          return;
        }

        if (taskConfig.end != null && this.imageList.length > taskConfig.end) {
          MessageBox.showMessageOnly(
              "图片数量不正确，最多需要（" + taskConfig.end.toString() + "张）", context);
          return;
        }
//        if(this.imageList.length < taskConfig.start || this.imageList.length > taskConfig.end){
//          // 数量范围提示
//          MessageBox.showMessageOnly("图片数量不正确，（" + taskConfig.start.toString() + "到"+ taskConfig.end.toString() + "张）",context);
//          return;
//        }
      }
    }
    dto.pictureNumber = this.imageList.length;
    List<PictureInfor> pics = new List();
    for (File f in this.imageList) {
//      File result = await FlutterImageCompress.compressAndGetFile(
//        f.absolute.path,
//        Directory.systemTemp.absolute.path + "/"+ f.path.substring(f.path.lastIndexOf("/")),
//        minWidth: 1024,
//        minHeight: 768,
//        quality: 94,
//        rotate: 180,
//      );
//      String bs64 = base64Encode(result.readAsBytesSync());
//      dto.imgbase64.add(bs64);

      var pic = new PictureInfor();
      pic.path = f.absolute.path;
      pic.targetPath = Directory.systemTemp.absolute.path +
          "/" +
          f.path.substring(f.path.lastIndexOf("/"));
      pics.add(pic);
    }

    // 调用接口保存处理信息
//    await savePorcessInfo(dto).then((resp){
//      if(resp.isOk()){
//        MessageBox.showMessageAndExitCurrentPage("保存成功！", true ,context);
//      }else{
//        MessageBox.showMessageOnly(resp.message,context);
//      }
//    });
    try {
      if (null == dto) {
        MessageBox.showMessageOnly("必填参数不能为空！", context);
      }

      try {
        var lst = await dbAccess().queryData(
            "select * from Tasks where id = '${this.widget.task.id}';");
        var jsonTask = json.decode(lst[0]['jsonTask'].toString());
        jsonTask['status'] = 1;
        var udRes = await dbAccess().excuteSql(
            "update Tasks set status = '已完成',jsonTask='${json.encode(jsonTask)}' where id = '${this.widget.task.id}';");
        if (udRes) {
          print('更新状态完成');
        } else {
          MessageBox.showMessageOnly("保存失败！", context);
          return;
        }
      } catch (e) {
        print(e);
        MessageBox.showMessageOnly("保存失败！", context);
        return;
      }

      var sql = new StringBuffer();
      sql.write("select * from FeedbackTask where id = '${this.widget.task.id}';");
      var lstF = await dbAccess().queryData(sql.toString());
      if (lstF != null && lstF.length > 0) {
        sql = new StringBuffer();
        sql.write("update ");
        sql.write(" FeedbackTask set");
        sql.write("  id = ?,");
        sql.write("  title = ?,");
        sql.write("  publishTime = ?,");
        sql.write("  executor = ?,");
        sql.write("  status = ?,");
        sql.write("  jsonData = ?,");
        sql.write("  jsonPictures = ?");
      } else {
        sql = new StringBuffer();
        sql.write("insert into ");
        sql.write("FeedbackTask");
        sql.write("(");
        sql.write("  id,");
        sql.write("  title,");
        sql.write("  publishTime,");
        sql.write("  executor,");
        sql.write("  status,");
        sql.write("  jsonData,");
        sql.write("  jsonPictures");
        sql.write(")");
        sql.write("values");
        sql.write("(");
        sql.write("  ?,");
        sql.write("  ?,");
        sql.write("  ?,");
        sql.write("  ?,");
        sql.write("  ?,");
        sql.write("  ?,");
        sql.write("  ?");
        sql.write(")");
      }
      var params = new List<dynamic>();
      params.add(this.widget.task.id);
      params.add(this.widget.task.title);
      params.add(this.initData.taskInfo.publishTime);
      params.add(this.widget.task.executor);
      params.add(this.widget.task.STATUS);
      params.add(dto.toString());
      params.add(pics.toString());
      dbAccess().excuteSql(sql.toString(), params).then((res) {
        if (res) {
          MessageBox.showMessageAndExitCurrentPage("保存成功！", true, context);
        } else {
          MessageBox.showMessageOnly("保存失败！", context);
        }
      });
    } catch (e) {
      print(e);
      MessageBox.showMessageOnly("保存失败！", context);
    }
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
    if (null == this.initData || null == this.initData.taskInfo) {
      return Scaffold(
          appBar: AppBar(
        title: Text(
          "任务处理",
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
          "任务处理",
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
            /*icon: Text(
              '取消',
              style: new TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),*/
            icon: Icon(
              Icons.save,
              color: Colors.red,
              size: 26.0,
            ),
            onPressed: () {
               saveData();
            },
          ),
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
                child: new Text(initData.taskInfo.title),
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
                  initData.taskInfo.publisherName,
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
                    initData.taskInfo.executor,
                    style: new TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  flex: 2,
                ),
              ],
            ),
          ),
//          onPressed: () {
//            Navigator.push(
//                context,
//                new MaterialPageRoute(
//                    builder: (context) => new ForwardPage(
//                          taskid: initData.taskInfo.id,
//                        )));
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
                child: new Text(DateUtil.timestampToDate(
                    initData.taskInfo.publishTime ?? 0)),
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
                child: new Text(DateUtil.timestampToDate(
                    initData.taskInfo.finishTime ?? 0)),
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
                  child: new Text(initData.taskDetails.length != 0
                      ? (initData.taskDetails[0].pointName ?? '')
                      : ""),
                  flex: 2,
                ),
              ],
            ),
          ),
        ),

        Offstage(
          offstage: initData.taskDetails.length != 0 ? false : true,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          ),
        ),

        Offstage(
          offstage: initData.taskDetails.length != 0 ? false : true,
          child: Container(
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
                child: new Text(initData.taskInfo.remark == null
                    ? ""
                    : initData.taskInfo.remark),
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
          child: new TouchCallBack(
              child: new Column(
                children: <Widget>[
                  Container(
                      color: Colors.white,
                      height: 50.0,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: new Row(
                                children: <Widget>[
                                  new Text(
                                    '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  new Text(
                                    '反馈信息',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(left: 10.0),
                            ),
                            flex: 8,
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                new Icon(
                                  Icons.message,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                new Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new FeedBackPage(
                            feedback: this.feedbackstr,
                          )),
                ).then((result) {
                  setState(() {
                    this.feedbackstr = result;
                    this._controller.text = result;
                  });
                }).catchError((error) {});
              }),
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
            child: TouchCallBack(
                child: new Container(
                    color: Colors.white,
                    height: 50.0,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: new Row(
                              children: <Widget>[
                                new Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                                new Text(
                                  '现场照片',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.only(left: 10.0),
                          ),
                          flex: 8,
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              new Icon(
                                Icons.photo_camera,
                                color: Colors.red,
                                size: 20,
                              ),
                              new Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.red,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              new ImageList(this.imageList))).then((result) {
                    setState(() {
                      print(result);
                      this.imageList = result;
                    });
                  });
                })),
      ]),
    );
  }
}

class TaskConfig {
  int end;
  int start;
  String isMust;
  String name;

  TaskConfig.fromParams({this.end, this.start, this.isMust, this.name});

  factory TaskConfig(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new TaskConfig.fromJson(json.decode(jsonStr))
          : new TaskConfig.fromJson(jsonStr);

  TaskConfig.fromJson(jsonRes) {
    end = jsonRes['end'];
    start = jsonRes['start'];
    isMust = jsonRes['isMust'];
    name = jsonRes['name'];
  }

  @override
  String toString() {
    return '{"end": $end,"start": $start,"isMust": ${isMust != null ? '${json.encode(isMust)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'}}';
  }
}

class PictureInfor {
  String path;
  String targetPath;

  @override
  String toString() {
    return '{"path": "$path","targetPath": "$targetPath"}';
  }
}
