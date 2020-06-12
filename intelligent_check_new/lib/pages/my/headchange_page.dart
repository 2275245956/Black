import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/widget/touch_callback.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeadChangePage extends StatefulWidget {
  @override
  _HeadChangePageState createState() => _HeadChangePageState();
}

class _HeadChangePageState extends State<HeadChangePage> {

  String theme="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        //backgroundColor: KColorConstant.floorTitleColor,
        title: Text(
          '头像',
          style: new TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.linear_scale,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              //Navigator.pop(context);
              showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TouchCallBack(
                          onPressed: () {
                            //处理
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20.0,top: 20.0),
                            height:60.0,
                            child: Text('从手机相册选择',
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Divider(
                            height: 0.5,
                            color: Color(0XFFd9d9d9),
                          ),
                        ),
                        TouchCallBack(
                          onPressed: () {
                            //处理
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20.0,top: 20.0),
                            height:60.0,
                            child: Text('保存到手机',
                              style: new TextStyle(
                                  color: Colors.black,
                                fontSize: 18.0,
                              ),),
                          ),
                        )
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body:new Center(
        child: new Image.asset('assets/images/icons/head.png'),
      ),
    );
  }

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
}
