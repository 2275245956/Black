import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityModel.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityStepModel.dart';
import 'package:intelligent_check_new/model/MovePointAttachment.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/services/Activility_services.dart';
import 'package:intelligent_check_new/services/HiddenDanger.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:uuid/uuid.dart';

class ActivilitySteps2Running extends StatefulWidget {
  final ActivilityModel _activility;
  final StepsModel steps;

  ActivilitySteps2Running(this._activility, this.steps);

  @override
  State<StatefulWidget> createState() {
    return _ActivilitySteps2Running();
  }
}

class _ActivilitySteps2Running extends State<ActivilitySteps2Running> {
  String strRouts = "";
  String strClassify = "";
  String permissionList = "";
  String theme = "";
  bool isAnimating = false;
  bool canOperate = true;
  List<File> imageList;
  Map<String, TextEditingController> _remarkController = Map();
  List<TaskFactorModel> factors = new List();
  List<MeasuresModel> subModel = new List();

  @override
  void initState() {
    super.initState();
    //添加备注参数 TextEditingController
    _initData();
  }

  void _initData() async {
    setState(() {
      isAnimating = true;
      canOperate = false;
    });
    getDetailTree(
            this.widget._activility.id, this.widget.steps.taskworkContentId)
        .then((data) {
      if (data.success) {
        for (var str in data.dataList) {
          setState(() {
            factors.add(new TaskFactorModel.fromJson(str));
          });
        }
      } else {
        HiddenDangerFound.popUpMsg(data.message ?? "获取失败");
      }
    }).then((_) {
      if (factors != null && factors.length > 0) {
        for (TaskFactorModel tf in factors) {
          if (tf.measuresList != null && tf.measuresList.length > 0) {
            for (MeasuresModel mm in tf.measuresList) {
              mm.uniquekey = Uuid().v4();
              _remarkController[mm.uniquekey] =
                  TextEditingController(text: mm.envChangeIdea);
            }
          }
        }
      }
    });
    setState(() {
      isAnimating = false;
      canOperate = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _upDateImg(StepModel f, List<Attachment> att) async {
      setState(() {
        isAnimating = true;
        canOperate = false;
      });

      var bizCode = "task_work";

      await updataImg(att, bizCode).then((data) {
        setState(() {
          ///保存文件路径
          if (data.success) {
            if (f.imgs == null) {
              f.imgs = data.message + ",";
            } else {
              f.imgs = f.imgs + data.message + ",";
            }

            HiddenDangerFound.popUpMsg("图片上传成功!");
          } else {
            HiddenDangerFound.popUpMsg(data.message);
          }

          isAnimating = false;
          canOperate = true;
        });
      });
    }

    bool _checkNeed() {
      if (factors != null && factors.length > 0) {
        for (TaskFactorModel tf in factors) {
          if (tf.measuresList != null && tf.measuresList.length > 0) {
            for (MeasuresModel mm in tf.measuresList) {
              //赋值
              mm.envChangeIdea = "${_remarkController[mm.uniquekey].text}";
              //验证
              if (mm.envEnsureStatus == 0) {
                HiddenDangerFound.popUpMsg("请选择....");
                return false;
              }
              subModel.add(mm);
            }
          }
        }
      }
      return true;
    }

    void confirmAll() {
      if (factors != null && factors.length > 0) {
        for (TaskFactorModel tf in factors) {
          if (tf.measuresList != null && tf.measuresList.length > 0) {
            for (MeasuresModel mm in tf.measuresList) {
              setState(() {
                mm.envEnsureStatus = 1;
                tf.isShow = true;
              });
            }
          }
        }
      }
    }

    Future<void> _saveMeaasures() async {
      if (subModel.length > 0) {
        var jsonArray = [];
        for (MeasuresModel mm in subModel) {
          jsonArray.add(mm);
        }
        await UpdateMeasures(jsonArray).then((data) {
          if (data.success) {
            Navigator.pop(context);
          }
          setState(() {
            subModel = new List();
          });
        });
      }
    }

    void saveMeasureAndBack() async {
      try {
        await _saveMeaasures();
      } catch (e) {
        Navigator.pop(context);
      }
    }

    // TODO: implement build
    if (this.widget._activility == null &&
        this.widget.steps == null &&
        factors.length > 0) {
      return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "措施确认",
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
          floatingActionButton: new Builder(builder: (BuildContext context) {
            return new FloatingActionButton.extended(
              label: Text("全部确认"),
              heroTag: null,
              foregroundColor: Colors.white,
              backgroundColor: GetConfig.getColor(theme),
              elevation: 7.0,
              highlightElevation: 14.0,
              onPressed: () {
                confirmAll();
              },
            );
          }),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "措施确认",
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
                onTap: () {
                  if (_checkNeed()) {
                    saveMeasureAndBack();
                  }
                },
                child: Icon(Icons.keyboard_arrow_left,
                    color: GetConfig.getColor(theme), size: 32),
              ),
            ),
          ),
          body: ModalProgressHUD(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    //开关柜检修
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 10, top: 10, bottom: 10),
                            //height: 50,
                            child: Text(
                              this.widget._activility.taskworkName ?? "--",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
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
                            padding:
                                EdgeInsets.only(left: 10, top: 10, bottom: 10),
                            //height: 50,
                            child: Text(
                              "等级",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child:
                              Text(this.widget._activility.levelDesc ?? "--"),
                        )
                      ],
                    ),
                    // Divider(),

                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 10, top: 10, bottom: 10),
                            //height: 50,
                            child: Text(
                              "申请时间",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                              this.widget._activility.applyDateTime ?? "--"),
                        ),
                      ],
                    ),
                    //分割线
                    Container(
                      color: Color.fromRGBO(242, 246, 249, 1),
                      height: 10,
                    ),

                    this.factors != null
                        ? Column(
                            children: this.factors.map((s) {
                            return Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${this.factors.indexOf(s) + 1}.  ${s.riskFactorName}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: s.measuresList != null
                                          ? s.measuresList.map((m) {
                                              return Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            left: 40,
                                                            right: 40),
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10,
                                                                bottom: 10),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                  flex: 9,
                                                                  child: Text(m
                                                                      .measureContentName),
                                                                ),
                                                                Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        GestureDetector(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .message,
                                                                        color: GetConfig.getColor(
                                                                            theme),
                                                                        size:
                                                                            28,
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          m.showRemark =
                                                                              !m.showRemark;
                                                                        });
                                                                      },
                                                                    )),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Flexible(
                                                                  child:
                                                                      RadioListTile(
                                                                    value: 1,
                                                                    groupValue:
                                                                        m.envEnsureStatus,
                                                                    title: Text(
                                                                      "已确认",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                    onChanged:
                                                                        (val) {
                                                                      setState(
                                                                          () {
                                                                        m.envEnsureStatus =
                                                                            val;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                  child:
                                                                      RadioListTile(
                                                                    value: 2,
                                                                    groupValue:
                                                                        m.envEnsureStatus,
                                                                    title: Text(
                                                                      "现场整改",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                    onChanged:
                                                                        (val) {
                                                                      setState(
                                                                          () {
                                                                        m.envEnsureStatus =
                                                                            val;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )),
                                                    m.showRemark
                                                        ? Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 40,
                                                                    right: 40,
                                                                    bottom: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                50,
                                                            height: 100,
                                                            decoration:
                                                                new BoxDecoration(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            244,
                                                                            244,
                                                                            244,
                                                                            1)),
                                                            child: TextField(
                                                              autofocus: false,
                                                              maxLength: 500,
                                                              controller: this
                                                                      ._remarkController[
                                                                  m.uniquekey],
                                                              enableInteractiveSelection:
                                                                  true,
                                                              maxLines: null,
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            10.0,
                                                                        horizontal:
                                                                            10),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    "请输入备注信息",
                                                                filled: true,
                                                                fillColor: Color
                                                                    .fromRGBO(
                                                                        244,
                                                                        244,
                                                                        244,
                                                                        1),
                                                              ),
                                                              inputFormatters: <
                                                                  TextInputFormatter>[
                                                                LengthLimitingTextInputFormatter(
                                                                    500)
                                                                //限制长度
                                                              ],
                                                            ))
                                                        : Container()
                                                  ],
                                                ),
                                              );
                                            }).toList()
                                          : Container(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList())
                        : Container(),

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
          resizeToAvoidBottomPadding: true),
      onWillPop: () {
        saveMeasureAndBack();
        Navigator.pop(context);
      },
    );
  }
}
