import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CompanyInfo.dart';
import 'package:intelligent_check_new/model/Config.dart';
import 'package:intelligent_check_new/model/UserAuthModel.dart';
import 'package:intelligent_check_new/model/version.dart';
import 'package:intelligent_check_new/pages/SelCompanyAndDept.dart';
import 'package:intelligent_check_new/pages/custom_setting_page.dart';
import 'package:intelligent_check_new/pages/navigation_keep_alive.dart';
import 'package:intelligent_check_new/services/CommonService.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/services/company_services.dart';
import 'package:intelligent_check_new/services/myinfo_services.dart';
import 'package:intelligent_check_new/services/update.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:td_password_encode_plugin/td_password_encode_plugin.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flukit/flukit.dart';
import 'package:flutter/foundation.dart';

import 'hidedanger_manage/hidden_danger_found.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool displayPassword = false;
  bool isAnimating = false;
  bool isSavePassword = false;

  String ErrorMsg = "";
  var loginState = false;
  int count = 0;

  Version _version;
  bool loginButtonEnable = true;

  bool isLoadedSysConfig = false;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;

  List<Config> sysConfig;

  String theme = "blue"; //登陆前获取主题
  String loginLogo = ""; //登陆前获取系统图标
  String loginLogoChTitle = ""; //系统中文标题
  String loginLogoEnTitle = ""; //系统英文标题
  String loginBottomTitle = "";


  CompanyInfos selectedCompany;
  DeptInfo selectedeDept;
  RoleInfo selectedRlole;
  List<CompanyInfos> comList = new List();


  @override
  Widget build(BuildContext context) {
    final logo = new Column(
      children: <Widget>[
        loginLogo.isEmpty || loginLogo == null ? Image.asset(
          "assets/images/login/logo_$theme.png",
          width: 130.0,
          height: 119.0,
        ) : Image.network(loginLogo, width: 130.0,
          height: 119.0,),
        Text(
          loginLogoChTitle.isEmpty ? "安全执行系统" : loginLogoChTitle,
          style: new TextStyle(
              color: GetConfig.getColor(theme),
              fontSize: 30.0,
              fontWeight: FontWeight.bold),
        ),
        Text(
          loginLogoEnTitle.isEmpty
              ? "Intelligent Inspection System"
              : loginLogoEnTitle,
          style: new TextStyle(
              color: GetConfig.getColor(theme),
              fontSize: 15.0,
              fontWeight: FontWeight.bold),
        ),
      ],
    );

    final username = TextField(
        controller: usernameController,
        autofocus: false,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        decoration: new InputDecoration(
//          prefixIcon: new Icon(Icons.perm_identity,color: Colors.black26,size: 26,),
          prefixIcon: Image.asset(
            'assets/images/login/username_' + theme + '.png',
            scale: 1.5,
          ),
          border: InputBorder.none,
          hintText: '请输入用户名',
          hintStyle: TextStyle(fontSize: 18.0, color: Colors.black12),
          contentPadding: EdgeInsets.all(13.0),
        ));

    final usernameFinal = new Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(247, 249, 250, 1),
          border: new Border.all(
            color: Colors.grey[300],
            width: 1,
          ),
          borderRadius: new BorderRadius.all(Radius.circular(5)),
        ),
        child: new Container(child: username));

    final password = TextField(
        controller: passwordController,
        autofocus: false,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
        obscureText: !displayPassword,
        decoration: new InputDecoration(
          prefixIcon: Image.asset(
            'assets/images/login/password_' + theme + '.png',
            scale: 1.5,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                displayPassword = !displayPassword;
              });
            },
            child: displayPassword
                ? Image.asset(
              'assets/images/login/display_password_' + theme + '.png',
              scale: 1.2,
            )
                : Image.asset(
              'assets/images/login/hide_password.png',
              scale: 1.2,
              color: Colors.grey[350],
            ),
          ),
          border: InputBorder.none,
          hintText: '密码',
          hintStyle: TextStyle(fontSize: 18.0, color: Colors.black12),
          contentPadding: EdgeInsets.all(13.0),
        ));

    final passwordFinal = new Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(247, 249, 250, 1),
          border: new Border.all(
            color: Colors.grey[300],
            width: 1,
          ),
          borderRadius: new BorderRadius.all(Radius.circular(5)),
        ),
        child: new Container(child: password));

    final loginButton = Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      child: loginButtonEnable
          ? RaisedButton(
        onPressed: () {
          this.ErrorMsg = "";

          if (this.usernameController.text.isEmpty ||
              this.passwordController.text.isEmpty) {
            //MessageBox.showMessageOnly("用户名密码不能为空！", context);
            setState(() {
              this.ErrorMsg = "用户名密码不能为空！";
            });
            return;
          }
          login(this.usernameController.text,
              this.passwordController.text, isSavePassword);
        },
        padding: EdgeInsets.all(10),
//        color: Color.fromRGBO(218, 37, 30, 1),
        color: GetConfig.getColor(theme),
        child: Text('登录',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            side: BorderSide(style: BorderStyle.none)),
      )
          : RaisedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) =>
              new AlertDialog(
                  title: new Text("警告"),
                  content: new Text("本版本必须更新，请重新运行本程序进行更新操作！"),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("关闭"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
        },
        padding: EdgeInsets.all(10),
        color: Color.fromRGBO(218, 37, 30, 1),
        child: Text('登录',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            side: BorderSide(style: BorderStyle.none)),
      ),
    );
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 246, 249, 1),
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Stack( //第一个子控件最下面
              children: <Widget>[
                SizedBox(
                    height: 230.0,
                    child: Container(
//                    color: Colors.grey,
                      child: Opacity(
                        child: ConstrainedBox(
                          child: Image.asset(
                            "assets/images/home/workspace.png",
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.bottomCenter,
//                            color: Colors.white,
                          ),
                          constraints: BoxConstraints.expand(),
                        ),
                        opacity: 1,
                      ),
                    )),
                GestureDetector(
                  child: Container(
//                    height: 30,
//                    width:double.infinity,
                    child: Image.asset(
                      "assets/images/login/system_setting_" + theme + ".png",
                      width: 20,
                    ),
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(top: 40, right: 30),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) {
                          return new CustomSettingPage();
                        }));
                  },
                ),
                Container(
                  padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 80),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: logo,
                        onTap: () {

                        },
                      ),

                      SizedBox(height: 40.0),
                      usernameFinal,
                      SizedBox(height: 8.0),
                      passwordFinal,
                      Stack(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    children: <Widget>[
                                      new Checkbox(
                                        value: isSavePassword,
                                        activeColor: GetConfig.getColor(
                                            theme),
                                        onChanged: (bool val) {
//                          // val 是布尔值
                                          this.setState(() {
                                            this.isSavePassword = val;
                                          });
                                        },
                                      ),
                                      Text("记住密码",
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                51, 51, 51, 1),
                                            fontSize: 15.0,
                                          )),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 5,
                                    child: Text(
                                      ErrorMsg,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ],
                            ),
                            alignment: FractionalOffset.centerLeft,
                          ),

//                          loginResultText()
                        ],
                      ),
//            SizedBox(height: 24.0),
                      loginButton,
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: MediaQuery
                          .of(context)
                          .size
                          .height - 30),
                  child: Text(
                    loginBottomTitle.isEmpty ? "中国西部质量科学与技术研究院 © ${DateTime
                        .now()
                        .year
                        .toString()} " : loginBottomTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(153, 153, 153, 1)),
                  ),
                )
              ]),
        ),
        inAsyncCall: isAnimating,
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
      ),
      resizeToAvoidBottomPadding: true,
    );
  }

  login(String userName, String password, bool savePassword) async {
    setState(() {
      isAnimating = true;
    });
    try {
      await TdPasswordEncodePlugin.getPasswordByPlugin(password).then((data) {
        userLogin(userName, data).then((result) {
          if (result != null && result['result'] == 'SUCCESS') {
            SharedPreferences.getInstance().then((preferences) {

              preferences.setBool("isRegister", false);


              //返回用户的token   查询个人信息等只需要token 数据
              var token = result["dataList"]['token'];
              var userId = result["dataList"]['userId'];
              // 20200212 start
              var product = result["dataList"]['product'] ?? "";
              var appKey = result["dataList"]['appKey'] ?? "";
              preferences.setString('user_product', product);
              preferences.setString('user_appKey', appKey);
              // 20200212 end
              preferences.setString('user_token', token);
              preferences.setString("loginUser", userName);
                  preferences.setString("loginUserId", userId);
              preferences.setString(
                  "jpushKey", result["dataList"]["jpushUserKey"]);
              if (savePassword) {
                preferences.setString("loginPassword", password);
              } else {
                preferences.setString("loginPassword", "");
              }
              preferences.setBool("offline", false);
            }).then((value) {
              getLogInInfo().then((data) {
                if (mounted) {
                  setState(() {
                    if(data==null) return null;
                    comList = data.coms;
                    //角色可以和部门关联  也可以和公司关联      公司和角色是必须有的
                    if (data.coms.length == 1 &&
                        data.roleInfo.length == 1 &&
                        data.deptInfos.length <= 1) {
                      selectedCompany = data.coms[0];
                      selectedeDept = null;
                      if (data.deptInfos.length == 1) {
                        // ==1只有一个部门
                        //有部门的情况下
                        selectedeDept =
                        data.deptInfos[selectedCompany.sequenceNbr][0];
                        selectedRlole =
                        data.roleInfo[selectedeDept.sequenceNbr][0];
                      } else if (data.deptInfos.length == 0) {
                        //没有部门
                        selectedRlole =
                        data.roleInfo[selectedCompany.sequenceNbr][0];
                      } else {
                        return false;
                      }
                      var jsonStr = {
                        "companyModel": json.decode(selectedCompany.toString()),
                        "departmentModel": json.decode(
                            selectedeDept.toString()),
                        "roleModel": json.decode(selectedRlole.toString())
                      };
                      saveSelect(jsonStr);
                    } else {
                      isAnimating = false;
                      //公司部门  选择
                      Navigator.push(
                          context, new MaterialPageRoute(builder: (context) {
                        return SelCompanyAndDept(initData: data,);
                      }));
                    }
                  });
                }
              });
            });
          } else {
            setState(() {
              isAnimating = false;
              this.ErrorMsg = result != null ? result['message'] : "登陆失败";
            });
          }
        });
      });
    } catch (e) {
      setState(() {
        isAnimating = false;
        this.ErrorMsg = "登录异常，请稍后重试！";
      });
    }
  }

  saveSelect(jsonData) async {
    await saveSeleCom(jsonData).then((data) {
      if (data.success) {
        SharedPreferences.getInstance().then((preferences) {
          //保存个人信息
          var userResult = {
            "id": data.dataList["userId"],
            "name": data.dataList["realName"],
            "mobile": data.dataList["userMobile"],
            "email": data.dataList["email"],
            "userName": data.dataList["userName"],
          };
          //菜单权限
          if (data.dataList["userShow"] != null &&
              data.dataList["userShow"] != "") {
            preferences.setString(
                'user_show', json.encode(data.dataList["userShow"]).toString());
          } else {
            preferences.setString('user_show', null);
          }
          //发卡设置NFC  离线
          if (data.dataList["userPower"] != null &&
              data.dataList["userPower"] != "") {
            List<String> plist = new List();
            var aulist = UserShowAuth
                .fromJson(data.dataList["userPower"])
                .children;
            if (aulist != null && aulist.length > 0) {
              for (UserShowAuth au in UserShowAuth
                  .fromJson(data.dataList["userPower"])
                  .children) {
                plist.add(au.path);
              }
            }
            preferences.setString("permissionList", plist.join(","));
          }else{
            preferences.setString("permissionList", "");
          }

          //保存登录信息
          User userInfos = User.fromJson(userResult);
          String token = preferences.get("user_token");
          String product = preferences.get("user_product");
          String appKey = preferences.get("user_appKey");
          var logInResult = {
            "X-Access-Token": token,
            "result": data.result,
            "user": userResult,
            "product": product,
            "appKey": appKey
          };
          LoginResult lgres = LoginResult.fromJson(logInResult);

          preferences.setString('user_token', token);
          preferences.setString('user_info', userInfos.toString());
          preferences.setString('LoginResult', lgres.toString());

          preferences.setString("loginUserNo", userInfos.sequenceNbr ?? "");
          preferences.setString("loginUserId", userInfos.id ?? "");

          //保存用户功能权限

          if (data.dataList["userPower"] != null &&
              data.dataList["userPower"] != "") {
            preferences.setString("user_power",
                json.encode(data.dataList["userPower"]).toString());
          }
//待处理任务
          print(data.dataList["userHaveToDo"]);
          if (data.dataList["userHaveToDo"] != null &&
              data.dataList["userHaveToDo"].length > 0) {
            List<String> userToDo = new List();
            for (String item in data.dataList["userHaveToDo"]) {
              userToDo.add(item);
            }
            preferences.setStringList("userHaveToDo", userToDo);
          } else {
            preferences.remove("userHaveToDo");
          }
          //保存公司 部门 角色信息
          preferences.setString("companyList", comList.toString());
          preferences.setString("sel_com", data.dataList["companyModel"] == null
              ? "" : new CompanyInfos.fromJson(data.dataList["companyModel"])
              .toString());
          preferences.setString(
              "sel_dept",
              data.dataList["departmentModel"] == null
                  ? ""
                  : new DeptInfo.fromJson(data.dataList["departmentModel"])
                  .toString());
          preferences.setString(
              "sel_role",
              data.dataList["roleModel"] == null
                  ? ""
                  : new RoleInfo.fromJson(data.dataList["roleModel"])
                  .toString());
        });

//        if (data.dataList["userShow"] == null) {
//          setState(() {
//            this.ErrorMsg = "该用户存在但没有分配权限！";
//            isAnimating = false;
//          });
//          return;
//        }
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => NavigationKeepAlive()),
                (route) => route == null);
      } else {
        HiddenDangerFound.popUpMsg("选择失败");
      }
    });
  }

  @override
  void didUpdateWidget(LoginPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();


    //强制竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    loginStateText = "";
    getTheme();
    getUserNameAndPassword();
    checkUpdate();
  }

  @override
  void dispose() {
    //取消强制竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  getConfigInfo() async {
    await getConfig().then((dataList) {
      this.sysConfig = dataList;
      SharedPreferences.getInstance().then((pref) {
        setState(() {
          if (sysConfig == null || sysConfig.length == 0) return;
          this.theme = sysConfig
              .firstWhere((t) => t.name == "themeColor")
              .attribute ?? KColorConstant.DEFAULT_COLOR;

          //设置标题  图片
          loginLogo = sysConfig
              .firstWhere((t) => t.name == "loginLogo")
              .attribute ?? "";
          loginLogoChTitle = sysConfig
              .firstWhere((t) => t.name == "loginLogoChTitle")
              .attribute ?? "";
          loginLogoEnTitle = sysConfig
              .firstWhere((t) => t.name == "loginLogoEnTitle")
              .attribute ?? "";
          loginBottomTitle = sysConfig
              .firstWhere((t) => t.name == "loginBottomTitle")
              .attribute ?? "";
          //保存字段
          pref.setString("theme", theme);
          pref.setString("sys_workLogo", sysConfig
              .firstWhere((t) => t.name == "workLogo")
              .attribute ?? "");
          pref.setString("sys_workLogoEnTitle", sysConfig
              .firstWhere((t) => t.name == "workLogoEnTitle")
              .attribute ?? "");
          pref.setString("sys_workLogoChTitle", sysConfig
              .firstWhere((t) => t.name == "workLogoChTitle")
              .attribute ?? "");

          isLoadedSysConfig = true;
        });
      });
    });
  }

  getUserNameAndPassword() async {
    await SharedPreferences.getInstance().then((preferences) {
      String loginUser = preferences.getString("loginUser");
      if (loginUser != null && loginUser.isNotEmpty) {
        this.usernameController.text = loginUser;
      }
      String loginPassword = preferences.getString("loginPassword");
      if (loginPassword != null && loginPassword.isNotEmpty) {
        this.passwordController.text = loginPassword;
        setState(() {
          this.isSavePassword = true;
        });
      }
    });
  }

  // 更新============================================================================
  checkUpdate() async {
    final prefs = await SharedPreferences.getInstance();
//    print(prefs.getString("updateUrl"));
    String updateUrl =
        prefs.getString("updateUrl") ?? ApiAddress.DEFAULT_UPDATE_URL;
    if (updateUrl == null || updateUrl.isEmpty) {
      return;
    } else {
      await checkNewVersion(updateUrl).then((version) {
        setState(() {
          _version = version;
        });
        if (_version != null) {
          PackageInfo.fromPlatform().then((packageInfo) {
            if (_version.version.compareTo(packageInfo.version) == 1) {
              if (_version.constraint) {
                setState(() {
                  this.loginButtonEnable = false;
                });
              }
              startUpdate();
            } else {
//              initData();
              setState(() {
                this.loginButtonEnable = true;
              });
            }
          });
        } else {
          // 更新文件获取失败、不进行更新
        }
      });
    }
  }

  startUpdate() {
    _askedToUpdate(_version).then((result) {
      if (result != null && result) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) =>
            new AlertDialog(
              content: Container(
                  height: 100,
                  width: 50,
                  child: Center(
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 16.0,
                      children: <Widget>[
                        AnimatedRotationBox(
                          child: GradientCircularProgressIndicator(
                            radius: 15.0,
                            colors: [
                              Colors.blue[300],
                              Colors.blue,
                              Colors.grey[50]
                            ],
                            value: .8,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        Text("更新中，请稍后。。。")
                      ],
                    ),
                  )),
            ));

        // 选择更新
        if (defaultTargetPlatform == TargetPlatform.android) {
          PackageInfo.fromPlatform().then((packageInfo) {
//            if(_version.version.compareTo(packageInfo.version) == 1){
            // 服务器版本大于当前版本
            checkPermission().then((permissionStatus) {
              if (permissionStatus == PermissionStatus.granted) {
                executeDownload();
              } else {
                requestPermission().then((permissionRst) {
                  checkPermission().then((permissionStatus) {
                    if (permissionStatus == PermissionStatus.granted) {
                      executeDownload();
                    } else {
                      // 权限申请失败
                      // 不进行处理
                      setState(() {
                        _permissionStatus = PermissionStatus.denied;
                      });
                    }
                  });
                });
              }
            });
//            }else{
//              //服务器版本小于当前版本,不更新
//            }
          });
        } else {
          // 非安卓平台
        }
      } else {
        // 非强制更新并且客户选择不更新,正常执行原有逻辑
//        initData();
        setState(() {
          this.loginButtonEnable = true;
        });
      }
    });
  }

  //是否有权限
  Future<PermissionStatus> checkPermission() async {
    return await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
  }

//打开权限
  Future<Map<PermissionGroup, PermissionStatus>> requestPermission() async {
    return await PermissionHandler()
        .requestPermissions([PermissionGroup.storage]);
  }

  // 获取安装地址
  Future<String> get _apkLocalPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

// 下载
  Future<void> executeDownload() async {
    final path = await _apkLocalPath;
    //下载
    final taskId = await FlutterDownloader.enqueue(
        url: _version.apkUrl,
        savedDir: path,
        fileName: "安全执行",
        showNotification: true,
        openFileFromNotification: true);

    FlutterDownloader.registerCallback((id, status, progress) {
      // 当下载完成时，调用安装
      if (taskId == id && status == DownloadTaskStatus.complete) {
        OpenFile.open(path);
        FlutterDownloader.open(taskId: id);
      }
    });
  }

  Future<bool> _askedToUpdate(Version version) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            AlertDialog(
              title: Text('发现新版本是否更新？'),
              content: Container(
                  width: 100,
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("更新内容:"),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      ),
                      Text(version.updateInfo)
                    ],
                  )),
              actions: <Widget>[
                version.constraint
                    ? FlatButton(
                  child: Text('确定'),
                  onPressed: () => Navigator.pop(context, true),
                )
                    : Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('暂不'),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    FlatButton(
                      child: Text('确定'),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                )
              ],
            ));
  }

  // 获取主题
  getTheme() async {
    getConfigInfo();
  }
}

class loginResultText extends StatefulWidget {
  @override
  _loginResultTextState createState() => _loginResultTextState();
}

String loginStateText = "";

class _loginResultTextState extends State<loginResultText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(loginStateText,
          style: TextStyle(
            color: Colors.red,
            fontSize: 16.0,
          )),
      padding: EdgeInsets.only(top: 10),
      alignment: FractionalOffset.centerRight,
    );
  }
}
