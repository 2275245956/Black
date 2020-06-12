import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hide_danger_page_mysend.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hide_danger_page_mytask.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hide_danger_page_all.dart';
import 'package:intelligent_check_new/widget/touch_callback.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/inspection_task_screening_page.dart';
import 'package:intelligent_check_new/pages/task_addition/task_addition_screen.dart';
import 'package:intelligent_check_new/model/Task/TaskContentInput.dart';

class HideDangerPage extends StatefulWidget {
  final int idx;
  HideDangerPage(this.idx);

  @override
  _HideDangerPageState createState() => _HideDangerPageState();
}

//with混入,类似多重继承
class _HideDangerPageState extends State<HideDangerPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  var titles = ['全部任务', '我接收', '我发起', '筛选'];

  TaskContentInput taskContentInput = new TaskContentInput();
  String theme="";

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        vsync: this, initialIndex: this.widget.idx, length: titles.length);
    initConfig();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(this.theme.isEmpty){
      return Scaffold(
          body:Text("")
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "任务列表",
            style: TextStyle(color: Colors.black, fontSize: 19),
          ),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child:
                  Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset("assets/images/icons/menu_add_"+theme+".png",width: 22,),
              tooltip: '添加任务',
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new TaskAdditionScreen()
                    )
                );
              },
              color:GetConfig.getColor(theme),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            new TabBar(
              controller: _controller,
              labelColor: theme=="blue"?Colors.blue:Colors.red,
              indicatorColor: theme=="blue"?Colors.blue:Colors.red,
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
                          "assets/images/filter_"+theme+".png",
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
                  Container()
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
