import 'dart:convert' show base64Encode, json;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intelligent_check_new/common/JunCommon.dart';
import 'package:intelligent_check_new/model/CheckRecord.dart';
import 'package:intelligent_check_new/model/CheckRecordDto.dart';
import 'package:intelligent_check_new/model/MovePointAttachment.dart';
import 'package:intelligent_check_new/services/CheckRecordServices.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/services/offline/dbAccess.dart';
import 'package:intelligent_check_new/tools/DateUtil.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';
import 'package:intelligent_check_new/widget/loadingdialoge.dart';
import 'package:intelligent_check_new/widget/completedialog.dart';
import 'package:intelligent_check_new/widget/faildialoge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:intelligent_check_new/constants/color.dart';


class OfflineRecordPage extends StatefulWidget {
  @override
  _OfflineRecordPageState createState() => _OfflineRecordPageState();
}

class _OfflineRecordPageState extends State<OfflineRecordPage> {
  var issaving = false;
  List<CheckRecord> listData;
  List<Map<String, dynamic>> list;
  List<Map<String,dynamic>> listTask;
  bool isOffline = false;
  String theme="";

  @override
  initState() {
    super.initState();

    getData();
  }

  getData() async{
    await SharedPreferences.getInstance().then((sp){
      if(sp.getBool("offline")!= null){
        setState(() {
          isOffline = sp.getBool("offline");
          this.theme = sp.getString("theme")??KColorConstant.DEFAULT_COLOR;
        });
      }
    });

    var sql = new StringBuffer();
    sql.write("select ");
    sql.write("* ");
    sql.write("from CheckReord;");
    var lstRd = await dbAccess().queryData(sql.toString());
    sql = new StringBuffer();
    sql.write(" select * ");
    sql.write(" from FeedbackTask;");
    var lstTask = await dbAccess().queryData(sql.toString());
    listData = new List();
    list = new List();
    setState(() {
      //--离线巡检---------------------------
      if(null != lstRd){
        list = lstRd;
        for (var item in list) {
          var jsonRecord = json.decode(item["recordJson"]);
          listData.add(CheckRecord.fromParams(
              planName: jsonRecord["planName"],
              userName: jsonRecord["executor"],
              finishStatus: jsonRecord["finishStatus"],
              checkTime: DateUtil.timestampToDate(jsonRecord["checkTime"])));
        }
      }

      //--离线任务---------------------------
      if(lstTask!=null) {
        listTask = lstTask;
        for (var map in lstTask) {
          listData.add(CheckRecord.fromParams(
              planName: map["title"],
              userName: map["executor"],
              finishStatus: map["status"],
              checkTime: DateUtil.timestampToDate(JunMath.parseInt(map["publishTime"]))));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (null == listData || listData.length == 0) {
      return Scaffold(
          backgroundColor: Color.fromRGBO(242, 246, 249, 1),
          appBar: new AppBar(
            backgroundColor: Colors.white,
            elevation: 0.2,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color:GetConfig.getColor(theme),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            //backgroundColor: KColorConstant.floorTitleColor,
            title: Text(
              '我的信息',
              style: new TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Text(
                  '提交',
                  style: new TextStyle(
                    color: GetConfig.getColor(theme),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: _submit,
              ),
            ],
          ));
    } else {
      return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 0.2,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: GetConfig.getColor(theme),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          //backgroundColor: KColorConstant.floorTitleColor,
          title: Text(
            '我的信息',
            style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Text(
                '提交',
                style: new TextStyle(
                  color:GetConfig.getColor(theme),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              onPressed: _submit,
            ),
          ],
        ),
        body: new Center(
          child: new ListView.builder(
            //ListView的Item
            itemCount: listData.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation:0.2,
                margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: new Container(
                    height: 80.0,
//                                          margin: EdgeInsets.only(top: 5,left: 20,right: 20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 8.0,
                          height: 80.0,
                          color: Colors.green,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                (listData[index].planName ?? "") == "" ? "无计划巡检"
                                    : listData[index].planName,
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "执行人: ${listData[index].userName}",
                                    style: new TextStyle(color: Colors.grey),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 36),
                                  ),
                                  Text(
                                    listData[index].finishStatus ?? "",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "时间:${listData[index].checkTime}",
                                    style: new TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              );
            },
          ),
        ),
      );
    }
  }

  _submit() async {
    if((null == list || list.length == 0) && (null == listTask || listTask.length == 0)){
      showDialog<Null>(
          context: context, //BuildContext对象
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text("提示"),
              //调用对话框
              content: new Text("暂无数据"),
            );
          });
      //关闭loading
      new Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
      return;
    }
    showDialog<Null>(
    context: context, //BuildContext对象
    barrierDismissible: false,
    builder: (BuildContext context) {
      return new LoadingDialog(
        //调用对话框
        text: '记录上传...',
      );
    });
    int successCount = 0;
    var dir = await path_provider.getTemporaryDirectory();

    if(null != list && list.length > 0){
      for(var map in list){
        try{
          var cid = map["cid"].toString();
          var jsonRecord = json.decode(map["recordJson"].toString());
          List<dynamic> localFileData = json.decode(map["filePaths"].toString());
          var pointId = jsonRecord["pointId"];
          List<Attachment> fileData = new List();
          // 处理图片信息
          if(null != localFileData && localFileData.length > 0){
            for(var _detail in localFileData){
              File f = File.fromUri(Uri.file(_detail["filePath"]));
              // 压缩图片
              File result = await FlutterImageCompress.compressAndGetFile(
                f.absolute.path,
//                Directory.systemTemp.absolute.path + "/"+ f.path.substring(f.path.lastIndexOf("/")),
                dir.absolute.path + "/"+  f.path.substring(f.path.lastIndexOf("/")),
                minWidth: 1024,
                minHeight: 768,
                quality: 94,
                rotate: 180,
              );
              if(null != _detail["itemId"]){
                fileData.add(Attachment.fromParams(file: result, itemId: _detail["itemId"], name: _detail["name"]));
              }else{
                fileData.add(Attachment.fromParams(file: result));
              }
            }
          }
          // 统计成功数量
          await saveCheckRecordData(cid,pointId,jsonRecord,fileData).then((result){
            if(null != result && result){
              successCount++;
            }
          });
        }catch(e){
          print("提交失败：" + e);
        }
      }
    }

    // 提交任务处理记录
    if(listTask!=null && listTask.length > 0){
      for(var task in listTask){
        try{
          var jsonDto = json.decode(task['jsonData'].toString());
          var jsonPics = json.decode(task['jsonPictures'].toString());
          for(var pic in jsonPics){
            File result = await FlutterImageCompress.compressAndGetFile(
              pic['path'].toString(),
//              pic['targetPath'].toString(),
              dir.absolute.path + "/"+pic['targetPath'].toString().substring(pic['targetPath'].toString().lastIndexOf("/")),
              minWidth: 1024,
              minHeight: 768,
              quality: 94,
              rotate: 180,
            );
            String bs64 = base64Encode(result.readAsBytesSync());
            jsonDto['imgbase64'].add(bs64);
          }

          await HttpUtil().post(ApiAddress.TASK_FEEDBACKTASK, data: jsonDto);
          await dbAccess().excuteSql("delete from FeedbackTask where cid = ?",[task['cid']]);
          print("提交任务：任务ID---》${task['id']}成功！");
          successCount++;
        }catch(e){
          print("提交失败：" + e);
        }
      }
    }

    //关闭loading
    new Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });

    var total = ((null != list) ? list.length : 0) + ((null != listTask) ? listTask.length : 0);
    // 全部成功
    if(successCount == total){
      new Future.delayed(Duration(seconds: 2), () {
        showDialog<Null>(
            context: context, //BuildContext对象
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new CompleteDialog(
                //调用对话框
                text: '上传成功',
              );
            });
        new Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context); //关闭对话框
        });
      });
    }else{
      new Future.delayed(Duration(seconds: 2), () {
        showDialog<Null>(
            context: context, //BuildContext对象
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new FailDialog(
                //调用对话框
                text: '处理完成，' + (list.length - successCount).toString() +  '条上传失败',
              );
            });
        new Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context); //关闭对话框
        });
      });
    }

    // 延迟两秒,保证事务提交
    new Future.delayed(Duration(seconds: 2), () {
      getData();
    });
  }

 Future<bool> saveCheckRecordData(cid,pointId, recordData, fileData) async {
    var checkRecordDto = CheckRecordDto(recordData);
    return await saveCheckRecord(checkRecordDto).then((result) {
      if (result.isOk() || result.message == "无需重新巡检") {
        if(result.isOk()){
          int checkRecordId = result.dataList["checkId"] as int;
          // 上传图片
          uploadAttachFile(fileData, checkRecordId, pointId).then((result) {
            var param = List();
            param.add(cid);
            dbAccess().excuteSql("delete from CheckReord where cid = ?",param);
          });
        }else{ // TODO:无需重新巡检，后台如果success 返回true，则去掉此逻辑
          var param = List();
          param.add(cid);
          dbAccess().excuteSql("delete from CheckReord where cid = ?",param);
        }
        return true;
      }else{
        return false;
      }
    });
  }

}
