import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/Task/TaskContentResult.dart';
import 'package:flutter_custom_bottom_tab_bar/eachtab.dart';
import 'package:intelligent_check_new/pages/task_detail/task_detail_process/manual_input.dart';
import 'package:intelligent_check_new/pages/task_detail/task_detail_process/nfc_page.dart';
import 'package:intelligent_check_new/pages/task_detail/task_detail_process/qr_page.dart';

class NoPlanInspection extends StatefulWidget{

//  final num taskId;
  final TaskContent task;
  final String pointNo;
  NoPlanInspection(this.task,this.pointNo);

  @override
  State<StatefulWidget> createState() => _NoPlanInspectionState();

}

class _NoPlanInspectionState extends State<NoPlanInspection> with SingleTickerProviderStateMixin{

  TabController _tabController;
  int _selectedIndex = 0;
  var titles = ['NFC', '二维码', '输入'];

  @override
  void initState() {
    super.initState();
    _tabController =
    new TabController(vsync: this, initialIndex: 0, length: titles.length);
    _tabController.addListener(() {
      setState(() => _selectedIndex = _tabController.index);
//      print("liucheng-> ${_tabController.indexIsChanging}");
    });

//    print(this.widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.grey,
        height: 120,
        child: Column(
          children: <Widget>[
            new TabBar(
              isScrollable: false,
              controller: _tabController,
              indicatorColor: Colors.black54,
              labelColor: Colors.white,
              labelPadding: EdgeInsets.all(0),
              unselectedLabelColor: Colors.white,
              tabs: <Widget>[
                EachTab(
                    width: 130,
                    height: 118,
                    padding: EdgeInsets.all(0),
                    icon: _selectedIndex == 0
                        ? Image.asset(
                      'assets/images/noplan/no_plan_nfc.png',
                      width: 80,
                      height: 40,
                    )
                        : Image.asset(
                      'assets/images/noplan/no_plan_nfc.png',
                      width: 80,
                      height: 40,
                    ),
                    text: titles[0],
                    iconPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    textStyle: TextStyle(fontSize: 16),
                    color: _selectedIndex == 0?Colors.black54:Colors.grey,
                ),
                EachTab(
                    width: 130,
                    height: 118,
                    padding: EdgeInsets.all(0),
                    icon: _selectedIndex == 1
                        ? Image.asset(
                      'assets/images/noplan/no_plan_qr.png',
                      width: 80,
                      height: 40,
                    )
                        : Image.asset(
                      'assets/images/noplan/no_plan_qr.png',
                      width: 80,
                      height: 40,
                    ),
                    text: titles[1],
                    iconPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    textStyle: TextStyle(fontSize: 16),
                    color: _selectedIndex == 1?Colors.black54:Colors.grey,
                ),
                EachTab(
                    width: 130,
                    height: 118,
                    padding: EdgeInsets.all(0),
                    icon: _selectedIndex == 2
                        ? Image.asset(
                      'assets/images/noplan/no_plan_input.png',
                      width: 80,
                      height: 40,
                    )
                        : Image.asset(
                      'assets/images/noplan/no_plan_input.png',
                      width: 80,
                      height: 40,
                    ),
                    text: titles[2],
                    iconPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    textStyle: TextStyle(fontSize: 16),
                    color: _selectedIndex == 2?Colors.black54:Colors.grey,
                ),
              ],
            )
          ],
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(), //设置滑动的效果，这个禁用滑动
        controller: _tabController,
        children: <Widget>[
          NfcPage(this.widget.task,this.widget.pointNo),
          QrPage(this.widget.task,this.widget.pointNo),
          ManualInput(this.widget.task,this.widget.pointNo),
        ],
      ),
    );
  }

}
