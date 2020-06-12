import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/common/JunCommon.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckItem.dart';
import 'package:intelligent_check_new/model/CheckRecordDto.dart';
import 'package:intelligent_check_new/model/ExtClass.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/model/MovePointAttachment.dart';
import 'package:intelligent_check_new/model/PlanTaskInitConfig.dart';
import 'package:intelligent_check_new/model/offline/offline_plan_list_output.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageList.dart';
import 'package:intelligent_check_new/pages/CheckExecute/TextView.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_inspection_list.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_Inspection_danger_add.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/pages/offline/CheckExecute/checkexec_inspection_list_detail.dart';
import 'package:intelligent_check_new/services/CheckRecordServices.dart';
import 'package:intelligent_check_new/services/offline/dbAccess.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/tools/MessageBox.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class OfflineCheckExecInspectionList extends StatefulWidget {
//  // 计划ID
//  int planId;
//
//  // 巡检点ID
//  int pointId;
//  String checkMode;
//
//  OfflineCheckExecInspectionList(this.pointId, [this.planId, this.checkMode]);
  Point point;
  String checkMode;
  int cid;
  OfflineCheckExecInspectionList(this.point,this.checkMode,{this.cid});

  @override
  State<StatefulWidget> createState() => _OfflineCheckExecInspectionList();
}

class _OfflineCheckExecInspectionList extends State<OfflineCheckExecInspectionList>
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

  int selectClass = -1;

  // 过滤后的检查项
  List<CheckItem> _filtercheckItem = List();

  bool isAnimating = false;

  String theme = "";

//  List<DropdownMenuItem> items = new List();
  ExtClass classifySelected;

  // 确定要提交的分类
  Map<String, bool> commitClassifies = Map();

  // 问题列表
  Map<num, bool> unCheckInputMap = Map();

  // 登陆人信息
  LoginResult loginResult;

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
    initThemeConfig();
  }

  initThemeConfig() async {
    SharedPreferences.getInstance().then((preferences) {
      setState(() {
        this.theme =
            preferences.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
      });
    });
  }

//  void getInitConfig() async {
//    // 调用接口获取配置
//    await getInitPlanTaskConfig(this.widget.planId, this.widget.pointId)
//        .then((data) {
////      data = null;
////      print(data);
//      if (null == data) {
//        MessageBox.showMessageAndExitCurrentPage("数据加载失败！", true, context);
//        return;
//      }
//
//      if (data.errorMsg != null && data.errorMsg.isNotEmpty) {
//        MessageBox.showMessageAndExitCurrentPage(data.errorMsg, true, context);
//        return;
//      }
//
//      setState(() {
//        initConfig = data;
//        if (data.extClass.length > 0) {
//          classifySelected = data.extClass[0];
//          data.extClass.forEach((f) {
//            // 初始化
//            commitClassifies[f.id.toString()] = false;
//          });
//        }
//      });
//      for (var item in initConfig.checkItem) {
//        List<ItemPictureInfo> pics = List();
//        for (var pic in json.decode(item.pictureJson)) {
//          ItemPictureInfo p = ItemPictureInfo.fromJson(pic);
////          p.isMust = "是";
//          pics.add(p);
////          setState(() {
////            itemCount ++;
////          });
//        }
//        item.pictureInfo = pics;
//        item.uniqueKey = new Uuid().v4();
//        _checkItem.add(item);
//        if (classifySelected != null) {
//          if (item.classifyIds == null &&
//              classifySelected.id.toString() == "null") {
//            _filtercheckItem.add(item);
//          } else if (item.classifyIds == classifySelected.id.toString()) {
//            _filtercheckItem.add(item);
//          }
//        } else {
//          _filtercheckItem.add(item);
//        }
//
//        // TextField 绑定初始化controller
//        if (item.itemType == "文本" || item.itemType == "数字") {
//          txtControllers[item.uniqueKey.toString()] = TextEditingController();
//        }
//
//        if (item.itemType == "选择") {
//          List<RadioWidgetInfo> rds = List();
//          for (var rd in jsonDecode(item.dataJson)) {
//            rds.add(RadioWidgetInfo.fromJson(rd));
//          }
//          rds.forEach((rd) {
//            if (rd.isChecked == "是") {
//              ItemResultData itemResultData = ItemResultData.fromParams();
//              itemResultData.uniqueKey = item.uniqueKey;
//              itemResultData.value = rd.name;
//              _itemResultDataMap[item.uniqueKey] = itemResultData;
//            }
//          });
//        }
//      }
//    });
//  }

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

  @override
  Widget build(BuildContext context) {
    if (this.theme.isEmpty) {
      return Scaffold(body: Text(""));
    }
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
            child: Icon(Icons.keyboard_arrow_left,
                color: GetConfig.getColor(theme), size: 32),
          ),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: this.widget.point == null
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
        actions: <Widget>[
          //IconButton(icon: Icon(Icons.search,color: Colors.red,),onPressed: (){},),
          IconButton(
            icon: Image(
              image: AssetImage("assets/images/icons/save_" + theme + ".png"),
              width: 22,
            ),
            onPressed: () {
              if (!issaving) {
                saveData();
              }
            },
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
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
                            this.widget.point == null
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
                                "检查计划",
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
                  color: Color.fromRGBO(242, 246, 249, 1),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 10, top: 10),
                  width: double.infinity,
                  height: 40,
                  child: Text(
                    "检查项目",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Container(
                  height: 10.0,
                  color: Color.fromRGBO(242, 246, 249, 1),
                ),
                Container(
                  child: Column(
                    children: initConfig.extClass.map((f) {
                      return GestureDetector(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 8, bottom: 6),
                                    child: Text(f.name),
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Icon(Icons.check_circle,
                                        color: f.hasDone
                                            ? Color.fromRGBO(0, 180, 22, 1)
                                            : Color.fromRGBO(215, 219, 225, 1)),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Icon(
                                      Icons.chevron_right,
                                      size: 28,
                                      color: GetConfig.getColor(theme),
                                    ),
                                    alignment: Alignment.centerRight,
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                            Divider()
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return OfflineCheckExecInspectionListDetail(
                                this.initConfig,
                                f,
                                _itemResultDataMap,
                                num.tryParse(this.widget.point.pointId),
                                num.tryParse(this.widget.point.planTaskId),
                                this.widget.checkMode);
                          })).then((v) {
                            if (v != null) {
                              if (v.toString().startsWith("cancel")) {
                                List<String> ids =
                                    v.toString().substring(8).split("||");
                                for (String id in ids) {
                                  commitClassifies[id] = false;
                                  _itemResultDataMap[id] = null;
                                  f.hasDone = commitClassifies[id];
                                }
                              } else if (v.toString().startsWith("back")) {
                                var exts = json.decode(v.toString().split("||")[1]);
                                f.hasDone=exts.hasDone;
                              } else {
//                                print("save");
//                                print(_itemResultDataMap);
                                setState(() {
                                  for (var _mKey in v.keys) {
                                    this._itemResultDataMap[_mKey] = v[_mKey];
                                    if (_itemResultDataMap[_mKey] == null ||
                                        _itemResultDataMap[_mKey].uniqueKey ==
                                            null) {
                                      commitClassifies[_mKey] = false;
                                      f.hasDone = false;
                                    } else {
                                      commitClassifies[_mKey] = true;
                                      f.hasDone = true;
                                    }
                                  }
                                });
                              }
                            } else {
//                              this.initConfig.checkItem.forEach((item){
//                                if(item.classifyIds == f.id.toString()){
//                                  commitClassifies[item.uniqueKey] = false;
//                                }
//                              });
                              f.hasDone = false;
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  height: 10.0,
                  color: Color.fromRGBO(242, 246, 249, 1),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 10,
                  child: Padding(
                      padding:
                          EdgeInsets.only(left: 10.0, bottom: 20.0, top: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "现场照片",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    flex: 9,
                                  ),
                                  Expanded(
                                    child: Image.asset(
                                      "assets/images/icons/camera_" +
                                          theme +
                                          ".png",
                                      height: 20,
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: new Icon(
                                      Icons.keyboard_arrow_right,
                                      color: GetConfig.getColor(theme),
                                      size: 28,
                                    ),
                                    flex: 0,
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
                ),
                Container(
                  height: 10.0,
                  color: Color.fromRGBO(242, 246, 249, 1),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 10,
                  child: GestureDetector(
                    child: Padding(
                        padding:
                            EdgeInsets.only(left: 10.0, bottom: 20.0, top: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 9,
                                    child: Text(
                                      "备注说明",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      "assets/images/icons/message.png",
                                      height: 20,
                                    ),
                                  ),
                                  Expanded(
                                    child: new Icon(
                                      Icons.keyboard_arrow_right,
                                      color: GetConfig.getColor(theme),
                                      size: 28,
                                    ),
                                    flex: 0,
                                  ),
                                ],
                              ),
                            ])),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
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
                  color: Colors.white,
                ),
                Container(
                  height: 10.0,
                  color: Color.fromRGBO(242, 246, 249, 1),
                )
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  //////////////////////////////////////////////////////////////////////////////////////
  // 开始加载价检查项
  List<CheckItem> _checkItem = List();
  Map<String, ItemResultData> _itemResultDataMap = Map();

  saveData() {
//    String error = checkData();

    // 错误信息不是空
//    if(error.isNotEmpty){
//      setState(() {
//        issaving = false;
//      });
//      MessageBox.showMessageOnly(error, context);
//
//      _itemResultDataMap.forEach((k,v){
//        v.hasError = false;
//        v.errorInfo="";
//      });
//
//      return;
//    }else{
    // save data
    print(
        "check 要提交数据完整性=====================================================");
//      if(_checkItem.where((f)=>f.isMust=="是").length > _itemResultDataMap.length){
//        MessageBox.showMessageOnly("有未提交的数据项！", context);
//        return;
//      }

    for (var item in _checkItem) {
      if (item.isMust == "是") {
        if (_itemResultDataMap[item.uniqueKey] == null) {
          HiddenDangerFound.popUpMsg("有未提交的数据项！");

          return;
        }
        if (_itemResultDataMap[item.uniqueKey] != null &&
            (_itemResultDataMap[item.uniqueKey].value == null ||
                _itemResultDataMap[item.uniqueKey].value.isEmpty) &&
            (_itemResultDataMap[item.uniqueKey].text == null ||
                _itemResultDataMap[item.uniqueKey].text.isEmpty)) {
          HiddenDangerFound.popUpMsg("有未提交的数据项！");
          return;
        }
      }
    }

    // 查看图片数量是否合格
//      int mustPicCount = 0;
//      _checkItem.forEach((f){
    for (var item in _checkItem) {
      int picCount = item.pictureInfo.where((f) => f.isMust == "是").length;
      if (picCount > 0) {
        //mustPicCount = mustPicCount + picCount;
        if (_itemResultDataMap[item.uniqueKey] != null) {
          if (_itemResultDataMap[item.uniqueKey].img == null ||
              picCount > _itemResultDataMap[item.uniqueKey].img.length) {
            HiddenDangerFound.popUpMsg("有未上传的图片！");
            return;
          }
        }
      }
    }

//      });

//      int updatePicCount = 0;
//      _itemResultDataMap.keys.forEach((k){
//
//      });
    print("check result=====================================================");

    // 需要上传的分类数据
    List<String> classifyIds = List();
    this.commitClassifies.forEach((k, v) {
      if (v == true) {
        classifyIds.add(k);
      }
    });

    if (classifyIds.length <= 0 &&
        initConfig.extClass != null &&
        initConfig.extClass.length > 0) {
      setState(() {
        issaving = false;
        isAnimating = false;
        HiddenDangerFound.popUpMsg("没有数据可以提交！");
        return;
      });
    } else {
      //
      if (classifyIds.length <= 0 &&
          (initConfig.extClass == null || initConfig.extClass.length <= 0)) {
        // check data
        String error = checkData(null);
        if (error.isNotEmpty) {
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
      // 要上传的文件
      List<Attachment> fileData = new List();
      if (null != this.imageList && this.imageList.length > 0) {
        this.imageList.forEach((f) {
          fileData.add(Attachment.fromParams(file: f));
        });
      }

      checkRecord.executor = this.loginResult.user.name;
      checkRecord.checkTime = DateTime.now().millisecondsSinceEpoch;
      checkRecord.planTaskId = num.tryParse(this.widget.point.planTaskId);
      checkRecord.pointId = num.tryParse(this.widget.point.pointId);
      checkRecord.remark = this._remarkController.text;
      checkRecord.checkMode = this.widget.checkMode ?? "OTHER";
      checkRecord.checkItems = new List();

      _itemResultDataMap.forEach((k, v) {
        if (k != null && k != "") {
          CheckItemDto item = CheckItemDto.fromJson({});
          // 检查项ID
          num itemId; //= _checkItem.singleWhere((f)=>f.uniqueKey == v.uniqueKey).id;
          for (var i = 0; i < _checkItem.length; i++) {
            if (_checkItem[i].uniqueKey == k) {
              itemId = _checkItem[i].id;
              item.classifyIds = _checkItem[i].classifyIds;
              break;
            }
          }

          item.inputItemId = itemId;
          // 检查项的值，数字，文本：放具体输入的值，选择：放选项的名字
          item.inputValue = v.value != null ? v.value.trim() : "";
          // 备注
          item.remark = v.text;
          item.routePointItemId = v.routePointItemId;

          checkRecord.checkItems.add(item);
          // 组装图片信息
          if (null != v && null != v.img) {
            v.img.forEach((key, val) {
              Attachment attach = new Attachment.fromParams(
                  itemId: itemId, file: val, name: key);
              attach.classifyIds = v.classifyIds;
              fileData.add(attach);
            });
          }
        }
      });

      // 将没有内容的检查项也上传
      List<String> keys = _itemResultDataMap.keys.toList();
      for (int i = 0; i < _checkItem.length; i++) {
        bool dataExist = false;
        for (int j = 0; j < keys.length; j++) {
          if (_checkItem[i].uniqueKey == keys[j]) {
            dataExist = true;
            break;
          }
        }
        if (!dataExist) {
//          List<String> classifyIds = List();
//          this.commitClassifies.forEach((k,v){
//            if(v==true){
//              classifyIds.add(k);
//            }
//          });
          classifyIds.forEach((id) {
            if (id == "null" && _checkItem[i].classifyIds == null) {
              CheckItemDto item = CheckItemDto.fromJson({});
              item.inputItemId = _checkItem[i].id;
              item.classifyIds = _checkItem[i].classifyIds;
              item.routePointItemId = _checkItem[i].routePointItemId;
              checkRecord.checkItems.add(item);
            } else if (id == _checkItem[i].classifyIds) {
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
//        List<CheckItemDto> finalCheckItems = List();
//        if(classifyIds != null && classifyIds.length >0){
//          checkRecord.checkItems.forEach((checkItem){
//            classifyIds.forEach((id){
//              if(id == "null" && checkItem.classifyIds == null ){
//                finalCheckItems.add(checkItem);
//              }else if(id == checkItem.classifyIds){
//                finalCheckItems.add(checkItem);
//              }
//            });
//          });
//        }else{
//          checkRecord.checkItems.forEach((checkItem){
//            finalCheckItems.add(checkItem);
//          });
//        }

//        checkRecord.checkItems = [];
//        checkRecord.checkItems = finalCheckItems;

      showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return SimpleDialog(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(left: 15, bottom: 15),
                  child: Text(
                    "提交后不可修改，请确认检查结果准确无误？",
                    style: TextStyle(fontSize: 16),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Divider(
                  height: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          child: FlatButton(
                              child: Text(
                                "确定",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                saveCheckRecordData(checkRecord, fileData);
                              })),
                    ),
                    Expanded(
                      child: Container(
                          child: FlatButton(
                              child: Text(
                                "取消",
                                style: TextStyle(fontSize: 16),
                              ),
                              onPressed: () {
                                setState(() {
                                  issaving = false;
                                  isAnimating = false;
                                });

                                Navigator.pop(context);
                              })),
                    ),
                  ],
                )
              ],
            );
          });
        },
      );

//    }
    }
  }

  var unCheckInputList;

  void saveCheckRecordData(recordData, fileData) async {
    // 保存数据
//    await saveCheckRecord(recordData).then((result) {
//      setState(() {
//        isAnimating = false;
//      });
//      if (result.isOk()) {
//        int checkRecordId = int.tryParse(result.dataList["checkId"].toString());
//        unCheckInputList = result.dataList["unCheckInputList"];
//        // 如果返回的不是ID，那么认为是提示信息
//        if (null == checkRecordId) {
//          MessageBox.showMessageOnly(result.dataList.toString(), context);
//          setState(() {
//            issaving = false;
//          });
//        } else {
//          // 上传图片
//          uploadAttachFile(fileData, checkRecordId, num.tryParse(this.widget.point.pointId))
//              .then((result) {
//            //MessageBox.showMessageAndExitCurrentPage("保存成功！", true, context);
////            var unCheckInputList = result.dataList["unCheckInputList"];
//            if (unCheckInputList != null) {
//              List<UNCheckInput> dataList = List();
//              for (var unCheckInput in unCheckInputList) {
//                UNCheckInput _uNCheckInput =
//                    UNCheckInput.fromJson(unCheckInput);
//                CheckItem checkItem = this
//                    ._checkItem
//                    .firstWhere((f) => f.id == _uNCheckInput.itemId);
//                if (checkItem != null) {
//                  _uNCheckInput.routePointItemId = checkItem.routePointItemId;
//                }
//                dataList.add(_uNCheckInput);
////                unCheckInputMap[_uNCheckInput.itemId] = false;
//              }
//              if (dataList.length > 0) {
//                Navigator.push(
//                    context,
//                    new MaterialPageRoute(
//                        builder: (context) => new InspectionHiddenDangerFound(
//                              false,
//                              checkId: checkRecordId,
//                              unCheckInputData: dataList,
//                              planId: num.tryParse(this.widget.point.planTaskId),
//                            ))).then((v) {
//                  Navigator.pop(context);
////                  Navigator.pop(context);
//                });
//              } else {
//                MessageBox.showMessageAndExitCurrentPage(
//                    "保存成功！", true, context);
//              }
//            } else {
//              MessageBox.showMessageAndExitCurrentPage("保存成功！", true, context);
//            }
//          });
//        }
//      } else {
//        MessageBox.showMessageOnly(result.message ?? "数据保存失败！", context);
//        setState(() {
//          issaving = false;
//        });
//      }
//    });

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
    Map<String, ItemResultData> _needCheckItemResultDataMap = Map();
//    List<String> classifyIds = List();
//    this.commitClassifies.forEach((k,v){
//      if(v==true){
//        classifyIds.add(k);
//      }
//    });

//    classifyIds.forEach((classifyId){
//      needCheckItems.addAll(_checkItem.where((f)=>f.classifyIds.toString() == classifyId).toList());
//    });
    if (classifySelected == null) {
      needCheckItems = this._checkItem;
    } else {
      if (classifySelected.id == null) {
        needCheckItems
            .addAll(_checkItem.where((f) => f.classifyIds == null).toList());
      } else {
        needCheckItems.addAll(_checkItem
            .where((f) => f.classifyIds == classifySelected.id.toString())
            .toList());
      }
    }
//    needCheckItems.addAll(_checkItem.where((f)=>f.classifyIds == classifySelected.id.toString()).toList());

//    if(this.initConfig.extClass == null || this.initConfig.extClass.length <= 0){
//      needCheckItems = this._checkItem;
//    }

    needCheckItems.forEach((f) {
      if (f.itemType == "文本") {
//        textCheck(f.uniqueKey,f);
      } else if (f.itemType == "选择") {
        radioCheck(f.uniqueKey, f);
      } else if (f.itemType == "数字") {
        numberCheck(f.uniqueKey, f);
      }

      // 检查照片是否上传
      f.pictureInfo.forEach((p) {
        // 照片没有传
        if (p.isMust == "是") {
          if (_itemResultDataMap[f.uniqueKey] == null) {
            _itemResultDataMap[f.uniqueKey] =
                ItemResultData.fromParams(uniqueKey: f.uniqueKey, value: "");
          }

          if (_itemResultDataMap[f.uniqueKey].img != null) {
            if (_itemResultDataMap[f.uniqueKey].img[p.name] == null) {
              // 必须项未拍照
              _itemResultDataMap[f.uniqueKey].hasError = true;
              if ((_itemResultDataMap[f.uniqueKey].errorInfo ?? "") != "") {
                _itemResultDataMap[f.uniqueKey].errorInfo +=
                    "\r\n" + p.name + "未上传照片";
              } else {
                _itemResultDataMap[f.uniqueKey].errorInfo = p.name + "未上传照片";
              }
            }
          } else {
            // 必须项未拍照
            _itemResultDataMap[f.uniqueKey].hasError = true;
            if ((_itemResultDataMap[f.uniqueKey].errorInfo ?? "") != "") {
              _itemResultDataMap[f.uniqueKey].errorInfo +=
                  "\r\n" + p.name + "未上传照片";
            } else {
              _itemResultDataMap[f.uniqueKey].errorInfo = p.name + "未上传照片";
            }
          }
        } else {
          // 无需检查
        }
      });

      _needCheckItemResultDataMap[f.uniqueKey] =
          _itemResultDataMap[f.uniqueKey];
    });

    // 打印检查项
    String error = "";
    /*_itemResultDataMap*/
    _needCheckItemResultDataMap.forEach((k, v) {
      if (null != v && null != v.hasError && v.hasError) {
        error = error + v.errorInfo + "\r\n";
        _needCheckItemResultDataMap[k].errorInfo = "";
      }
    });
    return error;
  }

  textCheck(String key, CheckItem checkItem) {
    if (_itemResultDataMap[key] == null) {
      _itemResultDataMap[key] = ItemResultData.fromParams(
          routePointItemId: checkItem.routePointItemId, value: "");
    }
//    if(checkItem.isMust == "是"){
//      if(_itemResultDataMap[key] == null){
//        _itemResultDataMap[key] = ItemResultData.fromParams(routePointItemId: checkItem.routePointItemId,value: "");
//      }

//      _itemResultDataMap[key].hasError = false;
//      _itemResultDataMap[key].errorInfo="";

//      if(_itemResultDataMap[key] == null || _itemResultDataMap[key].value.isEmpty){
//          _itemResultDataMap[key].hasError = true;
//          _itemResultDataMap[key].errorInfo="请输入："+ checkItem.name;
//      }else{
//          _itemResultDataMap[key].hasError = false;
//          _itemResultDataMap[key].errorInfo="";
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
        _itemResultDataMap[key] = ItemResultData.fromParams(
            routePointItemId: checkItem.routePointItemId, value: "");
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
        _itemResultDataMap[key] = ItemResultData.fromParams(
            routePointItemId: checkItem.routePointItemId, value: "");
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
}
//
class ItemResultData {
  num routePointItemId;
  num id;
  String value;
  Map<String, File> img = Map();
  String text;
  String errorInfo;
  bool hasError = false;
  String uniqueKey;
  num classifyIds;
  bool hasDone = false;

  ItemResultData.fromParams(
      {this.id,
      this.value,
      this.img,
      this.errorInfo,
      this.hasError,
      this.routePointItemId,
      this.uniqueKey,
      this.classifyIds,
      this.text});

  @override
  String toString() {
    return '{"id": $id,"value":$value,"text":$text,"errorInfo":$errorInfo,"hasError":$hasError,"img":$img}';
  }
}
//
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
//
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
//
//class UNCheckInput {
//  num itemId;
//  String name;
//  num value;
//  num routePointItemId;
//  String limitDate;
//  num dangerLevel;
//  bool isSelected = false;
//
//  TextEditingController limitedDate = new TextEditingController();
//  num dangerlevel = 1;
//
//  UNCheckInput.fromJson(jsonRes) {
//    itemId = jsonRes['itemId'];
//    name = jsonRes['name'];
//    value = jsonRes['value'];
//    routePointItemId = jsonRes['routePointItemId'];
//    isSelected = jsonRes['isSelected'] ?? false;
//    dangerLevel = jsonRes['dangerLevel'];
//    limitDate = jsonRes['limitDate'];
//  }
//}
