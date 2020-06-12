import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/plan_inspection/check_point_detail.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageListView.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_item_content.dart';
import 'package:intelligent_check_new/pages/plan_inspection/plan_list_screen.dart';
import 'package:intelligent_check_new/services/plan_inspection_services.dart';
import 'package:intelligent_check_new/tools/DateUtil.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';

class PlanListContentDetail extends StatefulWidget {
  final num planTaskId;
  final num pointId;

  PlanListContentDetail(this.planTaskId, this.pointId);

  @override
  State<StatefulWidget> createState() {
    return _PlanListContentDetail();
  }
}

class _PlanListContentDetail extends State<PlanListContentDetail> {
//  bool _switchSelected=true;
  // 页面数据体
  CheckPointDetail pointDetail;
  String theme = "";
  List<NetworkImage> imageListThumb = List();
  List<Image> imageList = List();

  @override
  void initState() {
    super.initState();
    getData();
    initConfig();
  }

  initConfig() async {
    SharedPreferences.getInstance().then((preferences) {
      setState(() {
        this.theme =
            preferences.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  getData() async {
    await queryPointPlanTaskDetail(this.widget.planTaskId, this.widget.pointId)
        .then((data) {
      if (data.message != null && data.message.isNotEmpty) {
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
                    content: Text(data.message),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("关闭",
                            style: TextStyle(fontSize: 20, color: Colors.grey)),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              new MaterialPageRoute(
                                  builder: (context) => new PlanListScreen()),
                              (route) => route == null);
                        },
                      ),
                    ])).then((v) {
          return v;
        });

        return;
      }

      setState(() {
        pointDetail = data;
//        print(pointDetail.checkInputs);
//        print(pointDetail.checkId);
        // wangkai 20190614
        pointDetail.pointImgUrls.forEach((url) {
          if (null != url && url.isNotEmpty) {
            if (url.endsWith("jpg")) {
              this.imageList.add(Image.network(url.replaceAll("\\", "/")));
              imageListThumb.add(NetworkImage(url.replaceAll("\\", "/")));
            }
          }
//            print(imageList);
          imageListThumb = imageListThumb.length > 3
              ? imageListThumb.sublist(0, 3).toList()
              : imageListThumb;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    num thumbIdx = -1;
    if (this.theme.isEmpty) {
      return Scaffold(body: Text(""));
    }
    // 数据未加载完成，只显示头部
    if (null == pointDetail) {
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
        title: Text(
          pointDetail.pointName ?? "",
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
//        actions: <Widget>[
//          pointDetail.pointStatus=="3"?
//          IconButton(
//            icon: new Icon(Icons.note_add),
//            tooltip: '添加任务',
//            onPressed: () {
//              if(pointDetail.checkId>0){
//                Navigator.push(context,
//                    new MaterialPageRoute(
//                        builder: (context) => new TaskAdditionScreen(checkId:pointDetail.checkId)));
//                }
//              },
//            color:  GetConfig.getColor(theme),
//          ):Container(),
//        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  width: 150,
                  height: 40,
                  child: Text(
                    "点编号",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                Text(pointDetail.pointNo ?? "",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  width: 150,
                  child: Text(
                    "巡检计划",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
              Container(
                padding: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width-150,
                child:   Text(pointDetail.planName ?? ""),
              )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  width: 150,
                  height: 40,
                  child: Text(
                    "执行时间",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                Text(pointDetail.checkTime == null
                    ? ""
                    : DateUtil.timestampToDate(pointDetail.checkTime ?? 0)),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  width: 150,
                  height: 40,
                  child: Text(
                    "执行部门",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                Text(pointDetail.departmentName ?? ""),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  width: 150,
                  height: 40,
                  child: Text(
                    "执行人",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                Text(pointDetail.username ?? ""),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  width: 150,
                  height: 40,
                  child: Text(
                    "点状态",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                Text(
                  getPointStatus(pointDetail.pointStatus),
                  style:
                      TextStyle(color: getPointColor(pointDetail.pointStatus)),
                ),
              ],
            ),
            Container(
              color: Colors.grey[100],
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 20, top: 10),
              height: 40,
              child: Text(
                "检查项目",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              alignment: Alignment.centerLeft,
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: pointDetail.checkInputs.keys.map((f) {
                  return GestureDetector(
                      child: Container(
                          padding: EdgeInsets.only(top: 8, bottom: 6),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              f == "其他"
                                  ? Container()
                                  : Container(
                                      child: Text(
                                        f,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      alignment: Alignment.topLeft,
                                    ),
                              Container(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        pointDetail.checkInputs[f].map((item) {
                                      return Text(
                                          "${pointDetail.checkInputs[f].indexOf(item) + 1}.  ${item.inputName}",
                                          style: TextStyle(
                                              color: (item.inputStatus == "2"
                                                  ? Colors.red
                                                  : Colors.black),
                                              fontSize: 14));
                                    }).toList()),
                                padding: EdgeInsets.only(top: 5),
                              )
                            ],
                          )),
                      onTap: () {
                        if (pointDetail.pointStatus != "0") {
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (context) {
                            return new CheckExecItemContent(
                                pointDetail.checkId);
                          }));
                        }
                      });

//                  return GestureDetector(
//                    child: Container(
//                      child: Text(f.inputName,style: TextStyle(color: (f.inputStatus == "2" ? Colors.red : Colors.black))),
//                      width: 280,
//                    ),
//                    onTap: (){
//                      Navigator.push( context,
//                          new MaterialPageRoute(builder: (context) {
//                            return new CheckExecItemContent(pointDetail.checkId);
//                          }));
//                    },
//                  );
                }).toList(),
              ),
            ),
            pointDetail.pointStatus == "0"
                ? Container()
                : Container(
                    height: 10.0,
                    color: Colors.grey[100],
                  ),
            pointDetail.pointStatus == "0"
                ? Container()
                : Container(
                    margin: EdgeInsets.only(top: 15, bottom: 15,left: 15),
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex:0,
                                  child: Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                Expanded(child: Text("现场照片"),flex: 3,),
                              Expanded(child:this.imageListThumb.length > 0
                                  ? Container(
                                width: 260,
                                height: 30,
                                padding: EdgeInsets.only(
                                    left: 210.0 -
                                        imageListThumb.length * 20.0),
                                child: Stack(
                                  children: imageListThumb.map((f) {
                                    thumbIdx++;
                                    return thumbIdx == 0
                                        ? Positioned(
//                                      left: 0,
                                      child: CircleAvatar(
                                        child: Image.network(
                                          f.url,
                                          height: 25,
                                        ),
                                        backgroundColor:
                                        Colors.grey,
                                        radius: 20,
                                      ),
                                    )
                                        : Positioned(
                                      left: thumbIdx * 25.0,
                                      child: CircleAvatar(
                                        child: Image.network(
                                          f.url,
                                          height: 25,
                                        ),
                                        backgroundColor:
                                        Colors.grey,
                                        radius: 20,
                                      ),
                                    );
                                  }).toList(),
//                                  children: <Widget>[
//                                    Positioned(
//                                      child: CircleAvatar(child: Text(imageListThumb.length.toString()),),
//                                    ),
//                                    Positioned(
//                                      left: 20,
//                                      child: CircleAvatar(child: Text("王"),),
//                                    ),
//                                    Positioned(
//                                      left: 40,
//                                      child: CircleAvatar(child: Text("里"),),
//                                    )
//                                  ],
                                ),
                              )
                                  : Container(
                                width: 260,
                              ) ,flex: 9,),
                                Expanded(child: new Icon(
                                  Icons.keyboard_arrow_right,
                                  color: GetConfig.getColor(theme),
                                  size: 20,
                                ),flex: 1,),

                              ],
                            ),
                          ]),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ImageListView(this.imageList);
                        }));
                      },
                    ),
                  ),
            pointDetail.pointStatus == "0"
                ? Container()
                : Container(
                    height: 10.0,
                    color: Colors.grey[100],
                  ),
            pointDetail.pointStatus == "0"
                ? Container()
                : Padding(
                    padding:
                        EdgeInsets.only(left: 10.0, top: 10.0, bottom: 20.0),
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
                            child: Text(null == pointDetail.remark
                                ? ""
                                : pointDetail.remark),
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

  String getPointStatus(String pointStatus) {
    if (pointStatus == "0") {
      return "未开始";
    } else if (pointStatus == "1") {
      return "正常";
    } else if (pointStatus == "2") {
      return "异常";
    } else if (pointStatus == "3") {
      return "漏检";
    } else {
      return "";
    }
  }

  Color getPointColor(String pointStatus) {
    if (pointStatus == "0") {
      return Colors.grey;
    } else if (pointStatus == "1") {
      return Colors.green;
    } else if (pointStatus == "2") {
      return Colors.red;
    } else if (pointStatus == "3") {
      return Colors.orange;
    } else {
      return Colors.white;
    }
  }
}
