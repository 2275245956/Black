import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelligent_check_new/common/JunCommon.dart';
import 'package:intelligent_check_new/model/CheckItem.dart';
import 'package:intelligent_check_new/model/CheckRecordDto.dart';
import 'package:intelligent_check_new/model/ExtClass.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/model/MovePointAttachment.dart';
import 'package:intelligent_check_new/model/PlanTaskInitConfig.dart';
import 'package:intelligent_check_new/model/offline/offline_plan_list_output.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageList.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageView.dart';
import 'package:intelligent_check_new/pages/CheckExecute/TextView.dart';
import 'package:intelligent_check_new/services/offline/dbAccess.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/tools/MessageBox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:intelligent_check_new/constants/color.dart';

class CheckExecInspection extends StatefulWidget {
  Point point;
  String checkMode;
  int cid;
  CheckExecInspection(this.point,this.checkMode,{this.cid});

  @override
  State<StatefulWidget> createState() => _CheckExecInspection();
}

class _CheckExecInspection extends State<CheckExecInspection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 页面配置信息
  PlanTaskInitConfig initConfig;

  // 当前点的附件
  List<File> imageList;

  // 点备注
  final TextEditingController _remarkController = new TextEditingController();

//  List<TextEditingController> txtControllers = List();
  Map<String, TextEditingController> txtControllers = Map();

//  int itemCount=0;// image count
//  int radioCount=0;// radio count;

  File img;

  // 正在保存
  bool issaving = false;

  bool isAnimating = false;

  int selectClass = -1;

  // 过滤后的检查项
  List<CheckItem> _filtercheckItem = List();

  // 登陆人信息
  LoginResult loginResult;

  ExtClass classifySelected;

  // 确定要提交的分类
  Map<String,bool> commitClassifies = Map();

  String theme="";

  @override
  void initState() {
    super.initState();
    // 获取登陆人信息
    SharedPreferences.getInstance().then((sp){
      String str= sp.get('LoginResult');
      setState(() {
        loginResult = LoginResult(str);
        this.theme = sp.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
    // 根据点ID和计划ID获取配置初始化checkitems
    getInitConfig();
  }

  void getInitConfig() {
    setState(() {
      Point point = this.widget.point;
      var ckPoint = CheckPoint.fromParams(
          id: JunMath.parseInt(point.pointId),
          routeId: point.routeId,
          name: point.name,
          pointNo: point.pointNO,
          offline:point.offline,
          status: point.status,
          isFixed: point.isFixed);
      var inputItems = List<CheckItem>();
      for (var item in point.inputItems) {
        inputItems.add(CheckItem.fromParams(
            id: JunMath.parseInt(item.id),
            createDate: JunMath.parseInt(item.createDate),
            catalogId: JunMath.parseInt(item.catalogId),
            createBy: item.createBy,
            dataJson: item.dataJson,
            defaultValue: item.defaultValue,
            inputJson: item.inputJson,
            isMultiline: item.isMultiline,
            isMust: item.isMust,
            isScore: item.isScore,
            itemType: item.itemType,
            name: item.name,
            orderNo: JunMath.parseInt(item.orderNo),
            orgCode: item.orgCode,
            pictureJson: item.pictureJson,
            remark: item.remark,
            isDelete: JunMath.parseBool(item.isDelete),
            pOrderNo: JunMath.parseInt(item.pOrderNo),
            pointItemId: JunMath.parseInt(item.pointItemId),
            classifyIds: item.classifyIds
            //item.classifyNames
            ));
      }

      var classifis = List<ExtClass>();
      for (var cls in point.classifis) {
        classifis.add(ExtClass.fromParams(
            id: JunMath.parseInt(cls.id),
            name: cls.name,
            orderNo: JunMath.parseInt(cls.orderNo)));
      }

      var planTask = null;
      if(null != point.planTask){
        planTask = PlanTask.fromParams(
          beginTime: point.planTask.beginTime.toString(),
          endTime: point.planTask.endTime.toString(),
          planTaskDetailId: point.planTask.planTaskDetailId,
          shotMaxNumber: point.planTask.shotMaxNumber,
          shotMinNumber: point.planTask.shotMinNumber,
          planName: point.planTask.planName,
          pointName: point.planTask.pointName,
          pointNo: point.planTask.pointNo,
        );
      }
      initConfig = new PlanTaskInitConfig.fromParams(
          point: ckPoint,
          checkItem: inputItems,
          planTask: planTask,
          extClass: classifis);
    });

//    if(initConfig.extClass.length>0){
//      classifySelected = initConfig.extClass[0];
//      initConfig.extClass.forEach((f){
//        // 初始化
//        commitClassifies[f.id.toString()] = false;
//      });
//    }

    setState(() {
//      initConfig = data;
      if(initConfig.extClass.length>0){
        classifySelected = initConfig.extClass[0];
        initConfig.extClass.forEach((f){
          // 初始化
          commitClassifies[f.id.toString()] = false;
        });
      }
    });

    for (var item in initConfig.checkItem) {
      List<ItemPictureInfo> pics = List();
      for (var pic in json.decode(item.pictureJson)) {
        ItemPictureInfo p = ItemPictureInfo.fromJson(pic);
        pics.add(p);
      }
      item.pictureInfo = pics;
      item.uniqueKey = new Uuid().v4();

      _checkItem.add(item);

//      _filtercheckItem.add(item);
      if(classifySelected != null){
        if(item.classifyIds == null && classifySelected.id.toString()=="null"){
          _filtercheckItem.add(item);
        }else if(item.classifyIds == classifySelected.id.toString()){
          _filtercheckItem.add(item);
        }
      }else{
        _filtercheckItem.add(item);
      }

      // TextField 绑定初始化controller
      if (item.itemType == "文本" || item.itemType == "数字") {
        txtControllers[item.name] = TextEditingController();
      }
    }


    /////
    if(initConfig.extClass != null && initConfig.extClass.length > 0){
      if(_checkItem.where((f)=>f.classifyIds == null || f.classifyIds.isEmpty).length > 0){
        ExtClass cls = ExtClass.fromParams(id:null,name: "其他");
        initConfig.extClass.add(cls);
        commitClassifies["null"]=false;
      }
    }
    /////
  }

  // 初始化扩展分类下拉
//  List<DropdownMenuItem> getListData() {
//    List<DropdownMenuItem> items = new List();
//    items.add(new DropdownMenuItem(
//      child: new Text("全部"),
//      value: -1,
//    ));
//    // 循环初始化扩展分类
//    if (initConfig.extClass != null && initConfig.extClass.length > 0) {
//      for (var c in initConfig.extClass) {
//        if (c != null) {
//          DropdownMenuItem dropdownMenuItem1 = new DropdownMenuItem(
//            child: new Text(c.name),
//            value: c.id,
//          );
//          items.add(dropdownMenuItem1);
//        }
//      }
//    }
//    return items;
//  }

  @override
  Widget build(BuildContext context) {
    if (null == initConfig) {
      return Scaffold(
          appBar: AppBar(
        title: Text(
          "巡检点名称",
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
          ),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: (this.widget.point.planTaskId ?? "") == ""
            ? Text(
                null != initConfig.point ? initConfig.point.name ?? "" : "",
                style: TextStyle(color: Colors.black, fontSize: 19),
              )
            : Text(
                null != initConfig.planTask
                    ? initConfig.planTask.pointName ?? ""
                    : "",
                style: TextStyle(color: Colors.black, fontSize: 19),
              ),
//        title: Text(null != initConfig.point ? initConfig.point.name??"" : "",
//          style: TextStyle(color: Colors.black,fontSize: 19),),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
          ),
        ),
        actions: <Widget>[
          //IconButton(icon: Icon(Icons.search,color: Colors.red,),onPressed: (){},),
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.red,
            ),
            onPressed: () {
              // 还未保存
              if (!issaving) {
                saveData();
//                initConfig.extClass!=null && initConfig.extClass.length>0?
//                saveSelectClassifyDialog():saveData();
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          width: 130,
                          height: 40,
                          child: Text(
                            "点编号",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ),
                        (this.widget.point.planTaskId ?? "") == ""
                            ? Text(
                                null != initConfig.point
                                    ? initConfig.point.pointNo ?? ""
                                    : "",
                                style: TextStyle(color: Colors.grey),
                              )
                            : Text(
                                null != initConfig.planTask
                                    ? initConfig.planTask.pointNo ?? ""
                                    : "",
                                style: TextStyle(color: Colors.grey),
                              )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          width: 130,
                          height: 40,
                          child: Text(
                            "巡检计划",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ),
                        Text(
                          ((null == initConfig.planTask)
                              ? "计划外"
                              : initConfig.planTask.planName),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Container(
              height: 10.0,
              color: Colors.grey[100],
            ),
            initConfig.extClass!=null && initConfig.extClass.length>0?
            Padding(
              padding :EdgeInsets.only(left: 10,top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10,top:10),
                    width: 130,
                    height: 40,
                    child: Text("扩展分类",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                  ),

                  Container(
                    width:180.0,
                    height:40.0,
                    child: GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Text(classifySelected==null?"":classifySelected.name,style: TextStyle(color:Colors.black),),
                          Icon(Icons.keyboard_arrow_down,color:GetConfig.getColor(theme))
                        ],
                      ),
                      onTap: (){
                        classifyDialog();
                      },
                    ),
                  ),
                ],
              ),
            ):Container(),
            Container(
              height: 10.0,
              color: Colors.grey[100],
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              width: 130,
              height: 40,
              child: Text(
                "检查项目",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                child: Column(
                    children: _filtercheckItem.map((f) {
                  if (f.itemType == "文本") {
                    return Container(
//                            height: 100,
                      child: getTextFiled(f),
                    );
                  } else if (f.itemType == "数字") {
                    return Container(
//                            height: 100,
                      child: getNumberFiled(f),
                    );
                  } else if (f.itemType == "选择") {
                    return Container(
//                            height: 100,
                      child: getRadioBoxField(f),
                    );
                  }
                }).toList()),
//                  height: (_checkItem.length) * 110.0 +  (itemCount + radioCount) * 70.0,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
//                        Row(
//                          children: <Widget>[
//                            Text("*",style: TextStyle(
//                                color: Colors.red
//                              ),
//                            ),
//                            Text("拍照点名称"),
//                            Padding(padding: EdgeInsets.only(left: 240),),
//                            new Icon(Icons.keyboard_arrow_right,color: Colors.red,size: 20,),
//                          ],
//                        ),
//                        Padding(padding: EdgeInsets.only(top: 10),),ImageList
                      GestureDetector(
                        child: Row(
                          children: <Widget>[
//                             Text("*",style: TextStyle(
//                                 color: Colors.red
//                             ),
//                             ),
                            Text(
                              "现场照片",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 220),
                            ),
                            new Icon(
                              Icons.photo_camera,
                              color: Colors.red,
                              size: 20,
                            ),
                            new Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.red,
                              size: 20,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ImageList(this.imageList);
                          })).then((v) {
                            if (v != null) {
                              setState(() {
                                imageList = v;
//                                 print(imageList);
                              });
                            }
                          });
                        },
                      )
                    ])),
            Container(
              height: 10.0,
              color: Colors.grey[100],
            ),
            GestureDetector(
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0, bottom: 20.0, top: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
//                              Text("*",style: TextStyle(
//                                  color: Colors.red
//                              ),
//                              ),
                            Text(
                              "备注说明",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 220),
                            ),
                            new Icon(
                              Icons.message,
                              color: Colors.grey,
                              size: 20,
                            ),
                            new Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.red,
                              size: 20,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                      ])),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TextView(
                      text: this._remarkController.text.isEmpty
                          ? ""
                          : this._remarkController.text);
                })).then((v) {
                  if (v != "back") {
                    setState(() {
                      this._remarkController.text = v;
                    });
                  }
                });
              },
            ),
            Container(
              height:10.0,
              color:Color.fromRGBO(242, 246, 249, 1),
            ),
            initConfig.extClass!=null && initConfig.extClass.length>0?
            commitClassifies[classifySelected.id.toString()]?
            Container(
              margin: const EdgeInsets.only(left: 15.0, right: 15.0,top: 5,bottom: 5),
              color: GetConfig.getColor(theme),
              width: double.infinity,
              child: new MaterialButton(
                onPressed: () {
                  setState(() {
                    commitClassifies[classifySelected.id.toString()] = false;
                  });
                },
                child: new Text(
                  "取消",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ):
            Container(
              margin: const EdgeInsets.only(left: 15.0, right: 15.0,top: 5,bottom: 5),
              color: GetConfig.getColor(theme),
              width: double.infinity,
              child: new MaterialButton(
                onPressed: () {
                  String error = checkData(classifySelected);
                  if(error.isEmpty){
                    setState(() {
                      commitClassifies[classifySelected.id.toString()] = true;
                    });
                  }else{
                    //                print(error);
                    MessageBox.showMessageOnly(error, context);
                  }

                },
                child: new Text(
                  "保存",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
                :Container()
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  //////////////////////////////////////////////////////////////////////////////////////
  // 开始加载价检查项
  List<CheckItem> _checkItem = List();
  Map<String, ItemResultData> _itemResultDataMap = Map();

  Widget getTextFiled(CheckItem _checkItem) {
    return Container(
//      padding: EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 40,
            child: Row(
              children: <Widget>[
                _checkItem.isMust == "是"
                    ? Text(
                        "*",
                        style: TextStyle(color: Colors.red),
                      )
                    : Text(""),
                Container(
                  child: Text(_checkItem.name),
                  width: 280,
                ),
                GestureDetector(
                  child: Container(
                    width: 40,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.topRight,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.message,
                          color: Colors.grey,
                          size: 14,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.red,
                          size: 14,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    if (_itemResultDataMap[_checkItem.uniqueKey] == null) {
                      _itemResultDataMap[_checkItem.uniqueKey] =
                          ItemResultData.fromParams(
                              uniqueKey: _checkItem.uniqueKey, value: "");
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TextView(
                          text: _itemResultDataMap[_checkItem.uniqueKey].text == null
                              ? ""
                              : _itemResultDataMap[_checkItem.uniqueKey].text);
                    })).then((v) {
                      if (v != "back") {
                        setState(() {
                          _itemResultDataMap[_checkItem.uniqueKey].text = v;
                        });
                      }
                    });
                  },
                ),
              ],
            ),
            padding: EdgeInsets.only(left: 10, top: 3),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 10, left: 10),
            width: 280,
            child: TextField(
              controller: txtControllers[_checkItem.name],
              onChanged: (value) {
                setState(() {
                  if (_itemResultDataMap[_checkItem.uniqueKey] == null) {
                    _itemResultDataMap[_checkItem.uniqueKey] =
                        ItemResultData.fromParams(uniqueKey: _checkItem.uniqueKey, value: "");
                  }
                  _itemResultDataMap[_checkItem.uniqueKey].value = value;
                });
              },
              onEditingComplete: () {
                txtControllers[_checkItem.uniqueKey].text =
                    _itemResultDataMap[_checkItem.uniqueKey].value;
              },
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            child: Column(
                children: _checkItem.pictureInfo.map((f) {
              return Column(
                children: <Widget>[
                  Container(
                    child: GestureDetector(
                      child: Row(
                        children: <Widget>[
                          f.isMust == "是"
                              ? Text(
                                  "*",
                                  style: TextStyle(color: Colors.red),
                                )
                              : Text(""),
                          Container(
                            child: Text(f.name),
                            width: 280,
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            width: 40,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.red,
                            ),
                            alignment: Alignment.centerRight,
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            width: 10,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.red,
                            ),
                            alignment: Alignment.centerRight,
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          ImagePicker.pickImage(source: ImageSource.camera)
                              .then((c) {
                            setState(() {
                              if (c != null) {
                                if (_itemResultDataMap[_checkItem.uniqueKey] == null) {
                                  _itemResultDataMap[_checkItem.uniqueKey] =
                                      ItemResultData.fromParams(
                                          uniqueKey: _checkItem.uniqueKey, value: "");
                                }
                                Map<String, File> m = Map();
                                m[f.name] = c;
                                if (_itemResultDataMap[_checkItem.uniqueKey].img ==
                                    null) {
                                  _itemResultDataMap[_checkItem.uniqueKey].img = Map();
                                }
                                _itemResultDataMap[_checkItem.uniqueKey].img.addAll(m);
//                                    itemCount = itemCount + 1;
                              }
                            });
                          });
                        });
                      },
                    ),
                    padding: EdgeInsets.only(left: 10, top: 10),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: _itemResultDataMap[_checkItem.uniqueKey] == null ||
                                  _itemResultDataMap[_checkItem.uniqueKey].img ==
                                      null ||
                                  _itemResultDataMap[_checkItem.uniqueKey]
                                          .img[f.name] ==
                                      null
                              ? Container()
                              : CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.black12,
                                  child: Image.file(
                                    _itemResultDataMap[_checkItem.uniqueKey]
                                        .img[f.name],
                                    height: 40,
                                  ),
                                )),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ImageView(Image.file(
                            _itemResultDataMap[_checkItem.uniqueKey].img[f.name],
                            height: 40,
                          ));
                        }));
                      },
                    ),
                    padding: EdgeInsets.only(left: 10, top: 10),
                  ),
                ],
              );
            }).toList()),
          ),
          Container(
            height: 10,
            color: Colors.grey[100],
          )
        ],
      ),
    );
  }

  Widget getNumberFiled(CheckItem _checkItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 40,
          child: Row(
            children: <Widget>[
              _checkItem.isMust == "是"
                  ? Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    )
                  : Text(""),
              Container(
                child: Text(_checkItem.name),
                width: 280,
              ),
              GestureDetector(
                child: Container(
                  width: 40,
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.topRight,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.message,
                        color: Colors.grey,
                        size: 14,
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.red,
                        size: 14,
                      )
                    ],
                  ),
                ),
                onTap: () {
                  if (_itemResultDataMap[_checkItem.uniqueKey] == null) {
                    _itemResultDataMap[_checkItem.uniqueKey] =
                        ItemResultData.fromParams(uniqueKey: _checkItem.uniqueKey, value: "");
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TextView(
                        text: _itemResultDataMap[_checkItem.uniqueKey] == null
                            ? ""
                            : _itemResultDataMap[_checkItem.uniqueKey].text);
                  })).then((v) {
                    if (v != "back") {
                      setState(() {
                        _itemResultDataMap[_checkItem.uniqueKey].text = v;
                      });
                    }
                  });
                },
              ),
//        Icon(Icons.camera_alt,color: Colors.red,)
            ],
          ),
          padding: EdgeInsets.only(left: 10, top: 3),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 10, left: 10),
          alignment: Alignment.centerLeft,
          width: 280,
          child: TextField(
            controller: txtControllers[_checkItem.name],
            onChanged: (value) {
              setState(() {
                if (_itemResultDataMap[_checkItem.uniqueKey] == null) {
                  _itemResultDataMap[_checkItem.uniqueKey] =
                      ItemResultData.fromParams(uniqueKey: _checkItem.uniqueKey, value: "");
                }
                _itemResultDataMap[_checkItem.uniqueKey].value = value;
              });
            },
            onEditingComplete: () {
              setState(() {
                txtControllers[_checkItem.uniqueKey].text =
                    _itemResultDataMap[_checkItem.uniqueKey].value;
              });
            },
          ),
        ),
        Divider(
          height: 1,
        ),
        Container(
          child: Column(
              children: _checkItem.pictureInfo.map((f) {
            return Column(
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        f.isMust == "是"
                            ? Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(""),
                        Container(
                          child: Text(f.name),
                          width: 280,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          width: 40,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.red,
                          ),
                          alignment: Alignment.centerRight,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          width: 10,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.red,
                          ),
                          alignment: Alignment.centerRight,
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        ImagePicker.pickImage(source: ImageSource.camera)
                            .then((c) {
                          setState(() {
                            if (c != null) {
                              if (_itemResultDataMap[_checkItem.uniqueKey] == null) {
                                _itemResultDataMap[_checkItem.uniqueKey] =
                                    ItemResultData.fromParams(
                                        uniqueKey: _checkItem.uniqueKey, value: "");
                              }
                              Map<String, File> m = Map();
                              m[f.name] = c;
                              if (_itemResultDataMap[_checkItem.uniqueKey].img ==
                                  null) {
                                _itemResultDataMap[_checkItem.uniqueKey].img = Map();
                              }
                              _itemResultDataMap[_checkItem.uniqueKey].img.addAll(m);
//                                  itemCount = itemCount + 1;
                            }
                          });
                        });
                      });
                    },
                  ),
                  padding: EdgeInsets.only(left: 10, top: 10),
                ),
                Divider(
                  height: 1,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: _itemResultDataMap[_checkItem.uniqueKey] == null ||
                                _itemResultDataMap[_checkItem.uniqueKey].img == null ||
                                _itemResultDataMap[_checkItem.uniqueKey].img[f.name] ==
                                    null
                            ? Container()
                            : CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.black12,
                                child: Image.file(
                                  _itemResultDataMap[_checkItem.uniqueKey].img[f.name],
                                  height: 40,
                                ),
                              )
//                          Image.file(_itemResultDataMap[_checkItem.id].img[f.name],
//                            height: 50,width: double.infinity,fit: BoxFit.fill,),
                        ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ImageView(Image.file(
                          _itemResultDataMap[_checkItem.uniqueKey].img[f.name],
                          height: 40,
                        ));
                      }));
                    },
                  ),
                  padding: EdgeInsets.only(left: 10, top: 10),
                ),
              ],
            );
          }).toList()),
        ),
        Container(
          height: 10,
          color: Colors.grey[100],
        )
      ],
    );
  }

  Widget getRadioBoxField(CheckItem _checkItem) {
//    print(_checkItem);
    // 获取radio信息
    List<RadioWidgetInfo> rds = List();
    for (var rd in jsonDecode(_checkItem.dataJson)) {
      rds.add(RadioWidgetInfo.fromJson(rd));
    }

//    setState(() {
////      radioCount = rds.length - 1;
////    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 40,
          child: Row(
            children: <Widget>[
              _checkItem.isMust == "是"
                  ? Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    )
                  : Text(""),
              Container(
                width: 280,
                child: Text(_checkItem.name),
              ),
              GestureDetector(
                child: Container(
                  width: 40,
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.topRight,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.message,
                        color: Colors.grey,
                        size: 14,
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.red,
                        size: 14,
                      )
                    ],
                  ),
                ),
                onTap: () {
                  if (_itemResultDataMap[_checkItem.uniqueKey] == null) {
                    _itemResultDataMap[_checkItem.uniqueKey] =
                        ItemResultData.fromParams(uniqueKey: _checkItem.uniqueKey, value: "");
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TextView(
                        text: _itemResultDataMap[_checkItem.uniqueKey] == null
                            ? ""
                            : _itemResultDataMap[_checkItem.uniqueKey].text);
                  })).then((v) {
                    if (v != "back") {
                      setState(() {
                        _itemResultDataMap[_checkItem.uniqueKey].text = v;
                      });
                    }
                  });
                },
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 10, top: 10),
        ),
        Container(
//          width: 300,
//          height: 30,
          padding: EdgeInsets.only(left: 10),
          child: Column(
              children: rds.map((f) {
            return Row(
              children: <Widget>[
                Radio(
                    value: f.name,
                    groupValue: _itemResultDataMap[_checkItem.uniqueKey] == null ||
                            _itemResultDataMap[_checkItem.uniqueKey].value == null
                        ? ""
                        : _itemResultDataMap[_checkItem.uniqueKey].value,
                    onChanged: (String val) {
                      setState(() {
                        if (_itemResultDataMap[_checkItem.uniqueKey] == null) {
                          _itemResultDataMap[_checkItem.uniqueKey] =
                              ItemResultData.fromParams(
                                  uniqueKey: _checkItem.uniqueKey, value: "");
                        }
                        _itemResultDataMap[_checkItem.uniqueKey].value = val;
                      });
                    }),
                Text(f.name ?? ""),
              ],
            );
          }).toList()),
        ),
        Divider(
          height: 1,
        ),
        Container(
          child: Column(
              children: _checkItem.pictureInfo.map((f) {
            return Column(
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        f.isMust == "是"
                            ? Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(""),
                        Container(
                          child: Text(f.name),
                          width: 280,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          width: 40,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.red,
                            size: 20,
                          ),
                          alignment: Alignment.centerRight,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          width: 10,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.red,
                          ),
                          alignment: Alignment.centerRight,
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        ImagePicker.pickImage(source: ImageSource.camera)
                            .then((c) {
                          setState(() {
                            if (c != null) {
                              if (_itemResultDataMap[_checkItem.uniqueKey] == null) {
                                _itemResultDataMap[_checkItem.uniqueKey] =
                                    ItemResultData.fromParams(
                                        uniqueKey: _checkItem.uniqueKey, value: "");
                              }
                              Map<String, File> m = Map();
                              m[f.name] = c;
                              if (_itemResultDataMap[_checkItem.uniqueKey].img ==
                                  null) {
                                _itemResultDataMap[_checkItem.uniqueKey].img = Map();
                              }
                              _itemResultDataMap[_checkItem.uniqueKey].img.addAll(m);
//                                  itemCount = itemCount + 1;
                            }
                          });
                        });
                      });
                    },
                  ),
                  padding: EdgeInsets.only(left: 10, top: 10),
                ),
                Divider(
                  height: 1,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    child: Container(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        child: _itemResultDataMap[_checkItem.uniqueKey] == null ||
                                _itemResultDataMap[_checkItem.uniqueKey].img == null ||
                                _itemResultDataMap[_checkItem.uniqueKey].img[f.name] ==
                                    null
                            ? Container()
                            : CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.black12,
                                child: Image.file(
                                  _itemResultDataMap[_checkItem.uniqueKey].img[f.name],
                                  height: 40,
                                ),
                              )
                        ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ImageView(Image.file(
                            _itemResultDataMap[_checkItem.uniqueKey].img[f.name]));
                      }));
                    },
                  ),
                  padding: EdgeInsets.only(left: 10, top: 10),
                ),
              ],
            );
          }).toList()),
        ),
        Container(
          height: 10,
          color: Colors.grey[100],
        )
      ],
    );
  }

  saveData() {
    // check data
//    String error = checkData();
//
//    // 错误信息不是空
//    if (error.isNotEmpty) {
//      setState(() {
//        issaving = false;
//      });
//      showAlertMessageOnly(error, false);
//
//      _itemResultDataMap.forEach((k, v) {
//        v.hasError = false;
//        v.errorInfo = "";
//      });
//
//      return;
//    } else {
//      setState(() {
//        issaving = true;
//      });
      // save data
      print("check result=====================================================");

      // 需要上传的分类数据
      List<String> classifyIds = List();
      this.commitClassifies.forEach((k,v){
        if(v==true){
          classifyIds.add(k);
        }
      });

      if(classifyIds.length <= 0 && initConfig.extClass != null && initConfig.extClass.length>0){
        setState(() {
          issaving = false;
          isAnimating = false;
          MessageBox.showMessageOnly("没有数据可以提交！", context);
          return;
        });
      }else{

        if(classifyIds.length <= 0 && (initConfig.extClass == null || initConfig.extClass.length <= 0)){
          // check data
          String error = checkData(null);
          if(error.isNotEmpty){
            MessageBox.showMessageOnly(error, context);
            return;
          }
        }

        setState(() {
          issaving = true;
          isAnimating = true;
        });

        // 组装要保存的数据
        CheckRecordDto checkRecord = CheckRecordDto.fromJson({});
        // 执行人
        checkRecord.executor = this.loginResult.user.name;
        // 执行时间
        checkRecord.checkTime = DateTime.now().millisecondsSinceEpoch;
        List<String> fileData = new List();
        if (null != this.imageList && this.imageList.length > 0) {
          this.imageList.forEach((f) {
            fileData.add(Attachment.fromParams(filePath: f.path).toString());
          });
        }

        checkRecord.planTaskId = JunMath.parseInt(this.widget.point.planTaskId);
        if(null != this.widget.point.planTask){
          checkRecord.planName = this.widget.point.planTask.planName;
        }
        checkRecord.pointId = JunMath.parseInt(this.widget.point.pointId);
        checkRecord.pointNo = this.widget.point.pointNO;
        checkRecord.checkMode = this.widget.checkMode??"OTHER";

        checkRecord.remark = this._remarkController.text;
        if (selectClass != -1) {
          checkRecord.classId = selectClass;
        }
        checkRecord.checkItems = new List();

        _itemResultDataMap.forEach((k, v) {
          CheckItemDto item = CheckItemDto.fromJson({});
          // 检查项ID
//        item.inputItemId = v.id;
          // 检查项ID
          num itemId; //= _checkItem.singleWhere((f)=>f.uniqueKey == v.uniqueKey).id;
          for(var i = 0; i< _checkItem.length; i++){
            if(_checkItem[i].uniqueKey == k){
              itemId = _checkItem[i].id;
              item.classifyIds = _checkItem[i].classifyIds;
              break;
            }
          }

          item.inputItemId = itemId;
          // 检查项的值，数字，文本：放具体输入的值，选择：放选项的名字
          item.inputValue = v.value;
          // 备注
          item.remark = v.text;
          checkRecord.checkItems.add(item);
          // 组装图片信息
          if (null != v && null != v.img) {
            v.img.forEach((key, val) {
//            Attachment attach = new Attachment.fromParams(itemId: v.id, name: key, filePath: val.path);
              Attachment attach = new Attachment.fromParams(itemId: itemId, name: key, filePath: val.path);
              fileData.add(attach.toString());
            });
          }
        });

        // 将没有内容的检查项也上传
        List<String> keys = _itemResultDataMap.keys.toList();
        for(int i=0;i<_checkItem.length;i++){
          bool dataExist = false;
          for(int j=0;j<keys.length;j++){
            if(_checkItem[i].uniqueKey == keys[j]){
              dataExist = true;
              break;
            }
          }
          if(!dataExist){
//          List<String> classifyIds = List();
//          this.commitClassifies.forEach((k,v){
//            if(v==true){
//              classifyIds.add(k);
//            }
//          });
            classifyIds.forEach((id){
              if(id == "null" && _checkItem[i].classifyIds == null ){
                CheckItemDto item = CheckItemDto.fromJson({});
                item.inputItemId = _checkItem[i].id;
                item.classifyIds = _checkItem[i].classifyIds;
                item.routePointItemId = _checkItem[i].routePointItemId;
                checkRecord.checkItems.add(item);
              }else if(id == _checkItem[i].classifyIds){
                CheckItemDto item = CheckItemDto.fromJson({});
                item.inputItemId = _checkItem[i].id;
                item.classifyIds = _checkItem[i].classifyIds;
                item.routePointItemId = _checkItem[i].routePointItemId;
                checkRecord.checkItems.add(item);
              }
            });
          }
        }

        // 数据过滤
        List<CheckItemDto> finalCheckItems = List();
        if(classifyIds != null && classifyIds.length >0){
          checkRecord.checkItems.forEach((checkItem){
            classifyIds.forEach((id){
              if(id == "null" && checkItem.classifyIds == null ){
                finalCheckItems.add(checkItem);
              }else if(id == checkItem.classifyIds){
                finalCheckItems.add(checkItem);
              }
            });
          });
        }else{
          checkRecord.checkItems.forEach((checkItem){
            finalCheckItems.add(checkItem);
          });
        }


        checkRecord.checkItems = [];
        checkRecord.checkItems = finalCheckItems;

        // 保存巡检记录
        saveCheckRecordData(checkRecord, fileData);
      }

//    }
  }

  void saveCheckRecordData(recordData, fileData) async {
    try {
      if(null == recordData){
        return showAlertMessageOnly("必填参数不能为空！",false);
      }
      //Insert data into Database
      Database db = await dbAccess().openDb();
      bool rt = await dbAccess().insertCheckRecord(db,recordData.toString(),fileData.toString());
      if(rt){
        List<Map<String,dynamic>> lstRd = await dbAccess().getCheckRecords(db);
        print(lstRd);
        await dbAccess().closeDb(db);
        // 第二个参数：true 关闭当前页
        return showAlertMessageOnly("数据保存成功！",true);
      }else{
        setState(() {
          issaving = false;
        });
        return showAlertMessageOnly("数据保存失败！",false);
      }
    } catch (e) {
      setState(() {
        issaving = false;
      });
      return showAlertMessageOnly("数据保存失败！",false);
    }
  }

  checkData(ExtClass classifySelected) {

    List<CheckItem> needCheckItems = List();
    Map<String,ItemResultData> _needCheckItemResultDataMap = Map();

//    List<CheckItem> needCheckItems = List();
//    if (selectClass != -1) {
//      _checkItem.forEach((f) {
//        List<String> ids = f.classifyIds.split(",");
//        ids.forEach((id) {
//          if (id == selectClass.toString()) {
//            needCheckItems.add(f);
//          }
//        });
//      });
//    } else {
//      needCheckItems = _checkItem;
//    }

//    List<CheckItem> needCheckItems = List();
//    List<String> classifyIds = List();
//    this.commitClassifies.forEach((k,v){
//      if(v==true){
//        classifyIds.add(k);
//      }
//    });
//
//    classifyIds.forEach((classifyId){
//      needCheckItems.addAll(_checkItem.where((f)=>f.classifyIds.toString() == classifyId).toList());
//    });
//
//    if(this.initConfig.extClass == null || this.initConfig.extClass.length <= 0){
//      needCheckItems = this._checkItem;
//    }

    if(classifySelected == null){
      needCheckItems = this._checkItem;
    }else{
      if(classifySelected.id == null){
        needCheckItems.addAll(_checkItem.where((f)=>f.classifyIds == null).toList());
      }else{
        needCheckItems.addAll(_checkItem.where((f)=>f.classifyIds == classifySelected.id.toString()).toList());
      }
    }

    needCheckItems.forEach((f) {
      if (f.itemType == "文本") {
//        textCheck(f.uniqueKey,f);
      } else if (f.itemType == "选择") {
        radioCheck(f.uniqueKey, f);
      } else if (f.itemType == "数字") {
        numberCheck(f.uniqueKey, f);
      }

      // 检查照片是否上传
//      f.pictureInfo.forEach((p) {
//        // 照片没有传
//        if (p.isMust == "是") {
//          if (_itemResultDataMap[f.uniqueKey] == null) {
//            _itemResultDataMap[f.uniqueKey] =
//                ItemResultData.fromParams(uniqueKey: f.uniqueKey, value: "");
//          }
//
//          if (_itemResultDataMap[f.uniqueKey].img != null) {
//            if (_itemResultDataMap[f.uniqueKey].img[p.name] == null) {
//              // 必须项未拍照
//              _itemResultDataMap[f.uniqueKey].hasError = true;
//              if ((_itemResultDataMap[f.uniqueKey].errorInfo ?? "") != "") {
//                _itemResultDataMap[f.uniqueKey].errorInfo += "\r\n" + p.name + "未上传照片";
//              } else {
//                _itemResultDataMap[f.uniqueKey].errorInfo = p.name + "未上传照片";
//              }
//            }
//          } else {
//            // 必须项未拍照
//            _itemResultDataMap[f.uniqueKey].hasError = true;
//            if ((_itemResultDataMap[f.uniqueKey].errorInfo ?? "") != "") {
//              _itemResultDataMap[f.uniqueKey].errorInfo += "\r\n" + p.name + "未上传照片";
//            } else {
//              _itemResultDataMap[f.uniqueKey].errorInfo = p.name + "未上传照片";
//            }
//          }
//        } else {
//          // 无需检查
//        }
//      });
      // 检查照片是否上传
      f.pictureInfo.forEach((p){
        // 照片没有传
        if(p.isMust == "是"){
          if(_itemResultDataMap[f.uniqueKey] == null){
            _itemResultDataMap[f.uniqueKey] = ItemResultData.fromParams(uniqueKey: f.uniqueKey,value: "");
          }

          if(_itemResultDataMap[f.uniqueKey].img != null){
            if(_itemResultDataMap[f.uniqueKey].img[p.name] == null){
              // 必须项未拍照
              _itemResultDataMap[f.uniqueKey].hasError = true;
              if((_itemResultDataMap[f.uniqueKey].errorInfo??"") != ""){
                _itemResultDataMap[f.uniqueKey].errorInfo += "\r\n" + p.name + "未上传照片";
              }else{
                _itemResultDataMap[f.uniqueKey].errorInfo = p.name + "未上传照片";
              }
            }
          }else{
            // 必须项未拍照
            _itemResultDataMap[f.uniqueKey].hasError = true;
            if((_itemResultDataMap[f.uniqueKey].errorInfo??"") != ""){
              _itemResultDataMap[f.uniqueKey].errorInfo += "\r\n" + p.name + "未上传照片";
            }else{
              _itemResultDataMap[f.uniqueKey].errorInfo = p.name + "未上传照片";
            }
          }
        }else{
          // 无需检查
        }
      });

      _needCheckItemResultDataMap[f.uniqueKey] = _itemResultDataMap[f.uniqueKey];
    });

    // 打印检查项
//    String error = "";
//    _itemResultDataMap.forEach((k, v) {
//      if (null != v.hasError && v.hasError) {
//        error = error + v.errorInfo + "\r\n";
//      }
//    });
    // 打印检查项
    String error="";
    /*_itemResultDataMap*/
    _needCheckItemResultDataMap.forEach((k,v){
      if(null != v && null != v.hasError && v.hasError){
        error = error + v.errorInfo + "\r\n";
        _needCheckItemResultDataMap[k].errorInfo = "";
      }
    });
    return error;
  }

  textCheck(String key, CheckItem checkItem) {

    if(_itemResultDataMap[key] == null){
      _itemResultDataMap[key] = ItemResultData.fromParams(routePointItemId: checkItem.routePointItemId,value: "");
    }

//    if (checkItem.isMust == "是") {
//      if (_itemResultDataMap[key] == null) {
//        _itemResultDataMap[key] =
//            ItemResultData.fromParams(id: checkItem.id, value: "");
//      }
//
//      if (_itemResultDataMap[key] == null ||
//          _itemResultDataMap[key].value.isEmpty) {
////        setState(() {
//        _itemResultDataMap[key].hasError = true;
//        _itemResultDataMap[key].errorInfo = "请输入：" + checkItem.name;
////        });
//      } else {
////        setState(() {
//        _itemResultDataMap[key].hasError = false;
//        _itemResultDataMap[key].errorInfo = "";
////        });
//      }
//    }
  }

  numberCheck(String key, CheckItem checkItem) {
    num value = num.tryParse(
      _itemResultDataMap[key] == null || _itemResultDataMap[key].value == null
          ? ""
          : _itemResultDataMap[key].value,
    );
//    print(value);
    if (checkItem.isMust == "是") {
      if (_itemResultDataMap[key] == null) {
        _itemResultDataMap[key] =
            ItemResultData.fromParams(id: checkItem.id, value: "");
      }

      _itemResultDataMap[key].hasError = false;

//      print(_itemResultDataMap[key] == null ||  _itemResultDataMap[key].value.isEmpty);
      if (_itemResultDataMap[key] == null ||
          _itemResultDataMap[key].value.isEmpty) {
//        setState(() {
        _itemResultDataMap[key].hasError = true;
        _itemResultDataMap[key].errorInfo = "请输入：" + checkItem.name;
//        });
      } else {
//        print("123");
        NumberCheckInfo checkInfo =
            NumberCheckInfo.fromJson(json.decode(checkItem.dataJson));
//        print(checkInfo.CheckValidDown);
        // -10 -- 50
        // 49
        if (checkInfo.CheckValidDown) {
          //num value = num.tryParse(_itemResultDataMap[key].value,);
//          print("parse result====>$value");
          if (value == null) {
            _itemResultDataMap[key].hasError = true;
            _itemResultDataMap[key].errorInfo = checkItem.name + ":请输入数字";
          } else {
//            print(checkInfo.ValidDown);
//            print(value);
            if(checkInfo.Precision==0 && value.toString().contains('.')){
              _itemResultDataMap[key].hasError = true;
              _itemResultDataMap[key].errorInfo =
                  checkItem.name + ":只允许输入整数";
            }
            if(checkInfo.Precision>0 && value.toString().contains('.')){
              var dotIndex=value.toString().indexOf(".");
              var numS=value.toString().substring(dotIndex+1);
              if(numS.length>checkInfo.Precision){
                _itemResultDataMap[key].hasError = true;
                _itemResultDataMap[key].errorInfo =
                    checkItem.name + ":只允许输入${checkInfo.Precision}位小数";
              }

            }

            if (value < checkInfo.ValidDown) {
              _itemResultDataMap[key].hasError = true;
              _itemResultDataMap[key].errorInfo =
                  checkItem.name + ":最小值不能小于" + checkInfo.ValidDown.toString();
            }
          }
        }
        if (checkInfo.CheckValidUp) {
          if (value == null) {
            _itemResultDataMap[key].hasError = true;
            _itemResultDataMap[key].errorInfo = checkItem.name + ":请输入数字";
          } else {
            if (value > checkInfo.ValidUp) {
              _itemResultDataMap[key].hasError = true;
              _itemResultDataMap[key].errorInfo =
                  checkItem.name + ":最大值不能大于" + checkInfo.ValidUp.toString();
            }

            if(checkInfo.Precision==0 && value.toString().contains('.')){
              _itemResultDataMap[key].hasError = true;
              _itemResultDataMap[key].errorInfo =
                  checkItem.name + ":只允许输入整数";
            }
            if(checkInfo.Precision>0 && value.toString().contains('.')){
              var dotIndex=value.toString().indexOf(".");
              var numS=value.toString().substring(dotIndex+1);
              if(numS.length>checkInfo.Precision){
                _itemResultDataMap[key].hasError = true;
                _itemResultDataMap[key].errorInfo =
                    checkItem.name + ":只允许输入${checkInfo.Precision}位小数";
              }

            }
          }
        }
        else{

          if(checkInfo.Precision==0 && value.toString().contains('.')){
            _itemResultDataMap[key].hasError = true;
            _itemResultDataMap[key].errorInfo =
                checkItem.name + ":只允许输入整数";
          }
          if(checkInfo.Precision>0 && value.toString().contains('.')){
            var dotIndex=value.toString().indexOf(".");
            var numS=value.toString().substring(dotIndex+1);
            if(numS.length>checkInfo.Precision){
              _itemResultDataMap[key].hasError = true;
              _itemResultDataMap[key].errorInfo =
                  checkItem.name + ":只允许输入${checkInfo.Precision}位小数";
            }

          }
        }
      }
    } else {
      if (_itemResultDataMap[key].value.isNotEmpty) {
        if (value == null) {
//          setState(() {
          _itemResultDataMap[key].hasError = true;
          _itemResultDataMap[key].errorInfo = checkItem.name + ":请输入数字";
//          });
          return;
        }
      } else {
//        setState(() {
        _itemResultDataMap[key].hasError = false;
        _itemResultDataMap[key].errorInfo = "";
//        });
      }
    }
  }

  radioCheck(String key, CheckItem checkItem) {
    if (checkItem.isMust == "是") {
      if (_itemResultDataMap[key] == null) {
        _itemResultDataMap[key] =
            ItemResultData.fromParams(id: checkItem.id, value: "");
      }
      if (_itemResultDataMap[key].value.isEmpty) {
        setState(() {
          _itemResultDataMap[key].hasError = true;
          _itemResultDataMap[key].errorInfo = "请输入：" + checkItem.name;
        });
      } else {
        setState(() {
          _itemResultDataMap[key].hasError = false;
          _itemResultDataMap[key].errorInfo = "";
        });
      }
    }
  }

  showAlertMessageOnly(String text, bool close) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => new AlertDialog(
                title: Column(
                  children: <Widget>[
                    new Text("信息"),
                    Divider(height: 2),
                  ],
                ),
                content: Text(text),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("关闭",
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // 是否关闭当前页
                      if (close) {
                        // 关闭当前页
                        Navigator.pop(context);
                      }
                    },
                  ),
                ]));
  }

  classifyDialog(){
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children:initConfig.extClass.map((f){
            return Column(
              children: <Widget>[
                new SimpleDialogOption(
                  child: new Text(f.name),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      classifySelected=f;
                      // 公司切换
//                      selectCompany(this.f..);
                      _filtercheckItem.clear();
                      setState(() {
                        _checkItem.forEach((v){
                          if(classifySelected.id != null){
                            if(classifySelected.id.toString() == v.classifyIds.toString()){
                              _filtercheckItem.add(v);
                            }
                          }else{
                            if(v.classifyIds == "null" || v.classifyIds.isEmpty){
                              _filtercheckItem.add(v);
                            }
                          }
                        });
                      });
                    });
                  },
                ),
                Divider(height: 1,)
              ],
            );
          }).toList(),
        );
      },
    );
  }

  saveSelectClassifyDialog(){
    showDialog<Null>(
      context: context,
//      barrierDismissible:false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder:(context, state) {
              return SimpleDialog(
                children: <Widget>[
                  Container(
                    child: Text("请选择要提交的扩展分类"),
                    alignment: Alignment.center,
                  ),
                  Divider(height: 1,),
                  Column(
                    children: initConfig.extClass.map((f){
                      return Column(
                        children: <Widget>[
                          new CheckboxListTile(
                            title: Text(f.name),
                            value: this.commitClassifies[f.id.toString()],
                            onChanged: (bool value) {
                              state(() {
                                this.commitClassifies[f.id.toString()] = !this.commitClassifies[f.id.toString()];
                              });
//                            print(this.commitClassifies[f.id.toString()]);
                            },
                          ),
                          Divider(height: 1,)
                        ],
                      );
                    }).toList(),
                  ),
                  this.commitClassifies.values.where((f)=>f==true).length>0?
                  FlatButton(child: Text("提交",style: TextStyle(fontSize: 16),),onPressed: (){
                    Navigator.pop(context);
                    saveData();
                  }):
                  FlatButton(child: Text("提交",style: TextStyle(fontSize: 16,color: Colors.grey),),onPressed: (){
                  })
                ],
              );
            }
        );
      },
    );
  }
}

class ItemResultData{
  num routePointItemId;
  num id;
  String value;
  Map<String,File> img = Map();
  String text;
  String errorInfo;
  bool hasError = false;
  String uniqueKey;
//  String classifyIds;

  ItemResultData.fromParams({
    this.id,this.value,this.img,
    this.errorInfo,this.hasError,
    this.routePointItemId,
    this.uniqueKey
//    this.classifyIds
  });

  @override
  String toString() {
    return '{"id": $id,"value":$value,"text":$text,"errorInfo":$errorInfo,"hasError":$hasError,"img":$img}';
  }
}

class RadioWidgetInfo {
  int score;
  String name;
  String isChecked;
  String isOk;

  RadioWidgetInfo.fromJson(jsonRes) {
    score = jsonRes['score'];
    name = jsonRes['name'];
    isChecked = jsonRes['isChecked'];
    isOk = jsonRes['isOk'];
  }
}

class NumberCheckInfo {
  num OkScore;
  num NoScore;
  num ValidUp;
  num ValidDown;
  num OkUp;
  num OkDown;
  bool CheckValidUp;
  bool CheckValidDown;
  bool CheckOkUp;
  bool CheckOkDown;
  num Precision;

  NumberCheckInfo.fromJson(jsonRes) {
    OkScore = jsonRes['OkScore'];
    NoScore = jsonRes['NoScore'];
    ValidUp = jsonRes['ValidUp'];
    ValidDown = jsonRes['ValidDown'];
    OkUp = jsonRes['OkUp'];
    OkDown = jsonRes['OkDown'];
    CheckValidUp = jsonRes['CheckValidUp'];
    CheckValidDown = jsonRes['CheckValidDown'];
    CheckOkUp = jsonRes['CheckOkUp'];
    CheckOkDown = jsonRes['CheckOkDown'];
    Precision = jsonRes['Precision'];
  }
}
