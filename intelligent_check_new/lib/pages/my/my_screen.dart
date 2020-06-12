import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/UserAuthModel.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/login_page.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/widget/My_scteen_item.dart';
import 'package:intelligent_check_new/widget/touch_callback.dart';
import 'package:intelligent_check_new/pages/my/myinfo_page.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/services/myinfo_services.dart';
import 'package:package_info/package_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:permission_handler/permission_handler.dart';

//我的页面
//qi 2019.03.03

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  LoginResult loginResult;
  String version;
  bool isOffline = false;
  bool isGPSON = false;
  List<String> myScreenAuth;

  String theme = "";
  num catchSize = 0.0;
  var userCompany = "";
  var deptName = "";
  UserShowAuth auth;

  @override
  void didUpdateWidget(MyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    SharedPreferences.getInstance().then((sp) {
      userCompany =
          (sp.getString("sel_com") == null || sp.getString("sel_com") == "")
              ? "--"
              : json.decode(sp.getString("sel_com"))["companyName"];
      deptName =
          (sp.getString("sel_dept") == null || sp.getString("sel_dept") == "")
              ? "--"
              : json.decode(sp.getString("sel_dept"))["departmentName"];

      String str = sp.get('LoginResult');
      if (mounted) {
        setState(() {
          loginResult = LoginResult(str);
          this.theme = sp.getString("theme") ?? KColorConstant.DEFAULT_COLOR;

          isGPSON = sp.getBool("isGPSON") ?? false;
          if (AmapLocation == null) {
            isGPSON = false;
          }
        });
      }
      if (sp.getBool("offline") != null) {
        if (mounted) {
          setState(() {
            isOffline = sp.getBool("offline");
          });
        }
      }

      var showAuthJson = sp.getString("user_show");
      if (showAuthJson != "" && showAuthJson != null) {
        //拿到工作台下的功能模块权限
        this.auth = new UserShowAuth.fromJson(json.decode(showAuthJson))
            .children
            .firstWhere((f) => f.frontComponent == "my");
        if (auth!=null && auth.children != null && auth.children.length > 0) {
          myScreenAuth = new List();
          for (UserShowAuth au in auth.children) {
            myScreenAuth.add(au.frontComponent);
          }
        }
      }
    });

    PackageInfo.fromPlatform().then((packageInfo) {
      if (mounted) {
        setState(() {
          version = packageInfo.version;
        });
      }
    });

    getDatabasesPath().then((dbPath) {
      SharedPreferences.getInstance().then((sp) {
        String str = sp.get('LoginResult');
        String myDbPath = join(dbPath, '${LoginResult(str).user.id}', 'my.db');
        File(myDbPath).exists().then((exists) {
          if (exists) {
            print("DB Path exists:$myDbPath");
            File(myDbPath).length().then((size) {
              print("$myDbPath:$size");
              catchSize = size;
            });
          } else {
            print("DB Path not exists:$myDbPath");
            catchSize = 0;
          }
        });
      });
    });
  }

  clearCatch() {
    if (!mounted) return;
    setState(() {
      catchSize = 0;
    });
  }

  opLocation(context) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);

    // 申请结果
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    //获取定位是否打开
    ServiceStatus serviceStatus =
        await PermissionHandler().checkServiceStatus(PermissionGroup.location);
    //未打开GPS
    if (serviceStatus == ServiceStatus.disabled) {
      HiddenDangerFound.popUpMsg('请检测GPS是否开启！');
      setState(() {
        isGPSON = false;
      });
      return false;
    } else {
      if (permission == PermissionStatus.granted) {
        HiddenDangerFound.popUpMsg("GPS已开启，正在发送位置信息....");
        await SharedPreferences.getInstance().then((sp) {
          setState(() {
            isGPSON = true;
          });
          sp.setBool("isGPSON", true);
        });

        await for (final location in AmapLocation.listenLocation()) {
          location.latLng.then((val) {
            //判断是否有权限
            PermissionHandler()
                .checkServiceStatus(PermissionGroup.location)
                .then((status) {
              PermissionHandler()
                  .checkPermissionStatus(PermissionGroup.location)
                  .then((auth) {
                if (status != ServiceStatus.disabled &&
                    auth == PermissionStatus.granted) {
                  SharedPreferences.getInstance().then((sp) {
                    userCompany = (sp.getString("sel_com") == null ||
                            sp.getString("sel_com") == "")
                        ? "--"
                        : json.decode(sp.getString("sel_com"))["companyName"];
                    deptName = (sp.getString("sel_dept") == null ||
                            sp.getString("sel_dept") == "")
                        ? "--"
                        : json
                            .decode(sp.getString("sel_dept"))["departmentName"];

                    String str = sp.get('LoginResult');
                    loginResult = LoginResult(str);

                    UpGPSData(val.longitude, val.latitude, loginResult);
                  });
                } else {
                  closeLocation();
                }
              });
            });
          });
        }
      } else {
        showDialog(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('提示'),
                content: Text('没有开启定位权限！'),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      '取消',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    onPressed: () {
                      if (!mounted) return;
                      setState(() {
                        isGPSON = false;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text('去开启', style: TextStyle(fontSize: 18)),
                    onPressed: () {
                      PermissionHandler().openAppSettings().then((value) {
                        if (!mounted) return;
                        setState(() {
                          if (!value) {
                            isGPSON = false;
                          } else {
                            isGPSON = true;
                          }
                        });
                        Navigator.pop(context);
                        //开启后重新获取位置
                        opLocation(context);
                      });
                    },
                  ),
                ],
                backgroundColor: Colors.white,
                elevation: 20,
                // 设置成 圆角
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              );
            });
      }
    }
  }

  // ignore: non_constant_identifier_names
   UpGPSData(double lng, double lat, LoginResult loginResult) {
    var jsonData = {
      "userId": loginResult.user.id,
      "userName": loginResult.user.userName,
      "deptCompany": deptName ?? userCompany,
      "telephone": loginResult.user.mobile,
      "longitude": "$lng",
      "latitude": "$lat"
    };
    print("<=========================${loginResult.user.userName}==========================>");
    gpsAddNewRoute(jsonData).then((_) {
      print(_.message);
    });
  }

  closeLocation() async {
    await SharedPreferences.getInstance().then((sp) {
      if (AmapLocation != null) {
        AmapLocation.stopLocation().then((_) {
          AmapLocation.dispose();
          HiddenDangerFound.popUpMsg("GPS已关闭，停止发送位置信息....");
        });
        print("close   Location");

        setState(() {
          isGPSON = false;
          sp.setBool("isGPSON", false);
        });
      } else {
        setState(() {
          isGPSON = false;
          sp.setBool("isGPSON", false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (theme.isEmpty) {
      return Scaffold(
        body: Text(""),
      );
    }
    return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.2,
          //backgroundColor: KColorConstant.floorTitleColor,
          title: Text(
            '我的',
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
            Container(
              //margin: const EdgeInsets.only(top: 0.0),
              color: Colors.white,
              height: 60.0,
              child: TouchCallBack(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
//                    Container(
//                      margin: const EdgeInsets.only(left: 12.0, right: 15.0),
//                      child: Image.asset(
//                        "assets/images/icons/head.png",
//                        width: 70.0,
//                        height: 70.0,
//                      ),
//                      //Image.network(myinfo.avantarUrl),
//                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: CircleAvatar(
                        backgroundColor: GetConfig.getColor(theme),
                        child: Text(
                          loginResult == null ? "" : loginResult.user.name[0],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            //myInfo.username,
                            loginResult == null ? "" : loginResult.user.name,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Color(0Xff353535),
                            ),
                          ),
                          Text(
                            userCompany,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Color(0Xffa9a9a9),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new MyInfoPage(),
                      )
                      //点击进入个人信息详细页面
                      );
                },
              ),
            ),
            //列表项，使用自定义ImItem
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  //修改密码
                  ImItem(
                    iconPath:
                        "assets/images/my/modify_password_" + theme + ".png",
                    title: '修改密码',
                    righticonPath: "assets/images/icons/righticon.png",
                    subtext: '',
                    theme: theme,
                  ),
                  //分割线
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Divider(
                      height: 0.5,
                      color: Color(0XFFd9d9d9),
                    ),
                  ),
                  //通讯录
                  ImItem(
                    iconPath: "assets/images/my/contact_" + theme + ".png",
                    title: '通讯录',
                    righticonPath: "assets/images/icons/righticon.png",
                    subtext: '',
                    theme: theme,
                  ),
                  //分割线
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Divider(
                      height: 0.5,
                      color: Color(0XFFd9d9d9),
                    ),
                  ),
                  //消息订阅
                  ImItem(
                    iconPath: "assets/images/my/message_" + theme + ".png",
                    title: '消息订阅',
                    righticonPath: "assets/images/icons/righticon.png",
                    subtext: '',
                    theme: theme,
                  ),
                  //分割线
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Divider(
                      height: 0.5,
                      color: Color(0XFFd9d9d9),
                    ),
                  ),
                  // TODO:暂时出去离线模式和清除缓存
                  //离线模式
                  (myScreenAuth!=null &&myScreenAuth.contains("offlineMode"))? ImItem(
                    iconPath: "assets/images/my/offline_" + theme + ".png",
                    title: '离线模式',
                    righticonPath: "assets/images/icons/righticon.png",
                    //动态获取
                    subtext: isOffline ? "已开启" : "未开启",
                    theme: theme,
                  ):Container(),
                  //分割线
                  (myScreenAuth!=null &&myScreenAuth.contains("offlineMode"))? Container():Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Divider(
                      height: 0.5,
                      color: Color(0XFFd9d9d9),
                    ),
                  ),
                  //清除缓存
                  ImItem(
                    iconPath: "assets/images/my/clean_" + theme + ".png",
                    title: '清除缓存',
                    righticonPath: '',
                    //动态获取
                    subtext: (catchSize / 1000000).toStringAsFixed(2) + "M",
                    theme: theme,
                    callback: clearCatch,
                  ),
//                  )),
                  //分割线
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Divider(
                      height: 0.5,
                      color: Color(0XFFd9d9d9),
                    ),
                  ),
                  //当前版本
                  ImItem(
                    iconPath: "assets/images/my/version_" + theme + ".png",
                    title: '当前版本',
                    righticonPath: '',
                    //动态获取
                    subtext: version ?? "",
                    theme: theme,
                  ),
                  //分割线
                  (myScreenAuth!=null &&myScreenAuth.contains("gps"))? Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Divider(
                      height: 0.5,
                      color: Color(0XFFd9d9d9),
                    ),
                  ):Container(),

                  (myScreenAuth!=null &&myScreenAuth.contains("gps"))?Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 18),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 0,
                            child: Icon(
                              isGPSON ? Icons.location_on : Icons.location_off,
                              color: GetConfig.getColor(theme),
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                "GPS定位",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                              ),
                            ),
                            flex: 11,
                          ),
                          Expanded(
                            child: Switch(
                              value: this.isGPSON, //当前状态
                              activeColor: GetConfig.getColor(theme),
                              onChanged: (value) {
                                if (!isGPSON) {
                                  opLocation(context);
                                } else {
                                  closeLocation();
                                }
                              },
                            ),
                            flex: 3,
                          ),
                        ],
                      )):Container(),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
              color: GetConfig.getColor(theme),
              width: 330,
              child: new MaterialButton(
                onPressed: () {
                  //关闭GPS

                  Logout();
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => route == null);
                },
                child: new Text(
                  "退出登录",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ));
  }
}
