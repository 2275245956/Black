import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckItem.dart';
import 'package:intelligent_check_new/model/ExtClass.dart';
import 'package:intelligent_check_new/model/PlanTaskInitConfig.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageView.dart';
import 'package:intelligent_check_new/pages/CheckExecute/TextView.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_inspection_list.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/tools/MessageBox.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckExecInspectionListDetail extends StatefulWidget{

  final PlanTaskInitConfig initConfig;
  final ExtClass extClass;
  final Map<String,ItemResultData> _itemResultDataMap;
  final String checkMode;
  final int planId;
  final int pointId;

  int dangerGroup=1;
  TextEditingController limtDate=new TextEditingController();

  CheckExecInspectionListDetail(this.initConfig,this.extClass,this._itemResultDataMap,this.pointId,[this.planId,this.checkMode]);

  @override
  State<StatefulWidget> createState() => _CheckExecInspectionListDetail();
}

class _CheckExecInspectionListDetail extends State<CheckExecInspectionListDetail> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  // 页面配置信息
  PlanTaskInitConfig initConfig;

  // 页面文本框集合
  Map<String, TextEditingController> txtControllers = Map();

  File img;

  // 正在保存
  bool issaving = false;

  int selectClass = -1;

  // 过滤后的检查项
  List<CheckItem> _filtercheckItem = List();

  bool isAnimating = false;

  String theme = "";

  ExtClass classifySelected;

  // 是否点击了提交
  bool commitClassify = false;

  String cancelItemKey="";

  ///////////////////////////////////////////////////////////////////////
  Map<String, ItemResultData> _itemResultDataMap = Map();
  Map<String, ItemResultData> _olDItemResultDataMapData = Map();

  @override
  void initState() {
    super.initState();
    // 根据点ID和计划ID获取配置初始化checkitems
    getInitConfig();
    initThemeConfig();
//    this.initConfig = this.widget.initConfig;
//    this.classifySelected = this.widget.extClass;
  }

  initThemeConfig() async {
    SharedPreferences.getInstance().then((preferences) {
      setState(() {
        this.theme =
            preferences.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  void getInitConfig() {
    // 调用接口获取配置
    setState(() {
      initConfig = this.widget.initConfig;
      classifySelected = this.widget.extClass;
      this.widget._itemResultDataMap.keys.forEach((key){
        if(key != null && key.isNotEmpty && this.widget._itemResultDataMap[key]!= null){
          ItemResultData data = new ItemResultData.fromParams(
              routePointItemId:this.widget._itemResultDataMap[key].routePointItemId,
              id:this.widget._itemResultDataMap[key].id,
              value:this.widget._itemResultDataMap[key].value,
              img:this.widget._itemResultDataMap[key].img,
              text:this.widget._itemResultDataMap[key].text,
              errorInfo:this.widget._itemResultDataMap[key].errorInfo,
              hasError:this.widget._itemResultDataMap[key].hasError,
              uniqueKey:this.widget._itemResultDataMap[key].uniqueKey,

          );
          _olDItemResultDataMapData[key] = data;
        }
      });
    });
    for (var item in initConfig.checkItem) {
      if (classifySelected != null) {
        if (item.classifyIds == null &&
            classifySelected.id.toString() == "null") {
          _filtercheckItem.add(item);
        } else if (item.classifyIds == classifySelected.id.toString()) {
          _filtercheckItem.add(item);
          cancelItemKey = cancelItemKey + item.uniqueKey+"||";
        }
      } else {
        _filtercheckItem.add(item);
      }

      // TextField 绑定初始化controller
      if (item.itemType == "文本" || item.itemType == "数字") {
        txtControllers[item.uniqueKey.toString()] = TextEditingController();
      }

      if (this.widget._itemResultDataMap.length > 0) {
        this.widget._itemResultDataMap.forEach((k, v) {
          if (k == item.uniqueKey) {
            this._itemResultDataMap[k] = v;

            if(v != null){
              if (item.itemType == "文本" || item.itemType == "数字") {
                txtControllers[k].text = v.value;
              }
            }
          }
        });
      }
    }

//    if(this.widget._itemResultDataMap.length > 0){
//      setState(() {
//        this.commitClassify = true;
//      });
//    }else{
//      setState(() {
//        this.commitClassify = false;
//      });
//    }
    this.widget.initConfig.checkItem.forEach((f){
      ItemResultData  result=ItemResultData.fromParams();
      ///添加&&this.widget.extClass.hasDone   在数据回显时   如果第一次有默认值  按钮显示为保存 不是取消  加上判断

      if(f.classifyIds == classifySelected.id.toString() &&this.widget.extClass.hasDone){
        if(_itemResultDataMap[f.uniqueKey] != null && _itemResultDataMap[f.uniqueKey].uniqueKey != null){
          setState(() {
            result.routePointItemId=f.routePointItemId;
//            _itemResultDataMap[f.uniqueKey]=result;
             this.commitClassify = true;  //数据回显   有数据显示取消  没有数据显示保存
          });
        }else{
          setState(() {

            result.routePointItemId=f.routePointItemId;
//            _itemResultDataMap[f.uniqueKey]=result;

          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.theme.isEmpty) {
      return Scaffold(
          body: Text("")
      );
    }
    if (null == initConfig) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              "巡检点名称", style: TextStyle(color: Colors.black, fontSize: 19),),
            centerTitle: true,
            elevation: 0.2,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            leading: new Container(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                    Icons.keyboard_arrow_left, color: GetConfig.getColor(theme),
                    size: 32),
              ),
            ),
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: this.widget.planId == null ? Text(
          null != initConfig.point ? initConfig.point.name ?? "" : "",
          style: TextStyle(color: Colors.black, fontSize: 19),) :
        Text(null != initConfig.planTask
            ? initConfig.planTask.pointName ?? ""
            : "",
          style: TextStyle(color: Colors.black, fontSize: 19),),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
//            onTap: () => Navigator.pop(context),
            onTap: (){
              setState(() {
                this._itemResultDataMap = _olDItemResultDataMapData;
              });
              Navigator.pop(context,"back||"+this.widget.extClass.toString());
            },
            child: Icon(
                Icons.keyboard_arrow_left, color: GetConfig.getColor(theme),
                size: 32),
          ),
        ),
//        actions: <Widget>[
//          //IconButton(icon: Icon(Icons.search,color: Colors.red,),onPressed: (){},),
//          IconButton(icon: Image(
//            image: AssetImage("assets/images/icons/save_" + theme + ".png"),
//            width: 22,),
//            onPressed: () {
//              // 还未保存
//              if (!issaving) {
//                saveData();
//              }
//            }
//            ,)
//        ],
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
                              child: Text("点编号", style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),),
                            ),
                            this.widget.planId == null ?
                            Text(null != initConfig.point ? initConfig.point
                                .pointNo ?? "" : "",
                              style: TextStyle(color: Colors.grey),) :
                            Text(
                              null != initConfig.planTask ? initConfig.planTask
                                  .pointNo ?? "" : "",
                              style: TextStyle(color: Colors.grey),)
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10, top: 10),
                              width: 130,
                              height: 40,
                              child: Text("巡检计划", style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),),
                            ),
                            Text(((null == initConfig.planTask)
                                ? "计划外"
                                : initConfig.planTask.planName),
                              style: TextStyle(fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.red,),),
                          ],
                        ),
                      ],
                    )
                ),

                Container(
                  height: 10.0,
                  color: Color.fromRGBO(242, 246, 249, 1),
                ),

                initConfig.extClass != null && initConfig.extClass.length > 0 ?
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        width: 130,
                        height: 40,
                        child: Text("检查项目", style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),),
                      ),

                      Container(
                        width: 180.0,
                        height: 40.0,
                        child: Text(
                          classifySelected == null ? "" : classifySelected.name,
                          style: TextStyle(color: Colors.black),),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                ) : Container(),
                initConfig.extClass != null && initConfig.extClass.length > 0 ?
                Container(
                  height: 10.0,
                  color: Color.fromRGBO(242, 246, 249, 1),
                ) : Container(),

                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 10, top: 10),
                  width: double.infinity,
                  height: 40,
                  child: Text("检查内容", style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18),),
                ),
                Divider(height: 1,),
                Container(
                  color: Colors.white,
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
                      }).toList()
                  ),
//                  height: (_checkItem.length) * 110.0 +  (itemCount + radioCount) * 70.0,
                ),




                commitClassify ?
                Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 5, bottom: 5),
                  color: GetConfig.getColor(theme),
                  width: double.infinity,
                  child: new MaterialButton(
                    onPressed: () {
                      setState(() {
                        commitClassify = false;
                        this.widget.extClass.hasDone=false;
                      });
                      Navigator.pop(context,"cancel"+"||"+cancelItemKey);
                    },
                    child: new Text(
                      "取消",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ) :
                Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 5, bottom: 5),
                  color: GetConfig.getColor(theme),
                  width: double.infinity,
                  child: new MaterialButton(
                    onPressed: () {
                      setState(() {
                        commitClassify = true;
                      });
                      saveData();
                    },
                    child: new Text(
                      "保存",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomPadding: true,
    );
  }

  //////////////////////////////////////////////////////////////////////////////////////
  // 开始加载价检查项
  Widget getTextFiled(CheckItem _checkItem) {
    return Container(
//      padding: EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
//            height: 40,
            child:     GestureDetector(
              child: Row(
                children: <Widget>[
                  _checkItem.isMust == "是" ? Text(
                    "*", style: TextStyle(color: Colors.red),) : Text(""),
                  Container(
                    child: Text(_checkItem.name),
                    width: 280,
                  ),
                  Container(
                    width: 40,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.topRight,
                    child: Row(
                      children: <Widget>[
                        //Icon(Icons.message,color: Colors.grey,size: 14,),
                        Image.asset(
                          "assets/images/icons/message.png", height: 14,),
                        Icon(Icons.keyboard_arrow_right,
                          color: GetConfig.getColor(theme), size: 14,)
                      ],
                    ),
                  ),
                ],
              ),

              onTap: () {
                if (_itemResultDataMap[_checkItem.uniqueKey] == null) {
                  _itemResultDataMap[_checkItem.uniqueKey] =
                      ItemResultData.fromParams(
                          uniqueKey: _checkItem.uniqueKey, value: "");
                }
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) {
                  return TextView(
                      text: _itemResultDataMap[_checkItem.uniqueKey].text ==
                          null ? "" : _itemResultDataMap[_checkItem
                          .uniqueKey].text);
                })).then((v) {
                  if (v != "back") {
                    setState(() {
                      _itemResultDataMap[_checkItem.uniqueKey].text = v;
                    });
                  }
                });
              },
            ),


            padding: EdgeInsets.only(left: 10, top: 3),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 10, left: 10),
            width: 280,
            child: TextField(
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp(
                    "[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]")), //只能输入汉字或者字母或数字
              ],
              controller: txtControllers[_checkItem.uniqueKey.toString()],
              onChanged: (value) {
                setState(() {
                  if (_itemResultDataMap[_checkItem.uniqueKey] == null) {
                    _itemResultDataMap[_checkItem.uniqueKey] =
                        ItemResultData.fromParams(
                            uniqueKey: _checkItem.uniqueKey, value: "");
                  }
                  _itemResultDataMap[_checkItem.uniqueKey].value = value;

                  commitClassify=false;//  数据回显后  按钮显示取消  内容改变 变成保存
                });
              },
              onEditingComplete: () {
                txtControllers[_checkItem.uniqueKey.toString()].text =
                    _itemResultDataMap[_checkItem.uniqueKey].value;
              },
            ),
          ),
          Divider(height: 1,),
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
                                "*", style: TextStyle(color: Colors.red),)
                                  : Text(""),
                              Container(
                                child: Text(f.name),
                                width: 280,
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                width: 40,
                                child: Image.asset(
                                  "assets/images/icons/camera_" + theme +
                                      ".png", height: 14,),
                                //Icon(Icons.camera_alt,color: GetConfig.getColor(theme),),
                                alignment: Alignment.centerRight,
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                width: 10,
                                child: Icon(Icons.keyboard_arrow_right,
                                  color: GetConfig.getColor(theme), size: 14,),
                                alignment: Alignment.centerRight,
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              ImagePicker.pickImage(source: ImageSource.camera)
                                  .then((c) {
                                setState(() {

                                  this.commitClassify = false;

                                  if (c != null) {
                                    if (_itemResultDataMap[_checkItem
                                        .uniqueKey] == null) {
                                      _itemResultDataMap[_checkItem.uniqueKey] =
                                          ItemResultData.fromParams(
                                              uniqueKey: _checkItem.uniqueKey,
                                              value: "");
                                    }
                                    Map<String, File> m = Map();
                                    m[f.name] = c;
                                    if (_itemResultDataMap[_checkItem.uniqueKey]
                                        .img == null) {
                                      _itemResultDataMap[_checkItem.uniqueKey]
                                          .img = Map();
                                    }
                                    //返回classifyIds   上传图片用
                                    _itemResultDataMap[_checkItem.uniqueKey].classifyIds=this.widget.extClass.id;
                                    _itemResultDataMap[_checkItem.uniqueKey].img
                                        .addAll(m);
//                                    itemCount = itemCount + 1;
                                  }
                                });
                              });
                            });
                          },
                        ),
                        padding: EdgeInsets.only(left: 10, top: 10),
                      ),
                      Divider(height: 1,),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: _itemResultDataMap[_checkItem.uniqueKey] ==
                                  null
                                  || _itemResultDataMap[_checkItem.uniqueKey]
                                      .img == null
                                  ||
                                  _itemResultDataMap[_checkItem.uniqueKey].img[f
                                      .name] == null ?
                              Container() : CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.black12,
                                child: Image.file(
                                  _itemResultDataMap[_checkItem.uniqueKey].img[f
                                      .name], height: 40,),
                              )
                          ),
                          onTap: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) {
                              return ImageView(Image.file(
                                _itemResultDataMap[_checkItem.uniqueKey].img[f
                                    .name], height: 40,));
                            }));
                          },
                        ),
                        padding: EdgeInsets.only(left: 10, top: 10),
                      ),
                    ],
                  );
                }).toList()
            ),
          ),
          Container(
            height: 10,
            color: Color.fromRGBO(242, 246, 249, 1),
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
//          height: 40,
          child: Row(
            children: <Widget>[
              _checkItem.isMust == "是" ? Text(
                "*", style: TextStyle(color: Colors.red),) : Text(""),
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
                      Image.asset(
                        "assets/images/icons/message.png", height: 14,),
                      Icon(Icons.keyboard_arrow_right,
                        color: GetConfig.getColor(theme), size: 14,)
                    ],
                  ),
                ),
                onTap: () {
                  if (_itemResultDataMap[_checkItem.uniqueKey] == null) {
                    _itemResultDataMap[_checkItem.uniqueKey] =
                        ItemResultData.fromParams(
                            uniqueKey: _checkItem.uniqueKey, value: "");
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
            keyboardType:TextInputType.number ,
            controller: txtControllers[_checkItem.uniqueKey.toString()],
            onChanged: (value) {
              setState(() {
                if (_itemResultDataMap[_checkItem.uniqueKey] == null) {
                  _itemResultDataMap[_checkItem.uniqueKey] =
                      ItemResultData.fromParams(
                          uniqueKey: _checkItem.uniqueKey, value: "");
                }
                _itemResultDataMap[_checkItem.uniqueKey].value = value;
                commitClassify=false;//  数据回显后  按钮显示取消  内容改变 变成保存
              });
            },
            onEditingComplete: () {
              setState(() {
                txtControllers[_checkItem.uniqueKey.toString()].text =
                    _itemResultDataMap[_checkItem.uniqueKey].value;
              });
            },
          ),
        ),
        Divider(height: 1,),
        Container(
          child: Column(
              children: _checkItem.pictureInfo.map((f) {
                return Column(
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        child: Row(
                          children: <Widget>[
                            f.isMust == "是" ? Text(
                              "*", style: TextStyle(color: Colors.red),) : Text(
                                ""),
                            Container(
                              child: Text(f.name),
                              width: 280,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              width: 40,
                              child: Image.asset(
                                "assets/images/icons/camera_" + theme + ".png",
                                height: 14,),
                              //Icon(Icons.camera_alt,color: GetConfig.getColor(theme),),
                              alignment: Alignment.centerRight,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              width: 10,
                              child: Icon(Icons.keyboard_arrow_right,
                                color: GetConfig.getColor(theme), size: 14,),
                              alignment: Alignment.centerRight,
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            ImagePicker.pickImage(source: ImageSource.camera)
                                .then((c) {
                              setState(() {

                                this.commitClassify = false;

                                if (c != null) {
                                  if (_itemResultDataMap[_checkItem
                                      .uniqueKey] == null) {
                                    _itemResultDataMap[_checkItem.uniqueKey] =
                                        ItemResultData.fromParams(
                                            uniqueKey: _checkItem.uniqueKey,
                                            value: "");
                                  }
                                  Map<String, File> m = Map();
                                  m[f.name] = c;
                                  if (_itemResultDataMap[_checkItem.uniqueKey]
                                      .img == null) {
                                    _itemResultDataMap[_checkItem.uniqueKey]
                                        .img = Map();
                                  }
                                  //返回classifyIds   上传图片用
                                  _itemResultDataMap[_checkItem.uniqueKey].classifyIds=this.widget.extClass.id;
                                  _itemResultDataMap[_checkItem.uniqueKey].img
                                      .addAll(m);
//                                  itemCount = itemCount + 1;
                                }
                              });
                            });
                          });
                        },
                      ),
                      padding: EdgeInsets.only(left: 10, top: 10),
                    ),
                    Divider(height: 1,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: _itemResultDataMap[_checkItem.uniqueKey] ==
                                null
                                ||
                                _itemResultDataMap[_checkItem.uniqueKey].img ==
                                    null
                                ||
                                _itemResultDataMap[_checkItem.uniqueKey].img[f
                                    .name] == null ?
                            Container() : CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.black12,
                              child: Image.file(
                                _itemResultDataMap[_checkItem.uniqueKey].img[f
                                    .name], height: 40,),
                            )
//                          Image.file(_itemResultDataMap[_checkItem.id].img[f.name],
//                            height: 50,width: double.infinity,fit: BoxFit.fill,),
                        ),
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) {
                            return ImageView(Image.file(
                              _itemResultDataMap[_checkItem.uniqueKey].img[f
                                  .name], height: 40,));
                          }));
                        },
                      ),
                      padding: EdgeInsets.only(left: 10, top: 10),
                    ),
                  ],
                );
              }).toList()
          ),
        ),
        Container(
          height: 10,
          color: Color.fromRGBO(242, 246, 249, 1),
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
//          height: 40,
          child: Row(
            children: <Widget>[
              _checkItem.isMust == "是" ? Text(
                "*", style: TextStyle(color: Colors.red),) : Text(""),
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
                      Image.asset(
                        "assets/images/icons/message.png", height: 14,),
                      Icon(Icons.keyboard_arrow_right,
                        color: GetConfig.getColor(theme), size: 14,)
                    ],
                  ),
                ),
                onTap: () {
                  if (_itemResultDataMap[_checkItem.uniqueKey] == null) {
                    _itemResultDataMap[_checkItem.uniqueKey] =
                        ItemResultData.fromParams(
                            uniqueKey: _checkItem.uniqueKey, value: "");
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TextView(
                        text: _itemResultDataMap[_checkItem.uniqueKey] == null
                            ? ""
                            : _itemResultDataMap[_checkItem.uniqueKey].text);
                  })).then((v) {
                    if (v != null && v != "back") {
//                      print(v);
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
                        groupValue:( _itemResultDataMap[_checkItem.uniqueKey] ==
                            null
                            || _itemResultDataMap[_checkItem.uniqueKey].value ==
                                null) ? "" : _itemResultDataMap[_checkItem
                            .uniqueKey].value,
                        onChanged: (String val) {
                          setState(() {
                            commitClassify = false;

                            if (_itemResultDataMap[_checkItem.uniqueKey] ==
                                null) {
                              _itemResultDataMap[_checkItem.uniqueKey] =
                                  ItemResultData.fromParams(
                                      uniqueKey: _checkItem.uniqueKey,
                                      value: "",
                                      routePointItemId: _checkItem.routePointItemId);
                            }
                            _itemResultDataMap[_checkItem.uniqueKey].value =
                                val;

                          });
                        }),
                    Text( f.name ?? ""),
                  ],
                );
              }).toList()
          ),
        ),
        Divider(height: 1,),
        Container(
          child: Column(
              children: _checkItem.pictureInfo.map((f) {
                return Column(
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        child: Row(
                          children: <Widget>[
                            f.isMust == "是" ? Text(
                              "*", style: TextStyle(color: Colors.red),) : Text(
                                ""),
                            Container(
                              child: Text(f.name),
                              width: 280,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              width: 40,
                              child: Image.asset(
                                "assets/images/icons/camera_" + theme + ".png",
                                height: 14,),
                              //Icon(Icons.camera_alt,color: GetConfig.getColor(theme),),
                              alignment: Alignment.centerRight,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              width: 10,
                              child: Icon(Icons.keyboard_arrow_right,
                                color: GetConfig.getColor(theme), size: 14,),
                              alignment: Alignment.centerRight,
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            ImagePicker.pickImage(source: ImageSource.camera)
                                .then((c) {
                              setState(() {

                                this.commitClassify = false;

                                if (c != null) {
                                  if (_itemResultDataMap[_checkItem
                                      .uniqueKey] == null) {
                                    _itemResultDataMap[_checkItem.uniqueKey] =
                                        ItemResultData.fromParams(
                                            uniqueKey: _checkItem.uniqueKey,
                                            value: "",
                                            routePointItemId: _checkItem.routePointItemId);
                                  }
                                  Map<String, File> m = Map();
                                  m[f.name] = c;
                                  if (_itemResultDataMap[_checkItem.uniqueKey]
                                      .img == null) {
                                    _itemResultDataMap[_checkItem.uniqueKey]
                                        .img = Map();
                                  }
                                  _itemResultDataMap[_checkItem.uniqueKey].classifyIds=this.widget.extClass.id;

                                  _itemResultDataMap[_checkItem.uniqueKey].img
                                      .addAll(m);
//                                  itemCount = itemCount + 1;
                                }
                              });
                            });
                          });
                        },
                      ),
                      padding: EdgeInsets.only(left: 10, top: 10),
                    ),
                    Divider(height: 1,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        child: Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 5),
                            child: _itemResultDataMap[_checkItem.uniqueKey] ==
                                null
                                ||
                                _itemResultDataMap[_checkItem.uniqueKey].img ==
                                    null
                                ||
                                _itemResultDataMap[_checkItem.uniqueKey].img[f
                                    .name] == null ?
                            Container() : CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.black12,
                              child: Image.file(
                                _itemResultDataMap[_checkItem.uniqueKey].img[f
                                    .name], height: 40,),
                            )

//                          Image.file(_itemResultDataMap[_checkItem.id].img[f.name],
//                            height: 50,width: double.infinity,fit: BoxFit.fill,),
                        ),
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) {
                            return ImageView(Image.file(
                                _itemResultDataMap[_checkItem.uniqueKey].img[f
                                    .name]));
                          }));
                        },
                      ),
                      padding: EdgeInsets.only(left: 10, top: 10),
                    ),
                  ],
                );
              }).toList()
          ),
        ),
        Container(
          height: 10,
          color: Color.fromRGBO(242, 246, 249, 1),
        ),
      ],
    );
  }

  saveData() {

    // 检查所有必填项是否已填
    for(var item in _filtercheckItem){
      if(item.isMust == "是"){

        if(_itemResultDataMap[item.uniqueKey] ==null){
          MessageBox.showMessageOnly("有未提交的数据项！",this.context);
          setState(() {
            commitClassify = false;
          });
          return;
        }
        if(_itemResultDataMap[item.uniqueKey] !=null &&
            (_itemResultDataMap[item.uniqueKey].value == null || _itemResultDataMap[item.uniqueKey].value.isEmpty)
            && (_itemResultDataMap[item.uniqueKey].text == null || _itemResultDataMap[item.uniqueKey].text.isEmpty)){
          setState(() {
            commitClassify = false;
          });
          MessageBox.showMessageOnly("有未提交的数据项！",this.context);
          return;
        }
      }
    }

    if (!this.commitClassify) {
      this.widget.initConfig.checkItem.forEach((f){
        if(f.classifyIds == classifySelected.id.toString()){
          _itemResultDataMap[f.uniqueKey] = ItemResultData.fromParams();
        }
      });
   this.widget.extClass.hasDone=false;
      Navigator.pop(context, _itemResultDataMap);
      return;
    }


    // 添加uniqueKey
    _itemResultDataMap.forEach((k,v){
      if(_itemResultDataMap[k]!=null)
         _itemResultDataMap[k].uniqueKey = k;
    });

    String error = checkData();
    if (error.isNotEmpty) {
      setState(() {
        issaving = false;
        commitClassify=false;
      });
      MessageBox.showMessageOnly(error, context);

      _itemResultDataMap.forEach((k, v) {
        v.hasError = false;
        v.errorInfo = "";
      });

      return;
    } else {
      this.widget.extClass.hasDone=true;
      Navigator.pop(context, _itemResultDataMap);
    }
  }

  checkData() {
    List<CheckItem> needCheckItems = List();
    Map<String, ItemResultData> _needCheckItemResultDataMap = Map();
    if (this.widget.extClass.id == null) {
      needCheckItems.addAll(
          this.widget.initConfig.checkItem.where((f) => f.classifyIds == null)
              .toList());
    } else {
      needCheckItems.addAll(
          this.widget.initConfig.checkItem.where((f) => f.classifyIds ==
              classifySelected.id.toString()).toList());
    }
    needCheckItems.forEach((f) {
      if (f.itemType == "文本") {
        textCheck(f.uniqueKey, f);
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
////          if (_itemResultDataMap[f.uniqueKey].img != null) {
////            if (_itemResultDataMap[f.uniqueKey].img[p.name] == null) {
////              // 必须项未拍照
////              _itemResultDataMap[f.uniqueKey].hasError = true;
////              if ((_itemResultDataMap[f.uniqueKey].errorInfo ?? "") != "") {
////                _itemResultDataMap[f.uniqueKey].errorInfo +=
////                    "\r\n" + p.name + "未上传照片";
////              } else {
////                _itemResultDataMap[f.uniqueKey].errorInfo = p.name + "未上传照片";
////              }
////            }
////          } else {
////            // 必须项未拍照
////            _itemResultDataMap[f.uniqueKey].hasError = true;
////            if ((_itemResultDataMap[f.uniqueKey].errorInfo ?? "") != "") {
////              _itemResultDataMap[f.uniqueKey].errorInfo +=
////                  "\r\n" + p.name + "未上传照片";
////            } else {
////              _itemResultDataMap[f.uniqueKey].errorInfo = p.name + "未上传照片";
////            }
////          }
//        } else {
//          // 无需检查
//        }
//      });

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

//    RegExp emoji = new RegExp(r"[\\ud83c\\udc00-\\ud83c\\udfff]|[\\ud83d\\udc00-\\ud83d\\udfff]|[\\u2600-\\u27ff]|[\\ud83e\\udd00-\\ud83e\\uddff]|[\\u2300-\\u23ff]|[\\u2500-\\u25ff]|[\\u2100-\\u21ff]|[\\u0000-\\u00ff]|[\\u2b00-\\u2bff]|[\\u2d06]|[\\u3030]");
//    if (emoji.hasMatch(_itemResultDataMap[key].value)) {
//      _itemResultDataMap[key].hasError = true;
//      _itemResultDataMap[key].errorInfo = "表情符号不允许输入！";
//    }
  }

  numberCheck(String key, CheckItem checkItem) {

//    if (_itemResultDataMap[key] == null) {
//      _itemResultDataMap[key] = ItemResultData.fromParams(
//          routePointItemId: checkItem.routePointItemId, value: "");
//    }

    num value = num.tryParse(
      _itemResultDataMap[key] == null || _itemResultDataMap[key].value == null
          ? ""
          : _itemResultDataMap[key].value,);
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
        NumberCheckInfo checkInfo = NumberCheckInfo.fromJson(
            json.decode(checkItem.dataJson));
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
        }else{

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
        _itemResultDataMap[key] = ItemResultData.fromParams(
            routePointItemId: checkItem.routePointItemId, value: "");
      }
      if (_itemResultDataMap[key].value==null) {
        setState(() {
          _itemResultDataMap[key].hasError = true;
          _itemResultDataMap[key].errorInfo = "请完成${checkItem.name ?? "--"}的选择!";
        });
      } else {
        setState(() {

          _itemResultDataMap[key].hasError = false;
          _itemResultDataMap[key].errorInfo = "";
        });
      }
    }
  }
}

class RadioWidgetInfo{
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

class NumberCheckInfo{
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
    OkScore = jsonRes['OkScore']==""?0:jsonRes['OkScore'];
    NoScore = jsonRes['NoScore']==""?0:jsonRes['NoScore'];
    ValidUp = jsonRes['ValidUp']==""?0:jsonRes['ValidUp'];
    ValidDown = jsonRes['ValidDown']==""?0:jsonRes['ValidDown'];
    OkUp = jsonRes['OkUp']==""?0:jsonRes['OkUp'];
    OkDown = jsonRes['OkDown']==""?0: jsonRes['OkDown'];
    CheckValidUp = jsonRes['CheckValidUp'];
    CheckValidDown = jsonRes['CheckValidDown'];
    CheckOkUp = jsonRes['CheckOkUp'];
    CheckOkDown = jsonRes['CheckOkDown'];
    Precision = jsonRes['Precision']==""?0:jsonRes['Precision'];
  }
}
