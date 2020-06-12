
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:intelligent_check_new/model/offline/offline_plan_list_output.dart';
import 'package:intelligent_check_new/pages/offline/CheckExecute/checkexec_inspection.dart';
import 'package:intelligent_check_new/pages/offline/CheckExecute/checkexec_inspection_list.dart';
import 'package:intelligent_check_new/services/offline/offline_plan_inspection_services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QrPage extends StatefulWidget{

  final num planTaskId;
  final String inOrder;
  QrPage(this.planTaskId, this.inOrder);

  @override
  State<StatefulWidget> createState() => _QrPageState();

}

class _QrPageState extends State<QrPage>{

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QrReaderViewController _controller;
  bool camState = false;
  int returnTimes = 0;
  List<Point> points;

  @override
  void initState() {
    super.initState();
    loadData();
    setState(() {
      camState = true;
    });
  }

  void loadData () async{
    await getOfflinePlanListOutputById(this.widget.planTaskId).then((data){
      setState(() {
        points = data.points;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("二维码扫描",style: TextStyle(color: Colors.black,fontSize: 19),),
        centerTitle: true,
        elevation: 0.2,
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                camState?
//                LastQrScannerPreview(
//                  key: qrKey,
//                  onQRViewCreated: _onQRViewCreated,
//                )
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
                Align(
                  alignment: const Alignment(0, -1),
                  child: Padding(padding: EdgeInsets.only(top: 50),
                    child:Container(
                      height: 40,
                      width: 200,
                      child:Align(
                        alignment: Alignment.center,
                        child: Text("对准二维码",style: TextStyle(fontSize: 16,color: Colors.white),),
                      ),
                      decoration: new BoxDecoration(
                        color: Colors.black38,
                        borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                  ),
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
                                border: Border.all(color: Colors.red, width: 1.0)),
                          ),
                        ),
                        Positioned(
//                        top: verticalPosition.value,
                          child: Container(
                            width: 270.0,
                            height: 1,
                            color: Colors.red,
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
            flex: 1,
          )
        ],
      ),
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
    print(code);
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
    // 获取点信息
    Point chkPoint;
    for(var point in this.points){
      if(point.pointNO == pointNo){
        chkPoint = point;
        break;
      }
    }
    if(chkPoint==null){
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
      return;
    }

    // 已巡检
    if(chkPoint.status == "1"){
      Fluttertoast.showToast(
        msg: '当前点已提交巡检记录！',
        toastLength: Toast.LENGTH_SHORT,
      ).then((v){
        if(this._controller != null){
          setState(() {
            returnTimes = 0;
          });
          this._controller.startCamera(onScan);
        }
      });
      return;
    }

    // 校验是否按顺序巡检
    if(this.widget.inOrder == "1"){
      num lastOrder = chkPoint.orderNo - 1;
      if(lastOrder < 1){
        // 本次扫描的点就是第一个点
      }else{
        Point _lastPoint;
        for(var _point in this.points){
          if(_point.orderNo == lastOrder){
            _lastPoint = _point;
            break;
          }
        }

        // check data
        if(_lastPoint.status == '1'){
          // 已完成 ok
        }else{
          Fluttertoast.showToast(
            msg: '此巡检为按序巡检,请按顺序进行巡检任务！',
            toastLength: Toast.LENGTH_SHORT,
          ).then((v){
            if(this._controller != null){
              setState(() {
                returnTimes = 0;
              });
              this._controller.startCamera(onScan);
            }
          });
          return;
        }
      }
    }

    setState(() {
      camState = false;
    });

    Navigator.push( context,
        new MaterialPageRoute(builder: (context) {
//         return CheckExecInspection(chkPoint, null);
          if(chkPoint.classifis != null && chkPoint.classifis.length > 0){
            return OfflineCheckExecInspectionList(chkPoint,"QR");
          }else{
            return CheckExecInspection(chkPoint, "QR");
          }
        })).then((v){
      if(this._controller != null){
        setState(() {
          returnTimes = 0;
        });
        this._controller.startCamera(onScan);
      }
      // 刷新页面点信息
      loadData();
      setState(() {
        camState = true;
      });
    });
  }
}