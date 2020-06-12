import 'package:flutter/material.dart';

class MessageBox{

  // 显示消息
  static showMessageOnly(String text,BuildContext context) async{
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
            content: Text(text),
            actions:<Widget>[
              new FlatButton(
                child:new Text("关闭",style: TextStyle(fontSize: 20,color: Colors.grey)), onPressed: (){
                Navigator.of(context).pop();
              },
              ),
            ]
        )
    ).then((v){
      return v;
    });
  }
  // status == true ,退出当前页面
  static showMessageAndExitCurrentPage(String text,bool status,BuildContext context) async{
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
            content: Text(text),
            actions:<Widget>[
              new FlatButton(
                child:new Text("关闭",style: TextStyle(fontSize: 20,color: Colors.grey)), onPressed: (){
                  Navigator.of(context).pop();
                  if(status){
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

  static showMessageWithAction(String text,BuildContext context,Function action) async{
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
            content: Text(text),
            actions:<Widget>[
              new FlatButton(
                child:new Text("关闭",style: TextStyle(fontSize: 20,color: Colors.grey)), onPressed: (){
                Navigator.of(context).pop();
              },
              ),
            ]
        )
    ).then((v){
      action();
    });
  }
}