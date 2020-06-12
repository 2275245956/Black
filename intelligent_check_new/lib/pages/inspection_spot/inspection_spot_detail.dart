import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckExecute/query_point_detail.dart';
import 'package:intelligent_check_new/pages/CheckExecute/send_card.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/inspection_record/record_list_screen.dart';
import 'package:intelligent_check_new/pages/inspection_spot/dangerous_factors_detail.dart';
import 'package:intelligent_check_new/pages/inspection_spot/device_detail.dart';
import 'package:intelligent_check_new/services/CheckRecordServices.dart';
import 'package:intelligent_check_new/services/check_point_service.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InspectionSpotDetail extends StatefulWidget{

  final num pointId;
  final bool canSendCard;
  InspectionSpotDetail(this.pointId,this.canSendCard);

  @override
  State<StatefulWidget> createState() {
    return _InspectionSpotDetail();
  }
}

class _InspectionSpotDetail extends State<InspectionSpotDetail>{
  bool _switchSelected=true;

  InherentPointDetail detail;
  String strRouts="";
  String strClassify="";
  String permissionList="";
  String theme="";

  @override
  void initState() {
    super.initState();
     SharedPreferences.getInstance().then((sp){

      setState(() {
        this.theme = sp.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
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
    await getInherentPointDetail(this.widget.pointId).then((data){
      setState(() {
        if(data.pointId==null)
          HiddenDangerFound.popUpMsg("查询巡检点详情失败！");
        else{
          detail=data;
        }

    /*    this.detail = data;

        String _routs = "";
        data.routs.forEach((r){
          _routs = _routs + r.routeName+";";
        });
        this.strRouts = _routs;

        String _classify="";
        data.classifies.forEach((c){
          _classify = _classify + c.classifyName + ";";
        });
        this.strClassify = _classify;*/
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(this.detail == null || this.detail.pointId==null){
      return Scaffold(
        appBar: AppBar(
          title: Text("固有风险点详情",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500 ),),
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
        title: Text("固有风险点详情",style: TextStyle(color: Colors.black,fontSize:20,fontWeight: FontWeight.w500 ),),
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
              // 风险点名称
              Row(
                children: <Widget>[
            Expanded(flex: 3,
            child:Container(
                    padding: EdgeInsets.only(left: 8,top:10,bottom:10),
                    width: MediaQuery.of(context).size.width,
                     
                    child: Text("点名称",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
                  ),),  Expanded(flex: 7,
          child:
                  Text(detail.pointName??"-"),)
                ],
              ),
             // Divider(),
              //点编号
              Row(
                children: <Widget>[
                  Expanded(flex: 3,
                    child:Container(
                    padding: EdgeInsets.only(left: 8,top:10,bottom:10),
                    width: MediaQuery.of(context).size.width,
                   
                    child: Text("点编号",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
                  ),),  Expanded(flex: 7,
                    child:
                  Text(detail.pointNo??""),)
                ],
              ),
             // Divider(),
              //等级
              Row(
                children: <Widget>[
                  Expanded(flex: 3,
                    child:Container(
                    padding: EdgeInsets.only(left: 8,top:10,bottom:10),
                    width: MediaQuery.of(context).size.width,
                   
                    child: Text("等级",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
                  ),),
                  Expanded(
                    flex: 7,
                    child:
                  Text(detail.pointLevel==null?"-":detail.pointLevel),),
                ],
              ),

              //分割线
              Container(
                color: Colors.grey[100],
                height: 10,
              ),
              //关联对象

              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 8,top:10,bottom:10),
                    width: MediaQuery.of(context).size.width,
                   
                    child: Text("关联对象",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
                  ),


                  Container(
                      child: Column(
                        children:detail.equipmentList==null?List():detail.equipmentList.map((eq){
                        return  Container(
                            child:    GestureDetector(
                              child:  Container(
                                  padding: EdgeInsets.only(left: 30,top:10,bottom: 10),
                                  width: MediaQuery.of(context).size.width,
                                 
                                  child:Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(eq.name+"-"+eq.code,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,fontFamily: 'Source Han Sans CN'),),
                                        flex: 9,
                                      ),

                                      Expanded(
                                        child: new Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size: 30,),
                                        flex: 1,
                                      ),
                                    ],
                                  )

                              ),
                              onTap: (){
                                Navigator.push(context,
                                    new MaterialPageRoute(
                                        builder: (context) {
                                          return new DeviceDetail( eq.id ,true);
                                        }
                                    )
                                );
                              },
                            ),
                          );
                        }).toList(),
                      )
                  ),

                ],
              ),

              Container(
                color: Colors.grey[100],
                height: 10,
              ),

              //危险因素列表
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 8,top:10,bottom:10),
                    width: MediaQuery.of(context).size.width,
                   
                    child: Text("危险源列表",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
                  ),
                  Container(
                      child: Column(
                        children: detail.riskFactorList==null?List(0):detail.riskFactorList.map((risk){
                          return Container(
                              padding: EdgeInsets.only(left:30,top:10,bottom: 10),
                              width:  MediaQuery.of(context).size.width,
                             
                              child:GestureDetector(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(risk.name,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,fontFamily: 'Source Han Sans CN'),),
                                      flex: 8,
                                    ),
                                    Expanded(
                                      child: Text(risk.rfLevel==null?"-":risk.rfLevel,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,fontFamily: 'Source Han Sans CN'),),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: new Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size: 30,),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                                onTap: (){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context){
                                        return new DangerousFactorsDetail(risk.id,true);
                                      }));
                                },
                              )
                          );
                        }).toList()
                      )
                  ),

                ],
              ),



              Container(
                color: Colors.grey[100],
                height: 10,
              ),


              Container(
                  padding: EdgeInsets.only(left: 25,top:10),
                  width:  MediaQuery.of(context).size.width,
                 
                  child:Row(
                    children: <Widget>[

                      Expanded(
                        child: Text("巡检记录",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                        flex: 9,
                      ),

                      Expanded(
                        child: GestureDetector(
                          child: new Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size: 32,),
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context){
                              return RecordListScreen(pointNo: detail.pointNo);
                            }));
                          }
                        ),
                        flex: 1,
                      ),
                    ],
                  )
              ),
              Divider(),
              checkPermission("AppOffline")&&this.widget.canSendCard?
              //离线巡检
              Row(
                  children: <Widget>[
                   Expanded(
                     child: Container(
                       padding: EdgeInsets.only(left: 25,top:10),
                       child: Text("离线巡检",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,)),
                     ) ,
                    flex: 11,
                   ),
                  Expanded(

                       child:  Switch(
                        value: _switchSelected,//当前状态
                        activeColor: GetConfig.getColor(theme),

                        onChanged:(value){
                          setState(() {
                           _switchSelected=value;
                           // 设置离线巡检模式
                           setPatrolModeValue();
                         });
                       },

                     ) ,
                     flex:2,
                  ),

                ],
              ):Container(),

              checkPermission("AppOffline")&&checkPermission("AppNFC")&&this.widget.canSendCard?
              Divider():Container(),

              checkPermission("AppNFC")&&this.widget.canSendCard?
              GestureDetector(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 25,top:10),
                        width: MediaQuery.of(context).size.width,
                       
                        child: Text("NFC发卡",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
                      ) ,
                      flex: 9,
                    ),
                    Expanded(
                      child:   new Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size: 30,),
                      flex: 1,
                    ),
                  ],
                ),
                onTap: (){
                  //SendCard();
                  Navigator.push(context, MaterialPageRoute(builder:(context){
                    return SendCard(this.detail.pointNo);
                  }));
                },
              ):Container(),

              (checkPermission("AppOffline") || checkPermission("AppNFC"))&&this.widget.canSendCard?
              Container(
                color: Colors.grey[100],
                height: 10,
              ):Container(),





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