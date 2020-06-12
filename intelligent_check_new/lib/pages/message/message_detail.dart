import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/message/MessageDetail.dart';
import 'package:intelligent_check_new/services/message_service.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageDetailPage extends StatefulWidget{

  final MessageDetail messageDetail;
  MessageDetailPage(this.messageDetail);

  @override
  State<StatefulWidget> createState() {
    return _MessageDetailPageState();
  }
}

class _MessageDetailPageState extends State<MessageDetailPage>{

  String theme="";

  @override
  void initState() {
    super.initState();

    setRead();
    initConfig();
  }

  setRead() async{
    getMessgaeRead(this.widget.messageDetail.id);
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
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "消息详情",
            style: TextStyle(color: Colors.black, fontSize: 19),
          ),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context,this.widget.messageDetail==null?0:this.widget.messageDetail.id),
              child: Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
            ),
          ),
        ),
        body: Container(
            width: 280,
            padding: EdgeInsets.all(10),
            child: Text("${this.widget.messageDetail==null?"--":this.widget.messageDetail.body.replaceAll(r"<br />", "\r\n").replaceAll(r"<br>", "\r\n")}",maxLines: 10,overflow: TextOverflow.ellipsis,)
        ),
      ),
      onWillPop:  (){
        Navigator.pop(context,this.widget.messageDetail.id);
      }
    );
  }
}