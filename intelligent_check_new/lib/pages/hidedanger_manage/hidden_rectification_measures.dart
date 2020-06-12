import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/Hidden_Danger/hidden_danger_model.dart';
import 'package:intelligent_check_new/model/name_value.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HiddenRectificationMeasures extends StatefulWidget {
  HideDangerInfoModel initData;
  List<String> rectMeasures;
  HiddenRectificationMeasures(this.initData,this.rectMeasures);
  @override
  _HiddenRectificationMeasures createState() => new _HiddenRectificationMeasures();
}

class _HiddenRectificationMeasures extends State<HiddenRectificationMeasures> {
  // Default placeholder text
  var radioValue=0;
  String theme="";
  final TextEditingController _controller = new TextEditingController();
//  List<String> reviewNotes = List();
//  List<TextEditingController> controllers = List();
  Map<String,TextEditingController> controllers = Map();
  @override
  void initState() {
    // TODO: implement initState
    initInfo();

  }
  initInfo() async{
    await SharedPreferences.getInstance().then((data) {
      if (data != null) {
        setState(() {
          this.theme = data.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    //null == routeList || routeList.length <= 0
    if (this.widget.initData==null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("整改措施",style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.w500),),
          actions: <Widget>[

          ],
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading:new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child:Icon(Icons.keyboard_arrow_left, color:GetConfig.getColor(theme) /*GetConfig.getColor(theme)*/, size: 32),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("整改措施",style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.w500),),
        actions: <Widget>[
//          Align(
//              child:Padding(padding: EdgeInsets.only(right:15),
//                child: GestureDetector(
//                  child:Text("确定",style: TextStyle(color: GetConfig.getColor(theme),fontSize: 20,fontWeight: FontWeight.w800,fontFamily: 'Source Han Sans CN')),
//                  onTap: (){
//                    //保存   返回前一页
////                    var rectMeasures={
////                      "result":reviewNotes
////                    };
//                    Navigator.pop(context);
//                  },
//                ),
//              )
//          )
          Align(
              child: Padding(
                padding: EdgeInsets.only(right: 8),
                child: GestureDetector(
                    onTap: () {
                      if(this._controller.text.isNotEmpty){
                        // 保存输入框内容
                        this.widget.rectMeasures.add(this._controller.text);
                      }
                      Navigator.pop(context);
                    },
                  child: Icon(
                    Icons.save,
                    color: GetConfig.getColor(theme),
                    size: 32,
                  ), //Image.asset("assets/images/search_"+theme+".png",width: 20,color: GetConfig.getColor(theme)),
                  // child:Image.asset("assets/images/search_"+theme+".png",width: 20,color: GetConfig.getColor(theme)),
                ),
              ))
        ],
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading:new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child:Icon(Icons.keyboard_arrow_left, color:GetConfig.getColor(theme) /*GetConfig.getColor(theme)*/, size: 32),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[

              //隐患名称
              Row(
                children: <Widget>[
                  Expanded(flex: 5,
                    child:Container(
                      padding: EdgeInsets.only(left: 10,top:10),
                      width: 150,
                      height: 50,
                      child:Row(children: <Widget>[

                        Expanded(
                          child:Text("隐患名称",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                          flex: 19,
                        ),
                      ],),
                    ),),
                  Expanded(
                    flex: 5,
                    child:
                    Text(this.widget.initData.dangerName??"-"),),

                ],
              ),
              //隐患等级
              Row(
                children: <Widget>[
                  Expanded(flex: 5,
                    child:Container(
                      padding: EdgeInsets.only(left: 10,top:10),
                      width: 150,
                      height: 50,
                      child:Row(children: <Widget>[

                        Expanded(
                          child:Text("隐患等级",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                          flex: 19,
                        ),
                      ],),
                    ),),
                  Expanded(
                    flex:5,
                    child:
                    Text(this.widget.initData.levelDesc??"", style:TextStyle(color:this.widget.initData.level==1?Colors.orange:Colors.red),),),

                ],
              ),
              Container(
                color: Colors.grey[100],
                height: 10,
              ),

              //控制措施
              Row(
                children: <Widget>[
                  Expanded(flex: 10,
                    child:Container(

                      padding: EdgeInsets.only(left: 10,top:10),

                      height: 50,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          Expanded(
                            child:Text("控制措施",textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                            flex: 9,
                          ),
                        ],),
                    ),),
                  Expanded(
                    flex:1,
                    child:Container(
                      child:GestureDetector(
                        child: Icon(Icons.add_comment,color:GetConfig.getColor(theme),size:25,),
                        onTap: (){
                          if(this._controller.text==""){
                            HiddenDangerFound.popUpMsg("未输入内容");
                            return false;
                          }
                          if(!this.widget.rectMeasures.contains(this._controller.text)){
                            setState(() {
                              this.widget.rectMeasures.add(this._controller.text);
                              this._controller.text="";
                            });
                          }
                        },
                      ),
                    ),
                  ),


                ],
              ),
              Column(

                  children: this.widget.rectMeasures.map((f){
                    return Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left:10,top: 5,bottom: 5),
                          child: Row(

                            children: <Widget>[
                              Expanded(
                                child:Text(f,style: TextStyle(fontSize: 16),),
                                flex: 9,
                              ),
                              Expanded(
                                flex:1,
                                child: GestureDetector(
                                  child: Icon(Icons.clear,color: Colors.red,),
                                  onTap: (){

                                    setState(() {
                                      this.widget.rectMeasures.removeAt(this.widget.rectMeasures.indexOf(f));
                                    });
                                  },
                                ),
                              ),

                            ],
                          ),
                        ),

                      ],


                      // Text(f),


                    );
                  }).toList()
              ),
              Container(
                width: MediaQuery.of(context).size.width-50,
                height: 200,
                margin: EdgeInsets.only(top:30,bottom: 30),
                decoration: new BoxDecoration(
                    color:Color.fromRGBO(244, 244, 244, 1)
                ),
                child: TextField(
                  autofocus:false,
                  maxLength: 500,
                  controller: _controller,
                  enableInteractiveSelection: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 10),
                    border: InputBorder.none,

                    hintText: "请输入控制措施",
                    filled: true,
                    fillColor:Color.fromRGBO(244, 244, 244, 1),
                  ),
                  onEditingComplete: (){
                    print(this._controller.text);
                  },
                ),

              ),



            ],
          ),
        ),
      ),

    );
  }
}


