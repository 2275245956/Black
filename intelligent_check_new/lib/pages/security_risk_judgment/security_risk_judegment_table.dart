import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/MovePointAttachment.dart';
import 'package:intelligent_check_new/model/SecurityRiskJudgement/SecurityRiskModel.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageList.dart';
import 'package:intelligent_check_new/pages/ImageViewPage.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/services/HiddenDanger.dart';
import 'package:intelligent_check_new/services/Security_Risk_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert' show json;


class SecurityRiskJudegmentTable extends StatefulWidget {
  final int taskId;
  final int type;
  final bool isSubmit;

  SecurityRiskJudegmentTable(this.taskId, this.type, this.isSubmit);

  @override
  State<StatefulWidget> createState() {
    return new _SecurityRiskJudegmentTable();
  }
}

class _SecurityRiskJudegmentTable extends State<SecurityRiskJudegmentTable> {
  _SecurityRiskJudegmentTable();

  bool isAnimating = false;
  bool canOperate = true;
  IconData iconsRun = Icons.keyboard_arrow_right;

  bool showOtherInfo = false;

  List<File> imageList;
  List<SecurityRiskItem> items = new List();
  String theme = "";

  Map<String, TextEditingController> _controllers = new Map();

  bool saveComplete = false;

  _upDateImg(SecurityRiskItem f, List<Attachment> att) async {
    setState(() {
      isAnimating = true;
      canOperate = false;
    });
    var bizCode = "risk_judgement";

    await updataImg(att, bizCode).then((data) {
      setState(() {
        ///保存文件路径
        if (data.success) {
          f.photoResult = data.message;
//          if (f.photoResult == null) {
//            f.photoResult = data.message;
//          } else {
//            f.photoResult = f.photoResult + data.message;
//          }
          HiddenDangerFound.popUpMsg("图片上传成功!");
        } else {
          HiddenDangerFound.popUpMsg(data.message);
        }

        isAnimating = false;
        canOperate = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getData();

    initConfig();
  }

  getData() async {
    setState(() {
      isAnimating = true;
    });
    //获取导航条数据
    await getJudgementItems(this.widget.taskId, this.widget.type, 1, null)
        .then((date) {
      setState(() {
        if (date.success && date.dataList != null) {
          for (var item in date.dataList) {
            SecurityRiskItem ri = new SecurityRiskItem.fromJson(item);
            ri.uniqueKey = new Uuid().v4();
            this._controllers[ri.uniqueKey] =
            new TextEditingController(text: ri.remarkResult);
            this.items.add(ri);
          }
        }
        isAnimating = false;
      });
    });
  }

  getSelectItems(SecurityRiskItem item) {
    if (item.selectJson == null) return Container();
    var options = List.from(json.decode(item.selectJson));
    return options != null
        ? Column(
            children: options.map((f) {
              return Expanded(
                  child: RadioListTile(
                      title: Text(
                        (f["name"] + "(" + f["tag"] + ")"),
                        style: TextStyle(fontSize: 16),
                      ),
                      value: f["id"],
                      groupValue: int.tryParse(item.selectResult ?? "0") ?? 0,
                      onChanged: (value) {
                        setState(() {
                          if (!this.widget.isSubmit)
                            item.selectResult = value.toString();
                        });
                      }));
            }).toList(),
          )
        : Container();
  }

  Widget getChildData(SecurityRiskItem item) {
    return item.showChild && item.children != null
        ? Column(
            children: item.children.map((f) {
              return Column(
                children: <Widget>[
                  ///标题
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 0,
                            child: Text(
                              "*",
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Text(
                              f.selectName,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: Icon(
                                  Icons.message,
                                  color: f.remarkResult != null
                                      ? GetConfig.getColor(theme)
                                      : Color.fromRGBO(215, 219, 225, 1),
                                ),
                                onTap: () {
                                  setState(() {
                                    f.remarkResult =
                                        f.remarkResult == null ? "" : null;
                                  });
                                },
                              )),
                        ],
                      )),

                  ///选择项
                  Container(height: 150, child: getSelectItems(f)),

                  ///备注
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 10, bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                f.remarkResult != null
                                    ? Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              "备注",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                f.remarkResult != null
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        height: 100,
                                        decoration: new BoxDecoration(
                                            color: Color.fromRGBO(
                                                244, 244, 244, 1)),
                                        child: TextField(
                                          autofocus:  !this.widget.isSubmit,
                                          enabled: !this.widget.isSubmit,
                                          textInputAction: TextInputAction.done,
                                          ///提交后不可再次编辑

                                          controller:
                                              this._controllers[f.uniqueKey],
                                          enableInteractiveSelection: true,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10),
                                            border: InputBorder.none,
                                            hintText: (!this.widget.isSubmit)
                                                ? "请输入备注信息"
                                                : "数据已提交无法编辑",
                                            filled: true,
                                            fillColor: Color.fromRGBO(
                                                244, 244, 244, 1),
                                          ),
                                          onEditingComplete: () {
                                            setState(() {
                                              f.remarkResult=this._controllers[f.uniqueKey].text;
                                            });

                                          },
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///拍照取证
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "现场照片",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
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
                                children: f.photoResult != null
                                    ? f.photoResult.split(",").map((purl) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              width: 40,
                                              height: 40,
                                              //  margin: EdgeInsets.only(right: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0)),
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
                                return PhotoViewPage(f.photoResult.split(","));
                              }));
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: GestureDetector(
                            child: Icon(
                              Icons.photo_camera,
                              color: GetConfig.getColor(theme),
                              size: 22,
                            ),
                            onTap: () {
                              if (this.widget.isSubmit)

                                ///提交后不能再次编辑
                                return false;

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ImageList(f.imageList,limitCount:5);
                              })).then((v) {
                                if (v != null) {
                                  setState(() {
                                    f.imageList = v;
                                    List<Attachment> fileData = new List();
                                    if (null != f.imageList &&
                                        f.imageList.length > 0) {
                                      f.imageList.forEach((img) {
                                        fileData.add(
                                            Attachment.fromParams(file: img));
                                      });

                                      //保存图片
                                      _upDateImg(f, fileData);
                                    }else{
                                      f.photoResult=null;
                                    }
                                  });
                                }
                              });
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
                    height: 5,
                  )
                ],
              );
            }).toList(),
          )
        : Container();
  }


  getChildren(SecurityRiskItem firstLevel) async {
    if (firstLevel.children.length == 0) {
      setState(() {
        isAnimating = true;
      });
      await getJudgementItems(
              this.widget.taskId, this.widget.type, 2, firstLevel.itemId)
          .then((date) {
        setState(() {
          if (date.success) {
            if (date.dataList != null) {
              for (var item in date.dataList) {
                SecurityRiskItem ri = new SecurityRiskItem.fromJson(item);
                ri.uniqueKey = new Uuid().v4();
                this._controllers[ri.uniqueKey] =
                    new TextEditingController(text: ri.remarkResult);
                firstLevel.children.add(ri);
              }
            } else {
              //为空   数据保存不做判断
              firstLevel.isFinish = true;
            }
          }
          isAnimating = false;
        });
      });
    }
  }

  saveRecord(SubmitDataModel model) async {
    await saveRecordTable(model).then((date) {
      HiddenDangerFound.popUpMsg(date.message);
      if (date.success) {
        Navigator.pop(context);
      }
    });
  }

  initConfig() async {
    SharedPreferences.getInstance().then((preferences) {
      setState(() {
        this.theme =
            preferences.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  bool _checkNeeded() {
    //遍历没有做操作的项
    for (SecurityRiskItem item in this.items) {
      if (items.indexOf(item) != 4) {
        //除其他内容外  检查项
        if (!item.isFinish &&
            item.children.length == 0 &&
            item.itemFinish == 0) {
          //有项目从未展开过  提示展开
          //未展开
          HiddenDangerFound.popUpMsg("《" + item.itemName + "》项未查看");
          return false;
        }

        for (SecurityRiskItem risk in item.children) {
          if (risk.selectResult != "" && risk.selectResult != null) {
            //展开了  全部子项操作了 将状态设置未已完成状态
            setState(() {
              item.isFinish = true;
              risk.itemFinish = 1;
              item.itemFinish = 1;
            });
          } else {
            //展开了  有子项未操作  提示操作
            HiddenDangerFound.popUpMsg("《" +
                item.itemName +
                "》   下有子项     <" +
                risk.itemName +
                ">    未操作！");
            setState(() {
              item.isFinish = false;
              item.itemFinish = 0;
            });
            return false;
          }
        }
      } else {
        setState(() {
          item.isFinish = true;

          item.itemFinish = 1;
        });
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (this.theme.isEmpty) {
      return Scaffold(body: Text(""));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "安全风险研判表",
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
//            onTap: (){
//              showDialog(
//                context: context,
//                barrierDismissible: true, // user must tap button!
//                builder: (BuildContext context) {
//                  return AlertDialog(
//                    title: Text('提示！'),
//                    content:Text('返回将不会保存您已填写的数据！\r\n确认返回？'),
//                    actions:<Widget>[
//
//                      FlatButton(
//
//                        child: Text('取消',style: TextStyle(fontSize: 18,color: Colors.grey),),
//                        onPressed: (){
//
//                        },
//                      ),
//                      FlatButton(
//
//                        child: Text('确定',style: TextStyle(fontSize: 18)),
//                        onPressed: (){
//
//                        },
//                      ),
//                    ],
//                    backgroundColor:Colors.white,
//                    elevation: 20,
//
//                    semanticLabel:'哈哈哈哈',
//                    // 设置成 圆角
//                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                  );
//                },
//              );
//
//            },
            child: Icon(Icons.keyboard_arrow_left,
                color: Color.fromRGBO(
                    50, 89, 206, 1) /*GetConfig.getColor(theme)*/,
                size: 32),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            child: this.widget.isSubmit
                ? Container()
                : Container(
                    child: Icon(
                      Icons.save,
                      size: 32,
                      color: GetConfig.getColor(theme),
                    ),
                    padding: EdgeInsets.only(right: 20),
                  ),

            ///提交后不能再次保存
            onTap: () {
              //正在上传图片不能做保存操作
              if (!this.canOperate) {
                HiddenDangerFound.popUpMsg("请等待操作完成...");
                return false;
              }
              if (_checkNeeded()) {
                //准备提交的数据
                SubmitDataModel subData = new SubmitDataModel.fromParams();
                List<SubModel> model = new List();

                for (SecurityRiskItem item in this.items) {
                  SubModel sm = new SubModel.fromParams(); //父级
                  sm.taskId = item.taskId;
                  sm.id = item.id;
                  sm.remarkResult =this._controllers[item.uniqueKey].text;
                  sm.inputResult = item.inputResult;
                  sm.photoResult = item.photoResult;
                  sm.deleted = item.deleted;
                  sm.itemId = item.itemId;
                  sm.selectResult = item.selectResult;
                  sm.itemFinish = item.itemFinish;
                  if (item.children.length > 0) {
                    //子级
                    sm.childs = new List();
                    for (SecurityRiskItem risk in item.children) {
                      sm.childs.add(new SubModel.fromParams(
                        taskId: risk.taskId,
                        id: risk.id,
                        itemId: risk.itemId,
                        remarkResult: this._controllers[risk.uniqueKey].text,
                        inputResult: risk.inputResult,
                        photoResult: risk.photoResult,
                        deleted: risk.deleted,
                        selectResult: risk.selectResult,
                        itemFinish: risk.itemFinish,
                      ));
                    }
                  }

                  model.add(sm);
                }
                subData.records = model;
                subData.taskId = this.widget.taskId;
                saveRecord(subData);
              }
            },
          )
        ],
      ),
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: items != null
                ? Column(
                    children: this.items.map((f) {
                      ///前四项   ///最后一项
                    return this.items.indexOf(f) < 4
                        ? Column(
                            children: <Widget>[
                              ///标题  一级标题
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                margin: EdgeInsets.only(left: 0),
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: new Border(
                                        left: BorderSide(
                                            color:
                                                GetConfig.getColor(theme),
                                            width: 3)),
                                    color: Colors
                                        .white /* getBgColor(initData[index].finishStatus)*/
                                    ),
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        f.showChild = !f.showChild;
                                        f.isExpanded = true;
                                        if (f.showChild) {
                                          //获取子级元素
                                          iconsRun = Icons.keyboard_arrow_down;
                                          getChildren(f);
                                        } else {
                                          iconsRun = Icons.keyboard_arrow_right;
                                        }
                                      });
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 11,
                                          child: Text(
                                            f.itemName ?? "--",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: (f.itemFinish == 1 &&
                                                    f.itemFinish != null)
                                                ? Color.fromRGBO(0, 180, 22, 1)
                                                : Color.fromRGBO(
                                                    215, 219, 225, 1),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Icon(
                                              f.showChild
                                                  ? Icons.keyboard_arrow_down
                                                  : Icons.keyboard_arrow_right,
                                              size: 25,
                                              color: Color.fromRGBO(
                                                  50, 89, 206, 1),
                                            )),
                                      ],
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 15, top: 10, right: 15, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                child: getChildData(f),
                              ),
                            ],
                          )
                        : Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                margin: EdgeInsets.only(top: 0, left: 0),
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: new Border(
                                        left: BorderSide(
                                            color:
                                                GetConfig.getColor(theme),
                                            width: 3)),
                                    color: Colors
                                        .white /* getBgColor(initData[index].finishStatus)*/
                                    ),
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        f.showChild = !f.showChild;
                                        f.isExpanded = true;
                                      });
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 11,
                                          child: Text(
                                            f.itemName ?? "--",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.message,
                                              size: 25,
                                              color: f.showChild ||
                                                      f.remarkResult != null
                                                  ? Color.fromRGBO(
                                                      50, 89, 206, 1)
                                                  : Color.fromRGBO(
                                                      215, 219, 225, 1),
                                            )),
                                      ],
                                    )),
                              ),
                              f.showChild
                                  ? Container(
                                      padding:
                                          EdgeInsets.only(left: 20, bottom: 5),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 100,
                                            decoration: new BoxDecoration(
                                                color: Color.fromRGBO(
                                                    244, 244, 244, 1)),
                                            child: TextField(
                                              autofocus: !this.widget.isSubmit,
                                              textInputAction: TextInputAction.done,
                                              enabled: !this.widget.isSubmit,
                                              minLines: 3,
                                              maxLines: 4,
                                              enableInteractiveSelection: true,
                                              controller: this
                                                  ._controllers[f.uniqueKey],
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 10),
                                                border: InputBorder.none,
                                                hintText:
                                                    (!this.widget.isSubmit)
                                                        ? "请输入备注信息"
                                                        : "数据已提交无法编辑",
                                                filled: true,
                                                fillColor: Color.fromRGBO(
                                                    244, 244, 244, 1),
                                              ),
                                              inputFormatters: <TextInputFormatter>[
                                                LengthLimitingTextInputFormatter(500)//限制长度
                                              ],
                                              onEditingComplete: () {
                                                setState(() {
                                                  f.remarkResult=this._controllers[f.uniqueKey].text;
                                                });

                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          );
                  }).toList())
                : Container(),
          ),
        ),

        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
//          progressIndicator: CircularProgressIndicator(), content: '加载中...',
      ),
      resizeToAvoidBottomPadding: true,
    );
  }
}
