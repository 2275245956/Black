import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityModel.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityStepModel.dart';
import 'package:intelligent_check_new/pages/ImageViewPage.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';

class ActivilityRunResult extends StatefulWidget {
  final ActivilityModel _activility;
  final StepModel stepModel;

  ActivilityRunResult(this._activility, this.stepModel);

  @override
  State<StatefulWidget> createState() {
    return _ActivilityRunResult();
  }
}

class _ActivilityRunResult extends State<ActivilityRunResult> {
  String strRouts = "";
  String strClassify = "";
  String permissionList = "";
  String theme = "";

  TextEditingController _remark=new TextEditingController();
  List<File> imageList;

  @override
  void initState() {
    super.initState();
  }

  Widget getRunResultDesc(int descStatus) {
    switch (descStatus) {
      case 0:
        return Text(
            "未确认",
            style: TextStyle(
              fontSize: 15,
              color:Colors.red,
            ));
        break;
      case 1: //未执行
        return Text(
          "未执行",
          style: TextStyle(
              fontSize: 15,
              color:Colors.red,
        ));
        break;
      case 2: //已执行
        return Text(
            "已执行",
            style: TextStyle(
            fontSize: 15,
            color:Colors.green,
        ));
        break;

    }
    return Text(
        "未知状态",
        style: TextStyle(
        fontSize: 15,
        color:Colors.grey,
    ));
  }


  Widget getVolitationSesc(int status){
    switch (status){

      case 0://未确认
        return Text(
          "未确认",
          style: TextStyle(
              fontSize: 15,
              color: Colors.red ),
        );
        break;
      case 1://无违章
       return Text(
          "无违章",
          style: TextStyle(
              fontSize: 15,
              color: Colors.green),
        );
       break;
      case 2://一般违章
        return Text(
          "一般违章",
          style: TextStyle(
              fontSize: 15,
              color: Colors.red),
        );
        break;
      case 3://严重违章
        return Text(
          "严重违章",
          style: TextStyle(
              fontSize: 15,
              color: Colors.red),
        );
        break;
    }
   return Text(
      "未知",
      style: TextStyle(
          fontSize: 15,
          color: Colors.grey),
    );

  }
  @override
  Widget build(BuildContext context) {
    if (this.widget._activility == null && this.widget.stepModel == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "执行结果",
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
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[],
        title: Text(
          "执行结果",
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
                      padding: EdgeInsets.only(left: 10, top: 10,bottom: 10),
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
                    child: Text(this.widget._activility.levelDesc ?? "--"),
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
                    child: Text(this.widget._activility.applyDateTime ?? "--"),
                  ),
                ],
              ),
              //分割线
              Container(
                color: Color.fromRGBO(242, 246, 249, 1),
                height: 10,
              ),

              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 10,bottom: 10),
                    //height: 50,
                    width: MediaQuery.of(context).size.width,

                    child: Text(
                      (this.widget.stepModel.serialNum.toString() +
                          "." +
                          (this.widget.stepModel.taskworkContentName ?? "--")),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                color: Color.fromRGBO(242, 246, 249, 1),
                height: 10,
              ),
              //控制措施
              this.widget.stepModel.taskworkMeasures != null
                  ? Column(
                      children: <Widget>[
                        Container(
                          child: Column(
                              children: this
                                  .widget
                                  .stepModel
                                  .taskworkMeasures
                                  .map((f) {
                            return Column(
                              children: <Widget>[
                                ///标题
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(
                                      left: 15, top: 10, right: 15, bottom: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 8,
                                        child: Text(
                                          f.measuresContent ?? "--",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: GestureDetector(
                                            child: Icon(
                                              Icons.message,
                                              color: f.showRemark ||
                                                      f.remark != null
                                                  ? Color.fromRGBO(
                                                      59, 89, 206, 1)
                                                  : Color.fromRGBO(
                                                      215, 219, 225, 1),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                f.showRemark = !f.showRemark;
                                              });
                                            },
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color.fromRGBO(242, 246, 249, 1),
                                  height: 1,
                                ),

                                ///选择项
                                Container(
                                  padding:
                                      EdgeInsets.only(left: 30, bottom: 15),
                                  height: 80,
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 7,
                                              child: Text(
                                                "执行结果",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              //带文字的单选按钮 value值=groupValue值 即选中状态
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child:getRunResultDesc(f.executeState),
                                              //带文字的单选按钮 value值=groupValue值 即选中状态
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 7,
                                              child: Text(
                                                "违章情况",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              //带文字的单选按钮 value值=groupValue值 即选中状态
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: getVolitationSesc(f.violateState),
                                              //带文字的单选按钮 value值=groupValue值 即选中状态
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                f.showRemark || f.remark != null
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            left: 20, bottom: 5),
                                        width:
                                            MediaQuery.of(context).size.width-40,
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, bottom: 5),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                  "备注",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 100,
                                              decoration: new BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      244, 244, 244, 1)),
                                              child: TextField(
                                                autofocus: false,
                                                enabled: false,
                                                minLines: 3,
                                                maxLines: 4,
                                                enableInteractiveSelection:true,
                                                controller: TextEditingController
                                                    .fromValue(TextEditingValue(
                                                        text: f.remark ?? "",
                                                        )),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5.0,
                                                          horizontal: 10),
                                                  border: InputBorder.none,
                                                  filled: true,
                                                  fillColor: Color.fromRGBO(
                                                      244, 244, 244, 1),
                                                ),

                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),
                                Container(
                                  color: Color.fromRGBO(242, 246, 249, 1),
                                  height: 5,
                                )
                              ],
                            );
                          }).toList()),
                        ),
                      ],
                    )
                  : Container(),

              Container(
                color: Color.fromRGBO(242, 246, 249, 1),
                height: 10,
              ),

              /// 备注
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 20, top: 10, bottom: 5),
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "执行备注",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 60,
                            height: 100,
                            margin: EdgeInsets.only(top: 10),
                            decoration: new BoxDecoration(
                                color: Color.fromRGBO(244, 244, 244, 1)),
                            child: TextField(

                              autofocus: false,
                              enabled: false,
                              controller: TextEditingController.fromValue(
                                  TextEditingValue(
                                      text: this.widget.stepModel.remark ?? "",
                                       )),
                              enableInteractiveSelection: true,
                              maxLines: null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Color.fromRGBO(244, 244, 244, 1),
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                color: Color.fromRGBO(242, 246, 249, 1),
                height: 10,
              ),

              ///拍照取证
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "现场照片",
                              textAlign: TextAlign.left,
                              style:
                              TextStyle(color: Colors.black, fontSize: 18),
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
                      child: GestureDetector(
                        child: Wrap(
                            spacing: -25.0, // 主轴(水平)方向间距
                            // runSpacing: 20.0, // 纵轴（垂直）方向间距
                            alignment: WrapAlignment.end, //沿主轴方向居中
                            children: this.widget.stepModel.imgs != null
                                ? this
                                .widget
                                .stepModel
                                .imgs
                                .split(",")
                                .map((purl) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    width: 40,
                                    height: 40,
                                    //  margin: EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        image: DecorationImage(
                                            image: NetworkImage(purl),
                                            fit: BoxFit.cover)),
                                  ),
                                ],
                              );
                            }).toList()
                                : List()),
                        onTap: () {
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (context) {
                                return PhotoViewPage(
                                    this.widget.stepModel.imgs.split(","));
                              }));
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      child: GestureDetector(
                        //50  89  206
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: GetConfig.getColor(theme),
                          size: 22,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                color: Color.fromRGBO(242, 246, 249, 1),
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }


}
