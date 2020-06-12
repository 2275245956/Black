import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/CheckPoint.dart';
import 'package:intelligent_check_new/model/CheckPointDetail.dart';
import 'package:intelligent_check_new/services/check_point_service.dart';

class PlanListContentDetail extends StatefulWidget{

  CheckPoint selectPoint;
  PlanListContentDetail(this.selectPoint);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlanListContentDetail(selectPoint);
  }
}

class _PlanListContentDetail extends State<PlanListContentDetail>{
  bool _switchSelected=true;
  // 页面数据体
  CheckPointDetail pointDetail;
  // 页面接受参数对象
  CheckPoint selectPoint;
  // 构造方法
  _PlanListContentDetail(this.selectPoint);
  @override
  void initState() {
    super.initState();
    getInitInfo();
  }

  @override
  Widget build(BuildContext context) {
    // 数据未加载完成，只显示头部
    if(null == pointDetail){
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
        )
      );
    }

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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:10),
                  width: 150,
                  height: 40,
                  child: Text("巡检点名称",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),Text(pointDetail.point.pointName != null ? pointDetail.point.pointName : ""),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:10),
                  width: 150,
                  height: 40,
                  child: Text("",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),Text(pointDetail.point.pointNo != null ? pointDetail.point.pointNo : ""),
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
                  child: Text("点类型",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),Text(pointDetail.point.fixed != null ? pointDetail.point.fixed : ""),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:10),
                  width: 150,
                  height: 40,
                  child: Text("归属区域\\部门",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),Text(pointDetail.point.departmentName != null ? pointDetail.point.departmentName : ""),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:10),
                  width: 150,
                  height: 40,
                  child: Text("责任人",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),Text(pointDetail.point.userName != null ? pointDetail.point.userName : ""),
              ],
            ),
            Container(
              color: Colors.grey[100],
              height: 10,
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:10),
                  width: 150,
                  height: 40,
                  child: Text("巡检线路",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),Text(pointDetail.point.routeName != null ? pointDetail.point.routeName : ""),
              ],
            ),
            Container(
              color: Colors.grey[100],
              height: 10,
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:10),
                  width: 150,
                  height: 40,
                  child: Text("扩展分类",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),
                Column(
                 children: pointDetail.classify.map((f){
                   return Text(f.classifyName + ";");
                  }).toList(),
                ),
              ],
            ),
            Container(
              color: Colors.grey[100],
              height: 10,
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:15),
                  width: 150,
                  height: 50,
//                  padding: EdgeInsets.only(top: 10),
                  child: Text("检查项目",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pointDetail.inputItems.map((f){
                    return GestureDetector(
                      child: Text(f.inputItenName),
                      onTap: (){
                        // TODO:添加点击事件
                      },
                    );
                  }).toList(),
                )
              ],
            ),
            Container(
              color: Colors.grey[100],
              height: 10,
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:10),
                  width: 150,
                  height: 40,
                  child: Text("离线巡检",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),
                Switch(
                  value: _switchSelected,//当前状态
                  onChanged:(value){
                    setState(() {
                      _switchSelected=value;
                      // 设置离线巡检模式
                      setPatrolModeValue();
                    });
                  },
                ),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:10),
                  width: 150,
                  height: 40,
                  child: Text("NFC发卡",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                ),new Icon(Icons.keyboard_arrow_right,color: Colors.red,size: 16,),
              ],
            ),
            Container(
              color: Colors.grey[100],
              height: 10,
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20,top:10),
                  width: 150,
                  height: 40,
                  child: Text.rich(TextSpan(
                      children: [
                        TextSpan(
                          text: "*",
                          style: TextStyle(
                              color: Colors.red
                          ),
                        ),
                        TextSpan(
                          text: "备注说明",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ]
                  )),
                ),new Icon(Icons.note,color: Colors.red,size: 16,),new Icon(Icons.keyboard_arrow_right,color: Colors.red,size: 16,),
              ],
            ),
            Divider(),
            Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 20,top:0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(pointDetail.point.remark)
                      ],
                    )
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  void getInitInfo() async{
    // 获取线路数据
    await getCheckPointDetail(selectPoint.id).then((data){
      setState(() {
        pointDetail = data;
      });
    });
  }

  void setPatrolModeValue() async{
    // 设置离线巡检
    await setPatrolMode(this.selectPoint.id, this._switchSelected).then((data){
      // TODO：设置成功或失败处理
    });
  }

}