import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckExecute/ContactInfo.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/widget/touch_callback.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contactinfo extends StatefulWidget {
  final ChildInfo info;

  Contactinfo({
    Key key,
    @required this.info,
  }) : super(key: key);

  @override
  _ContactinfoState createState() => _ContactinfoState();
}

class _ContactinfoState extends State<Contactinfo> {

  String theme="";

  @override
  void initState() {
    super.initState();
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
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 0.2,
          leading:  new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.keyboard_arrow_left,
                  color: GetConfig.getColor(theme), size: 32),
            ),
          ),
          //backgroundColor: KColorConstant.floorTitleColor,
          title: Text(
            '联系人信息',
            style: new TextStyle(
              color: Colors.black,
//              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            //头像部分
            TouchCallBack(
              onPressed: () {},
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
                      child: new CircleAvatar(
                        radius: 15.0,
//                        backgroundColor: Colors.blue,
                        child: Text(widget.info.name[0])
                      ),
                      margin: const EdgeInsets.all(5.0),
                    ),
                    //标题
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
                    child: new Text(widget.info.name??""),
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
//                    // TODO：未提供
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
                    child: new Text(widget.info.departmentName??"--"),
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
                        '电话',
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
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                      // TODO：未提供
                        new Text(widget.info.telephone??""),
//                        Container(
//                          child: IconButton(
//                              icon: new Icon(
//                                Icons.call,
//                                color: Colors.red,
//                              ),
//                              onPressed: null),
//                        ),
                      ],
                    ),
                    flex: 2,
                  ),
                  //右侧icon
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
//                        '邮箱',
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
//                    // TODO：未提供
//                    child: new Text(this.widget.info.email??""),
//                    flex: 2,
//                  ),
//                ],
//              ),
//            ),
          ],
        ));
  }
}
