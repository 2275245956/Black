import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/widget/touch_callback.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';

class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  var userCompany="";
  var department="";
  LoginResult loginResult;
  String theme="";

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData()  {

    SharedPreferences.getInstance().then((sp){

      setState(() {
        String str= sp.get('LoginResult');
        userCompany= (sp.getString("sel_com")==null || sp.getString("sel_com")=="")?"--":json.decode(sp.getString("sel_com"))["companyName"];;
        if(sp.getString("sel_dept")!=null && sp.getString("sel_dept")!="")
          department= json.decode(sp.getString("sel_dept"))["departmentName"];
        loginResult = LoginResult(str);
        this.theme = sp.getString("theme")??KColorConstant.DEFAULT_COLOR;

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(loginResult==null){
      return Scaffold(
          backgroundColor: Color.fromRGBO(242, 246, 249, 1),
          appBar: new AppBar(
            backgroundColor: Colors.white,
            elevation: 0.2,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color:GetConfig.getColor(theme),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Text(
              '我的信息',
              style: new TextStyle(
                color: Colors.black,
//              fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
//              IconButton(
//                icon: Text(
//                  '确定',
//                  style: new TextStyle(
//                    color: GetConfig.getColor(theme),
////                  fontWeight: FontWeight.bold,
//                    fontSize: 16.0,
//                  ),
//                ),
//                onPressed: () {
//                  //确认后的处理
//                  Navigator.pop(context);
//                },
//              ),
            ],
          ),
          body:Text(""));
    }
    return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 0.2,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color:GetConfig.getColor(theme),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            '我的信息',
            style: new TextStyle(
              color: Colors.black,
//              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
//            IconButton(
//              icon: Text(
//                '确定',
//                style: new TextStyle(
//                  color: GetConfig.getColor(theme),
////                  fontWeight: FontWeight.bold,
//                  fontSize: 16.0,
//                ),
//              ),
//              onPressed: () {
//                //确认后的处理
//                Navigator.pop(context);
//              },
//            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            //头像部分
            TouchCallBack(
              onPressed: () {
//                Navigator.push(
//                  context,
//                  new MaterialPageRoute(
//                      builder: (context) => new HeadChangePage()),
//                );
                //到换头像页面
              },
              child: Container(
                //margin: const EdgeInsets.only(top: 0.0),
                color: Colors.white,
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //图标或图片
                    Container(
                      width: 220.0,
                      height: 32.0,
                      child: Text(
                        '头像',
                        style: TextStyle(
                            fontSize: 16.0,
//                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      padding: const EdgeInsets.only(left: 10.0),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 80.0),
//                      child: Image.asset(
//                        'assets/images/icons/head.png',
//                      ),
                      child: CircleAvatar(
                        backgroundColor: GetConfig.getColor(theme),
                        child: Text(loginResult == null
                            ? ""
                            : loginResult.user.name[0],style: TextStyle(color: Colors.white),),
                      ),

//                      CircleAvatar(child:Text(loginResult.user.name==null?"":loginResult.user.name[0])),
                      //Image.network(myInfo.avantatUrl),
                      margin: const EdgeInsets.all(5.0),
                    ),
                    //标题
                    //右侧icon
//                    Container(
//                      child: Image.asset(
//                        'assets/images/icons/righticon.png',
//                        color: Colors.blueAccent,
//                      ),
//                    ),
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
            Container(
              color: Colors.white,
              height: 50.0,
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: new Text(
                        '姓名',
                        style: TextStyle(
                            fontSize: 15.0,
//                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      padding: const EdgeInsets.only(left: 10.0),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                   // child: new Text(myInfo.username),
                    child: new Text(loginResult.user.name==null?"":loginResult.user.name),
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
//            Container(
//              color: Colors.white,
//              height: 50.0,
//              child: new Row(
//                children: <Widget>[
//                  Expanded(
//                    child: Container(
//                      child: new Text(
//                        '性别',
//                        style: TextStyle(
//                            fontSize: 15.0,
////                            fontWeight: FontWeight.bold,
//                            color: Colors.black),
//                      ),
//                      padding: const EdgeInsets.only(left: 10.0),
//                    ),
//                    flex: 1,
//                  ),
//                  Expanded(
//                    child: new Text(""),
//                    flex: 2,
//                  ),
//                ],
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//              child: Divider(
//                height: 0.5,
//                color: Color(0XFFd9d9d9),
//              ),
//            ),
            Container(
              color: Colors.white,
              height: 50.0,
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: new Text(
                        '部门',
                        style: TextStyle(
                            fontSize: 15.0,
//                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      padding: const EdgeInsets.only(left: 10.0),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    //child: new Text(myInfo.userdepartment),
                    child: new Text(department==""?"--":department),
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
                        '账号',
                        style: TextStyle(
                            fontSize: 15.0,
//                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      padding: const EdgeInsets.only(left: 10.0),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    //child: new Text(myInfo.userid.toString()),
                    child: new Text(loginResult.user.userName==null?"":loginResult.user.userName),
                    flex: 2,
                  ),
                ],
              ),
            ),
      /*      Padding(
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
                        '邮箱',
                        style: TextStyle(
                            fontSize: 15.0,
//                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      padding: const EdgeInsets.only(left: 10.0),
                    ),
                    flex: 1,
                  ),
                  Expanded(

                    child: new Text(
                        loginResult.user.email == null?"":loginResult.user.email),
                    flex: 2,
                  ),
                ],
              ),
            ),*/
          ],
        ));
  }
}
