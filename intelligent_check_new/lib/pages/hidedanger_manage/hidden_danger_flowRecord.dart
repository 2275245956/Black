import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/Hidden_Danger/hidden_danger_model.dart';
import 'package:intelligent_check_new/pages/ImageViewPage.dart';
import 'package:intelligent_check_new/services/HiddenDanger.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HidenDangerFlowRecord extends StatefulWidget {
  final dangerId;

  HidenDangerFlowRecord(this.dangerId);

  @override
  _HidenDangerFlowRecord createState() => new _HidenDangerFlowRecord();
}

class _HidenDangerFlowRecord extends State<HidenDangerFlowRecord> {
  HideDangerInfoModel initData;
  Map<String,List<String>> photoMap=new Map();
  String theme="";
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
    }).then((data) {
      getFlowRecords();
    });

  }

  void getFlowRecords() async {
    await getDangerFlowRrecord(this.widget.dangerId).then((data) {
     if(mounted){
       setState(() {
         if(data!=null){
           this.initData=data;


           for(RecordItem item in initData.records.list){
             if(item.flowJson!="" && item.flowJson!=null){
               String photosUrls= json.decode(item.flowJson)["photoUrls"];
               if(photosUrls!=null && photosUrls!=""){
                 photoMap[item.actionFlag]=photosUrls.split(',');
               }

             }
           }

         }

       });
     }


    });
  }


  @override
  Widget build(BuildContext context) {
    ///null == routeList || routeList.length <= 0
    if (this.initData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "执行日志",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.keyboard_arrow_left,
                  color: Color.fromRGBO(
                      50, 89, 206, 1) /*GetConfig.getColor(theme)*/,
                  size: 32),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "执行日志",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.keyboard_arrow_left,
                color: Color.fromRGBO(
                    50, 89, 206, 1) /*GetConfig.getColor(theme)*/,
                size: 32),
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
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      width: 150,
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "隐患名称",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                            flex: 19,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(this.initData.dangerName ?? "-"),
                  ),
                ],
              ),
              //隐患等级
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      width: 150,
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "隐患等级",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                            flex: 19,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      this.initData.levelDesc ?? "",
                      style: TextStyle(
                          color: this.initData.level == 1
                              ? Colors.orange
                              : Colors.red),
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.grey[100],
                height: 10,
              ),

              initData.records != null && initData.records.list != null
                  ? Container(
                color:Color.fromRGBO(242, 246, 249, 1),
                margin: EdgeInsets.symmetric( horizontal: 2.0,vertical: 0.0, ),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: initData.records.list.length,
                  itemBuilder:(context,index){
                    return  Stack(

                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Container(

                            margin: EdgeInsets.only(left:8,bottom:10.0),
                            child: Container(
                              color:Color.fromRGBO(242, 246, 249, 1),
                              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              width: double.infinity,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width:MediaQuery.of(context).size.width-100,
                                    margin:EdgeInsets.only(bottom: 10),
                                    child: Text(initData.records.list[index].executeTime,
                                        textAlign: TextAlign.left,
                                        style:TextStyle(color:Color.fromRGBO(154, 154, 154, 1),
                                            fontSize: 16,fontWeight:FontWeight.w600 )),
                                  ),
                                  Container(

                                      color:Colors.white,
                                      width:MediaQuery.of(context).size.width-100,
//                                       margin:EdgeInsets.only(top: 10),
                                      padding:EdgeInsets.all(10.0),
                                      child:Text("${initData.records.list[index].executeDepartmentName}\r\t${initData.records.list[index].executeUserName}\r\t${initData.records.list[index].excuteResult}",
                                          textAlign: TextAlign.left,
                                          style:TextStyle(color:Color.fromRGBO(154, 154, 154, 1),fontSize: 16))
                                  ),
                                  Container(
                                    height: 10,
                                    color:Color.fromRGBO(242, 246, 249, 1),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    width:MediaQuery.of(context).size.width-100,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(flex: 4,
                                          child:Container(

                                            padding: EdgeInsets.only(left: 10,),

                                            height: 50,
                                            child:Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child:Text("拍照取证",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(fontWeight: FontWeight.w800,fontSize: 16,color: Color.fromRGBO(154,154,154,1)),),

                                                ),
                                              ],),
                                          ),),

                                        Expanded(
                                          flex: 6,
                                          child:Container(
                                            child:GestureDetector(
                                              child:   Wrap(
                                                  direction: Axis.horizontal,
                                                  spacing: -25.0, // 主轴(水平)方向间距
                                                  // runSpacing: 20.0, // 纵轴（垂直）方向间距
                                                  alignment: WrapAlignment.end, //沿主轴方向居中
                                                  children: this.photoMap[initData.records.list[index].actionFlag]!=null?
                                                  this.photoMap[initData.records.list[index].actionFlag].map((f){
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 40,
                                                          height:40,
                                                          //  margin: EdgeInsets.only(right: 5),
                                                          decoration: BoxDecoration(
                                                              color:Colors.transparent,
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(20.0)
                                                              ),
                                                              image: DecorationImage(image: NetworkImage(f),
                                                                  fit: BoxFit.cover)
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }).toList()
                                                      :List()
                                              ),
                                              onTap: (){
                                                if(this.photoMap[initData.records.list[index].actionFlag]!=null && this.photoMap[initData.records.list[index].actionFlag].length>0){
                                                  Navigator.push(context,new MaterialPageRoute(builder: (context){
                                                    return PhotoViewPage(this.photoMap[initData.records.list[index].actionFlag]);
                                                  }));}
                                              },
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          flex:1,
                                          child:Container(
                                            child:GestureDetector(
                                              //50  89  206
                                              child: Icon(Icons.keyboard_arrow_right,color:GetConfig.getColor(theme),size: 22,),
                                              onTap: (){
                                                  Navigator.push(context,new MaterialPageRoute(builder: (context){
                                                    return PhotoViewPage(this.photoMap[initData.records.list[index].actionFlag]);
                                                  }));

                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:MediaQuery.of(context).size.width-100,
                                    padding:EdgeInsets.only(bottom: 10,top: 8),
                                    color: Colors.white,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(flex: 3,
                                          child:Container(

                                            padding: EdgeInsets.only(left: 10,),


                                            child:Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[

                                                Expanded(
                                                  child:Text("备注",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(fontWeight: FontWeight.w800,fontSize: 16,color: Color.fromRGBO(154,154,154,1)),),
                                                  flex: 9,
                                                ),
                                              ],),
                                          ),),

                                        Expanded(
                                            flex: 7,
                                            child: Text(initData.records.list[index].remark??"--",textAlign: TextAlign.left,
                                                style:TextStyle(color:Color.fromRGBO(154, 154, 154, 1),fontSize: 16))
                                        ),

                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          bottom: 0.0,
                          left: 35.0,
                          child: Container(
                            height: double.infinity,
                            width: 1.0,
                            color: Colors.blue,
                          ),
                        ),
                        Positioned(
                          top:65.0,
                          left: 29.5,
                          child: Container(
                            height: 12.0,
                            width: 12.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Container(
                              margin: EdgeInsets.all(2.0),
                              height: 16.0,
                              width: 16.0,
                              decoration:
                              BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                            ),
                          ),
                        )
                      ],
                    );
                  } ,

                ),
              ) :Container(),
            ]
          ),
        ),
      ),
    );
  }
}
