import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckExecute/ContactInfo.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/pages/my/contact/contact_item.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/widget/touch_callback.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactExapandPage extends StatefulWidget {
  final ContractInfo item;
  final LoginResult loginResult;

  ContactExapandPage(this.item,this.loginResult);

  @override
  _ContactExapandPageState createState() => _ContactExapandPageState();
}

class _ContactExapandPageState extends State<ContactExapandPage> {
  final TextEditingController _controller = new TextEditingController();
  List<ChildInfo> tmpItem = List();
  List<ChildInfo> pageData  = List();
  String theme="";
  var companyName = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      tmpItem = this.widget.item.children;
      pageData = this.widget.item.children;
    });
    initConfig();
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
        companyName=json.decode(preferences.getString("sel_com"))["companyName"];


      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: AppBar(
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Color(0xFFFFFFFF),
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.keyboard_arrow_left,
                  color: GetConfig.getColor(theme), size: 32),
            ),
          ),
          title: new  Container(
            height: 30,
            width: 250,
            padding: EdgeInsets.only(bottom: 5),
            decoration: new BoxDecoration(
              color: Colors.grey[100],
              borderRadius: new BorderRadius.all(Radius.circular(25.0)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5,right: 5,top:6),
                  child: Image.asset("assets/images/search_"+theme+".png",width: 20,color: Colors.black26),
                ),
                new Container(
//                  child:Align(
                  width: 190,
                  child:TextField(
                      controller: _controller,
//                  autofocus: true,
//                      focusNode: _focusNode,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          contentPadding:EdgeInsets.only(top: 8)
                      )
                  ),
//                  )
                )
              ],
            ),
          ),

//          new Container(
//            height: 40,
//            width: 350,
//            //padding: EdgeInsets.only(bottom: 15.0),
//            //margin: EdgeInsets.only(bottom: 5.0),
//            decoration: new BoxDecoration(
//              color: Colors.grey[100],
//              borderRadius: new BorderRadius.all(Radius.circular(30.0)),
//            ),
//            //child: new Container(
//            //margin: EdgeInsets.only(bottom: 15.0),
////                  child:Align(
//            //padding: EdgeInsets.only(bottom: 5.0),
//
//            child: Row(
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.only(left: 5,right: 5,top:8),
//                  child: Image.asset("assets/images/search_"+theme+".png",width: 20,color: Colors.black26),
//                ),
//                Container(
//                  width: 190,
//                  child: TextField(
//                      controller: _controller,
//                      autofocus: false,
//                      style: TextStyle(fontSize: 15.0, color: Colors.black),
//                      decoration: new InputDecoration(
////                    prefixIcon: new Icon(
////                      Icons.search,
////                      color: Colors.black26,
////                    ),
//                        /*suffixIcon: GestureDetector(
//                            onTap: () => _controller.text = "",
//                            child: new Icon(
//                              Icons.delete_forever,
//                              color: Colors.black26,
//                            )),*/
//                          border: InputBorder.none,
//                          hintText: "请输入搜索内容")),
//                )
//              ],
//            )
//
////                  )
//            //)
//          ),
          centerTitle: true,
          actions: <Widget>[
            Align(
                child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if(this._controller.text.isEmpty){
                      print(tmpItem.length);
                      pageData = tmpItem;
                    }else{
                      pageData =[];
                      tmpItem.forEach((f){
                        if(f.label.indexOf(this._controller.text) != -1){
                          pageData.add(f);
                        }
                      });
                    }
                  });
                },
                child: Text(
                  "搜索",
                  style: TextStyle(color: Colors.black26, fontSize: 18.0),
                ),
              ),
            ))
          ],
        ),
        body: SingleChildScrollView(
          child: new Column(children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 15.0),
              height: 30.0,
              color: Colors.white,
              child: new Row(
                children: <Widget>[
                  TouchCallBack(
                    child: Text(
                      companyName== null?"": companyName+"/",
                      style: TextStyle(color: GetConfig.getColor(theme)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(this.widget.item.name),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Divider(
                height: 0.5,
                color: Colors.grey,
              ),
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pageData.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    child: ContactItem(item: pageData[i]),
                  );
                }),
          ]),
        )
    );
  }
}
