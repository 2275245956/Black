import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_tools/flutter_nfc_tools.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intelligent_check_new/model/offline/offline_plan_list_output.dart';
import 'package:intelligent_check_new/pages/offline/CheckExecute/checkexec_inspection.dart';
import 'package:intelligent_check_new/services/offline/dbAccess.dart';
import 'package:intelligent_check_new/services/offline/offline_plan_inspection_services.dart';

class NfcPage extends StatefulWidget{
  final num taskId;
  NfcPage({this.taskId});


  @override
  State<StatefulWidget> createState() => _NfcPageState();

}

class _NfcPageState extends State<NfcPage>{

//  NfcData _nfcData;
  String _platformVersion = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("NFC",style: TextStyle(color: Colors.black,fontSize: 19),),
      centerTitle: true,
      elevation: 0.7,
      brightness: Brightness.light,
      backgroundColor:  Colors.grey,
      leading:new Container(
        child: GestureDetector(
          onTap: (){Navigator.pop(context);},
          child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
        ),
      ),
    ),
      body:Container(
      color: Colors.black54,
      width: double.infinity,
      child:  Container(
        padding: EdgeInsets.only(top:30),
        child: Column(
          children: <Widget>[
            Container(
              height: 40,
              width: 200,
              child:Align(
                alignment: Alignment.center,
                child: Text("靠近巡检标签",style: TextStyle(fontSize: 16,color: Colors.white),),
              ),
              decoration: new BoxDecoration(
                color: Colors.black38,
                borderRadius: new BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 20),),
            Image.asset("assets/images/noplan/nfc_m.png",height: 200.0,width: 270.0,)
          ],
        ),
      ),
    )
    );
  }

  Future<void> initPlatformState() async {
    try {
      FlutterNfcTools.ndefEventsStream.listen((m) {
        if(m['ndefMessage']==null){
          Fluttertoast.showToast(
            msg: '标签无内容',
            toastLength: Toast.LENGTH_SHORT,
          );
          return;
        }

        print(m['ndefMessage'][0]['payload']);

        List<int> payload = m['ndefMessage'][0]['payload'].sublist(3).cast<int>().toList();
        String content = FlutterNfcTools.bytesToString(payload);
        if(content.isNotEmpty){
          getContent(content);
        }else{
          Fluttertoast.showToast(
            msg: '标签内容无法识别！',
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      });
    } on PlatformException {
      Fluttertoast.showToast(
        msg: '内容读取失败！',
        toastLength: Toast.LENGTH_SHORT,
      );
    }

    if (!mounted) return;
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

//  getContentOld(String no) async{
//    await getQueryPlanTaskBySerialInfo(2,no).then((data){
//      // 跳转页面
//      if(data != null){
////        if(this.widget.taskId != null && this.widget.taskId>0){
////          Navigator.push( context,
////              new MaterialPageRoute(builder: (context) {
////                return NavigationCheckExec(data.id,planId: this.widget.taskId,);
////              }));
////        }else{
//          Navigator.push( context,
//              new MaterialPageRoute(builder: (context) {
//                return NavigationCheckExec(data.id,checkMode:"NFC");
//              }));
////        }
//      }else{
//        Fluttertoast.showToast(
//          msg: '没有对应的巡检计划！',
//          toastLength: Toast.LENGTH_SHORT,
//        );
//      }
//    });

    getContent(String pointNo) async{
    // 查询参数
    List<dynamic> params = new List<dynamic>();
    params.add(pointNo);
    // 根据点编号查询点信息
    List<Map<String,dynamic>> points = await dbAccess().queryData("select * from Point where pointNo = ?;", params);
    print(points);

    if(points.length == 0){
      Fluttertoast.showToast(
        msg: '没有对应的巡检点！',
        toastLength: Toast.LENGTH_SHORT,
      );
    }else{
      List<Point> listPoint = await getOfflinePointList(points);
      Point chkPoint = listPoint[0];
      Navigator.push( context,
          new MaterialPageRoute(builder: (context) {
            return CheckExecInspection(chkPoint,"NFC");
          })
      );
    }
  }
}