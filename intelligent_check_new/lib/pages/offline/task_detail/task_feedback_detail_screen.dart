import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageListView.dart';
import 'package:intelligent_check_new/widget/touch_callback.dart';
import 'package:intelligent_check_new/model/Task/TaskModel.dart';

class TaskFeecbackDetailPage extends StatefulWidget {
  FeedBack showfeedback;
  TaskFeecbackDetailPage({Key key, @required this.showfeedback}) : super(key: key);
  @override
  _TaskFeecbackDetailPage createState() => _TaskFeecbackDetailPage();
}

class _TaskFeecbackDetailPage extends State<TaskFeecbackDetailPage> {
  TextEditingController _controller = new TextEditingController();

  void initState() {
    super.initState();
  }

  List<Image> convertBase642File(List<String> picBase64List){
    List<Image> result = new List();
    picBase64List.forEach((s){
      result.add(Image.memory(base64Decode(s)));
    });
    return result;
  }


  @override
  Widget build(BuildContext context) {
    if(this.widget.showfeedback == null){
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "反馈详情",
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
//
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "反馈详情",
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
      ),

      body: ListView(children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              new TouchCallBack(
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
                                flex: 5,
                              ),
                            ],
                          )),
                      new Container(
                        color: Colors.white,
                        margin: EdgeInsets.all(20.0),
                        child: TextField(
                          enabled: false,
                          controller: _controller,
                          textAlign: TextAlign.start,
                          maxLines: 4,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintText: null != this.widget.showfeedback ? this.widget.showfeedback.message : "",
                            contentPadding: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 40.0, bottom: 40.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
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
                          flex: 5,
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              new Icon(
                                Icons.camera_alt,
                                color: Colors.red,
                                size: 16,
                              ),
                              new Icon(
                                Icons.chevron_right,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          flex: 1,
                        ),
                      ],
                    )),
                onPressed: () {
                  Navigator.push(context,
                      new MaterialPageRoute(
                          builder: (context) => new ImageListView(
                              convertBase642File(null != this.widget.showfeedback ? this.widget.showfeedback.feedbackPics : [])
                          )
                      )
                  );
                })
        ),
      ]),
    );
  }
}
