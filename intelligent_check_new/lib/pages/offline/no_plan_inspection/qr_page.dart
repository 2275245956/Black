import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:intelligent_check_new/model/offline/offline_plan_list_output.dart';
import 'package:intelligent_check_new/pages/offline/CheckExecute/checkexec_inspection.dart';
import 'package:intelligent_check_new/services/offline/dbAccess.dart';
import 'package:intelligent_check_new/services/offline/offline_plan_inspection_services.dart';
import 'package:intelligent_check_new/tools/MessageBox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';


class QrPage extends StatefulWidget{

  final num taskId;
  QrPage({this.taskId});

  @override
  State<StatefulWidget> createState() => _QrPageState();

}

class _QrPageState extends State<QrPage>{

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QrReaderViewController _controller;

//  QrCamera qrCamera;
  bool camState = false;
  int returnTimes = 0;

  PermissionStatus _permissionStatus = PermissionStatus.unknown;

  @override
  void initState() {
    super.initState();

    // 权限check
    checkPermission().then((v){
      if(v == PermissionStatus.granted){
        setState(() {
          camState = true;
        });
      }else{
        requestPermission().then((v){
          if(_permissionStatus == PermissionStatus.granted){
            setState(() {
              camState = true;
            });
          }else{
            setState(() {
              camState = false;
            });
            MessageBox.showMessageOnly("请授予权限后重新操作！", context);
          }
        });
      }
    });
  }

  //是否有权限
  Future<PermissionStatus> checkPermission() async {
    return await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
  }

//打开权限
  Future<void> requestPermission() async {
    PermissionGroup permission = PermissionGroup.camera;
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
    await PermissionHandler().requestPermissions(permissions);

    setState(() {
//      print(permissionRequestResult);
      _permissionStatus = permissionRequestResult[permission];
//      print(_permissionStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("二维码扫描",style: TextStyle(color: Colors.black,fontSize: 19),),
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
//        actions: <Widget>[
//          IconButton(icon:ImageIcon(AssetImage("assets/images/noplan/no_plan_torch.png"),size: 30,),
//            onPressed: (){
//            this.controller.toggleTorch();
//          },)
//        ],
      ),
      body:Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                camState?
            /*    LastQrScannerPreview(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                )*/
                QrReaderView(
                    width: 400,
                    height: 1000,
                    callback: (container) {
                      this._controller = container;
                      _controller.startCamera(onScan);
                    })
                    :new Container(
                  decoration: new BoxDecoration(
                    color: Colors.black,
                  ),
                ),
                Container(
                    height: 40,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 60,right: 60,top:40),
                    child:Container(
//                      padding: EdgeInsets.only(left: 40,top:10),
                      child: Text("对准二维码",style: TextStyle(fontSize: 16,color: Colors.white),),
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.black38,
                      borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                    ),
                    alignment: Alignment.center
                ),
                GestureDetector(
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(bottom: 10),),
                        SizedBox(
                          height: 300.0,
                          width: 270.0,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 1.0)),
                          ),
                        ),
                        Positioned(
                          child: Container(
                            width: 270.0,
                            height: 1,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: (){
                    this._controller.setFlashlight();
                  },
                ),
              ],
            ),
            flex: 4,
          ),
        ],
      )
    );
  }

//  void _onQRViewCreated(/*QRViewController controller*/) {
//    this.controller = controller;
//    final channel = controller.channel;
//    controller.init(qrKey);
//    channel.setMethodCallHandler((MethodCall call)  async{
//      switch (call.method) {
//        case "onRecognizeQR":
//          controller.pauseScanner();
//          scan(call.arguments.toString());
//      }
//    });
//  }


  void onScan(String v, List<Offset> offsets) {
    if(v != null && v.isNotEmpty){
      setState(() {
        returnTimes = returnTimes + 1;
      });
      if(returnTimes == 1){
        scan(v);
      }
      _controller.stopCamera();
    }
  }

  scan(String code){
    if(code.isNotEmpty){
      getContent(code);
    }else{
      Fluttertoast.showToast(
        msg: '标签内容无法识别！',
        toastLength: Toast.LENGTH_SHORT,
      ).then((v){
        if(this._controller != null){
          setState(() {
            returnTimes = 0;
          });
          this._controller.startCamera(onScan);
        }
      });
    }
  }

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
      ).then((v){
        if(this._controller != null){
          setState(() {
            returnTimes = 0;
          });
          this._controller.startCamera(onScan);
        }
      });
    }else{
      List<Point> listPoint = await getOfflinePointList(points);
      Point chkPoint = listPoint[0];

      setState(() {
        camState = false;
      });

      Navigator.push( context,
          new MaterialPageRoute(builder: (context) {
            return CheckExecInspection(chkPoint,"QR");
          })).then((v){
        if(this._controller != null){
          setState(() {
            returnTimes = 0;
          });
          this._controller.startCamera(onScan);
        }
        setState(() {
          camState = true;
        });
      });
    }
  }
}