import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckExecute/query_point_detail.dart';
import 'package:intelligent_check_new/pages/CheckExecute/send_card.dart';
import 'package:intelligent_check_new/services/CheckRecordServices.dart';
import 'package:intelligent_check_new/services/check_point_service.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckExecSpotDetail extends StatefulWidget{

  final num pointId;
  final bool canSendCard;
  CheckExecSpotDetail(this.pointId,this.canSendCard);

  @override
  State<StatefulWidget> createState() {
    return _CheckExecSpotDetail();
  }
}

class _CheckExecSpotDetail extends State<CheckExecSpotDetail>{
  bool _switchSelected=true;

  QueryPointDetail detail;
  String strRouts="";
  String strClassify="";
  String permissionList="";
  String theme="";

  @override
  void initState() {
    super.initState();

    getData();
  }

  getPermissionData()  async{
    await SharedPreferences.getInstance().then((sp){
      String str= sp.get('permissionList');
      setState(() {
        permissionList = str;
        this.theme = sp.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  checkPermission(String permission){
    if(permissionList == null || permissionList.isEmpty) return false;
    bool hasPermission = false;
    List permissions = permissionList.split(",");
    if(permissions.length <= 0){
      hasPermission =  false;
    }else{
      permissions.forEach((f){
        print(f);
        if(f == permission){
          hasPermission = true;
        }
      });
    }

    return hasPermission;
  }

  getData() async{
    await getPermissionData();
//    print("permissionList" + permissionList);
    await getQueryPointDetail(this.widget.pointId).then((data){
      setState(() {
        this.detail = data;
        String _routs = "";
        data.routs.forEach((r){
          _routs = _routs + r.routeName+";";
        });
        this.strRouts = _routs;

        String _classify="";
        data.classifies.forEach((c){
          _classify = _classify + c.classifyName + ";";
        });
        this.strClassify = _classify;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(this.detail == null){
      return Scaffold(
        appBar: AppBar(
          title: Text("巡检点详情",style: TextStyle(color: Colors.black,fontSize: 19),),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading:new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("巡检点详情",style: TextStyle(color: Colors.black,fontSize: 19),),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading:new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20,top:10),
                    width: 150,
                    height: 40,
                    child: Text("点名称",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                  ),
                  Text(detail.pointInfo.pointName??""),
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20,top:10),
                    width: 150,
                    height: 40,
                    child: Text("点编号",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                  ),
                  Text(detail.pointInfo.pointNo??""),
                ],
              ),

              Divider(),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20,top:10),
                    width: 150,
                    height: 40,
                    child: Text("区域\\部门",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                  ),
                  Text(detail.pointInfo.departmentName??""),
                ],
              ),
//              Divider(),
//              Row(
//                children: <Widget>[
//                  Container(
//                    padding: EdgeInsets.only(left: 20,top:10),
//                    width: 150,
//                    height: 40,
//                    child: Text("责任人",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
//                  ),
//                  Text(this.detail.pointInfo.userName??""),
//                ],
//              ),

              Container(
                color: Colors.grey[100],
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20,top:10),
                    width: 100,
                    height: 50,
                    child: Text("检查项目",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 0,top:10),
                    width: MediaQuery.of(context).size.width-100,
//                    height: detail.inputItems.length * 35.0,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: detail.inputItems.keys.map((f){
//                          return Text(inputItem.inputItenName??"");
                            return Container(

//                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        f=="其他"?Container():
                                        Container(
                                          margin:EdgeInsets.only(top:8,bottom:6),
                                          child: Text(f,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                          alignment: Alignment.topLeft,
                                        ),
                                        Container(
                                          padding:EdgeInsets.only(top: 5),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: detail.inputItems[f].map((item){
                                                return Text("${item.inputItenName}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),);
                                              }).toList()
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(padding: EdgeInsets.only(bottom: 5),),
                                    Divider(height: 1,),
                                  ],
                                )
                            );
                        }).toList()
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.grey[100],
                height: 10,
              ),
              checkPermission("AppOffline")&&this.widget.canSendCard?
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20,top:10),
                    width: MediaQuery.of(context).size.width-10,
                    height: 40,
                    child: Text("离线巡检",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                  ),
                  Padding (padding: EdgeInsets.only(left: 140)),
                  Switch(
                    value: _switchSelected,//当前状态
                    activeColor: GetConfig.getColor(theme),
                    onChanged:(value){
                      setState(() {
                        _switchSelected=value;
                        // 设置离线巡检模式
                        setPatrolModeValue();
                      });
                    },
                  ),
                ],
              ):Container(),

              checkPermission("AppOffline")&&checkPermission("AppNFC")&&this.widget.canSendCard?
              Divider():Container(),

              checkPermission("AppNFC")&&this.widget.canSendCard?
              GestureDetector(
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20,top:10),
                      width: 150,
                      height: 40,
                      child: Text("NFC发卡",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                    ),
                    Padding (padding: EdgeInsets.only(left: 180)),
                    new Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size: 16,),
                  ],
                ),
                onTap: (){
                  //SendCard();
                  Navigator.push(context, MaterialPageRoute(builder:(context){
                    return SendCard(this.detail.pointInfo.pointNo);
                  }));
                },
              ):Container(),

              (checkPermission("AppOffline") || checkPermission("AppNFC"))&&this.widget.canSendCard?
              Container(
                color: Colors.grey[100],
                height: 10,
              ):Container(),

              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20,top:10),
                    width: 150,
                    height: 40,
                    child: Text.rich(TextSpan(
                        children: [
                          TextSpan(
                            text: "*",
                            style: TextStyle(
                                color: Colors.red
                            ),
                          ),
                          TextSpan(
                            text: "备注说明",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ]
                    )
                    ),
                  ),
//                  Padding (padding: EdgeInsets.only(left: 163)),
//                  new Icon(Icons.receipt,color: GetConfig.getColor(theme),size: 16,),
//                  new Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size: 16,),
                ],
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(left: 20,right: 10),
                child: Text(detail.pointInfo.remark??""),
                width: double.infinity,
              ),

            ],
          ),
        ),
      ),
    );
  }

  void setPatrolModeValue() async{
    // 设置离线巡检
    await setPatrolMode(this.widget.pointId, this._switchSelected).then((data){
      // TODO：设置成功或失败处理
    });
  }
}