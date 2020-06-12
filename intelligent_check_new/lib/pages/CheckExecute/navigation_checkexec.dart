import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/PlanTaskInitConfig.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_inspection.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_inspection_list.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_list_screen.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_spot_detail.dart';
import 'package:flutter_custom_bottom_tab_bar/eachtab.dart';
import 'package:intelligent_check_new/services/PlanTaskInitConfigServices.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationCheckExec extends StatefulWidget{

  int pointId;
  int planId;
  String pointName;
  String checkMode;
  NavigationCheckExec(this.pointId,{this.planId,this.pointName,this.checkMode});

  @override
  State<StatefulWidget> createState() => _NavigationCheckExec();

}

class _NavigationCheckExec extends State<NavigationCheckExec> with SingleTickerProviderStateMixin{

  TabController _tabController;
  int _selectedIndex = 0;
  var titles = ['巡检', '记录', '详情'];
  String theme="";
  PlanTaskInitConfig checkInitConfig;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: titles.length);
    _tabController.addListener(() {

      if(_tabController.indexIsChanging){
        setState(() => _selectedIndex = _tabController.index);
      }
    });
//    print("=====================================================");
//    print(widget.pointName);

    initConfig();

    // 获取巡检内容
    getData();
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  getData() async{
    await getInitPlanTaskConfig(this.widget.planId, this.widget.pointId).then((data){
      setState(() {
        checkInitConfig = data;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    if(this.theme.isEmpty || checkInitConfig == null){
      return Scaffold(
          body:Text("")
      );
    }

    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 60.0,
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 5),),
            new TabBar(
              isScrollable: false,
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.black,
              labelPadding: EdgeInsets.all(0),
              unselectedLabelColor: Colors.white,
              tabs: <Widget>[
                EachTab(
                  width: 80,
                  height: 50,
                  padding: EdgeInsets.all(0),
                  icon: _selectedIndex == 0
                      ? Image.asset(
                    'assets/images/checkexec/inspection_'+theme+'.png',
                    width: 70,
                    height: 22,
                  )
                      : Image.asset(
                    'assets/images/checkexec/un_inspection.png',
                    width: 70,
                    height: 22,
                  ),
                  text: titles[0],
                  iconPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  textStyle: TextStyle(fontSize: 12, color: _selectedIndex == 0?GetConfig.getColor(theme):Colors.grey),
                  //color: _selectedIndex == 0?Colors.white:Colors.grey,
                ),
                EachTab(
                  width: 80,
                  height: 50,
                  padding: EdgeInsets.all(0),
                  icon: _selectedIndex == 1
                      ? Image.asset(
                    'assets/images/checkexec/record_'+theme+'.png',
                    width: 70,
                    height: 22,
                  )
                      : Image.asset(
                    'assets/images/checkexec/un_record.png',
                    width: 70,
                    height: 22,
                  ),
                  text: titles[1],
                  iconPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  textStyle: TextStyle(fontSize: 12, color: _selectedIndex == 1?GetConfig.getColor(theme):Colors.grey),
                  //color: _selectedIndex == 1?Colors.white:Colors.grey,
                ),
                EachTab(
                  width: 80,
                  height: 50,
                  padding: EdgeInsets.all(0),
                  icon: _selectedIndex == 2
                      ? Image.asset(
                    'assets/images/checkexec/detail_'+theme+'.png',
                    width: 70,
                    height: 22,
                  )
                      : Image.asset(
                    'assets/images/checkexec/un_detail.png',
                    width: 70,
                    height: 22,
                  ),
                  text: titles[2],
                  iconPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  textStyle: TextStyle(fontSize: 12, color: _selectedIndex == 2?GetConfig.getColor(theme):Colors.grey),
                  //color: _selectedIndex == 2?Colors.white:Colors.grey,
                )
              ],
              onTap: (int idx){
                this._selectedIndex = idx;
              },
            )
          ],
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(), //设置滑动的效果，这个禁用滑动
        controller: _tabController,
        children: <Widget>[
//          CheckExecInspection(this.widget.pointId, this.widget.planId,this.widget.checkMode),
          checkInitConfig.extClass != null && checkInitConfig.extClass.length>0?
          CheckExecInspectionList(this.widget.pointId, this.widget.planId,this.widget.checkMode)
              :CheckExecInspection(this.widget.pointId, this.widget.planId,this.widget.checkMode),
          CheckExecListScreen(this.widget.pointId,this.widget.pointName),
          CheckExecSpotDetail(this.widget.pointId,false),
        ],
      ),
    );
  }
}
