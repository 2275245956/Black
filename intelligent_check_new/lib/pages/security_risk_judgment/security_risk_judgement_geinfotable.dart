import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/SecurityRiskJudgement/SecurityRiskModel.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/services/Security_Risk_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;

import 'package:uuid/uuid.dart';

class SecurityRiskJudegmentGetInfoTable extends StatefulWidget {
  final int taskId;
  final int type;
  final bool isSubmit;

  SecurityRiskJudegmentGetInfoTable(this.taskId, this.type, this.isSubmit);

  @override
  State<StatefulWidget> createState() {
    return new _SecurityRiskJudegmentGetInfoTable();
  }
}

class _SecurityRiskJudegmentGetInfoTable
    extends State<SecurityRiskJudegmentGetInfoTable> {
  _SecurityRiskJudegmentGetInfoTable();

  Map<String, TextEditingController> _remarkControllers = new Map();
  Map<String, TextEditingController> _inputControllers = new Map();
  bool isAnimating = false;
  bool isEnable = true;
  int addChild = 0;
  var modelData = new SecurityRiskItem.fromParams();

  IconData iconsRun = Icons.keyboard_arrow_right;

  // 当前点的附件
  bool canOperate = true;
  bool hasNext = true;
  bool showOtherInfo = false;
  List<File> imageList;
  List<SecurityRiskItem> items = new List();
  String theme = "";

  @override
  void initState() {
    super.initState();

    getData();

    initConfig();
  }

  getSelectItems(SecurityRiskItem item) {
    if (item.selectJson == null) return Container();

    var options = List.from(json.decode(item.selectJson));
    return options != null
        ? Row(
            children: options.map((f) {
              return Expanded(
                  child: RadioListTile(
                      title: Text(
                        f["name"],
                        style: TextStyle(fontSize: 16),
                      ),
                      value: f["id"],
                      groupValue: int.tryParse(item.selectResult ?? "0") ?? 0,
                      onChanged: (value) {
                        setState(() {
                          //未提交 或者  不是危险作业管控情况
                          if (!this.widget.isSubmit && !item.itemFlag.startsWith("danger_work_control"))
                            item.selectResult = value.toString();
                        });
                      }));
            }).toList(),
          )
        : Container();
  }

  Widget getChildData(SecurityRiskItem item) {
    return Column(
      children: <Widget>[
        Container(
          //第一个需要能够添加子节点 显示添加按钮
          child: item.itemFlag == "equipment_run_status" && item.showChild
              ? Container(
                  child: FlatButton(
                  onPressed: () {
                    setState(() {
                      if (this.widget.isSubmit) return false;

                      item.showChild = true;
                      var jsonModel = {
                        "itemFlag": "equipment_run_status_a",
                        "itemLevel": 2,
                        "itemType": 2,
                        "itemName": "生产装置运行状况-a",
                        "itemParentId": item.itemId,
                        "itemCanCopy": 1,
                        "selectName": "状态",
                        "selectIsNeed": 1,
                        "selectIsRequired": 1,
                        "selectJson":
                            "[{\"id\":1,\"name\":\"运行\",\"tag\":\"\",\"defaultSelect\":false},{\"id\":2,\"name\":\"停运\",\"tag\":\"\",\"defaultSelect\":false},{\"id\":3,\"name\":\"检修\",\"tag\":\"\",\"defaultSelect\":false}]",
                        "inputName": "生产装置名称",
                        "inputIsNeed": 1,
                        "inputIsRequired": 1,
                        "remarkIsNeed": 0,
                        "remarkIsRequired": 0,
                        "photoIsNeed": 0,
                        "photoIsRequired": 0,
                        "id": null,
                        "taskId": this.widget.taskId,
                        "itemId": item.itemId + 1,
                        "selectResult": null,
                        "inputResult": null,
                        "remarkResult": null,
                        "photoResult": null,
                        "itemFinish": 0,
                        "orgCode": "1",
                        "deleted": 0,
                        "createDate": null,
                        "updateDate": null
                      };
                      SecurityRiskItem newItem;

                      if (item.children.length - addChild <= 0) {
                        newItem = SecurityRiskItem.fromJson(
                            json.decode(json.encode(jsonModel)));
                      } else {
                        var jsonStr = item.children[0].toString();
                        newItem =
                            SecurityRiskItem.fromJson(json.decode(jsonStr));
                      }
                      newItem.id = null; //新添加的id不存在
                      newItem.deleted = 0; //是否删除   未删除
                      newItem.inputResult = ""; //输入结果  保存值
                      newItem.remarkResult = ""; //备注  无
                      newItem.selectResult = "0"; //选择默认值
                      newItem.inputCanEdit = 1; //能编辑
                      newItem.inputType = 0; //字符串
                      newItem.uniqueKeyForInput = new Uuid().v4();
                      newItem.uniqueKey = new Uuid().v4();
                      this._remarkControllers[newItem.uniqueKey] =
                          new TextEditingController(text: newItem.remarkResult);
                      this._inputControllers[newItem.uniqueKeyForInput] =
                          new TextEditingController(text: newItem.inputResult);
                      item.children.add(newItem);
                      addChild += 1;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(right: 0),
                          margin: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.note_add,
                            color: GetConfig.getColor(theme),
                          )),
                      Container(
                          padding: EdgeInsets.only(left: 0),
                          margin: EdgeInsets.only(left: 0),
                          child: Text(
                            "添加",
                            style: TextStyle(fontSize: 17),
                          ))
                    ],
                  ),
                  color: Color.fromRGBO(228, 228, 228, 1),
                ))
              : Container(),
        ),

        Container(
            child: item.showChild && item.children != null
                ? Column(
                    children: item.children.map((f) {
                      return f.deleted == 0
                          ? Column(
                              children: <Widget>[
                                ///标题
                                f.inputIsNeed == 1
                                    ? Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  "*",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 10,
                                                child: Text(
                                                  f.inputName ?? f.itemName,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),

                                              ///第一个没有备注  其他的有备注  根据remarkIsNeed来判断
                                              ///=1则显示消息按钮   否则显示删除按钮
                                              f.remarkIsNeed == 1
                                                  ? Expanded(
                                                      flex: 1,
                                                      child: GestureDetector(
                                                        child: Icon(
                                                          Icons.message,
                                                          color:
                                                              f.remarkResult !=
                                                                      null
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          50,
                                                                          89,
                                                                          206,
                                                                          1)
                                                                  : Color
                                                                      .fromRGBO(
                                                                          215,
                                                                          219,
                                                                          225,
                                                                          1),
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            f.remarkResult =
                                                                f.remarkResult ==
                                                                        null
                                                                    ? ""
                                                                    : null;
                                                          });
                                                        },
                                                      ))
                                                  : Expanded(
                                                      flex: 1,
                                                      child: GestureDetector(
                                                        child: Icon(Icons.clear,
                                                            color: Colors.red),
                                                        onTap: () {
                                                          setState(() {
                                                            ///已提交 不可修改
                                                            if (this
                                                                .widget
                                                                .isSubmit)
                                                              return false;

                                                            if (f.id == null) {
                                                              item.children
                                                                  .remove(f);
                                                              this.addChild -=
                                                                  1;
                                                            } else {
                                                              f.deleted = 1;
                                                            }

                                                            //遍历是否还有未删除的子节点
                                                            var undeleteChilds =
                                                                0;
                                                            for (SecurityRiskItem si
                                                                in item
                                                                    .children) {
                                                              if (si.deleted ==
                                                                  0) {
                                                                undeleteChilds +=
                                                                    1;
                                                              }
                                                            }
                                                            //无子节点 关闭下拉
                                                            if (addChild == 0 &&
                                                                undeleteChilds ==
                                                                    0) {
                                                              item.showChild =
                                                                  false;
                                                            }
                                                          });
                                                        },
                                                      )),
                                            ],
                                          ),

                                          ///通过inputIsRequired 来判断是否需要输入框
                                          ///1需要  2不需要
                                          f.inputIsNeed == 1
                                              ? Container(
                                                  margin:
                                                      EdgeInsets.only(top: 6),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 40,
                                                  decoration: new BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          244, 244, 244, 1)),

                                                  ///判断数据类型  0字符串  1数字
                                                  child: f.inputType == 1
                                                      ? TextField(
                                                          autofocus:
                                                              f.inputCanEdit ==
                                                                  1,
                                                          enabled:
                                                              f.inputCanEdit ==
                                                                  1,

                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          enableInteractiveSelection:
                                                              true,
                                                          maxLines: 1,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: [
                                                            WhitelistingTextInputFormatter
                                                                .digitsOnly
                                                          ],
                                                          //只允许输入数字
                                                          controller: this
                                                                  ._inputControllers[
                                                              f.uniqueKeyForInput],
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10.0,
                                                                    horizontal:
                                                                        10),
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                "请输入(只能输入数字)",
                                                            filled: true,
                                                            fillColor:
                                                                Color.fromRGBO(
                                                                    244,
                                                                    244,
                                                                    244,
                                                                    1),
                                                          ),
                                                          onEditingComplete:
                                                              () {
                                                            setState(() {
                                                              f.inputResult = this
                                                                  ._inputControllers[
                                                                      f.uniqueKeyForInput]
                                                                  .text;
                                                            });
                                                          },
                                                        )
                                                      : TextField(
                                                          autofocus: !this
                                                              .widget
                                                              .isSubmit,
                                                          enabled: !this
                                                              .widget
                                                              .isSubmit,
                                                          enableInteractiveSelection:
                                                              true,
                                                          maxLines: 1,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          controller: this
                                                                  ._inputControllers[
                                                              f.uniqueKeyForInput],
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10.0,
                                                                    horizontal:
                                                                        10),
                                                            border: InputBorder
                                                                .none,
                                                            hintText: "请输入",
                                                            filled: true,
                                                            fillColor:
                                                                Color.fromRGBO(
                                                                    244,
                                                                    244,
                                                                    244,
                                                                    1),
                                                          ),
                                                          onEditingComplete:
                                                              () {
                                                            setState(() {
                                                              f.inputResult = this
                                                                  ._inputControllers[
                                                                      f.uniqueKeyForInput]
                                                                  .text;
                                                            });
                                                          },
                                                        ),
                                                )
                                              : Container()
                                        ],
                                      )
                                    : Container(),

                                //状态
                                f.selectIsRequired == 1
                                    ? Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 0,
                                                  child: Text(
                                                    f.selectIsRequired == 1
                                                        ? "*"
                                                        : "\r\t",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 10,
                                                  child: Text(
                                                    f.selectName ?? "",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),

                                                ///
                                                f.inputIsNeed == 0 &&
                                                        f.remarkIsNeed == 1
                                                    ? Expanded(
                                                        flex: 1,
                                                        child: GestureDetector(
                                                          child: Icon(
                                                            Icons.message,
                                                            color: f.remarkResult !=
                                                                    null
                                                                ? Color
                                                                    .fromRGBO(
                                                                        50,
                                                                        89,
                                                                        206,
                                                                        1)
                                                                : Color
                                                                    .fromRGBO(
                                                                        215,
                                                                        219,
                                                                        225,
                                                                        1),
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              f.remarkResult =
                                                                  f.remarkResult ==
                                                                          null
                                                                      ? ""
                                                                      : null;
                                                            });
                                                          },
                                                        ))
                                                    : Expanded(
                                                        flex: 1,
                                                        child: Container()),
                                              ],
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: getSelectItems(f))
                                          ],
                                        ),
                                      )
                                    : Container(),

                                ///备注
                                f.remarkIsNeed == 1
                                    ? Container(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 5),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Column(
                                                  children: <Widget>[
                                                    f.remarkResult != null
                                                        ? Row(
                                                            children: <Widget>[
                                                              Expanded(
                                                                child: Text(
                                                                  "备注",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                    f.remarkResult != null
                                                        ? Container(
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
                                                              autofocus: !this
                                                                  .widget
                                                                  .isSubmit,

                                                              ///已提交  不可编辑
                                                              enabled: !this
                                                                  .widget
                                                                  .isSubmit,

                                                              enableInteractiveSelection:
                                                                  true,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                              controller: this
                                                                      ._remarkControllers[
                                                                  f.uniqueKey],
                                                              maxLines: 4,
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
                                                                hintText: (!this
                                                                        .widget
                                                                        .isSubmit)
                                                                    ? "请输入备注信息"
                                                                    : "数据已提交无法编辑",
                                                                filled: true,
                                                                fillColor: Color
                                                                    .fromRGBO(
                                                                        244,
                                                                        244,
                                                                        244,
                                                                        1),
                                                              ),
                                                              onEditingComplete:
                                                                  () {
                                                                this.setState(
                                                                    () {
                                                                  f.remarkResult = this
                                                                      ._remarkControllers[
                                                                          f.uniqueKey]
                                                                      .text;
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
                                      )
                                    : Container(),

                                Container(
                                  color: Color.fromRGBO(242, 246, 249, 1),
                                  height: 5,
                                )
                              ],
                            )
                          : Container();
                    }).toList(),
                  )
                : Container()),

      ],
    );
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

            this._remarkControllers[ri.uniqueKey] =
                TextEditingController(text: ri.remarkResult);

            this.items.add(ri);
          }
        }
        isAnimating = false;
      });
    });
  }

  getChildren(SecurityRiskItem firstLevel) async {
    if (firstLevel.children.length - addChild <= 0) {
      setState(() {
        isAnimating = true;
      });
      await getJudgementItems(
              this.widget.taskId, this.widget.type, 2, firstLevel.itemId)
          .then((date) {
        setState(() {
          if (date.success && date.dataList != null) {
            for (var item in date.dataList) {
              SecurityRiskItem ri = new SecurityRiskItem.fromJson(item);
              ri.uniqueKey = new Uuid().v4();
              ri.uniqueKeyForInput = new Uuid().v4();
              this._remarkControllers[ri.uniqueKey] =
                  TextEditingController(text: ri.remarkResult);
//              ri.inputType==1?(ri.inputResult??"0"):ri.inputResult
//
              this._inputControllers[ri.uniqueKeyForInput] =
                  TextEditingController(text: ri.inputResult);
              firstLevel.children.add(ri);
            }
          }
          isAnimating = false;
        });
      });
    }
    return firstLevel.children == null;
  }

  initConfig() async {
    SharedPreferences.getInstance().then((preferences) {
      setState(() {
        this.theme =
            preferences.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  getWidget() {
    return Column(
        children: this.items.map((f) {
      return f.itemFlag != "other_infomation"
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
                              color: GetConfig.getColor(theme), width: 3)),
                      color: Colors
                          .white
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
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Icon(
                              Icons.check_circle,
                              color: (f.itemFinish == 1 && f.itemFinish != null)
                                  ? Color.fromRGBO(0, 180, 22, 1)
                                  : Color.fromRGBO(215, 219, 225, 1),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Icon(
                                f.showChild
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_right,
                                size: 25,
                                color: GetConfig.getColor(theme),
                              )),
                        ],
                      )),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 5),
                  width: MediaQuery.of(context).size.width,
                  child: getChildData(f),
                ),
              ],
            )
          : Column(
              //最后的备注
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  margin: EdgeInsets.only(top: 0, left: 0, bottom: 15),
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: new Border(
                          left: BorderSide(
                              color: GetConfig.getColor(theme), width: 3)),
                      color: Colors
                          .white
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
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.message,
                                size: 25,
                                // ignore: null_aware_in_logical_operator
                                color: f.showChild || f.remarkResult != null
                                    ? GetConfig.getColor(theme)
                                    : Color.fromRGBO(215, 219, 225, 1),
                              )),
                        ],
                      )),
                ),
                f.showChild
                    ? Container(
                        padding: EdgeInsets.only(left: 20, bottom: 5),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              decoration: new BoxDecoration(
                                  color: Color.fromRGBO(244, 244, 244, 1)),
                              child: TextField(
                                autofocus: !this.widget.isSubmit,
                                textInputAction: TextInputAction.done,

                                ///已提交  不可编辑
                                enabled: !this.widget.isSubmit,

                                minLines: 3,
                                maxLines: 4,
                                enableInteractiveSelection: true,
                                controller:
                                    this._remarkControllers[f.uniqueKey],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10),
                                  border: InputBorder.none,
                                  hintText: (!this.widget.isSubmit)
                                      ? "请输入备注信息"
                                      : "数据已提交无法编辑",
                                  filled: true,
                                  fillColor: Color.fromRGBO(244, 244, 244, 1),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(500)//限制长度
                                ],
                                onEditingComplete: () {
                                  this.setState(() {
                                    f.remarkResult = this
                                        ._remarkControllers[f.uniqueKey]
                                        .text;
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
    }).toList());
  }

  bool _checkNeeded() {
    //遍历没有做操作的项
    for (SecurityRiskItem item in this.items) {
      if (item.itemFlag!="other_infomation") {
        //除其他内容外  检查项
        if (!item.isFinish &&
            item.children.length == 0 &&
            item.itemFinish == 0) {
          //未展开 提示展开
          HiddenDangerFound.popUpMsg("《" + item.itemName + "》项未查看");
          return false;
        }
        for (SecurityRiskItem risk in item.children) {
          if (risk.deleted == 0) {
            if (risk.selectIsNeed==1 && risk.selectResult != null) {
              //只判断选择项
              setState(() {
                item.isFinish = true;
                risk.itemFinish = 1;
                item.itemFinish = 1;
              });
            } else if (risk.selectIsNeed==0 && risk.inputIsNeed==1&&
                (this._inputControllers[risk.uniqueKeyForInput].text != "" &&
                    this._inputControllers[risk.uniqueKeyForInput].text !=
                        null)) {
              //没有单选项  判断输入数据
              //展开了  全部子项操作了 将状态设置未已完成状态
              setState(() {
                item.isFinish = true;
                risk.itemFinish = 1;
                item.itemFinish = 1;
              });
            } else if (risk.selectIsNeed==1 &&
                        risk.inputIsNeed==1 &&
                          (this._inputControllers[risk.uniqueKeyForInput].text != "" &&
                          this._inputControllers[risk.uniqueKeyForInput].text !=
                          null) &&
                 risk.selectResult != null ) {
              //有输入 有选择
              setState(() {
                item.isFinish = true;
                risk.itemFinish = 1;
                item.itemFinish = 1;
              });
            }  else {
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
        }
      } else {
        item.isFinish = true;

        item.itemFinish = 1;
      }
    }

    return true;
  }

  saveRecord(SubmitDataModel model) async {
    await saveRecordTable(model).then((date) {
      HiddenDangerFound.popUpMsg(date.message);
      if (date.success) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.items == null) {
      return Scaffold(body: Text(""));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "安全风险研判信息采集表",
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
            onTap: () {
              ///已提交  不可编辑
              if (this.widget.isSubmit) return false;

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
                  sm.itemId = item.itemId;
                  sm.remarkResult =
                      this._remarkControllers[item.uniqueKey].text;
                  sm.inputResult = item.inputResult;
                  sm.photoResult = item.photoResult != null
                      ? item.photoResult
                          .substring(0, item.photoResult.length - 1)
                      : null;
                  sm.deleted = item.deleted;
                  sm.selectResult = item.selectResult;
                  sm.itemFinish = item.itemFinish;
//                  if(!item.isExpanded){//未展开
//                    HiddenDangerFound.popUpMsg("请检查《"+item.itemName+"》填写的数据！");
//                    return false;
//                  }
                  if (item.children.length > 0) {
                    //子级
                    sm.childs = new List();
                    for (SecurityRiskItem risk in item.children) {
                      sm.childs.add(new SubModel.fromParams(
                        taskId: risk.taskId,
                        itemId: risk.itemId,
                        id: risk.id,
                        remarkResult:
                            this._remarkControllers[risk.uniqueKey].text,
                        inputResult:
                            this._inputControllers[risk.uniqueKeyForInput].text,
                        photoResult: risk.photoResult != null
                            ? risk.photoResult
                                .substring(0, risk.photoResult.length - 1)
                            : null,
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
          child: Container(color: Colors.white, child: getWidget()),
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
