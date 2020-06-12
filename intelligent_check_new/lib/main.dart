import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/constants/system_config.dart';
import 'package:intelligent_check_new/pages/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intelligent_check_new/services/CommonService.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';

//void main() => runApp(MyApp());
Color globalTheme;
void main() async{
//  await getConfig().then((config){
//    String theme = config.firstWhere((f)=>f.name=="theme").attribute;
//    if(theme == null || theme.isEmpty){
//      theme= KColorConstant.DEFAULT_COLOR;
//    }
//    SharedPreferences.getInstance().then((pref){
//      pref.setString("theme", theme);
//      if(theme == "blue"){
//        pref.setString("globalTheme", "blue");
//      }else{
//        pref.setString("globalTheme", "red");
//      }
//    });
//  }).then((f){
//    // 启动app
//    runApp(MyApp());
//  }).catchError((e){
//    SharedPreferences.getInstance().then((pref){
//      pref.setString("theme", KColorConstant.DEFAULT_COLOR);
//      pref.setString("globalTheme", KColorConstant.DEFAULT_COLOR);
//    }).then((f){
//      runApp(MyApp());
//    });
//  });

  SharedPreferences.getInstance().then((pref){
    pref.setString("theme", "blue");
//    pref.setString("globalTheme", "blue");
  }).then((v){
    runApp(MyApp());
  });

}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp>{

  Color globalTheme;

  @override
  void initState() {
    super.initState();
    globalTheme = SystemConfig.THEME_COLOR;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智能巡检',
      theme: ThemeData(
        primarySwatch: globalTheme,
      ),
      debugShowCheckedModeBanner: true,
      home: SplashScreen(),
      localizationsDelegates: [                             //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [                                   //此处
        const Locale('zh','CH'),
        const Locale('en','US'),
      ],
    );
  }
}


