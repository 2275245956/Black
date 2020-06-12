import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckExecute/query_point_detail.dart';
import 'package:intelligent_check_new/pages/inspection_spot/dangerous_factors_detail.dart';
import 'package:intelligent_check_new/services/CheckRecordServices.dart';
import 'package:intelligent_check_new/services/check_point_service.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceDetail extends StatefulWidget{

  final num deviceId;

  final bool canSendCard;
  DeviceDetail(this.deviceId,this.canSendCard);

  @override
  State<StatefulWidget> createState() {

    return _DeviceDetail();
  }
}

class _DeviceDetail extends State<DeviceDetail>{
  bool _switchSelected=true;


  String strRouts="";
  String strClassify="";
  String permissionList="";
  String theme="";

  @override
  void initState() {
    super.initState();
    print(this.widget.deviceId);
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
   EquipmentDetail eDetail;
  getData() async{
    await getPermissionData();


    await getEquipmentDetail(this.widget.deviceId).then((data){
      setState(() {
        eDetail=data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(eDetail==null ||eDetail.equipmentName== ""){
      return Scaffold(
        appBar: AppBar(
          title: Text("设备设施详情",style: TextStyle(color: Colors.black,fontSize:20,fontWeight: FontWeight.w500 ),),
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
        title: Text("设备设施详情",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500 ),),
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
              // 设备名称
              Row(
                children: <Widget>[
            Expanded(flex: 4,
            child:Container(
                    padding: EdgeInsets.only(left: 8,top:10,bottom:10),
                    width: MediaQuery.of(context).size.width,
                    
                    child: Text("设备名称",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
                  ),),  Expanded(flex: 6,
          child:
                  Text(eDetail.equipmentName??"--"),),
                ],
              ),
              // Divider(),
              //设备位号
              Row(
                children: <Widget>[
                  Expanded(flex:4 ,
                    child:Container(
                    padding: EdgeInsets.only(left: 8,top:10,bottom:10),
                    width: MediaQuery.of(context).size.width,
                    
                    child: Text("设备位号",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
                  ),)  ,Expanded(flex: 6,
        child:
                  Text(eDetail.equipmentCode??"--"),),
                ],
              ),
              // Divider(),
              //所在分区
              Row(
               children: <Widget>[
                  Expanded(flex: 4,
                  child:Container(
                    padding: EdgeInsets.only(left: 8,top:10,bottom:10),
                    width: MediaQuery.of(context).size.width,
                    
                    child: Text("所在分区",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
                  ),),  Expanded(flex: 6,
                   child:
                  Text(eDetail.equipmentRegionName??"--"),)
                ],
              ),
              // Divider(),

              //所属部门
              Row(
                children: <Widget>[
                  Expanded(flex: 4,
                    child:Container(
                    padding: EdgeInsets.only(left: 8,top:10,bottom:10),
                    width: MediaQuery.of(context).size.width,
                    
                    child: Text("所属部门/车间",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
                  ), ),
                  Expanded(flex: 6,
                child:Text(eDetail.equipmentDepartmentName??"--"),
                  )
                ],
              ),

              //所在工段
              Row(
                children: <Widget>[
                  Expanded(flex: 4,
                    child:Container(
                    padding: EdgeInsets.only(left: 8,top:10,bottom:10),
                    width: MediaQuery.of(context).size.width,
                    
                    child: Text("所在工段",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
                  ),),  Expanded(flex:6,
                    child:
                  Text(eDetail.equipmentWorkshopSection??"--"),)
                ],
              ),
              //责任人
              Row(
                children: <Widget>[
                  Expanded(flex: 4,
                    child:Container(
                    padding: EdgeInsets.only(left: 8,top:10,bottom:10),
                    width: MediaQuery.of(context).size.width,
                    
                    child: Text("责任人",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
                  ),),  Expanded(flex: 6,
                child:
                  Text(eDetail.equipmentUserName??"--",style:TextStyle(color:Colors.blue,)),)
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

  void setPatrolModeValue() async{
    // 设置离线巡检
    await setPatrolMode(this.widget.deviceId, this._switchSelected).then((data){
      // TODO：设置成功或失败处理
    });
  }
}