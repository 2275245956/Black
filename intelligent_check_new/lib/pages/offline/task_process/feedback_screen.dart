import 'package:flutter/material.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';

class FeedBackPage extends StatefulWidget {
  final String feedback;
  FeedBackPage({Key key, @required this.feedback}) : super(key: key);
  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  TextEditingController _controller = new TextEditingController();
  String theme="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _controller.text = this.widget.feedback;
    });
    initConfig();
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "反馈信息",
            style: TextStyle(color: Colors.black, fontSize: 19),
          ),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
//        leading: new Container(
//          child: GestureDetector(
//            onTap: () => Navigator.pop(context),
//            child: Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
//          ),
//        ),
          leading:new Container(
            child: GestureDetector(
              onTap: (){
//              Navigator.pop(context,"back");
                if(this._controller.text != "" && this._controller.text != this.widget.feedback){
//                  MessageBox.showMessageOnly("内容发生变化是否退出?", context);
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => new AlertDialog(
                          title: Column(
                            children: <Widget>[
                              new Text("信息"),
                              Divider(height: 2),
                            ],
                          ),
                          content: Text("内容发生变化是否退出?"),
                          actions:<Widget>[
                            new FlatButton(
                              child:new Text("关闭",style: TextStyle(fontSize: 20,color: Colors.grey)), onPressed: (){
                              Navigator.of(context).pop();
                            },
                            ),
                            new FlatButton(
                              child:new Text("退出",style: TextStyle(fontSize: 20,color: Colors.grey)), onPressed: (){
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            ),
                          ]
                      )
                  ).then((v){
                    return v;
                  });
                }else{
                  Navigator.pop(context,this._controller.text);
                }
              },
              child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Text(
                '提交',
                style: new TextStyle(
                  color: GetConfig.getColor(theme),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              onPressed: () {
                //确认后的处理
                if (_controller.text != null)
                  Navigator.pop(context, _controller.text);
                else
                  Navigator.pop(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10.0),
            color: Colors.white,
            child: Container(
              height: 200,
              child: new TextField(
                maxLines: 10,
                autofocus: true,
                controller: _controller,
                textAlign: TextAlign.start,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.grey[200],
                  filled: true,
                  hintText: widget.feedback,
                  contentPadding: EdgeInsets.only(
                      left: 10.0, right: 10.0,top: 5),
                ),
//          decoration: new InputDecoration(
//            border: InputBorder.none,
//            //fillColor: Colors.grey[200],
//            //filled: true,
//            hintText: widget.feedback,
//
//            contentPadding: EdgeInsets.only(
//                left: 20.0, right: 20.0, top: 40.0, bottom: 40.0),
//          ),
              ),
            ),
          ),
        ),
        resizeToAvoidBottomPadding:true
    );
  }
}
