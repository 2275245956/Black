import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/offline/offline_plan_list_output.dart';
import 'package:intelligent_check_new/model/plan_inspection/check_point_detail.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_item_content.dart';
import 'package:intelligent_check_new/pages/task_addition/task_addition_screen.dart';
import 'package:intelligent_check_new/tools/DateUtil.dart';

class CheckExecListContent extends StatefulWidget{

  final Point point;
  CheckExecListContent(this.point);

  @override
  State<StatefulWidget> createState() {
    return _CheckExecListContent();
  }

}

class _CheckExecListContent extends State<CheckExecListContent>{

  CheckPointDetail _checkPointDetail;
//  QueryCheckDetail _queryCheckDetail;

  @override
  Widget build(BuildContext context) {
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
              child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_checkPointDetail.pointName??"计划外",style: TextStyle(color: Colors.black,fontSize: 19),),
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
        actions: <Widget>[
          _checkPointDetail.pointStatus=="2"?
          IconButton(
            icon: new Icon(Icons.note_add),
            tooltip: '添加任务',
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(
                      builder: (context) => new TaskAdditionScreen(checkId:_checkPointDetail.checkId)
                  ));
            },
            color: Colors.red,
          ):Container(),
        ],
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
//                  padding: EdgeInsets.only(top: 10),
                  child: Text("巡检计划",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),Text(_checkPointDetail.planName??"计划外"),
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
              child: Text("检查项目",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
              alignment: Alignment.centerLeft,
            ),
            Divider(height: 1,),
            Padding(padding: EdgeInsets.only(top: 10),),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:15,right: 10),
                  width: 120,
                  height: 50,
//                  padding: EdgeInsets.only(top: 10),
                  child: Text("关联检查项",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _checkPointDetail.checkInputs.keys.map((f){
                    GestureDetector(
                        child: Container(
                            width: 280,
                            child: Column(
                              children: <Widget>[
                                Text(f),
                                Column(
                                    children: _checkPointDetail.checkInputs[f].map((item){
                                      return Text(item.inputName,style: TextStyle(color: (item.inputStatus == "2" ? Colors.red : Colors.black)));
                                    }).toList()
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
                    );
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
                  }).toList(),
                )
              ],
            ),
          ],
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async{
    print("this.widget.id:$this.widget.id");
    var point = this.widget.point;

//    int checkId;
//    int checkTime;
//    int pointId;
//    String departmentName;
//    String planName;
//    String pointName;
//    String pointNo;
//    String pointStatus;
//    String username;
//    List<String> pointImgUrls;
//    List<CheckInput> checkInputs;
//    String remark;

//    _checkPointDetail = CheckPointDetail.fromParams(
//     checkId : 0,//this.checkId = 0,//point.pointId;
//        // 0,//this.checkTime = 0;//point.pointId;
//      int.parse(point.pointId),//this.pointId = int.parse(point.pointId);
//      "",//this.departmentName = "";//point.departmentName;
//      "",//this.planName = "";//point.planName;
//      "",//this.pointName = "";//point.pointName;
//      point.pointNO,//this.pointNo = point.pointNO;
//      point.status,//this.pointStatus = point.status;
//      "",//this.username = "";//point.username;
//      null,//this.pointImgUrls = null;//
//      new List(),//this.checkInputs = new List();//
//      ""//this.remark = "";//point.remark;
//    );
    _checkPointDetail = CheckPointDetail.fromParams(
      checkId: 0
      ,checkTime: 0
      ,pointId: JunMath.parseInt(point.pointId)
      ,departmentName: ""
      ,planName: ""
      ,pointName: ""
      ,pointNo: point.pointNO,pointStatus: point.status,username: "",remark: ""
    );

    // TODO:为对应融合
//    _checkPointDetail.checkInputs = new List();
    _checkPointDetail.checkInputs = new Map();

    for(var item in point.inputItems){
      CheckInput chkInput = new CheckInput();
      chkInput.remark = "";//item.id;
      chkInput.checkInputId = JunMath.parseInt(item.id);//item.id;
      chkInput.dataJson = "";//item.id;
      chkInput.inputName = "";//item.id;
      chkInput.inputStatus = "";//item.id;
      chkInput.inputValue = //item.id;
      chkInput.isMultiline = //item.id;
      chkInput.isMust = //item.id;
      chkInput.itemType = //item.id;
      chkInput.orderNo = item.orderNo;//item.id;

      // TODO:为对应融合
//      _checkPointDetail.checkInputs.add(chkInput);
    }
//    await queryCheckPointDetail(this.widget.id).then((data){
//      if(data != null){
//        setState(() {
//          _checkPointDetail = data;
//        });
//      }
//    });
  }

  String getPointStatus(String pointStatus){
    if(pointStatus == "0") {
      return "未开始";
    }else if(pointStatus == "1") {
      return "合格";
    }else if(pointStatus == "2") {
      return "不合格";
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

class JunMath{
  static int parseInt(String str){
    try {
      if (str == null)
        return 0;
      if (str == "null")
        return 0;
      return int.parse(str);
    }catch(e){
      return 0;
    }
  }
}