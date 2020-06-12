import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/Hidden_Danger/hidden_danger_model.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';






class HiddenDangerProcessedRectificationMeasuresShow extends StatefulWidget {
  HideDangerInfoModel initData;
  HiddenDangerProcessedRectificationMeasuresShow(this.initData);

  @override
  _HiddenDangerProcessedRectificationMeasuresShow createState() => new _HiddenDangerProcessedRectificationMeasuresShow();
}

class _HiddenDangerProcessedRectificationMeasuresShow extends State<HiddenDangerProcessedRectificationMeasuresShow> {

  List<dynamic> reviewNotes = List();
  String theme="";
  @override
  void initState() {
    // TODO: implement initState
    initInfo();

  }
  void initInfo()async{
    await SharedPreferences.getInstance().then((data) {
      if (data != null) {
        setState(() {
          this.theme = data.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
        });
      }
    }).then((data) {
      if(this.widget.initData!=null){
        if(mounted){
          setState(() {
            var measures=json.encode(this.widget.initData.reformJson);
            reviewNotes.addAll(json.decode(measures)["rectMeasures"]);
          });
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    //null == routeList || routeList.length <= 0
    if (this.widget.initData==null) {
      return Scaffold(
          appBar: AppBar(
            title: Text("治理措施",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
            actions: <Widget>[

            ],
            centerTitle: true,
            elevation: 0.2,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            leading:new Container(
              child: GestureDetector(
                //  onTap: () => Navigator.pop(context),
                child:Icon(Icons.save,color:GetConfig.getColor(theme),size: 20,),//Image.asset("assets/images/search_"+theme+".png",width: 20,color: GetConfig.getColor(theme)),
              ),
            ),
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("治理措施",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500,fontFamily: 'Source Han Sans CN'),),
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
                          child:Text("隐患名称",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
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
                          child:Text("隐患等级",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
                          flex: 19,
                        ),
                      ],),
                    ),),
                  Expanded(
                    flex:5,
                    child:
                    Text(this.widget.initData.levelDesc??"-", style:TextStyle(color: Colors.orange),),),

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
                            child:Text("控制措施",textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Source Han Sans CN'),),
                            flex: 9,
                          ),
                        ],),
                    ),),

                ],
              ),

        Column(

                    children: this.reviewNotes.map((f){
                      return Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 40,top: 5,bottom: 5),
                            child: Row(

                              children: <Widget>[
                                Expanded(
                                  child:Text(f.toString(),style: TextStyle(fontSize: 16),),
                                  flex: 9,
                                ),


                              ],
                            ),
                          ),
                          Divider(),
                        ],


                        // Text(f),


                      );
                    }).toList()
                ),





        ],
          ),
        ),
      ),

    );
  }
}


