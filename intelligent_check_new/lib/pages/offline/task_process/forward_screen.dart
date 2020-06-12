import 'package:flutter/material.dart';
import 'package:intelligent_check_new/pages/inspection_record/contact.dart';
import 'package:intelligent_check_new/services/TaskServices.dart';
class ForwardPage extends StatefulWidget {
  final int taskid;
  ForwardPage({Key key, @required this.taskid}) : super(key: key);
  @override
  _ForwardPageState createState() => _ForwardPageState();

}

class _ForwardPageState extends State<ForwardPage> {
  TextEditingController _controller = new TextEditingController();
  String _contactName="";
  String  _contactId = "";
  bool isSavedPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "转发",
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
          isSavedPressed?
          IconButton(
            icon: Text(
              '提交',
              style: new TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            onPressed: () {
            },
          ):IconButton(
            icon: Text(
              '提交',
              style: new TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            onPressed: () {
              //确认后的处理
              /* if (_controller.text != null)
                Navigator.pop(context, _controller.text);
              else
                Navigator.pop(context);*/
              if(widget.taskid <= 0 || _contactId ==""){
                showAlertMessageOnly("任务或者转发人信息不存在，不能进行转发操作！","fail");
                return;
              }

              setState(() {
                isSavedPressed = true;
              });
              getForward(widget.taskid, _contactId).then((data){
                setState(() {
                  isSavedPressed = false;
                });
                if(data){
                  showAlertMessageOnly("数据保存成功！","ok");
                }else{
                  showAlertMessageOnly("数据保存失败！","fail");
                }
              });
//             Navigator.pop(context);
            },
          ),
        ],
      ),
      body:SingleChildScrollView(
        child:  Container(
          padding: EdgeInsets.all(10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 200,
                  color: Colors.white,
                  child: new TextField(
                    maxLines: 10,
                    controller: _controller,
                    textAlign: TextAlign.start,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.grey[200],
                      filled: true,
                      //hintText: widget.feedback,
                      contentPadding: EdgeInsets.only(
                          left: 10.0, right: 10.0,top: 5),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15),),
                Row(
                  children: <Widget>[
                    Text("*",style: TextStyle(color: Colors.red)),
                    Text("  执行人员"),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 5),),
                GestureDetector(
                  child:  Container(
                    height: 40,
                    //width: 340,
                    padding: EdgeInsets.only(bottom: 5),
                    decoration: new BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding:EdgeInsets.only(left: 5),
                          child: Text(_contactName),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child:  Icon(Icons.keyboard_arrow_right,size: 14,color: Colors.red,),
                        )
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.push( context,
                        new MaterialPageRoute(builder: (context) {
                          return Contact();
                        })).then((value){
                      setState(() {
                        _contactName = value.name;
                        _contactId = value.value;
                        //              print(_contactId);
                        //print(widget.taskid);
                      });
                    });
                  },
                ),
              ]
          ),
        ),
      ),
        resizeToAvoidBottomPadding:false
    );
  }

  showAlertMessageOnly(String text,String status) async{
    showDialog(
        context: context,
        barrierDismissible:false,
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
                if(status == "ok"){
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
