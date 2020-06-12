import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckExecute/query_point_detail.dart';
import 'package:intelligent_check_new/services/CheckRecordServices.dart';
import 'package:intelligent_check_new/services/check_point_service.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DangerousFactorsDetail extends StatefulWidget {
  final num riskId;

  final bool canSendCard;

  DangerousFactorsDetail(this.riskId, this.canSendCard);

  @override
  State<StatefulWidget> createState() {
    return _DangerousFactorsDetail();
  }
}

class _DangerousFactorsDetail extends State<DangerousFactorsDetail> {
  bool _switchSelected = true;

  RiskFactorsDetail detail;
  String strRouts = "";
  String strClassify = "";
  String permissionList = "";
  String theme = "";

  @override
  void initState() {
    super.initState();

    getData();
  }

  getPermissionData() async {
    await SharedPreferences.getInstance().then((sp) {
      String str = sp.get('permissionList');
      setState(() {
        permissionList = str;
        this.theme = sp.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  checkPermission(String permission) {
    if (permissionList == null || permissionList.isEmpty) return false;
    bool hasPermission = false;
    List permissions = permissionList.split(",");
    if (permissions.length <= 0) {
      hasPermission = false;
    } else {
      permissions.forEach((f) {
        print(f);
        if (f == permission) {
          hasPermission = true;
        }
      });
    }

    return hasPermission;
  }

  getData() async {
    await getPermissionData();


    await getRiskFactorsDetail(this.widget.riskId).then((data) {
      setState(() {
        if (data != null && data.riskFactorName != null)
          this.detail = data;
        });
    });
  }

  //返回后果字符串
  String getaftermathStr(List<AfterMathList> list ){
    String result="";
      if(list==null|| list.length==0){
        result= "-";
        return result;
      }
      for(var ls in list){
          result+=ls.name+"、";
      }
      return result.substring(0,result.length-1);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (this.detail == null || this.detail.riskSourceName == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "危险源详情",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.keyboard_arrow_left,
                  color: GetConfig.getColor(theme), size: 32),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "危险源详情",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.keyboard_arrow_left,
                color: GetConfig.getColor(theme), size: 32),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              // 危险因素名称
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.only(left: 8, top: 10,bottom:10),
                      width: 150,
                      
                      child: Text(
                        "危险源名称",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(detail.riskFactorName??"--"),
                    flex: 6,
                  ),
                ],
              ),
              // Divider(),
              //等级
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 8, top: 10,bottom:10),
                      
                      child: Text(
                        "等级",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            ),
                      ),
                    ),
                    flex: 4,
                  ),
                  Expanded(
                    child: Text(detail.riskFactorLevel==null?"-":detail.riskFactorLevel),
                    flex: 6,
                  ),
                ],
              ),
              // Divider(),
              //辨识人
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.only(left: 8, top: 10,bottom:10),
                      width: 150,
                      
                      child: Text(
                        "辨识人",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(detail.userNames??"--",
                        style: TextStyle(
                          color: Colors.blue,
                        )),
                  ),
                ],
              ),
              // Divider(),

              //辨识方法
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.only(left: 8, top: 10,bottom:10),
                      width: 150,
                      
                      child: Text(
                        "辨识方法",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(detail.identificationMethodNames??"--"),
                  ),
                ],
              ),

              //评价人
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.only(left: 8, top: 10,bottom:10),
                      width: 150,
                      
                      child: Text(
                        "评价人",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(detail.evaluateUserNames??"--",
                        style: TextStyle(
                          color: Colors.blue,
                        )),
                  ),
                ],
              ),
              //评价方法
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.only(left: 8, top: 10,bottom:10),
                      width: 150,
                      
                      child: Text(
                        "评价方法",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(detail.evaluateMethodNames??"--"),
                  )
                ],
              ),
              //危险源分类
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.only(left: 8, top: 10,bottom:10),
                      width: 150,
                       
                      child: Text(
                        "危险源分类",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(detail.hazardSourceClassifyName??"--"),
                  )
                ],
              ),

              //可能造成的后果
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.only(left: 8, top: 10,bottom:10,),
                      width: 150,

                      child: Text(
                        "可能造成的后果",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(getaftermathStr(detail.aftermathList)),
                  )
                ],
              ),

              //分割线
              Container(
                color: Colors.grey[100],
                height: 10,
              ),

              //危险因素列表
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 8, top: 10,bottom:10),
                    width: MediaQuery.of(context).size.width,
                    
                    child: Text(
                      "管理措施",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          ),
                    ),
                  ),
                  detail.controlMeasureList!=null?Container(
                      child: Column(
                    children: detail.controlMeasureList.map((ls){
                      return   Container(
                        padding: EdgeInsets.only(left: 25, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          ls.type+" - "+ls.name+" - "+ls.category,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                      );
                    }).toList()
                  )):Container(),
                ],
              ),

              Container(
                color: Colors.grey[100],
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setPatrolModeValue() async {
    // 设置离线巡检
    await setPatrolMode(this.widget.riskId, this._switchSelected)
        .then((data) {
      // TODO：设置成功或失败处理
    });
  }
}
