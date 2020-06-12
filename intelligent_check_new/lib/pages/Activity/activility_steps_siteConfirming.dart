import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityModel.dart';
import 'package:intelligent_check_new/model/Activility/ActivilityStepModel.dart';
import 'package:intelligent_check_new/model/MovePointAttachment.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageList.dart';
import 'package:intelligent_check_new/pages/ImageViewPage.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/services/Activility_services.dart';
import 'package:intelligent_check_new/services/HiddenDanger.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:uuid/uuid.dart';

class ActivilityStepsSiteConfirming extends StatefulWidget {
  final ActivilityModel _activility;
  final StepsModel steps;
  final bool readonly;

  ActivilityStepsSiteConfirming(this._activility, this.steps, this.readonly);

  @override
  State<StatefulWidget> createState() {
    return _ActivilityStepsSiteConfirming();
  }
}

class _ActivilityStepsSiteConfirming
    extends State<ActivilityStepsSiteConfirming> {
  String strRouts = "";
  String strClassify = "";
  String permissionList = "";
  String theme = "";
  bool isAnimating = false;
  bool canOperate = true;
  Map<String, TextEditingController> _remarkController = Map();
  List<TaskFactorModel> factorsList = new List();
  List<MeasuresModel> subModel = new List();
  List<String> imgList = new List();

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
            factorsList.add(new TaskFactorModel.fromJson(str));
          });
        }
      } else {
        HiddenDangerFound.popUpMsg(data.message ?? "获取失败");
      }
    }).then((_) {
      if (factorsList != null && factorsList.length > 0) {
        for (TaskFactorModel twr in factorsList) {
          if (twr.measuresList != null && twr.measuresList.length > 0) {
            for (MeasuresModel mm in twr.measuresList) {
              mm.uniquekey = Uuid().v4();
              mm.showRemark =
                  mm.siteChangeIdea != "" && mm.siteChangeIdea != null;
              _remarkController[mm.uniquekey] =
                  TextEditingController(text: mm.siteChangeIdea);
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
    _upDateImg(MeasuresModel f, List<Attachment> att) async {
      setState(() {
        isAnimating = true;
        canOperate = false;
      });

      var bizCode = "task_work";

      await updataImg(att, bizCode).then((data) {
        setState(() {
          ///保存文件路径
          if (data.success) {
            f.siteImgs = data.message;
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
      if (factorsList != null && factorsList.length > 0) {
        for (TaskFactorModel twr in factorsList) {
          if (twr.measuresList != null && twr.measuresList.length > 0) {
            for (MeasuresModel mm in twr.measuresList) {
              //验证
//              if (mm.siteEnsureStatus == 0) {
//                HiddenDangerFound.popUpMsg("请选择....");
//                return false;
//              }
              if (mm.siteEnsureStatus == 2 &&
                  _remarkController[mm.uniquekey].text == "") {
                HiddenDangerFound.popUpMsg("请输入《${mm.measureContentName}》的整改意见！");
                return false;
              }
              //赋值
              mm.siteChangeIdea = "${_remarkController[mm.uniquekey].text}";
              subModel.add(mm);
            }
          }
        }
      }
      return true;
    }

    void confirmAll() {
      if (factorsList != null && factorsList.length > 0) {
        for (TaskFactorModel twr in factorsList) {
          if (twr.measuresList != null && twr.measuresList.length > 0) {
            for (MeasuresModel mm in twr.measuresList) {
              setState(() {
                mm.siteEnsureStatus = 1;
                twr.isShow = true;
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
            setState(() {
              subModel = new List();
            });
            Navigator.pop(context);
          }
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
        factorsList.length > 0) {
      return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              this.widget.readonly ? "确认结果" : "措施确认",
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
            return (!this.widget.readonly)
                ? FloatingActionButton.extended(
              label: Text("全部确认"),
              heroTag: null,
              foregroundColor: Colors.white,
              backgroundColor: GetConfig.getColor(theme),
              elevation: 7.0,
              highlightElevation: 14.0,
              onPressed: () {
                confirmAll();
              },
            )
                : Container();
          }),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              this.widget.readonly ? "确认结果" : "措施确认",
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
                  if ((!this.widget.readonly)) {
                    if(_checkNeed()){
                      saveMeasureAndBack();
                    }

                  } else {
                    Navigator.pop(context);
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
                    this.factorsList != null
                        ? Column(
                        children: this.factorsList.map((s) {
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
                                    children:
                                    s.measuresList != null
                                        ? s.measuresList
                                        .map((m) {
                                      return Container(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          flex: 9,
                                                          child: Text(m
                                                              .measureContentName),
                                                        ),
                                                        Expanded(
                                                            flex: 1,
                                                            child: GestureDetector(
                                                              child: Icon(
                                                                Icons.message,
                                                                color: GetConfig
                                                                    .getColor(
                                                                    theme),
                                                                size: 28,
                                                              ),
                                                              onTap: () {
                                                                setState(() {
                                                                  m.showRemark =
                                                                  !m.showRemark;
                                                                });
                                                              },
                                                            )),
                                                      ],
                                                    ),
                                                    Divider(),
                                                    (!this.widget.readonly)
                                                        ? Row(
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: RadioListTile(
                                                            value: 1,
                                                            groupValue: m
                                                                .siteEnsureStatus,
                                                            title: Text(
                                                              "已确认",
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                            onChanged: (val) {
                                                              setState(() {
                                                                m
                                                                    .siteEnsureStatus =
                                                                    val;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: RadioListTile(
                                                            value: 2,
                                                            groupValue: m
                                                                .siteEnsureStatus,
                                                            title: Text(
                                                              "现场整改",
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                            onChanged: (val) {
                                                              setState(() {
                                                                m
                                                                    .siteEnsureStatus =
                                                                    val;
                                                                m.showRemark =
                                                                true;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                        : Container(
                                                      margin: EdgeInsets.only(
                                                          top: 20, bottom: 10),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            margin: EdgeInsets
                                                                .only(top: 10),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                  child: Text(
                                                                    "现场确认",
                                                                    textAlign: TextAlign
                                                                        .left,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                      "${m
                                                                          .siteEnsureStatus ==
                                                                          1
                                                                          ? '已确认'
                                                                          : (m
                                                                          .siteEnsureStatus ==
                                                                          2
                                                                          ? '现场整改'
                                                                          : '--')}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .green),
                                                                      textAlign: TextAlign
                                                                          .right),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: GestureDetector(
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .only(top: 10),
                                                        height: 50,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Text(
                                                                "拍照取证",
                                                                textAlign: TextAlign
                                                                    .left,
                                                              ),
                                                              flex: 9,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 7,
                                                      child:GestureDetector(
                                                        child:   Container(
                                                          child: Wrap(
                                                              spacing: -25.0,
                                                              // 主轴(水平)方向间距
                                                              // runSpacing: 20.0, // 纵轴（垂直）方向间距
                                                              alignment: WrapAlignment
                                                                  .end,
                                                              //沿主轴方向居中
                                                              children: m
                                                                  .siteImgs !=
                                                                  "" &&
                                                                  m.siteImgs !=
                                                                      null
                                                                  ? m.siteImgs
                                                                  .split(",")
                                                                  .map((f) {
                                                                return Column(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .end,
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      width: 40,
                                                                      height: 40,
                                                                      //  margin: EdgeInsets.only(right: 5),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .transparent,
                                                                          borderRadius: BorderRadius
                                                                              .all(
                                                                              Radius
                                                                                  .circular(
                                                                                  20.0)),
                                                                          image: DecorationImage(
                                                                              image: NetworkImage(
                                                                                  f),
                                                                              fit: BoxFit
                                                                                  .cover)),
                                                                    ),
                                                                  ],
                                                                );
                                                              }).toList()
                                                                  : List()),
                                                        ),
                                                        onTap: (){
                                                           Navigator.push(context, MaterialPageRoute(builder: (context){
                                                             return PhotoViewPage(m.siteImgs.split(","));
                                                           }));
                                                        },
                                                      ),

                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        child: Icon(
                                                          Icons.photo_camera,
                                                          color: GetConfig
                                                              .getColor(theme),
                                                          size: 22,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        child: Icon(
                                                          Icons
                                                              .keyboard_arrow_right,
                                                          color: GetConfig
                                                              .getColor(theme),
                                                          size: 22,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  if (!this.widget.readonly) {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                              return ImageList(
                                                                m.imageList,
                                                                limitCount: 5,
                                                              );
                                                            })).then((v) {
                                                      if (v != null) {
                                                        setState(() {
                                                          m.imageList = v;
                                                          List<
                                                              Attachment> fileData = new List();
                                                          if (null !=
                                                              m.imageList &&
                                                              m.imageList
                                                                  .length > 0) {
                                                            m.imageList
                                                                .forEach((f) {
                                                              fileData.add(
                                                                  Attachment
                                                                      .fromParams(
                                                                      file: f));
                                                            });
                                                            //保存图片
                                                            _upDateImg(
                                                                m, fileData);
                                                          }
                                                        });
                                                      }
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            m.showRemark
                                                ? Container(
                                                margin: EdgeInsets.only(
                                                    left: 40,
                                                    right: 40,
                                                    bottom: 10),
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width - 50,
                                                height: 100,
                                                decoration: new BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        244, 244, 244, 1)),
                                                child: TextField(
                                                  autofocus: false,
                                                  maxLength: 500,
                                                  enabled: (!this.widget
                                                      .readonly),
                                                  controller: this
                                                      ._remarkController[m
                                                      .uniquekey],
                                                  enableInteractiveSelection: true,
                                                  maxLines: null,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10),
                                                    border: InputBorder.none,
                                                    hintText: "请输入整改意见",
                                                    filled: true,
                                                    fillColor: Color.fromRGBO(
                                                        244, 244, 244, 1),
                                                  ),
                                                  inputFormatters: <
                                                      TextInputFormatter>[
                                                    LengthLimitingTextInputFormatter(
                                                        500)
                                                    //限制长度
                                                  ],
                                                ))
                                                : Container(),

                                            Container(
                                              color: Color.fromRGBO(
                                                  242,
                                                  246,
                                                  249,
                                                  1),
                                              height: 10,
                                            ),
                                          ],
                                        ),
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
        Navigator.pop(context);
      },
    );
  }
}
