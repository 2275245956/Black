import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityModel.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityStepModel.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/services/Activility_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';

class ActivilityTeamViewSteps extends StatefulWidget {
  final ActivilityModel _activility;
  final StepsModel steps;

  ActivilityTeamViewSteps(this._activility, this.steps);

  @override
  State<StatefulWidget> createState() {
    return _ActivilityTeamViewSteps();
  }
}

class _ActivilityTeamViewSteps extends State<ActivilityTeamViewSteps> {
  String strRouts = "";
  String strClassify = "";
  String permissionList = "";
  String theme = "";
  List<TaskFactorModel> factorsList = new List();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await getDetailTree(
        this.widget._activility.id, this.widget.steps.taskworkContentId)
        .then((data) {
      if (data.success) {
        for (var str in data.dataList) {
          setState(() {
            factorsList.add(new TaskFactorModel.fromJson(str));
          });
        }
      } else {
        HiddenDangerFound.popUpMsg(data.message ?? "获取失败");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (this.widget.steps == null) {
      return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "措施清单",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            centerTitle: true,
            elevation: 0.2,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            leading: new Container(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.keyboard_arrow_left,
                    color: GetConfig.getColor(theme), size: 32),
              ),
            ),
          ),
        ),
        onWillPop: () {
          Navigator.pop(context);
        },
      );
    }
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "措施清单",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.keyboard_arrow_left,
                  color: GetConfig.getColor(theme), size: 32),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                //开关柜检修
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        //height: 50,
                        child: Text(
                          this.widget._activility.taskworkName ?? "--",
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
                        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        //height: 50,
                        child: Text(
                          "等级",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(this.widget._activility.levelDesc ?? "--"),
                    )
                  ],
                ),
                // Divider(),
                //所属部门/车间
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        //height: 50,
                        child: Text(
                          "申请时间",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child:
                          Text(this.widget._activility.applyDateTime ?? "--"),
                    ),
                  ],
                ),
                //分割线
                Container(
                  color: Color.fromRGBO(242, 246, 249, 1),
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 9,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${this.widget.steps.taskworkContentName}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                factorsList != null
                    ? Column(
                        children: factorsList.map((s) {
                        return Container(
                          child: Column(
                            children: <Widget>[
                            GestureDetector(
                            child:Row(
                              children: <Widget>[
                                Expanded(
                                    flex:9,
                                    child:Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${factorsList.indexOf(s) + 1}.  ${s.riskFactorName}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                ),
                                Expanded(
                                  flex:1,
                                  child:  Container(
                                    padding: EdgeInsets.all(10),
                                    alignment: Alignment.centerRight,
                                    child:Icon( s.isShow?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,size: 28,color:  GetConfig.getColor(theme),),
                                  ),
                                ),
                              ],
                            ),
                            onTap: (){
                              setState(() {
                                s.isShow=!s.isShow;
                              });
                            },
                          ),

                              Divider(),
                              s.isShow?Container(
                                child: Column(
                                  children: s.measuresList != null
                                      ? s.measuresList.map((m) {
                                          return Container(
                                            margin: EdgeInsets.only(left: 20,right: 20),
                                            padding: EdgeInsets.only(
                                                top: 10,
                                                bottom: 10),
                                            alignment:
                                            Alignment.centerLeft,
                                            child:
                                            Text(m.measureContentName),
                                          );
                                        }).toList()
                                      : Container(),
                                ),
                              ):Container(),
                            ],
                          ),
                        );
                      }).toList())
                    : Container(),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () {
        Navigator.pop(context);
      },
    );
  }
}
