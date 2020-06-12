import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intelligent_check_new/model/CompanyInfo.dart';
import 'package:intelligent_check_new/model/InitData.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/model/UserAuthModel.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/login_page.dart';
import 'package:intelligent_check_new/pages/navigation_keep_alive.dart';
import 'package:intelligent_check_new/services/company_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelCompanyAndDept extends StatefulWidget {
  bool isSelect;

  InitData initData;


  SelCompanyAndDept({this.isSelect = false,this.initData});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SelCompanyAndDept();
  }
}

class _SelCompanyAndDept extends State<SelCompanyAndDept> {
  List<CompanyInfos> comList = new List();
  Map<String, List<DeptInfo>> deptMap = new Map();
  Map<String, List<RoleInfo>> roleMap = new Map();

  CompanyInfos selectedCompany;
  DeptInfo selectedeDept;
  RoleInfo selectedRlole;
  bool canOperate = true;
  String theme="";
//  Map selResult=new Map();

  @override
  Widget build(BuildContext context) {
    if (comList == null || comList.length <= 0) {
      return new Scaffold(
        appBar: AppBar(
          title: Text(
            "公司部门角色选择",
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
            ),
          ),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.keyboard_arrow_left,
                  color:GetConfig.getColor(theme),
                  size: 32),
            ),
          ),
        ),
      );
    }
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          "公司部门角色选择",
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.keyboard_arrow_left,
                color: GetConfig.getColor(theme),
                size: 32),
          ),
        ),
      ),
      body: new Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        selectedCompany == null
                            ? "请选择公司"
                            : selectedCompany.companyName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 0),
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                  ],
                ),
                onTap: () {
                  companyDialog();
                },
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        selectedeDept == null
                            ? "请选择部门"
                            : selectedeDept.departmentName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 0),
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                  ],
                ),
                onTap: () {
                  departmentDialog();
                },
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        selectedRlole == null
                            ? "请选择角色"
                            : selectedRlole.roleName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 0),
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                  ],
                ),
                onTap: () {
                  roleDialog();
                },
              )
            ],
          ),
          alignment: Alignment.center,
        ),
      ),
      persistentFooterButtons: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: (MediaQuery.of(context).size.width / 2) - 16,
              height: 60,
              margin: EdgeInsets.only(left: 0),
              child: new MaterialButton(
                color: Color.fromRGBO(242, 246, 249, 1),
                height: 60,
                textColor: Colors.black,
                child: new Text(
                  '重置',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  setState(() {
                    selectedeDept = null;
                    selectedRlole = null;
                    selectedCompany = null;
                  });
                },
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width / 2),
              child: new MaterialButton(
                color: GetConfig.getColor(theme),
                height: 60,
                textColor: Colors.white,
                child: new Text('确定', style: TextStyle(fontSize: 24)),
                onPressed: () {
                  //必填项判断
                  if (selectedCompany != null && selectedRlole != null) {
                    var jsonStr = {
                      "companyModel": json.decode(selectedCompany.toString()),
                      "departmentModel": json.decode(selectedeDept.toString()),
                      "roleModel": json.decode(selectedRlole.toString())
                    };
                    if (canOperate) {
                      saveSelect(jsonStr);
                    }
                  } else {
                    HiddenDangerFound.popUpMsg("请完成选择!",
                        gravity: ToastGravity.TOP);
                  }
                },
              ),
            ),
          ],
        ),
      ],
      resizeToAvoidBottomPadding: false,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initData();
  }

  initData() async {
    await SharedPreferences.getInstance().then((prep){
        this.theme=prep.getString("theme")??"blue";
    }).then((_){
      if(this.widget.initData!=null){
        setState(() {
          comList = this.widget.initData.coms;
          deptMap = this.widget.initData.deptInfos;
          roleMap = this.widget.initData.roleInfo;
        });
      }else{
        getLogInInfo().then((data) {
          if (mounted) {
            setState(() {
              comList = data.coms;
              deptMap = data.deptInfos;
              roleMap = data.roleInfo;

            });
          }
        });
      }

    });


  }

  companyDialog() {
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return comList != null
            ? SimpleDialog(
                children: comList.map((f) {
                  return Column(
                    children: <Widget>[
                      new SimpleDialogOption(
                        child: new Text(f.companyName),
                        onPressed: () {
                          setState(() {
                            selectedCompany = f;
                            selectedeDept = null;
                            selectedRlole = null;
                            //                      selResult["selCom"]=f;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      Divider(
                        height: 1,
                      )
                    ],
                  );
                }).toList(),
              )
            : Container();
      },
    );
  }

  departmentDialog() {
    if (selectedCompany == null) {
      HiddenDangerFound.popUpMsg("请先选择公司！", gravity: ToastGravity.TOP);
      return Container();
    }

    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return deptMap[selectedCompany.sequenceNbr] != null
            ? SimpleDialog(
                children: deptMap[selectedCompany.sequenceNbr].map((f) {
                  return Column(
                    children: <Widget>[
                      new SimpleDialogOption(
                        child: new Text(f.departmentName),
                        onPressed: () {
                          setState(() {
                            selectedeDept = f;
                            selectedRlole = null;
//                      selResult["selDept"]=f;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      Divider(
                        height: 1,
                      )
                    ],
                  );
                }).toList(),
              )
            : Container();
      },
    );
  }

  roleDialog() {
    if (selectedCompany == null) {
      HiddenDangerFound.popUpMsg("请先选择公司！", gravity: ToastGravity.TOP);
      return Container();
    }
    //未选择部门
    else if (selectedeDept == null) {
      if (roleMap[selectedCompany.sequenceNbr] == null) {
        HiddenDangerFound.popUpMsg("用户在该公司下没有分配角色，\n请先选择部门！",
            gravity: ToastGravity.TOP);
        return Container();
      }
      showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return roleMap[selectedCompany.sequenceNbr] != null
              ? SimpleDialog(
                  children: roleMap[selectedCompany.sequenceNbr].map((f) {
                    return Column(
                      children: <Widget>[
                        new SimpleDialogOption(
                          child: new Text(f.roleName),
                          onPressed: () {
                            setState(() {
                              selectedRlole = f;
//                      selResult["selRole"]=f;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        Divider(
                          height: 1,
                        )
                      ],
                    );
                  }).toList(),
                )
              : Container();
        },
      );
    } else {
      //选择部门

      if (roleMap[selectedeDept.sequenceNbr] == null) {
        HiddenDangerFound.popUpMsg("用户在该部门下没有分配角色！", gravity: ToastGravity.TOP);
        return Container();
      }
      showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return roleMap[selectedeDept.sequenceNbr] != null
              ? SimpleDialog(
                  children: roleMap[selectedeDept.sequenceNbr].map((f) {
                    return Column(
                      children: <Widget>[
                        new SimpleDialogOption(
                          child: new Text(f.roleName),
                          onPressed: () {
                            setState(() {
                              selectedRlole = f;
//                      selResult["selRole"]=f;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        Divider(
                          height: 1,
                        )
                      ],
                    );
                  }).toList(),
                )
              : Container();
        },
      );
    }
  }

  saveSelect(jsonData) async {
    setState(() {
      canOperate = false;
    });
    await saveSeleCom(jsonData).then((data) {
      if (data.success) {
        SharedPreferences.getInstance().then((preferences) {
          //保存个人信息
          var userResult = {
            "id": data.dataList["userId"],
            "name": data.dataList["realName"],
            "mobile": data.dataList["mobile"],
            "email": data.dataList["email"],
            "userName": data.dataList["userName"],
          };
          //菜单权限
          if (data.dataList["userShow"] != null &&
              data.dataList["userShow"] != "") {
            preferences.setString(
                'user_show', json.encode(data.dataList["userShow"]).toString());
          }else{
            preferences.setString(
                'user_show', null);
          }

          //发卡设置NFC  离线
          if(data.dataList["userPower"]!=null && data.dataList["userPower"]!=""){
            List<String> plist=new List();
            for(UserShowAuth au in UserShowAuth.fromJson(data.dataList["userPower"]).children){
              plist.add(au.path);
            }
            preferences.setString("permissionList",plist.join(","));
          }else{
            preferences.setString("permissionList","");
          }

          //保存登录信息
          User userInfos = User.fromJson(userResult);
          String token = preferences.get("user_token");
          var logInResult = {
            "X-Access-Token": token,
            "result": data.result,
            "user": userResult
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
          }else{
            preferences.setString("user_power",null);
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
          }else{
            preferences.remove("userHaveToDo");
          }
          //保存公司 部门 角色信息
          preferences.setString("companyList", comList.toString());
          preferences.setString( "sel_com",data.dataList["companyModel"] == null
              ? "": new CompanyInfos.fromJson(data.dataList["companyModel"]).toString());
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

        setState(() {
          canOperate = true;
        });
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => NavigationKeepAlive()),
            (route) => route == null);
      } else {
        canOperate = true;
        HiddenDangerFound.popUpMsg("选择失败");
      }
    });
  }
}
