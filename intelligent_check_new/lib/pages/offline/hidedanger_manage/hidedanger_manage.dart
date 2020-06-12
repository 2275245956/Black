import 'package:flutter/material.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hide_danger_page_mysend.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hide_danger_page_mytask.dart';
import 'hide_danger_page_all.dart';
import 'package:intelligent_check_new/widget/touch_callback.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/inspection_task_screening_page.dart';
import 'package:intelligent_check_new/pages/task_addition/task_addition_screen.dart';
import 'package:intelligent_check_new/model/Task/TaskContentInput.dart';

class OfflineHideDangerPage extends StatefulWidget {
  final int idx;
  OfflineHideDangerPage(this.idx);

  @override
  _OfflineHideDangerPageState createState() => _OfflineHideDangerPageState();
}

//with混入,类似多重继承
class _OfflineHideDangerPageState extends State<OfflineHideDangerPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  var titles = ['全部任务', '我接收', '我发起', '筛选'];

  TaskContentInput taskContentInput = new TaskContentInput();

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        vsync: this, initialIndex: this.widget.idx, length: titles.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "任务列表",
            style: TextStyle(color: Colors.black, fontSize: 19),
          ),
          centerTitle: true,
          elevation: 0.7,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child:
                  Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.note_add),
              tooltip: '添加任务',
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new TaskAdditionScreen()));
              },
              color: Colors.red,
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            new TabBar(
              controller: _controller,
              labelColor: Colors.red,
              indicatorColor: Colors.red,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 1.0,
              isScrollable: true,
              labelStyle: TextStyle(fontSize: 16),
              unselectedLabelColor: Colors.grey,
              tabs: [
                new Tab(text: "全部任务"),
                new Tab(text: "我接收"),
                new Tab(text: "我发起"),
//              new Tab(text:"筛选"),
                Tab(
                  child: TouchCallBack(
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey[200],
                        ),
                        Container(
                          width: 4,
                        ),
                        Text(
                          titles[3],
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 15),
                        ),
                        Image.asset(
                          "assets/images/filter_red.png",
                          height: 15,
                        )
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new TaskScreenPage(
                                  (data, onlyMe) => callBack(data, onlyMe))));
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 2),
            ),
            Divider(
              height: 1,
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  HiderManageAllPage(taskContentInput),
                  HiderManageMyTaskPage(taskContentInput),
                  HiderManageMySendPage(taskContentInput),
                ],
              ),
            )
          ],
        ));
  }

  callBack(TaskContentInput data, bool onlyMe) {
    setState(() {
      taskContentInput = data;
    });
  }
}
