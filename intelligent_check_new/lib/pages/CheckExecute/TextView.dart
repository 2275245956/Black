import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextView extends StatefulWidget{

  final String text;
  final bool readonly;
  TextView({this.text,this.readonly = false});

  @override
  State<StatefulWidget> createState() {
    return _TextView();
  }
}

class _TextView extends State<TextView>{

  TextEditingController _textEditingController = TextEditingController();
  String theme="";

  @override
  void initState() {
    super.initState();
    this.widget.text == null || this.widget.text.isEmpty?_textEditingController.text=""
                  :_textEditingController.text=this.widget.text;
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
    if(this.theme.isEmpty){
      return Scaffold(
          body:Text("")
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("备注说明",style: TextStyle(color: Colors.black,fontSize: 19),),
        centerTitle: true,
        elevation: 0.7,
        brightness: Brightness.light,
        backgroundColor:  Colors.white,
        leading:new Container(
          child: GestureDetector(
            onTap: (){
//              Navigator.pop(context,"back");
                if(this._textEditingController.text != "" && this._textEditingController.text != this.widget.text){
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
                  Navigator.pop(context,this._textEditingController.text);
                }
              },
            child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
          ),
        ),
        actions: <Widget>[
          (this.widget.readonly) ?  Container() : IconButton(
            icon: Icon(Icons.save),color: GetConfig.getColor(theme),onPressed: (){
            Navigator.pop(context,this._textEditingController.text);
          },)
        ],
      ),
      body: SingleChildScrollView(
        child: this.widget.readonly?Container(
            padding: EdgeInsets.only(
                left: 10.0, right: 10.0,top: 5),
                child: Text(this.widget.text),
        ):
        Container(
          child: TextField(
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp(
                  "[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]")), //只能输入汉字或者字母或数字
            ],
            maxLines: 10,
            autofocus: true,
            controller: _textEditingController,
            decoration: new InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.grey[200],
              filled: true,
              //hintText: widget.feedback,
              contentPadding: EdgeInsets.only(
                  left: 10.0, right: 10.0,top: 5),
            ),
          ),
          margin: EdgeInsets.all(10),
        ),
      ),
        resizeToAvoidBottomPadding:true
    );
  }
}