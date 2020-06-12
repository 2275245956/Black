import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/Task/TaskModel.dart';
import 'package:intelligent_check_new/pages/task_detail/task_feedback_detail_screen.dart';
import 'package:intelligent_check_new/services/TaskServices.dart';
import 'package:intelligent_check_new/model/Task/ProcessInfo.dart';
import 'package:intelligent_check_new/tools/DateUtil.dart';

class ProcessingInfoPage extends StatefulWidget {
  final int taskid;
  final TaskModel taskData;
  ProcessingInfoPage({Key key, @required this.taskid, @required this.taskData}) : super(key: key);
  @override
  _ProcessingInfoPageState createState() => _ProcessingInfoPageState();
}

class _ProcessingInfoPageState extends State<ProcessingInfoPage> {
  List<ProssingInfo> initData = List();
  @override
  void initState() {
    getData();
    super.initState();
  }
  getData() async {
    await getProcessInfo(widget.taskid).then((data) {
      setState(() {
        initData = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "处理信息",
            style: TextStyle(color: Colors.black, fontSize: 19),
          ),
          centerTitle: true,
          elevation: 0.7,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child:
                  Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
            ),
          ),
        ),
        body: ListView.builder(
            padding: new EdgeInsets.all(5.0),
            itemCount: initData.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: BuildItem(index),
                onTap:(){
                  // TODO 目前会报错
                  Navigator.push( context,
                    new MaterialPageRoute(builder: (context) {
                      FeedBack feedback = this.widget.taskData.feedback.singleWhere((f) => f.id == initData[index].id);
                      return TaskFeecbackDetailPage(showfeedback: feedback,);
                    }));
                },
              );
            })
    );
  }

  Widget BuildItem(int index) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 5.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      left: 15.0, top: 20.0),
                  decoration: BoxDecoration(
                      border:
                          Border(left: BorderSide(color: Color(0xFFD6d6d6)))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        initData[index].messageType??"",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        //"2019-03-30   21:43   王多余",
                        initData.length!=0?DateUtil.timestampToDate(initData[index].feedbackTime ?? 0) + "  " + initData[index].userName:"",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "反馈信息:",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        //"软件页面无法开启",
                        initData.length!=0?initData[index].message:"",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0, right: 1.0),
                        child: Divider(
                          height: 0.5,
                          color: Color(0XFFd9d9d9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 8.0,
            top: 20.0,
          ),
          child: Icon(Icons.brightness_1, color: Colors.green),
        ),
      ],
    );
  }
}
