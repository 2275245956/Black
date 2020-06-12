import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/offline/offline_plan_list_output.dart';
import 'package:intelligent_check_new/pages/offline/CheckExecute/send_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineCheckExecSpotDetail extends StatefulWidget{

  final Point point;
  OfflineCheckExecSpotDetail(this.point);

  @override
  State<StatefulWidget> createState() {
    return _OfflineCheckExecSpotDetail();
  }
}

class _OfflineCheckExecSpotDetail extends State<OfflineCheckExecSpotDetail>{

  String permissionList="";

  @override
  void initState() {
    super.initState();

    getPermissionData();
  }

  getPermissionData()  async{
    await SharedPreferences.getInstance().then((sp){
      String str= sp.get('permissionList');
      setState(() {
        permissionList = str;
      });
    });
  }

  checkPermission(String permission){
    if(permissionList.isEmpty) return false;
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

  @override
  Widget build(BuildContext context) {
    if(this.widget.point == null){
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
              child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
            ),
          ),
        ),
      );
    }
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
            child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:10),
                  width: 150,
                  height: 40,
                  child: Text("巡检点名称",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),
                Text(this.widget.point.name??""),
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
                Text(this.widget.point.pointNO??""),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:10),
                  width: 150,
                  height: 40,
                  child: Text("点类型",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),
                Text((this.widget.point.isFixed??"")=="1" ? "固定点" : "移动点"),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:10),
                  width: 150,
                  height: 40,
                  child: Text("归属区域\\部门",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),
                Text(this.widget.point.departmentName??""),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:10),
                  width: 150,
                  height: 40,
                  child: Text("责任人",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),
                Text(this.widget.point.chargePerson??""),
              ],
            ),
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
                  height: 60,
                  child: Text("巡检线路",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),
                Container(
                  padding: EdgeInsets.only(left: 0,top:10),
                  width: 250,
                  child: Text(this.widget.point.routeName??""),
                ),
              ],
            ),
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
                  height: 60,
                  child: Text("扩展分类",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),
                Container(
                  padding: EdgeInsets.only(left: 0,top:10),
                  width: 250,
                  child: Text(this.widget.point.classifyNames??""),
                ),
              ],
            ),
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
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: this.widget.point.inputItems.map((inputItem){
                      return Text(inputItem.name??"");
                    }).toList()
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.grey[100],
              height: 10,
            ),

            checkPermission("AppNFC")?
            Divider():Container(),

            checkPermission("AppNFC")?
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
                  new Icon(Icons.keyboard_arrow_right,color: Colors.red,size: 16,),
                ],
              ),
              onTap: (){
                //SendCard();
                Navigator.push(context, MaterialPageRoute(builder:(context){
                  return SendCard(this.widget.point.pointNO);
                }));
              },
            ):Container(),

            checkPermission("AppNFC")?
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
                Padding (padding: EdgeInsets.only(left: 163)),
                new Icon(Icons.receipt,color: Colors.red,size: 16,),
                new Icon(Icons.keyboard_arrow_right,color: Colors.red,size: 16,),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 20,top:0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("")
                      ],
                    )
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}