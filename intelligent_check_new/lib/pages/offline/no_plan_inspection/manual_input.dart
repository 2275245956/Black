import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intelligent_check_new/model/offline/offline_plan_list_output.dart';
import 'package:intelligent_check_new/pages/offline/CheckExecute/checkexec_inspection.dart';
import 'package:intelligent_check_new/services/offline/dbAccess.dart';
import 'package:intelligent_check_new/services/offline/offline_plan_inspection_services.dart';

class ManualInput extends StatefulWidget{

  final num taskId;
  ManualInput({this.taskId});

  @override
  State<StatefulWidget> createState() => _ManualInputState();
}

class _ManualInputState extends State<ManualInput>{

  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("输入二维码编号",style: TextStyle(color: Colors.black,fontSize: 19),),
          centerTitle: true,
          elevation: 0.7,
//        brightness: Brightness.light,
          backgroundColor:  Colors.grey,
          leading:new Container(
            child: GestureDetector(
              onTap: (){Navigator.pop(context);},
              child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
            ),
          ),
        ),
        body: Container(
          color: Colors.black54,
          child: Padding(
            padding: EdgeInsets.only(top: 100,left: 30,right: 30),
            child: Column(
              children: <Widget>[
                TextField(
                    controller: _controller,
                    autofocus: false,
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                    decoration: new InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:BorderSide(color: Colors.white,width: 1),
                        ),
                        contentPadding: EdgeInsets.all(10.0),
                        fillColor: Colors.blue
                    )
                ),
                Padding(padding: EdgeInsets.only(bottom: 20),),
                Row(
                  children: <Widget>[
                    Container(
                      width: 140,
//                  color: Colors.black45,
                      decoration: new BoxDecoration(
                        color: Colors.black38,
                        borderRadius: new BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            Image.asset("assets/images/icons/scan.png",color: Colors.white,),
                            Padding(padding:EdgeInsets.only(right: 10)),
                            Text("切换扫码",style: TextStyle(color:Colors.white),)
                          ],
                        ),
                        onPressed: (){
//                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 20),),
                    Container(
                        width: 140,
                        decoration: new BoxDecoration(
                          color: Color.fromRGBO(218, 37, 30, 1),
                          borderRadius: new BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: FlatButton(
                          child: Text("确定",style: TextStyle(color:Colors.white),),
                          onPressed: (){
                            String code = this._controller.text;
                            if(code.isNotEmpty){
                              getContent(code);
                            }else{
                              Fluttertoast.showToast(
                                msg: '请输入输入二维码编号！',
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            }
                          },
                        )
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
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
      );
    }else{
      List<Point> listPoint = await getOfflinePointList(points);
      Point chkPoint = listPoint[0];
      Navigator.push( context,
          new MaterialPageRoute(builder: (context) {
            return CheckExecInspection(chkPoint,"QR");
          }));
    }
  }
}