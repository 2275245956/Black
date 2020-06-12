import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckItem.dart';
import 'package:intelligent_check_new/model/CheckRecordDto.dart';
import 'package:intelligent_check_new/model/ExtClass.dart';
import 'package:intelligent_check_new/model/MovePointAttachment.dart';
import 'package:intelligent_check_new/model/PlanTaskInitConfig.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageList.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageView.dart';
import 'package:intelligent_check_new/pages/CheckExecute/TextView.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_inspection_list.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_Inspection_danger_add.dart';
import 'package:intelligent_check_new/services/CheckRecordServices.dart';
import 'package:intelligent_check_new/services/PlanTaskInitConfigServices.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/tools/MessageBox.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CheckExecInspection extends StatefulWidget{
  // 计划ID
  int planId;
  // 巡检点ID
  int pointId;
  String checkMode;
  CheckExecInspection(this.pointId,[this.planId,this.checkMode]);
  @override
  State<StatefulWidget> createState() => _CheckExecInspection();
}

class _CheckExecInspection extends State<CheckExecInspection> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  // 页面配置信息
  PlanTaskInitConfig initConfig;

  // 当前点的附件
  List<File> imageList;
  // 点备注
  final TextEditingController _remarkController = new TextEditingController();

//  List<TextEditingController> txtControllers = List();
  Map<String,TextEditingController> txtControllers = Map();
//  int itemCount=0;// image count
//  int radioCount=0;// radio count;

  File img;

  // 正在保存
  bool issaving = false;

  int selectClass = -1;

  // 过滤后的检查项
  List<CheckItem> _filtercheckItem = List();

  bool isAnimating = false;

  String theme="";

//  List<DropdownMenuItem> items = new List();
  ExtClass classifySelected;

  // 确定要提交的分类
  Map<String,bool> commitClassifies = Map();

  // 问题列表
  Map<num,bool> unCheckInputMap = Map();

  @override
  void initState() {
    super.initState();
    // 根据点ID和计划ID获取配置初始化checkitems
    getInitConfig();
    initThemeConfig();
  }

  initThemeConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  void getInitConfig() async {
    // 调用接口获取配置
    await getInitPlanTaskConfig(this.widget.planId, this.widget.pointId).then((data){
//      data = null;
      if(null == data){
        MessageBox.showMessageAndExitCurrentPage("数据加载失败！", true, context);
        return;
      }

      if(data.errorMsg != null && data.errorMsg.isNotEmpty){
        MessageBox.showMessageAndExitCurrentPage(data.errorMsg, true, context);
        return;
      }


      setState(() {
        initConfig = data;
        if(data.extClass.length>0){
          classifySelected = data.extClass[0];
          data.extClass.forEach((f){
            // 初始化
            commitClassifies[f.id.toString()] = false;
          });
        }
      });
      for(var item in initConfig.checkItem){
        List<ItemPictureInfo> pics = List();
        for(var pic in json.decode(item.pictureJson)){
          ItemPictureInfo p =  ItemPictureInfo.fromJson(pic);
//          p.isMust = "是";
          pics.add(p);
//          setState(() {
//            itemCount ++;
//          });
        }
        item.pictureInfo = pics;
        item.uniqueKey = new Uuid().v4();
        _checkItem.add(item);
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
        if(item.itemType == "文本"||item.itemType=="数字"){
          txtControllers[item.uniqueKey.toString()]  = TextEditingController();
        }

        if(item.itemType == "选择"){
          List<RadioWidgetInfo> rds = List();
          for(var rd in jsonDecode(item.dataJson)){
            rds.add(RadioWidgetInfo.fromJson(rd));
          }
          rds.forEach((rd){
            if(rd.isChecked == "是"){
              ItemResultData itemResultData = ItemResultData.fromParams();
              itemResultData.uniqueKey = item.uniqueKey;
              itemResultData.value = rd.name;
              _itemResultDataMap[item.uniqueKey] = itemResultData;
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(this.theme.isEmpty){
      return Scaffold(
          body:Text("")
      );
    }
    if(null == initConfig){
      return Scaffold(
          appBar: AppBar(
            title: Text("巡检点名称",style: TextStyle(color: Colors.black,fontSize: 19),),
            centerTitle: true,
            elevation: 0.2,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            leading:new Container(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child:Icon(Icons.keyboard_arrow_left, color:GetConfig.getColor(theme), size: 32),
              ),
            ),
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: this.widget.planId == null?Text(null != initConfig.point ? initConfig.point.name??"" : "",
          style: TextStyle(color: Colors.black,fontSize: 19),):
        Text(null != initConfig.planTask? initConfig.planTask.pointName??"" : "",
          style: TextStyle(color: Colors.black,fontSize: 19),),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading:new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
          ),
        ),
        actions: <Widget>[
          //IconButton(icon: Icon(Icons.search,color: Colors.red,),onPressed: (){},),
          IconButton(icon: Image(image: AssetImage("assets/images/icons/save_"+theme+".png"),width: 22,),
            onPressed: (){
              // 还未保存
              if(!issaving){

                saveData();
//                initConfig.extClass!=null && initConfig.extClass.length>0?
//                saveSelectClassifyDialog():saveData();
              }
            }
            ,)
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
        child: SingleChildScrollView(
          child: Container(
            color:Colors.white,
            child:  new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding :EdgeInsets.only(left:10, top:10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10,top:10),
                              width: 130,
                              height: 40,
                              child: Text("点编号",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                            ),
                            this.widget.planId == null?
                            Text(null != initConfig.point ? initConfig.point.pointNo??"" : "",style: TextStyle(color: Colors.grey),):
                            Text(null != initConfig.planTask ? initConfig.planTask.pointNo??"" : "",style: TextStyle(color: Colors.grey),)
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10,top:10),
                              width: 130,
                              height: 40,
                              child: Text("巡检计划",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                            ),Text(((null == initConfig.planTask) ? "计划外" : initConfig.planTask.planName),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16, color: Colors.red,),),
                          ],
                        ),
                      ],
                    )
                ),

                Container(
                  height:10.0,
                  color:Color.fromRGBO(242, 246, 249, 1),
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
                initConfig.extClass!=null && initConfig.extClass.length>0?
                Container(
                  height:10.0,
                  color:Color.fromRGBO(242, 246, 249, 1),
                ):Container(),

                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 10,top:10),
                  width: double.infinity,
                  height: 40,
                  child: Text("检查项目",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                ),
                Divider(height: 1,),
                Container(
                  color: Colors.white,
                  child:Column(
                      children: _filtercheckItem.map((f){
                        if(f.itemType== "文本"){
                          return Container(
//                            height: 100,
                            child: getTextFiled(f),
                          );
                        }else if(f.itemType== "数字"){
                          return Container(
//                            height: 100,
                            child:  getNumberFiled(f),
                          );
                        }else if(f.itemType== "选择"){
                          return Container(
//                            height: 100,
                            child:  getRadioBoxField(f),
                          );
                        }
                      }).toList()
                  ),
//                  height: (_checkItem.length) * 110.0 +  (itemCount + radioCount) * 70.0,
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                      padding :EdgeInsets.only(left: 10.0, bottom: 20.0,top:15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              child: Row(
                                children: <Widget>[
//                             Text("*",style: TextStyle(
//                                 color: Colors.red
//                             ),
//                             ),
                                  Text("现场照片",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                  Padding(padding: EdgeInsets.only(left: 220),),
                                  //new Icon(Icons.photo_camera,color: GetConfig.getColor(theme),size: 20,),
                                  Image.asset("assets/images/icons/camera_"+theme+".png",height: 20,),//
                                  new Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size: 20,),
                                ],
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder:(context){
                                  return ImageList(this.imageList);
                                })).then((v){
                                  if(v!=null){
                                    setState(() {
                                      imageList = v;
//                                 print(imageList);
                                    });
                                  }
                                });
                              },
                            )
                          ]
                      )
                  ),
                ),
                Container(
                  height:10.0,
                  color:Color.fromRGBO(242, 246, 249, 1),
                ),
                Container(
                  child: GestureDetector(
                    child: Padding(
                        padding :EdgeInsets.only(left: 10.0, bottom: 20.0,top:15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
//                              Text("*",style: TextStyle(
//                                  color: Colors.red
//                              ),
//                              ),
                                  Text("备注说明",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                  Padding(padding: EdgeInsets.only(left: 220),),
                                  Image.asset("assets/images/icons/message.png",height: 20,),
                                  new Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size: 20,),
                                ],
                              ),
                            ]
                        )
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context){
                        return TextView(text: this._remarkController.text.isEmpty?"":this._remarkController.text);
                      })).then((v){
                        if(v != "back"){
                          setState(() {
                            this._remarkController.text = v;
                          });
                        }
                      });
                    },
                  ),
                  color: Colors.white,
                ) ,
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
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
  //////////////////////////////////////////////////////////////////////////////////////
  // 开始加载价检查项
  List<CheckItem> _checkItem = List();
  Map<String,ItemResultData> _itemResultDataMap = Map();

  Widget getTextFiled(CheckItem _checkItem){
    return Container(
//      padding: EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
//            height: 40,
            child: Row(
              children: <Widget>[
                _checkItem.isMust=="是"?Text("*",style: TextStyle(color: Colors.red),):Text(""),
                Container(
                  child: Text(_checkItem.name),
                  width: 280,
                ),
                GestureDetector(
                  child: Container(
                    width: 40,
                    padding: EdgeInsets.only(left:10),
                    alignment: Alignment.topRight,
                    child: Row(
                      children: <Widget>[
                        //Icon(Icons.message,color: Colors.grey,size: 14,),
                        Image.asset("assets/images/icons/message.png",height: 14,),
                        Icon(Icons.keyboard_arrow_right,color:GetConfig.getColor(theme),size: 14,)
                      ],
                    ),
                  ),
                  onTap: (){
                    if(_itemResultDataMap[_checkItem.uniqueKey] == null){
                      _itemResultDataMap[_checkItem.uniqueKey] = ItemResultData.fromParams(uniqueKey: _checkItem.uniqueKey,value: "");
                    }
                    Navigator.push(context, MaterialPageRoute(builder:(context){
                      return TextView(text: _itemResultDataMap[_checkItem.uniqueKey].text==null?"":_itemResultDataMap[_checkItem.uniqueKey].text);
                    })).then((v){
                      if(v != "back"){
                        setState(() {
                          _itemResultDataMap[_checkItem.uniqueKey].text = v;
                        });
                      }
                    });
                  },
                ),
              ],
            ),
            padding: EdgeInsets.only(left:10,top: 3),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 10,left: 10),
            width: 280,
            child:TextField(
              controller: txtControllers[_checkItem.uniqueKey.toString()],
              onChanged: (value){
                setState(() {
                  if(_itemResultDataMap[_checkItem.uniqueKey] == null){
                    _itemResultDataMap[_checkItem.uniqueKey] = ItemResultData.fromParams(uniqueKey: _checkItem.uniqueKey,value: "");
                  }
                  _itemResultDataMap[_checkItem.uniqueKey].value = value;
                });
              },
              onEditingComplete: (){
                txtControllers[_checkItem.uniqueKey.toString()].text = _itemResultDataMap[_checkItem.uniqueKey].value;
              },
            ),
          ),
          Divider(height: 1,),
          Container(
            child: Column(
                children: _checkItem.pictureInfo.map((f){
                  return Column(
                    children: <Widget>[
                      Container(
                        child:GestureDetector(
                          child: Row(
                            children: <Widget>[
                              f.isMust=="是"?Text("*",style: TextStyle(color: Colors.red),):Text(""),
                              Container(
                                child: Text(f.name),
                                width: 280,
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                width: 40,
                                child:Image.asset("assets/images/icons/camera_"+theme+".png",height: 14,),//Icon(Icons.camera_alt,color: GetConfig.getColor(theme),),
                                alignment: Alignment.centerRight,
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                width: 10,
                                child:Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size: 14,),
                                alignment: Alignment.centerRight,
                              ),
                            ],
                          ),
                          onTap: (){
                            setState(() {
                              ImagePicker.pickImage(source: ImageSource.camera).then((c){
                                setState(() {
                                  if(c!=null){
                                    if(_itemResultDataMap[_checkItem.uniqueKey] == null){
                                      _itemResultDataMap[_checkItem.uniqueKey] = ItemResultData.fromParams(uniqueKey: _checkItem.uniqueKey,value: "");
                                    }
                                    Map<String,File> m = Map();
                                    m[f.name]=c;
                                    if(_itemResultDataMap[_checkItem.uniqueKey].img == null){
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
                        padding: EdgeInsets.only(left:10,top: 10),
                      ),
                      Divider(height: 1,),
                      Container(
                        alignment: Alignment.centerLeft,
                        child:GestureDetector(
                          child: Container(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: _itemResultDataMap[_checkItem.uniqueKey] ==null
                                  || _itemResultDataMap[_checkItem.uniqueKey].img==null
                                  || _itemResultDataMap[_checkItem.uniqueKey].img[f.name] == null?
                              Container():CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.black12,
                                child: Image.file(_itemResultDataMap[_checkItem.uniqueKey].img[f.name],height: 40,),
                              )
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder:(context){
                              return ImageView(Image.file(_itemResultDataMap[_checkItem.uniqueKey].img[f.name],height: 40,));
                            }));
                          },
                        ),
                        padding: EdgeInsets.only(left:10,top: 10),
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

  Widget getNumberFiled(CheckItem _checkItem){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
//          height: 40,
          child: Row(
            children: <Widget>[
              _checkItem.isMust=="是"?Text("*",style: TextStyle(color: Colors.red),):Text(""),
              Container(
                child: Text(_checkItem.name),
                width: 280,
              ),
              GestureDetector(
                child: Container(
                  width: 40,
                  padding: EdgeInsets.only(left:10),
                  alignment: Alignment.topRight,
                  child: Row(
                    children: <Widget>[
                      Image.asset("assets/images/icons/message.png",height: 14,),
                      Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size: 14,)
                    ],
                  ),
                ),
                onTap: (){
                  if(_itemResultDataMap[_checkItem.uniqueKey] == null){
                    _itemResultDataMap[_checkItem.uniqueKey] = ItemResultData.fromParams(uniqueKey: _checkItem.uniqueKey,value: "");
                  }
                  Navigator.push(context, MaterialPageRoute(builder:(context){
                    return TextView(text: _itemResultDataMap[_checkItem.uniqueKey]==null?"":_itemResultDataMap[_checkItem.uniqueKey].text);
                  })).then((v){
                    if(v != "back"){
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
          padding: EdgeInsets.only(left:10,top: 3),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 10,left: 10),
          alignment: Alignment.centerLeft,
          width: 280,
          child:TextField(
            controller: txtControllers[_checkItem.uniqueKey.toString()],
            onChanged: (value){
              setState(() {
                if(_itemResultDataMap[_checkItem.uniqueKey] == null){
                  _itemResultDataMap[_checkItem.uniqueKey] = ItemResultData.fromParams(uniqueKey: _checkItem.uniqueKey,value: "");
                }
                _itemResultDataMap[_checkItem.uniqueKey].value = value;
              });
            },
            onEditingComplete: (){
              setState(() {
                txtControllers[_checkItem.uniqueKey.toString()].text = _itemResultDataMap[_checkItem.uniqueKey].value;
              });
            },
          ),
        ),
        Divider(height: 1,),
        Container(
          child: Column(
              children: _checkItem.pictureInfo.map((f){
                return Column(
                  children: <Widget>[
                    Container(
                      child:GestureDetector(
                        child: Row(
                          children: <Widget>[
                            f.isMust=="是"?Text("*",style: TextStyle(color: Colors.red),):Text(""),
                            Container(
                              child: Text(f.name),
                              width: 280,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              width: 40,
                              child:Image.asset("assets/images/icons/camera_"+theme+".png",height: 14,),//Icon(Icons.camera_alt,color: GetConfig.getColor(theme),),
                              alignment: Alignment.centerRight,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              width: 10,
                              child:Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size: 14,),
                              alignment: Alignment.centerRight,
                            ),
                          ],
                        ),
                        onTap: (){
                          setState(() {
                            ImagePicker.pickImage(source: ImageSource.camera).then((c){
                              setState(() {
                                if(c!=null){
                                  if(_itemResultDataMap[_checkItem.uniqueKey] == null){
                                    _itemResultDataMap[_checkItem.uniqueKey] = ItemResultData.fromParams(uniqueKey: _checkItem.uniqueKey,value: "");
                                  }
                                  Map<String,File> m = Map();
                                  m[f.name]=c;
                                  if(_itemResultDataMap[_checkItem.uniqueKey].img == null){
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
                      padding: EdgeInsets.only(left:10,top: 10),
                    ),
                    Divider(height: 1,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child:GestureDetector(
                        child: Container(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: _itemResultDataMap[_checkItem.uniqueKey] ==null
                                || _itemResultDataMap[_checkItem.uniqueKey].img==null
                                || _itemResultDataMap[_checkItem.uniqueKey].img[f.name] == null?
                            Container():CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.black12,
                              child: Image.file(_itemResultDataMap[_checkItem.uniqueKey].img[f.name],height: 40,),
                            )
//                          Image.file(_itemResultDataMap[_checkItem.id].img[f.name],
//                            height: 50,width: double.infinity,fit: BoxFit.fill,),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder:(context){
                            return ImageView(Image.file(_itemResultDataMap[_checkItem.uniqueKey].img[f.name],height: 40,));
                          }));
                        },
                      ),
                      padding: EdgeInsets.only(left:10,top: 10),
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

  Widget getRadioBoxField(CheckItem _checkItem){
//    print(_checkItem);
    // 获取radio信息
    List<RadioWidgetInfo> rds = List();
    for(var rd in jsonDecode(_checkItem.dataJson)){
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
              _checkItem.isMust=="是"?Text("*",style: TextStyle(color: Colors.red),):Text(""),
              Container(
                width: 280,
                child: Text(_checkItem.name),
              ),
              GestureDetector(
                child: Container(
                  width: 40,
                  padding: EdgeInsets.only(left:10),
                  alignment: Alignment.topRight,
                  child: Row(
                    children: <Widget>[
                      Image.asset("assets/images/icons/message.png",height: 14,),
                      Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size: 14,)
                    ],
                  ),
                ),
                onTap: (){
                  if(_itemResultDataMap[_checkItem.uniqueKey] == null){
                    _itemResultDataMap[_checkItem.uniqueKey] = ItemResultData.fromParams(uniqueKey: _checkItem.uniqueKey,value: "");
                  }
                  Navigator.push(context, MaterialPageRoute(builder:(context){
                    return TextView(text: _itemResultDataMap[_checkItem.uniqueKey]==null?"":_itemResultDataMap[_checkItem.uniqueKey].text);
                  })).then((v){
                    if(v != null && v != "back"){
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
          padding: EdgeInsets.only(left:10,top: 10),
        ),
        Container(
//          width: 300,
//          height: 30,
          padding: EdgeInsets.only(left: 10),
          child: Column(
              children: rds.map((f){
                return Row(
                  children: <Widget>[
                    Radio(
                        value: f.name,
                        groupValue:  _itemResultDataMap[_checkItem.uniqueKey] == null
                            || _itemResultDataMap[_checkItem.uniqueKey].value==null?"":_itemResultDataMap[_checkItem.uniqueKey].value,
                        onChanged: (String val) {
                          setState(() {
                            if(_itemResultDataMap[_checkItem.uniqueKey] == null){
                              _itemResultDataMap[_checkItem.uniqueKey] = ItemResultData.fromParams(uniqueKey: _checkItem.uniqueKey,value: "");
                            }
                            _itemResultDataMap[_checkItem.uniqueKey].value = val;
                          });
                        }),
                    Text(f.name??""),
                  ],
                );
              }).toList()
          ),
        ),
        Divider(height: 1,),
        Container(
          child: Column(
              children: _checkItem.pictureInfo.map((f){
                return Column(
                  children: <Widget>[
                    Container(
                      child:GestureDetector(
                        child: Row(
                          children: <Widget>[
                            f.isMust=="是"?Text("*",style: TextStyle(color: Colors.red),):Text(""),
                            Container(
                              child: Text(f.name),
                              width: 280,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              width: 40,
                              child:Image.asset("assets/images/icons/camera_"+theme+".png",height: 14,),//Icon(Icons.camera_alt,color: GetConfig.getColor(theme),),
                              alignment: Alignment.centerRight,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              width: 10,
                              child:Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),size: 14,),
                              alignment: Alignment.centerRight,
                            ),
                          ],
                        ),
                        onTap: (){
                          setState(() {
                            ImagePicker.pickImage(source: ImageSource.camera).then((c){
                              setState(() {
                                if(c!=null){
                                  if(_itemResultDataMap[_checkItem.uniqueKey] == null){
                                    _itemResultDataMap[_checkItem.uniqueKey] = ItemResultData.fromParams(uniqueKey: _checkItem.uniqueKey,value: "");
                                  }
                                  Map<String,File> m = Map();
                                  m[f.name]=c;
                                  if(_itemResultDataMap[_checkItem.uniqueKey].img == null){
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
                      padding: EdgeInsets.only(left:10,top: 10),
                    ),
                    Divider(height: 1,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child:GestureDetector(
                        child: Container(
                            padding: EdgeInsets.only(left: 10,right: 10,bottom: 5),
                            child: _itemResultDataMap[_checkItem.uniqueKey] ==null
                                || _itemResultDataMap[_checkItem.uniqueKey].img==null
                                || _itemResultDataMap[_checkItem.uniqueKey].img[f.name] == null?
                            Container():CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.black12,
                              child: Image.file(_itemResultDataMap[_checkItem.uniqueKey].img[f.name],height: 40,),
                            )

//                          Image.file(_itemResultDataMap[_checkItem.id].img[f.name],
//                            height: 50,width: double.infinity,fit: BoxFit.fill,),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder:(context){
                            return ImageView(Image.file(_itemResultDataMap[_checkItem.uniqueKey].img[f.name]));
                          }));
                        },
                      ),
                      padding: EdgeInsets.only(left:10,top: 10),
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

  saveData(){

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
      //
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
      // 要上传的文件
      List<Attachment> fileData =  new List();
      if(null != this.imageList && this.imageList.length > 0){
        this.imageList.forEach((f){
          fileData.add(Attachment.fromParams(file: f));
        });
      }

      checkRecord.planTaskId = this.widget.planId;
      checkRecord.pointId = this.widget.pointId;
      checkRecord.remark = this._remarkController.text;
      checkRecord.checkMode = this.widget.checkMode??"OTHER";
      checkRecord.checkItems = new List();

      _itemResultDataMap.forEach((k,v){
        CheckItemDto item = CheckItemDto.fromJson({});
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
        item.inputValue = v.value.trim();
        // 备注
        item.remark = v.text;
        item.routePointItemId = v.routePointItemId;

        checkRecord.checkItems.add(item);
        // 组装图片信息
        if(null != v && null != v.img){
          v.img.forEach((key, val){
            Attachment attach =  new Attachment.fromParams(itemId: itemId,file: val, name: key);
            attach.classifyIds = v.classifyIds;
            fileData.add(attach);
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

      saveCheckRecordData(checkRecord, fileData);
//    }
    }
  }

//  void saveCheckRecordData(recordData, fileData) async{
//    // 保存数据
//    await saveCheckRecord(recordData).then((result){
//      setState(() {
//        isAnimating=false;
//      });
//      if(result.isOk()){
//        int checkRecordId = int.tryParse(result.dataList.toString());
//        // 如果返回的不是ID，那么认为是提示信息
//        if(null == checkRecordId){
//          MessageBox.showMessageOnly(result.dataList.toString(), context);
//          setState(() {
//            issaving = false;
//          });
//        }else{
//          // 上传图片
//          uploadAttachFile(fileData, checkRecordId, this.widget.pointId).then((result){
//            MessageBox.showMessageAndExitCurrentPage("保存成功！", true, context);
//          });
//        }
//      }else{
//        MessageBox.showMessageOnly(result.message??"数据保存失败！", context);
//          setState(() {
//            issaving = false;
//        });
//      }
//    });
//  }

  var unCheckInputList;
  void saveCheckRecordData(recordData, fileData) async{
    // 保存数据
    await saveCheckRecord(recordData).then((result){
      setState(() {
        isAnimating=false;
      });
      if(result.isOk()){

        int checkRecordId = int.tryParse(result.dataList["checkId"].toString());
        unCheckInputList = result.dataList["unCheckInputList"];
        // 如果返回的不是ID，那么认为是提示信息
//        int checkRecordId = int.tryParse(result.dataList.toString());
        // 如果返回的不是ID，那么认为是提示信息
        if(null == checkRecordId){
          MessageBox.showMessageOnly(result.dataList.toString(), context);
          setState(() {
            issaving = false;
          });
        }else{
          // 上传图片
//          uploadAttachFile(fileData, checkRecordId, this.widget.pointId).then((result){
//            MessageBox.showMessageAndExitCurrentPage("保存成功！", true, context);
//          });
          uploadAttachFile(fileData, checkRecordId, this.widget.pointId).then((result){
            //MessageBox.showMessageAndExitCurrentPage("保存成功！", true, context);
//            var unCheckInputList = result.dataList["unCheckInputList"];
            if(unCheckInputList != null){
              List<UNCheckInput> dataList = List();
              for(var unCheckInput in unCheckInputList){
                UNCheckInput _uNCheckInput = UNCheckInput.fromJson(unCheckInput);
                CheckItem checkItem = this._checkItem.firstWhere((f)=>f.id == _uNCheckInput.itemId);
                if(checkItem != null){
                  _uNCheckInput.routePointItemId = checkItem.routePointItemId;
                }

                dataList.add(_uNCheckInput);
//                unCheckInputMap[_uNCheckInput.itemId] = false;
              }
              if(dataList.length > 0){
                resultTaskDialog(dataList,checkRecordId);
              }else{
                MessageBox.showMessageAndExitCurrentPage("保存成功！", true, context);
              }
            }else{
              MessageBox.showMessageAndExitCurrentPage("保存成功！", true, context);
            }
          });

        }
//        }
      }else{
        MessageBox.showMessageOnly(result.message??"数据保存失败！", context);
        setState(() {
          issaving = false;
        });
      }
    });
  }

  checkData(ExtClass classifySelected){

    List<CheckItem> needCheckItems = List();
    Map<String,ItemResultData> _needCheckItemResultDataMap = Map();
//    List<String> classifyIds = List();
//    this.commitClassifies.forEach((k,v){
//      if(v==true){
//        classifyIds.add(k);
//      }
//    });

//    classifyIds.forEach((classifyId){
//      needCheckItems.addAll(_checkItem.where((f)=>f.classifyIds.toString() == classifyId).toList());
//    });
    if(classifySelected == null){
      needCheckItems = this._checkItem;
    }else{
      if(classifySelected.id == null){
        needCheckItems.addAll(_checkItem.where((f)=>f.classifyIds == null).toList());
      }else{
        needCheckItems.addAll(_checkItem.where((f)=>f.classifyIds == classifySelected.id.toString()).toList());
      }
    }
//    needCheckItems.addAll(_checkItem.where((f)=>f.classifyIds == classifySelected.id.toString()).toList());

//    if(this.initConfig.extClass == null || this.initConfig.extClass.length <= 0){
//      needCheckItems = this._checkItem;
//    }

    needCheckItems.forEach((f){
      if(f.itemType=="文本"){
//        textCheck(f.uniqueKey,f);
      }else if(f.itemType=="选择"){
        radioCheck(f.uniqueKey,f);
      }else if(f.itemType=="数字"){
        numberCheck(f.uniqueKey,f);
      }

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

  textCheck(String key,CheckItem checkItem){
    if(_itemResultDataMap[key] == null){
      _itemResultDataMap[key] = ItemResultData.fromParams(routePointItemId: checkItem.routePointItemId,value: "");
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

  numberCheck(String key,CheckItem checkItem){

    num value = num.tryParse(_itemResultDataMap[key]==null||_itemResultDataMap[key].value==null?"":_itemResultDataMap[key].value,);
//    print(value);
    if(checkItem.isMust == "是"){
      if(_itemResultDataMap[key] == null){
        _itemResultDataMap[key] = ItemResultData.fromParams(routePointItemId: checkItem.routePointItemId,value: "");
      }

      _itemResultDataMap[key].hasError = false;

//      print(_itemResultDataMap[key] == null ||  _itemResultDataMap[key].value.isEmpty);
      if(_itemResultDataMap[key] == null ||  _itemResultDataMap[key].value.isEmpty){
//        setState(() {
        _itemResultDataMap[key].hasError = true;
        _itemResultDataMap[key].errorInfo="请输入："+ checkItem.name;
//        });
      }else{
//        print("123");
        NumberCheckInfo checkInfo = NumberCheckInfo.fromJson(json.decode(checkItem.dataJson));
//        print(checkInfo.CheckValidDown);
        // -10 -- 50
        // 49
        if(checkInfo.CheckValidDown){
          //num value = num.tryParse(_itemResultDataMap[key].value,);
//          print("parse result====>$value");
          if(value == null){
            _itemResultDataMap[key].hasError = true;
            _itemResultDataMap[key].errorInfo=checkItem.name+":请输入数字";
          }else{
//            print(checkInfo.ValidDown);
//            print(value);
            if(value < checkInfo.ValidDown){
              _itemResultDataMap[key].hasError = true;
              _itemResultDataMap[key].errorInfo=checkItem.name+":最小值不能小于"+checkInfo.ValidDown.toString();
            }
          }
        }
        if(checkInfo.CheckValidUp){
          if(value == null){
            _itemResultDataMap[key].hasError = true;
            _itemResultDataMap[key].errorInfo=checkItem.name+":请输入数字";
          }else{
            if(value > checkInfo.ValidUp){
              _itemResultDataMap[key].hasError = true;
              _itemResultDataMap[key].errorInfo=checkItem.name+":最大值不能大于"+checkInfo.ValidUp.toString();
            }
          }
        }
      }
    }else{

      if(_itemResultDataMap[key].value.isNotEmpty){
        if(value == null){
//          setState(() {
          _itemResultDataMap[key].hasError = true;
          _itemResultDataMap[key].errorInfo=checkItem.name+":请输入数字";
//          });
          return;
        }
      }else{
//        setState(() {
        _itemResultDataMap[key].hasError = false;
        _itemResultDataMap[key].errorInfo="";
//        });
      }
    }
  }

  radioCheck(String key,CheckItem checkItem){
    if(checkItem.isMust == "是"){
      if(_itemResultDataMap[key] == null){
        _itemResultDataMap[key] = ItemResultData.fromParams(routePointItemId: checkItem.routePointItemId,value: "");
      }
      if(_itemResultDataMap[key].value.isEmpty){
        setState(() {
          _itemResultDataMap[key].hasError = true;
          _itemResultDataMap[key].errorInfo="请输入："+ checkItem.name;
        });
      }else{
        setState(() {
          _itemResultDataMap[key].hasError = false;
          _itemResultDataMap[key].errorInfo="";
        });
      }
    }
  }

  /////
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
                            if(v.classifyIds == null){
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

  // 任务创建
  resultTaskDialog(List<UNCheckInput> data,num checkId){
    showDialog<Null>(
      context: context,
      barrierDismissible:false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder:(context, state) {
              return SimpleDialog(
                children: <Widget>[
                  Container(
                    child: Text("有不合格项是否创建任务？"),
                    alignment: Alignment.center,
                  ),
                  Divider(height: 1,),
                  Column(
                    children: data.map((f){
                      return Column(
                        children: <Widget>[
                          new CheckboxListTile(
                            title: Text(f.name),
                            value: f.isSelected,
                            onChanged: (bool value) {
                              state(() {
                                f.isSelected = !f.isSelected;
                              });
//                            print(this.commitClassifies[f.id.toString()]);
                            },
                          ),
                          Divider(height: 1,)
                        ],
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          width: 100,
                          child: FlatButton(child: Text("创建任务",style: TextStyle(fontSize: 16),),onPressed: (){
                            // 导航至任务列表
//                            List<num> selectedId = List();
//                            unCheckInputMap.forEach((k,v){
//                              if(v){
//                                selectedId.add(k);
//                              }
//                            });
                            Navigator.push(context,
                                new MaterialPageRoute(
                                    builder: (context) => new InspectionHiddenDangerFound(false,checkId:checkId,unCheckInputData:data)
                                )).then((v){
                              Navigator.pop(context);
//                              Navigator.pop(context);
                            });
                          })
                      ),
                      Container(
                          width: 100,
                          child: FlatButton(child: Text("返回",style: TextStyle(fontSize: 16),),onPressed: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
//                        saveData();
                          })
                      )
                    ],
                  )
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
  num classifyIds;

  ItemResultData.fromParams({
    this.id,this.value,this.img,
    this.errorInfo,this.hasError,
    this.routePointItemId,
    this.uniqueKey,
    this.classifyIds
  });

  @override
  String toString() {
    return '{"id": $id,"value":$value,"text":$text,"errorInfo":$errorInfo,"hasError":$hasError,"img":$img}';
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
