import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityModel.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/services/Activility_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivilityRunLog extends StatefulWidget {
  final ActivilityModel initData;

  ActivilityRunLog(this.initData);

  @override
  _ActivilityRunLog createState() => new _ActivilityRunLog();
}

class _ActivilityRunLog extends State<ActivilityRunLog> {
  String theme="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getInitInfo();
  }

  void getInitInfo() async {
    await SharedPreferences.getInstance().then((data) {
      if (data != null) {
        setState(() {
          this.theme = data.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
        });
      }
    });

    var data=  await getLogInfo(this.widget.initData.id);
    if(data.success && this.widget.initData!=null){
      this.widget.initData.records=new List();
      for(var str in data.dataList){
        setState(() {
          this.widget.initData.records.add(new Records.fromJson(str));
        });
      }
    }else{
      HiddenDangerFound.popUpMsg(data.message??"获取日志失败");
    }
  }
  @override
  Widget build(BuildContext context) {
    ///null == routeList || routeList.length <= 0
    if (this.widget.initData == null) {
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
                  color:GetConfig.getColor(theme) /*GetConfig.getColor(theme)*/,
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
                color :GetConfig.getColor(theme),
                size: 32),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(children: <Widget>[
            //开关柜检修
            Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, top: 10,bottom: 10),
                    //height: 50,
                    child: Text(
                      this.widget.initData.taskworkName??"--",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),

              ],
            ),
            //等级
            Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, top: 10,bottom: 10),
                    //height: 50,
                    child: Text(
                      "等级",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(this.widget.initData.levelDesc??"--"),
                )
              ],
            ),
            // Divider(),

            Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, top: 10,bottom: 10),
                    //height: 50,
                    child: Text(
                      "申请时间",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(this.widget.initData.applyDateTime??"--"),
                ),
              ],
            ),

            Container(
              color: Color.fromRGBO(242, 246, 249, 1),
              margin: EdgeInsets.symmetric(
                horizontal: 2.0,
                vertical: 0.0,
              ),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: this.widget.initData.records==null?0:this.widget.initData.records.length ,
                itemBuilder: (context, index) {
                  return Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                          margin: EdgeInsets.only(left: 8, bottom: 10.0),
                          child: Container(
                            color: Color.fromRGBO(242, 246, 249, 1),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            width: double.infinity,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 10,
                                  margin: EdgeInsets.only(top: 10,bottom: 3),
                                  child: Text(this.widget.initData.records[index].executeTime??"--",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(154, 154, 154, 1),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                ),
                                Container(
                                    color: Colors.white,
                                    width:
                                        MediaQuery.of(context).size.width ,
//                                       margin:EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                        "${this.widget.initData.records[index].executeDepartmentName}\r\t${this.widget.initData.records[index].executeUserName}\r\t${this.widget.initData.records[index].excuteResult}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                154, 154, 154, 1),
                                            fontSize: 16))),
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width - 10,
                                  padding: EdgeInsets.only(bottom: 10, top: 8),
                                  color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  "审核意见",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w800,
                                                      fontSize: 16,
                                                      color: Color.fromRGBO(
                                                          154, 154, 154, 1)),
                                                ),
                                                flex: 9,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 7,
                                          child: Text(
                                              this.widget.initData.records[index].remark??
                                                  "--",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      154, 154, 154, 1),
                                                  fontSize: 16))),
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
                        left: 10.0,
                        child: Container(
                          height: double.infinity,
                          width: 1.0,
                          color: Colors.blue,
                        ),
                      ),
                      Positioned(
                        top: 33.0,
                        left: 4.5,
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
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.green),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
