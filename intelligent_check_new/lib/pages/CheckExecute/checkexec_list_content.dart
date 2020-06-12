import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/plan_inspection/check_point_detail.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageListView.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_item_content.dart';
import 'package:intelligent_check_new/pages/ImageViewPage.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_Inspection_danger_add.dart';
import 'package:intelligent_check_new/services/plan_inspection_services.dart';
import 'package:intelligent_check_new/tools/DateUtil.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckExecListContent extends StatefulWidget{

  final num id;//巡检点check Id
  CheckExecListContent(this.id);

  @override
  State<StatefulWidget> createState() {
    return _CheckExecListContent();
  }

}

class _CheckExecListContent extends State<CheckExecListContent>{

  CheckPointDetail _checkPointDetail;
//  QueryCheckDetail _queryCheckDetail;
  String theme="";
  List<Image> imageList = List();
  List<NetworkImage> imageListThumb = List();


  @override
  Widget build(BuildContext context) {
    num thumbIdx=-1;
    if(_checkPointDetail == null){
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
              child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_checkPointDetail.pointName??"计划外",style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.w500),),
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
        actions: <Widget>[
          _checkPointDetail.pointStatus=="2"?
          IconButton(
            icon: new Icon(Icons.note_add),
            tooltip: '添加任务',
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(
                      builder: (context) => new InspectionHiddenDangerFound(true,checkId:_checkPointDetail.checkId)
                  ));
            },
            color: GetConfig.getColor(theme),
          ):Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20,top:10),
                    width: 150,
                    height: 40,
                    child: Text("点编号",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                  ),Text(_checkPointDetail.pointNo??""),
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20,top:10),
                    width: 150,
                    height: 40,
                    child: Text("巡检计划",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                  ),
                Container(
                  width: MediaQuery.of(context).size.width-150,
                  child: Text(_checkPointDetail.planName??"计划外"),
                  padding: EdgeInsets.only(top:10),

                )
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20,top:10),
                    width: 150,
                    height: 40,
                    child: Text("执行时间",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                  ),Text(DateUtil.timestampToDate(_checkPointDetail.checkTime??0)),
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20,top:10),
                    width: 150,
                    height: 40,
                    child: Text("执行部门",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                  ),Text(_checkPointDetail.departmentName??""),
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20,top:10),
                    width: 150,
                    height: 40,
                    child: Text("执行人",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                  ),Text(_checkPointDetail.username??""),
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20,top:10),
                    width: 150,
                    height: 40,
                    child: Text("点状态",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                  ),Text(getPointStatus(_checkPointDetail.pointStatus),style: TextStyle(color: getPointColor(_checkPointDetail.pointStatus)),),
                ],
              ),
              Container(
                color: Colors.grey[100],
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 20,top:10),
                height: 40,
                child: Text("检查项目",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                alignment: Alignment.centerLeft,
              ),
              Divider(height: 1,),
              Padding(padding: EdgeInsets.only(top: 10),),
//            Row(
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.only(left: 20,top:15,right: 10),
//                  width: 120,
//                  height: 50,
////                  padding: EdgeInsets.only(top: 10),
//                  child: Text("关联检查项",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
//                ),
//                Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: _checkPointDetail.checkInputs.map((f){
//                    return GestureDetector(
//                      child: Container(
//                        child: Text(f.inputName,style: TextStyle(color: (f.inputStatus == "2" ? Colors.red : Colors.black))),
//                        width: 230,
//                      ),
//                      onTap: (){
//                        Navigator.push( context,
//                            new MaterialPageRoute(builder: (context) {
//                              return new CheckExecItemContent(_checkPointDetail.checkId);
//                            }));
//                      },
//                    );
//                  }).toList(),
//                )
//              ],
//            ),
              Container(
                  child: Column(
                    children: _checkPointDetail.checkInputs.keys.map((f){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                              child: Container(
                                  width: 280,
                                  padding: EdgeInsets.only(left: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      f=="其他"?Container():
                                      Container(
                                        height: 20,
                                        child: Text(f,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                        alignment: Alignment.topLeft,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: _checkPointDetail.checkInputs[f].map((item){
                                              return Text("${_checkPointDetail.checkInputs[f].indexOf(item)+1}.  ${item.inputName}",style: TextStyle(color: (item.inputStatus == "2" ? Colors.red : Colors.black),fontSize: 14));
                                            }).toList()
                                        ),
                                      )
                                    ],
                                  )
                              ),
                              onTap: (){
                                Navigator.push( context,
                                    new MaterialPageRoute(builder: (context) {
                                      return new CheckExecItemContent(_checkPointDetail.checkId);
                                    }));
                              }
                          ),
//                          Divider(height: 1,)
                        ],
                      );
                    }).toList(),
                  )
              ),
              Container(
                height: 10.0,
                color: Colors.grey[100],
              ),
              GestureDetector(
                child:Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 20.0),
                    child:  Row(
                      children: <
                          Widget>[
                        Expanded(
                          flex:3,
                          child:Container(
                            padding: EdgeInsets.only(top: 10),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "现场照片",
                                    textAlign: TextAlign.left,
                                  ),
                                  flex: 9,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            child: Wrap(
                                spacing: -25.0,
                                // 主轴(水平)方向间距
                                // runSpacing: 20.0, // 纵轴（垂直）方向间距
                                alignment: WrapAlignment
                                    .end,
                                //沿主轴方向居中
                                children:
                                this._checkPointDetail.pointImgUrls != null
                                    ? this._checkPointDetail.pointImgUrls.map((f) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <
                                        Widget>[
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius
                                                .all(
                                                Radius
                                                    .circular(
                                                    20.0)),
                                            image: DecorationImage(
                                                image: NetworkImage(f),
                                                fit: BoxFit.cover)),
                                      ),
                                    ],
                                  );
                                }).toList()
                                    : List()),
                          )
                        ),
                        Expanded(
                          flex:
                          1,
                          child:
                          Container(
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: GetConfig.getColor(theme),
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return PhotoViewPage(this._checkPointDetail.pointImgUrls);
                  }));
                },
              ),
//              GestureDetector(
//                child:Padding(
//                    padding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 20.0),
//                    child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Row(
//                            children: <Widget>[
//
//                              Text("现场照片"),
//                              this.imageListThumb.length > 0 ?
//                                  Container(
//                                width: 260,
//                                height: 30,
//                                padding: EdgeInsets.only(left: 210.0 - imageListThumb.length*20.0),
//                                child: Stack(
//                                  children: imageListThumb.map((f){
//                                   thumbIdx ++;
//                                    return thumbIdx ==0?
//                                    Positioned(
////                                      left: 0,
//                                      child: CircleAvatar(child: Image.network(f.url,height: 25,),backgroundColor: Colors.grey, radius: 20,),
//                                    ) :Positioned(
//                                      left: thumbIdx * 25.0,
//                                      child: CircleAvatar(child: Image.network(f.url,height: 25,),backgroundColor: Colors.grey, radius: 20,),
//                                    );
//                                  }).toList(),
//
//                                ),
//                              )
//                                  :Container( width: 260,),
//                              new Icon(
//                                Icons.keyboard_arrow_right,
//                                color: GetConfig.getColor(theme),
//                                size: 20,
//                              ),
//                            ],
//                          ),
//                        ])),
//                onTap: (){
//                  Navigator.push(context, MaterialPageRoute(builder:(context){
//                    return ImageListView(this.imageList);
//                  }));
//                },
//              ),
              Container(
                height: 10.0,
                color: Colors.grey[100],
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("备注"),
                    Container(
                      margin: EdgeInsets.only(right: 20, top: 20),
                      height: 80,
                      width: double.infinity,
                      color: Colors.grey[100],
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(null == _checkPointDetail.remark ? "" : _checkPointDetail.remark),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          color: Colors.white,
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();

    getData();
    initConfig();
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }


  getData() async{
    await queryCheckPointDetail(this.widget.id).then((data){
      if(data != null){
        setState(() {
          _checkPointDetail = data;

          // wangkai 20190614
          _checkPointDetail.pointImgUrls.forEach((url){
//            print(url);
            if(null != url && url.isNotEmpty){
              if(url.endsWith("jpg")){
                this.imageList.add(Image.network(url.replaceAll("\\", "/")));
                imageListThumb.add(NetworkImage(url.replaceAll("\\", "/")));
              }
            }
//            print(imageList);
            imageListThumb = imageListThumb.length>3?imageListThumb.sublist(0,3).toList():imageListThumb;
          });
        });
      }
    });
  }

  String getPointStatus(String pointStatus){
    if(pointStatus == "0") {
      return "未开始";
    }else if(pointStatus == "1") {
      return "正常";
    }else if(pointStatus == "2") {
      return "异常";
    }else if(pointStatus == "3") {
      return "漏检";
    }else{
      return "";
    }
  }
  Color getPointColor(String pointStatus){
    if(pointStatus == "0") {
      return Colors.grey;
    }else if(pointStatus == "1") {
      return Colors.green;
    }else if(pointStatus == "2") {
      return Colors.red;
    }else if(pointStatus == "3") {
      return Colors.orange;
    }else{
      return Colors.white;
    }
  }
}