import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intelligent_check_new/model/VideoMonitor.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/services/VideoMonitorService.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoPlay extends StatefulWidget {
  List<VideoMonitorListModel> initData;
  String videoToken;
  String Title;

  VideoPlay({this.initData, this.videoToken, this.Title});

  @override
  _VideoPlay createState() => _VideoPlay();
}

class _VideoPlay extends State<VideoPlay> {
  String theme = "";
  bool showVideoList = false;
  bool showTitle = true;
  var videoUrl = "";

  @override
  void dispose() {
    //取消强制竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  @override
  void initState() {
    //强制横屏

    delayHideTitle();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SharedPreferences.getInstance().then((sp) {
      setState(() {
        theme = sp.getString("theme") ?? "blue";
      });
      iniData();
    });
  }

  void delayHideTitle() async {
    new Future.delayed(Duration(seconds: 5), () {
      setState(() {
        showTitle = false;
      });
    });
  }

  void iniData() {
    getVideoUrl().then((data) {
      if (data.success) {
        setState(() {
          videoUrl = "${data.dataList}${this.widget.videoToken}";
        });
      } else {
        HiddenDangerFound.popUpMsg(data.message ?? "获取监控地址失败！");
      }
    });
  }

  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    if (this.widget.initData == null && videoUrl == "") {
      return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.2,
            backgroundColor: Color(0xFFFFFFFF),
            title: Container(
              margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: Text("${this.widget.Title}",
                  style: new TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
            leading: new Container(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.keyboard_arrow_left,
                    color: GetConfig.getColor(theme), size: 32),
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.menu,
                    color: GetConfig.getColor(theme),
                    size: 32,
                  ),
                ),
                onTap: () {
                  setState(() {
                    showVideoList = !showVideoList;
                  });
                },
              )
            ],
            centerTitle: true,
          ),
          body: Container(),
        ),
        onWillPop: () {
          Navigator.pop(context);
        },
      );
    }
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: videoUrl == ""
                  ? Container()
                  : new WebView(
                      initialUrl: "$videoUrl",
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller = webViewController;
                      },
                    ),
            ),
            new Positioned(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: new Opacity(
                  opacity: 0.0,
                  child: GestureDetector(
                    child: Container(
                      color: Colors.transparent,
                    ),
                    onTap: () {
                      setState(() {
                        showVideoList = !showVideoList;
                      });
                    },
                    onVerticalDragEnd: (details) {
                     if(details.velocity.pixelsPerSecond.dy>0){//下拉
                       setState(() {
                         showTitle = true;
                       });
                     }
                     else{
                       setState(() {
                         showTitle = false;
                       });
                     }
                    },
                  ),
                )),
            showTitle
                ? new Positioned(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: new Opacity(
                      opacity: 0.7,
                      child: Container(
                        color: Colors.black,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  margin: EdgeInsets.only(right: 20, left: 10),
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "${this.widget.Title}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                : Container(),
            showVideoList
                ? new Positioned(
                    right: 0,
                    height: MediaQuery.of(context).size.height,
                    width: (MediaQuery.of(context).size.width * 3) / 5,
                    child: new Opacity(
                      opacity: 0.7,
                      child: SingleChildScrollView(
                          child: Container(
                        color: Colors.black12,
                        child: new ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: this.widget.initData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  this.widget.Title =
                                      this.widget.initData[index].name;
                                  showVideoList = false;
                                  _controller.evaluateJavascript(
                                      "window.location.search='?token=${this.widget.initData[index].token}'");
                                });
                              },
                              child: Container(
                                height: 60.0,
                                margin: EdgeInsets.only(left: 3),
                                child: Card(
                                    color: Colors.black54,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        //任务类型
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                  child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: Colors.black,
                                                child: Icon(
                                                  Icons.videocam,
                                                  size: 32,
                                                  color: Colors.white,
                                                ),
                                              )),
                                            ],
                                          ),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${index + 1}.${this.widget.initData[index].name}",
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          flex: 5,
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          },
                        ),
                      )),
                    ))
                : Container()
          ],
        ),
      ),
      onWillPop: () {
        Navigator.pop(context);
      },
    );
  }
}
