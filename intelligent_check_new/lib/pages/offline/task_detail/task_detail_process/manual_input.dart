import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intelligent_check_new/model/Task/TaskContentResult.dart';
import 'package:intelligent_check_new/model/Task/TaskModel.dart';
import 'package:intelligent_check_new/pages/offline/task_process/task_process_screen.dart';

import '../task_detail_screen.dart';

class ManualInput extends StatefulWidget{

  final TaskContent task;
  final TaskModel taskModel;
  ManualInput(this.task,this.taskModel);

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

  getContent(String no) async{
//    await getQueryPlanTaskBySerialInfo(1,no).then((data){
//      // 跳转页面
//      if(data != null){
////        Navigator.push( context,
////            new MaterialPageRoute(builder: (context) {
////              return NavigationCheckExec(data.id);
////            }));
////        if(this.widget.taskId != null && this.widget.taskId>0){
////          Navigator.push( context,
////              new MaterialPageRoute(builder: (context) {
////                return NavigationCheckExec(data.id,planId: this.widget.taskId,);
////              }));
////        }else{
////          Navigator.push( context,
////              new MaterialPageRoute(builder: (context) {
////                return NavigationCheckExec(data.id);
////              }));
////        }
//
//        Navigator.push(
//            context,
//            new MaterialPageRoute(
//                builder: (context) => new TaskProcessPage(
//                  task: widget.task,
//                  taskModel: widget.taskModel,
//                )));
//      }else{
//        Fluttertoast.showToast(
//          msg: '没有对应的巡检计划！',
//          toastLength: Toast.LENGTH_SHORT,
//        );
//      }
//    });

//    var sql = new StringBuffer();
//    sql.write("SELECT * ");
//    sql.write("FROM Point ");
//    sql.write("WHERE pointNo = ?");
//    dbAccess().queryData(sql.toString(),[no]).then((data){
//      if(data.length>0){
//        Navigator.push(
//            context,
//            new MaterialPageRoute(
//                builder: (context) => new TaskProcessPage(
//                  task: widget.task,
//                  taskModel: widget.taskModel,
//                )));
//      }else{
//        Fluttertoast.showToast(
//          msg: '没有对应的巡检计划！',
//          toastLength: Toast.LENGTH_SHORT,
//        );
//      }
//    });


    if(this.widget.taskModel.taskDetails[0].pointNo == no){
        await Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new TaskProcessPage(
                  task: widget.task,
                  taskModel: widget.taskModel,
                ))
        ).then((v){

             Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new TaskDetailPage(
                      task: this.widget.task,
                    ))
            );
        }
        );
      }else{
        Fluttertoast.showToast(
          msg: '请输入正确的标签！',
          toastLength: Toast.LENGTH_SHORT,
        );
      }

  }
}