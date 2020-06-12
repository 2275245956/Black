import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/plan_inspection/check_point_detail.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageListView.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageView.dart';
import 'package:intelligent_check_new/pages/CheckExecute/TextView.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_inspection.dart';
import 'package:intelligent_check_new/services/plan_inspection_services.dart';

class CheckExecItemContent extends StatefulWidget {
  int checkId;
  CheckExecItemContent(this.checkId);
  @override
  State<StatefulWidget> createState() => _CheckExecItemContent();
}

class _CheckExecItemContent extends State<CheckExecItemContent> {
  CheckPointDetail checkPointItemDetail;

  List<Image> imageList = List();
  @override
  void initState() {
    super.initState();
    // 根据点ID和计划ID获取配置初始化checkitems
    initPage();
  }

  void initPage() async {
    await queryCheckPointDetail(this.widget.checkId).then((result) {
      setState(() {
        checkPointItemDetail = result;

        checkPointItemDetail.pointImgUrls.forEach((url){
          if(null != url && url.isNotEmpty){
            this.imageList.add(Image.network(url.replaceAll("\\", "/")));
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (null == checkPointItemDetail ||
        null == checkPointItemDetail.checkInputs) {
      return Scaffold(
          appBar: AppBar(
        title: Text(
          "各检查项详情",
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
        title: Text(
          "各检查项详情",
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(top: 5),
            ),

            Container(
              child: Column(
                children: checkPointItemDetail.checkInputs.keys.map((f) {
                  checkPointItemDetail.checkInputs[f].map((item){
                    if (item.itemType == "文本" || item.itemType == "数字") {
                      return Column(
                        children: <Widget>[
                          Text(f),
                          getTextNumFiled(item),
                          Container(
                            height: 10.0,
                            color: Colors.grey[100],
                          ),
                        ],
                      );
                    } else if (item.itemType == "选择") {
                      return Column(
                        children: <Widget>[
                          Text(f),
                          getSelectFiled(item),
                          Container(
                            height: 10.0,
                            color: Colors.grey[100],
                          ),
                        ],
                      );
                    }
                  });
                }).toList(),
              ),
            ),

            GestureDetector(
              child:

              Padding(
                padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "*",
                          style: TextStyle(color: Colors.red),
                        ),
                        Text("现场照片"),
                        Padding(
                          padding: EdgeInsets.only(left: 240),
                        ),
                        new Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.red,
                          size: 20,
                        ),
                      ],
                    ),
                  ])),

              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:(context){
                  return ImageListView(this.imageList);
                }));
              },
            ),

            Container(
              height: 10.0,
              color: Colors.grey[100],
            ),

            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("备注"),
                  Container(
                    margin: EdgeInsets.only(right: 20, top: 20),
                    height: 80,
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(null == checkPointItemDetail.remark ? "" : checkPointItemDetail.remark),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 组装文本，数字检查项显示
  Widget getTextNumFiled(CheckInput _checkItem) {
    TextEditingController _remarkController = new TextEditingController();

    // 初始化拍照点下拉
    List<DropdownMenuItem> getListData() {
      List<DropdownMenuItem> items = new List();
      // 循环初始化扩展分类
      for (var p in _checkItem.pictureInfo) {
        DropdownMenuItem dropdownMenuItem1 = new DropdownMenuItem(
          child: Row(
            children: <Widget>[
              Text(
                null == p.isMust
                    ? ""
                    : ("是" == p.isMust ? "*" : ""),
                style: TextStyle(color: Colors.red),
              ),
              Text(p.name)
            ],
          ),
          value: p.name,
        );
        items.add(dropdownMenuItem1);
      }

      if(items.length == 0){
        DropdownMenuItem dropdownMenuItem1 = new DropdownMenuItem(
          child: Text("无拍照点"),
          value: "无拍照点",
        );
        items.add(dropdownMenuItem1);
      }
      return items;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      null == _checkItem.isMust
                          ? ""
                          : ("是" == _checkItem.isMust ? "*" : ""),
                      style: TextStyle(color: Colors.red),
                    ),
                    Container(
                      width: 300,
                      child: Text(null == _checkItem.inputName ? "" : _checkItem.inputName),
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
                        Navigator.push(this.context,
                            MaterialPageRoute(builder: (context) {
                          return TextView(
                            text: null == _checkItem.remark
                                ? ""
                                : _checkItem.remark,
                            readonly: true,
                          );
                        }));
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  height: 80,
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(null == _checkItem.inputValue
                        ? ""
                        : _checkItem.inputValue),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text("拍照点"),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                    ),
                    Container(
                      height: 40.0,
                      child: new DropdownButton(
                        items: getListData(),
                        hint: Padding(
                          padding: EdgeInsets.only(
                            right: 70.0,
                          ),
                          child: new Text(_checkItem.pictureInfo.length > 0 ? _checkItem.pictureInfo[0].name : "无拍照点"),
                        ),
                        //下拉菜单选择完之后显示给用户的值
                        value: _checkItem.selectPicName,
                        onChanged: (T) {
                          //下拉菜单item点击之后的回调
                          setState(() {
                            _checkItem.selectPicName = T;
                            // 筛选图片
                            _checkItem.selectPic = _checkItem.pointInputImgUrls.where((url) => url.indexOf(_checkItem.selectPicName) != -1).toList();
                          });
                        },
                        elevation: 24,
                        //设置阴影的高度
                        style: new TextStyle(
                            //设置文本框里面文字的样式
                            color: Colors.black),
                        isDense: false,
                        //减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
                        iconSize: 35.0, //设置三角标icon的大小
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 100,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          children: _checkItem.selectPic.length > 0 ? _checkItem.selectPic.map((p) {
                            return  GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Image.network(p.replaceAll("\\", "/"), width: 80.0, height: 80.0),
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder:(context){
                                  return ImageView(Image.network(p.replaceAll("\\", "/")));
                                }));
                              },
                            );
                          }).toList() : <Widget>[],
                        ),
                      ]),
                ),

              ],
            )),
      ],
    );
  }

// 组装选择检查项显示
  Widget getSelectFiled(CheckInput _checkItem) {
    TextEditingController _remarkController = new TextEditingController();
    // 获取radio信息
    List<RadioWidgetInfo> rds = List();
    for (var rd in jsonDecode(_checkItem.dataJson)) {
      rds.add(RadioWidgetInfo.fromJson(rd));
    }

    // 初始化拍照点下拉
    List<DropdownMenuItem> getListData() {
      List<DropdownMenuItem> items = new List();
      // 循环初始化扩展分类
      for (var p in _checkItem.pictureInfo) {
        DropdownMenuItem dropdownMenuItem1 = new DropdownMenuItem(
          child: Row(
            children: <Widget>[
              Text(
                null == p.isMust
                    ? ""
                    : ("是" == p.isMust ? "*" : ""),
                style: TextStyle(color: Colors.red),
              ),
              Text(p.name)
            ],
          ),
          value: p.name,
        );
        items.add(dropdownMenuItem1);
      }

      if(items.length == 0){
        DropdownMenuItem dropdownMenuItem1 = new DropdownMenuItem(
          child: Row(
            children: <Widget>[
              Text("无拍照点")
            ],
          ),
          value: "无拍照点",
        );
        items.add(dropdownMenuItem1);
      }
      return items;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("*", style: TextStyle(color: Colors.red), ),
                    Container(
                      width: 300,
                      child: Text(null == _checkItem.inputName ? "" : _checkItem.inputName),
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
                        Navigator.push(this.context,
                            MaterialPageRoute(builder: (context) {
                          return TextView(
                              text: null == _checkItem.remark
                                  ? ""
                                  : _checkItem.remark,
                            readonly: true,);
                        }));
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                Column(
                  children: rds.map((r) {
                    return Row(
                      children: <Widget>[
                        Radio(
                          value: r.name,
                          groupValue: null == _checkItem.inputValue ? "" : _checkItem.inputValue,
                          onChanged: null,
                        ),
                        Text(r.name)
                      ],
                    );
                  }).toList(),
                ),
                Row(
                  children: <Widget>[
                    Text("拍照点"),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                    ),
                    Container(
                      height: 40.0,
                      child: new DropdownButton(
                        items: getListData(),
                        hint: Padding(
                          padding: EdgeInsets.only(
                            right: 70.0,
                          ),
                          child: new Text(_checkItem.pictureInfo.length > 0
                              ? _checkItem.pictureInfo[0].name
                              : "无拍照点"),
                        ),
                        //下拉菜单选择完之后显示给用户的值
                        value: _checkItem.selectPicName ?? "",
                        onChanged: (T) {
                          //下拉菜单item点击之后的回调
                          setState(() {
                            _checkItem.selectPicName = T;

                            // 筛选图片
                            _checkItem.selectPic = _checkItem.pointInputImgUrls.where((url) => url.indexOf(_checkItem.selectPicName) != -1).toList();
                          });
                        },
                        elevation: 24,
                        //设置阴影的高度
                        style: new TextStyle(
                            //设置文本框里面文字的样式
                            color: Colors.black),
                        isDense: false,
                        //减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
                        iconSize: 35.0, //设置三角标icon的大小
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 100,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          children: _checkItem.selectPic.length > 0 ? _checkItem.selectPic.map((p) {
                            return  GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Image.network(p.replaceAll("\\", "/"), width: 80.0, height: 80.0),
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder:(context){
                                  return ImageView(Image.network(p.replaceAll("\\", "/")));
                                }));
                              },
                            );
                          }).toList() : <Widget>[],
                        ),
                      ]),
                ),
              ],
            )),
      ],
    );
  }
}
