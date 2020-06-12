import 'package:flutter/material.dart';
import 'package:intelligent_check_new/pages/offline/no_plan_inspection/manual_input.dart';
import 'package:intelligent_check_new/pages/offline/no_plan_inspection/nfc_page.dart';
import 'package:intelligent_check_new/pages/offline/no_plan_inspection/qr_page.dart';
import 'package:flutter_custom_bottom_tab_bar/eachtab.dart';

class OfflineNoPlanInspection extends StatefulWidget{

  final num taskId;
  OfflineNoPlanInspection({this.taskId});

  @override
  State<StatefulWidget> createState() => _NoPlanInspectionState();

}

class _NoPlanInspectionState extends State<OfflineNoPlanInspection> with SingleTickerProviderStateMixin{

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

    print(this.widget.taskId);
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
          this.widget.taskId != null && this.widget.taskId > 0?NfcPage(taskId: this.widget.taskId,):NfcPage(),
          this.widget.taskId != null && this.widget.taskId > 0?QrPage(taskId: this.widget.taskId,):QrPage(),
          this.widget.taskId != null && this.widget.taskId > 0?ManualInput(taskId: this.widget.taskId,):ManualInput(),
        ],
      ),
    );
  }

}
