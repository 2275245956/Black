import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'dart:async';
import 'package:intelligent_check_new/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String theme="";

//  _SplashScreenState(){
//    getSystemConfig();
//  }

  @override
  void initState() {

    super.initState();
    getTheme();
//    getSystemConfig();

    //加载页面停留两秒
    new Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (context) => LoginPage(
                  //title: "home page",
                  )),
          (route) => route == null);
    });
  }

//  initConfig() async{
//    SharedPreferences.getInstance().then((preferences){
//      setState(() {
//        this.theme = preferences.getString("theme");
//      });
//      return theme;
//    }).then((theme){
//      if(theme== null || theme.isEmpty){
//        getSystemConfig();
//      }
//    });
//  }

//  getSystemConfig() async{
//    try{
//      await getConfig().then((config){
//        // 保存配置
//        setState(() {
//          theme = config.firstWhere((f)=>f.name=="theme").attribute;
//          if(theme == null || theme.isEmpty){
//            theme=KColorConstant.DEFAULT_COLOR;
//          }
////          theme="";
//        });
////        String logo = config.firstWhere((f)=>f.name=="logo").attribute;
////        String themeTimestamp = config.firstWhere((f)=>f.name=="timestamp").attribute;
//
//        SharedPreferences.getInstance().then((pref){
//          pref.setString("theme", theme);
////          pref.setString("logo", logo);
////          pref.setString("themeTimestamp", themeTimestamp);
//        });
//      });
//    }catch(e){
//
//      print("服务器访问异常！");
//
////      setState(() {
//        theme=KColorConstant.DEFAULT_COLOR;
////      });
//
//      SharedPreferences.getInstance().then((pref){
//        pref.setString("theme", KColorConstant.DEFAULT_COLOR);
//      });
//    }
//  }

  // 获取主题
  getTheme() async{
    await SharedPreferences.getInstance().then((pref){
      setState(() {
        this.theme = pref.getString("theme")??KColorConstant.DEFAULT_COLOR; //pref.get("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

//    getSystemConfig();
    if(theme== null || theme.isEmpty){
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
        ),
      );
    }

//    print("theme--->$theme");
    return Scaffold(
//        color: Colors.red,
      body: Container(
        child: theme==null || theme.isEmpty?
            Image.asset(
              "assets/images/splash_"+KColorConstant.DEFAULT_COLOR+".png",
              fit: BoxFit.fitHeight,
              height: 2000,
            ):Image.asset(
          "assets/images/splash_"+theme+".png",
          fit: BoxFit.fitHeight,
          height: 2000,
        ),
      ),
    );
  }
}
