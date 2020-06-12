import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_custom_bottom_tab_bar/eachtab.dart';
import 'package:intelligent_check_new/model/CompanyInfo.dart';
import 'package:intelligent_check_new/model/UserAuthModel.dart';
import 'package:intelligent_check_new/pages/AndroidBackTop.dart';
import 'package:intelligent_check_new/pages/home_screen.dart';
import 'package:intelligent_check_new/pages/my/my_screen.dart';
import 'package:intelligent_check_new/pages/statistics_screen.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';

class NavigationKeepAlive extends StatefulWidget {
  @override
  _NavigationKeepAliveState createState() => _NavigationKeepAliveState();
}

class _NavigationKeepAliveState extends State<NavigationKeepAlive>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _selectedIndex = 0;
  var titles = [];
  UserShowAuth  auth;
  List<CompanyInfo> cqDatas = List();
  bool isAnimating = false;
  String theme = "blue";
  bool isOffline = false;
/// 离线模式获取数据
  initOfflineData() {
    SharedPreferences.getInstance().then((preferences) {


      var companyData = preferences.get("companyList");
      if (null != companyData) {

        try {
          var cominfo = json.decode(companyData)[0];
          var _dataList = {
            "level": null,
            "checked": false,
            "code": cominfo["orgCode"],
            "key": cominfo["sequenceNbr"],
            "label": cominfo["companyName"],
            "type": cominfo["level"],
            "value": cominfo["companyName"],
          };
          cqDatas.add(CompanyInfo.fromJson(_dataList));
        } catch (e) {
          throw e;
        }
      }
    });
  }
///在线模式获取数据
  initOnlineData() async {

    SharedPreferences.getInstance().then((preferences) {
      var companyData = preferences.get("companyList");
      if (null != companyData) {

        try {
          var cominfo = json.decode(companyData)[0];
          var _dataList = {
            "level": null,
            "checked": false,
            "code": cominfo["orgCode"],
            "key": cominfo["sequenceNbr"],
            "label": cominfo["companyName"],
            "type": cominfo["level"],
            "value": cominfo["companyName"],
          };
          cqDatas.add(CompanyInfo.fromJson(_dataList));
        } catch (e) {
          throw e;
        }

      }
    });
  }
  @override
  void initState() {
    super.initState();
    // 初始化首页数据
    setState(() {
      isAnimating = true;
    });

    // 判断当前是否是离线状态
    SharedPreferences.getInstance().then((preferences) {
      setState(() {
        this.isOffline = preferences.getBool("offline");
        this.theme =preferences.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
        var showAuthJson=preferences.getString("user_show");
        if(showAuthJson!="" && showAuthJson!=null){
          this.auth=new UserShowAuth.fromJson(json.decode(showAuthJson));
          if(this.auth==null || this.auth.children==null)return;
          this.auth.children.sort((now,next)=> now.sort.compareTo(next.sort) );
          if(this.auth.children!=null && this.auth.children.length>0){
            for(UserShowAuth au  in this.auth.children){
              titles.add(au.permissionName);
            }
          }
        }else{
          titles.add("我的");
        }
        isAnimating = false;
      });
      return isOffline;
    }).then((result) {
      // 是离线模式，从缓存中获取公司信息
      if (this.isOffline) {
        initOfflineData();
      } else {
        initOnlineData();
      }

      _tabController =
      new TabController(vsync: this, initialIndex: 0, length: titles.length);
      _tabController.addListener(() {
        setState(() => _selectedIndex = _tabController.index);
      });


    });

  }
///获取菜单栏数据
  Widget getImgAsset(selIndex,curentIndex){
    switch(curentIndex){
      case 0:
       return  selIndex == curentIndex
            ? Image.asset('assets/images/home/home_tab_workspace_' + theme +'.png',height: 30,)
            : Image.asset( 'assets/images/home/un_home_tab_workspace.png',height: 30,);
        break;
      case 1:
        return  selIndex == curentIndex
            ? Image.asset('assets/images/home/home_statistic_' + theme +'.png',height: 30,)
            : Image.asset( 'assets/images/home/un_home_statistic.png',height: 30,);
        break;
      case 2:
        return  selIndex == curentIndex
            ? Image.asset('assets/images/home/home_my_' + theme +'.png',height: 30,)
            : Image.asset( 'assets/images/home/un_home_my.png',height: 30,);
        break;
    }
    return Image.asset( 'assets/images/home/un_home_tab_workspace.png',height: 30,);

  }
///获取页面
  List<Widget> getPageWidgets(){
    List<Widget> ws=new List();

    if(this.auth!=null && this.auth.children!=null && this.auth.children.length>0) {
      for (UserShowAuth au in this.auth.children) {
        switch (au.frontComponent) {
          case "operatingFloor":
            ws.add(HomeScreen(cqDatas /*,taskCount,unReadCount*/));
            break;
          case "statistics":
            ws.add(StatisticsScreen());
            break;
          case "my":
            ws.add(MyScreen());
            break;
        }
      }
    }else{
      ws.add(MyScreen());
      setState(() {

      });
    }

    return ws;


  }
  @override
  Widget build(BuildContext context) {
    if (this.theme == null || this.theme.isEmpty|| this.titles.length==0) {
      return WillPopScope(
        child: Scaffold(body: Text("")),
        onWillPop: () async {
          AndroidBackTop.backDeskTop(); //设置为返回不退出app
          return false;
        },
      );
    }

    if (this.auth==null) {
      return WillPopScope(
        child: Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(), //设置滑动的效果，这个禁用滑动
            controller: _tabController,
            children:getPageWidgets(),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            height: 70.0,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                new TabBar(
                  isScrollable: false,
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.black,
                  labelPadding: EdgeInsets.all(0),
                  unselectedLabelColor: Colors.white,
                  tabs:[
                    EachTab(
                      width: 80,
                      height: 60,
                      padding: EdgeInsets.all(0),
                      icon: getImgAsset(2,2),
                      text: "我的",
                      iconPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      textStyle: TextStyle(
                          fontSize: 12,
                          color:   GetConfig.getColor(theme) ),
                    )
                  ]
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          AndroidBackTop.backDeskTop(); //设置为返回不退出app
          return false;
        },
      );
    }
    return WillPopScope(
      child: Scaffold(
          bottomNavigationBar: Container(
            color: Colors.white,
            height: 70.0,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                new TabBar(
                  isScrollable: false,
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.black,
                  labelPadding: EdgeInsets.all(0),
                  unselectedLabelColor: Colors.white,
                  tabs:this.auth.children.map((f){
                    return  EachTab(
                      width: 80,
                      height: 60,
                      padding: EdgeInsets.all(0),
                      icon:getImgAsset(_selectedIndex,this.auth.children.indexOf(f)),
                      text: f.permissionName,
                      iconPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      textStyle: TextStyle(
                          fontSize: 12,
                          color: _selectedIndex == this.auth.children.indexOf(f)
                              ? GetConfig.getColor(theme)
                              : Colors.grey),
                    );
                  }).toList()
                )
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(), //设置滑动的效果，这个禁用滑动
            controller: _tabController,
            children:getPageWidgets(),
          )),
      onWillPop: () async {
        AndroidBackTop.backDeskTop(); //设置为返回不退出app
        return false;
      },
    );
  }
}
