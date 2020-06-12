import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/services/myinfo_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/tools/MessageBox.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';

class PswdChangePage extends StatefulWidget {
  @override
  _PswdChangePageState createState() => _PswdChangePageState();
}

class _PswdChangePageState extends State<PswdChangePage> {

  bool displayPassword1 = false;
  bool displayPassword2 = false;
  bool displayPassword3 = false;
  final TextEditingController _pswdinputcontroller =
      new TextEditingController();
  final TextEditingController _newpswdcontroller = new TextEditingController();
  final TextEditingController _checkpswdcontroller =
      new TextEditingController();

  LoginResult loginResult;

  bool isSavedPressed = false;

  bool isAnimating = false;

  String theme="";

  getData()  {
    SharedPreferences.getInstance().then((sp){
      String str= sp.get('LoginResult');
      setState(() {
        loginResult = LoginResult(str);
        this.theme = sp.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        //backgroundColor: KColorConstant.floorTitleColor,
        title: Text(
          '修改密码',
          style: new TextStyle(
            color: Colors.black,
//            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
        child: Form(
            child: ListView(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  '原密码',
                  style: new TextStyle(
//              fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                child: new Container(
                    decoration: new BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                      border: new Border.all(
//                        color: Colors.grey[300],
//                        width: 1,
//                      ),
                    ),
                    child: new Container(
                        child: new TextFormField(
                            controller: _pswdinputcontroller,
                            autofocus: false,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return '请输入密码';
                              }
                            },
                            style: TextStyle(fontSize: 18.0, color: Colors.black),
                            obscureText: !displayPassword1,
                            decoration: new InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    displayPassword1 = !displayPassword1;
                                  });
                                },
                                child: displayPassword1
                                    ? Image.asset(
                                  'assets/images/login/display_password_'+theme+'.png',
                                  scale: 1.2,
                                )
                                    : Image.asset(
                                  'assets/images/login/hide_password.png',
                                  scale: 1.2,
                                ),
                              ),
                              border: InputBorder.none,
                              hintText: '密码',
                              contentPadding: EdgeInsets.all(10.0),
                            )))),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  '新密码',
                  style: new TextStyle(
//              fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                child: new Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.grey[100],
//                      border: new Border.all(
//                        color: Colors.grey[300],
//                        width: 1,
//                      ),
                    ),
                    child: new Container(
                        child: new TextFormField(
                            controller: _newpswdcontroller,
                            autofocus: false,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return '请输入密码';
                              }
                            },
                            style: TextStyle(fontSize: 18.0, color: Colors.black),
                            obscureText: !displayPassword2,
                            decoration: new InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    displayPassword2 = !displayPassword2;
                                  });
                                },
                                child: displayPassword2
                                    ? Image.asset(
                                  'assets/images/login/display_password_'+theme+'.png',
                                  scale: 1.2,
                                )
                                    : Image.asset(
                                  'assets/images/login/hide_password.png',
                                  scale: 1.2,
                                ),
                              ),
                              border: InputBorder.none,
                              hintText: '密码',
                              contentPadding: EdgeInsets.all(10.0),
                            )))),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  '再次确认',
                  style: new TextStyle(
//              fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                child: new Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.grey[100],
//                      border: new Border.all(
//                        color: Colors.grey[300],
//                        width: 1,
//                      ),
                    ),
                    child: new Container(
                        child: new TextFormField(
                            controller: _checkpswdcontroller,
                            autofocus: false,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return '请输入密码';
                              }
                            },
                            style: TextStyle(fontSize: 18.0, color: Colors.black),
                            obscureText: !displayPassword3,
                            decoration: new InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    displayPassword3 = !displayPassword3;
                                  });
                                },
                                child: displayPassword3
                                    ? Image.asset(
                                  'assets/images/login/display_password_'+theme+'.png',
                                  scale: 1.2,
                                )
                                    : Image.asset(
                                  'assets/images/login/hide_password.png',
                                  scale: 1.2,
                                ),
                              ),
                              border: InputBorder.none,
                              hintText: '密码',
                              contentPadding: EdgeInsets.all(10.0),
                            )))),
              ),
            ])),
      ),
      persistentFooterButtons: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 170,
              height: 50,
              color: Color.fromRGBO(242, 246, 249, 1),
              child: MaterialButton(
                  onPressed: () {
                    if(isSavedPressed){
                      return;
                    }
                    setState(() {
                      //清空画面内输入值
                      _checkpswdcontroller.clear();
                      _newpswdcontroller.clear();
                      _pswdinputcontroller.clear();
                    });
                  },
                  child: Text("重置",
                      style: TextStyle(color: Colors.black,fontSize: 18)
                  )
              ),
            ),
            Container(
              width: 170,
              height: 50,
              color: GetConfig.getColor(theme),
              child: isSavedPressed?
              MaterialButton(
                onPressed: () {
                },
                child: Text("确定",
                    style: TextStyle(color: Colors.white,fontSize: 18)
                ),
              ):MaterialButton(
                onPressed: () {
                  if(_newpswdcontroller.text.isEmpty ||
                      _checkpswdcontroller.text.isEmpty || _pswdinputcontroller.text.isEmpty){
                    MessageBox.showMessageOnly("请输入原密码和新密码再进行修改操作！", context);
                    return;
                  }
                  if(_newpswdcontroller.text !=  _checkpswdcontroller.text){
                    MessageBox.showMessageOnly("两次密码输入不一致，请确认后重新输入！", context);
                    return;
                  }
                  changPWD();
                },
                child: Text("确定",
                    style: TextStyle(color: Colors.white,fontSize: 18)
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  changPWD()async{
    setState(() {
      isSavedPressed = true;
      isAnimating = true;
    });
    ChangePswd(_newpswdcontroller.text, _pswdinputcontroller.text, loginResult.user.id).then((data){
      setState(() {
        isSavedPressed = false;
        isAnimating = false;
      });
      if(data.success){
        MessageBox.showMessageAndExitCurrentPage(data.message, true, context);
      }else{
        MessageBox.showMessageOnly(data.message, context);
      }
    });
  }
}
