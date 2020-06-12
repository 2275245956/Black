import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityModel.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityStepModel.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/inspection_spot/dangerous_factors_detail.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:uuid/uuid.dart';

class ActivilityConfirmViolation extends StatefulWidget {
  final ActivilityModel _activility;
  final StepModel stepModel;
  ActivilityConfirmViolation(this._activility,this.stepModel);

  @override
  State<StatefulWidget> createState() {
    return _ActivilityConfirmViolation();
  }
}

class _ActivilityConfirmViolation extends State<ActivilityConfirmViolation> {
  String strRouts = "";
  String strClassify = "";
  String permissionList = "";
  String theme = "";
  bool isAnimating=false;

  List<File> imageList;

  Map<String, TextEditingController> _remarkController = Map();
  @override
  void initState() {
    super.initState();
    //添加备注参数
    this.widget.stepModel.uniqueKey=new Uuid().v4();
    this._remarkController[this.widget.stepModel.uniqueKey] = new TextEditingController(text: this.widget.stepModel.remark);
    for (StepMeasureModel stm in this.widget.stepModel.taskworkMeasures){
      stm.uniqueKeyForMeasures=new Uuid().v4();
      this._remarkController[stm.uniqueKeyForMeasures]=new TextEditingController(text: stm.remark);
    }
  }

  bool _checkNeed(){
     for(StepMeasureModel st in this.widget.stepModel.taskworkMeasures){
       if(st.violateState==0){
         HiddenDangerFound.popUpMsg("请完成《"+st.measuresContent+"》的状态选择！");
         return false;
       }
     }
     return true;
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget._activility == null && this.widget.stepModel == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "违章确认",
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
        actions: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(top: 15, right: 20),
              child: Text(
                "确定",
                style: TextStyle(
                    color: GetConfig.getColor(theme),
                    fontWeight: FontWeight.w800,
                    fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () {
              //返回数据   将controller的数据绑定并返回
              this.widget.stepModel.remark=this._remarkController[this.widget.stepModel.uniqueKey].text ?? "";
              for(StepMeasureModel stm in this.widget.stepModel.taskworkMeasures){
                stm.remark=this._remarkController[stm.uniqueKeyForMeasures].text ?? "";
              }
              if(_checkNeed()){
                Navigator.pop(context,this.widget.stepModel);
              }



            },
          ),
        ],
        title: Text(
          "违章确认",
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
      body: ModalProgressHUD(
        child:  SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        height: 50,
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
                        padding: EdgeInsets.only(left: 10, top: 10),
                        height: 50,
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
                        padding: EdgeInsets.only(left: 10, top: 10),
                        height: 50,
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
                      padding: EdgeInsets.only(left: 20, top: 10),
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
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(
                                left: 30,
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              child: GestureDetector(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "危险有害因素",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                      flex: 8,
                                    ),

                                  ],
                                ),
                                onTap: () {},
                              )),
                          Container(
                            color: Color.fromRGBO(242, 246, 249, 1),
                            height: 1,
                          ),
                          this.widget.stepModel.riskFactors!=null?Container(child:Column(
                            children: this.widget.stepModel.riskFactors.map((factor){
                              return Container(
                                  padding: EdgeInsets.only(left:40),
                                  width:  MediaQuery.of(context).size.width,
                                  height: 50,
                                  child:GestureDetector(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(factor.name,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16, ),),
                                          flex: 8,
                                        ),
                                        Expanded(
                                          child: Text(factor.rfLevel==null?"-":factor.rfLevel,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16 ),),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: new Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size:25,),
                                          flex: 1,
                                        ),
                                      ],
                                    ),
                                    onTap: (){
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context){
                                            return new DangerousFactorsDetail(factor.id,true);
                                          }));
                                    },
                                  )
                              );
                            }).toList(),
                          ),):Container(),

                        ],
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            height: 50,
                            child: Text(
                              "控制措施",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: Color.fromRGBO(242, 246, 249, 1),
                      height: 5,
                    ),
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
                                          child:GestureDetector(
                                            child:  Icon(
                                              Icons.message,
                                              color: f.showRemark  || f.remark!=null
                                                  ? Color.fromRGBO(59, 89, 206, 1)
                                                  : Color.fromRGBO(215, 219, 225, 1),
                                            ),
                                            onTap: (){
                                              setState(() {
                                                f.showRemark=!f.showRemark;
                                              });
                                            },
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color.fromRGBO(242, 246, 249, 1),
                                  height: 1,
                                ),

                                ///选择项
                                Container(
                                  height:160,
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
//                                      Expanded(
//                                        child: RadioListTile(
//                                            title: Text(
//                                              "未确认",
//                                              style: TextStyle(fontSize: 15),
//                                            ),
//                                            value: 0,
//                                            groupValue: f.violateState,
//                                            onChanged: (value) {
//                                              setState(() {
//                                                f.violateState = value;
//                                              });
//                                            }),
//                                        //带文字的单选按钮 value值=groupValue值 即选中状态
//                                      ),
                                      Expanded(
                                        child: RadioListTile(
                                            title: Text(
                                              "无违章",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            value: 1,
                                            groupValue: f.violateState,
                                            onChanged: (value) {
                                              setState(() {
                                                f.violateState = value;
                                              });
                                            }),
                                        //带文字的单选按钮 value值=groupValue值 即选中状态
                                      ),
                                      Expanded(
                                        child: RadioListTile(
                                            title: Text(
                                              "一般违章",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            value: 2,
                                            groupValue: f.violateState,
                                            onChanged: (value) {
                                              setState(() {
                                                f.violateState = value;

                                              });
                                            }),
                                        //带文字的单选按钮 value值=groupValue值 即选中状态
                                      ),
                                      Expanded(
                                        child: RadioListTile(
                                            title: Text(
                                              "严重违章",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            value: 3,
                                            groupValue: f.violateState,
                                            onChanged: (value) {
                                              setState(() {
                                                f.violateState = value;

                                              });
                                            }),
                                        //带文字的单选按钮 value值=groupValue值 即选中状态
                                      ),
                                    ],
                                  ),
                                ),


                                f.showRemark || f.remark!=null
                                    ? Container(
                                  padding:
                                  EdgeInsets.only(left: 20, bottom: 5),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          margin:EdgeInsets.only(top: 10,bottom: 5),
                                          width:MediaQuery.of(context).size.width,
                                          child:Text("备注",style: TextStyle(fontSize: 18),)),
                                      Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width-40,
                                        height: 100,
                                        decoration: new BoxDecoration(
                                            color: Color.fromRGBO(
                                                244, 244, 244, 1)),
                                        child: TextField(
                                          autofocus: true,
                                          minLines: 3,
                                          maxLines: 4,
                                          textInputAction: TextInputAction.done,
                                          enableInteractiveSelection: true,
                                          controller: _remarkController[
                                          f.uniqueKeyForMeasures],
                                          decoration: InputDecoration(
                                            contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 10),
                                            border: InputBorder.none,
                                            hintText: "请输入备注信息",
                                            filled: true,
                                            fillColor: Color.fromRGBO(
                                                244, 244, 244, 1),
                                          ),

                                          onEditingComplete: () {
                                            this.setState(() {
                                              f.remark =
                                                  _remarkController[f
                                                      .uniqueKeyForMeasures]
                                                      .text;
                                            });
                                          },
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



                Container(
                  color: Color.fromRGBO(242, 246, 249, 1),
                  height: 10,
                )
              ],
            ),
          ),
        ),
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
      ),
        resizeToAvoidBottomPadding: true);



  }

}
