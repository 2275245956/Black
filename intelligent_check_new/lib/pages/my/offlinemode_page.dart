
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/piedata.dart';
import 'package:intelligent_check_new/services/offline/dbAccess.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/widget/pie_chart_weight.dart';
import 'package:intelligent_check_new/pages/my/offlinerecord_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intelligent_check_new/constants/color.dart';

class OfflineModePage extends StatefulWidget {
  @override
  _OfflineModePageState createState() => _OfflineModePageState();
}

class _OfflineModePageState extends State<OfflineModePage> {
  //数据源 下标  表示当前是PieData哪个对象
  int subscript = 0;

  //数据源
  List<PieData> mData;

  //传递值
  PieData pieData;

  String msgLoading = "";

  bool value = false;

  String theme="";

  void processChange(num precent) {
    setState(() {
      mData[0].percentage = precent;
      pieData.percentage = precent;
      if(precent==1){
        msgLoading = "数据同步完成";
      }
    });
  }

  //初始化 控制器
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((sp) {
      if (sp.getBool("offline") != null) {
        setState(() {
          value = sp.getBool("offline");
          this.theme = sp.getString("theme")??KColorConstant.DEFAULT_COLOR;
        });
      }
    });

    //初始化 扇形 数据
    initData();
  }

  @override
  Widget build(BuildContext context) {
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
            '离线模式',
            style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.menu, color: GetConfig.getColor(theme)),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new OfflineRecordPage()),
                );
              },
            ),
          ],
        ),
        body: new Column(children: <Widget>[
          new Container(
              color: Colors.white,
              height: 200.0,
              width: double.maxFinite,
              child: new Center(
                //mainAxisAlignment: MainAxisAlignment.center,

                //  自定义的饼状图
                child: new Container(
                    width: 90.0,
                    height: 90.0,
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: new MyCustomCircle(
                        lstPieData: mData, pieData: pieData)),
              )),
          new Container(
            color: Colors.white,
            width: double.maxFinite,
            child: new Center(
              child: Text(msgLoading),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Divider(
              height: 0.5,
              color: Color(0XFFd9d9d9),
            ),
          ),
          Container(
            color: Colors.white,
            height: 50.0,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: new Text(
                      '离线模式',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    padding: const EdgeInsets.only(left: 10.0),
                  ),
                  flex: 5,
                ),
                Expanded(
                  child: new Switch(
                      value: value,
                      onChanged: (newValue) {
                        setState(() {
                          value = newValue;
                          // 开启离线同步数据
                          if (value) {
                            loadData().then((ret){
                              // 数据同步失败
                              if(!ret){
                                value = false;
                                processChange(0.0);
                              }else{
                                SharedPreferences.getInstance().then((sp) {
                                  sp.setBool("offline", value);
                                });
                                print("Set offline = $value");
                              }
                            });
                          } else { // 关闭离线
                            processChange(0.0);
                            SharedPreferences.getInstance().then((sp) {
                              sp.setBool("offline", value);
                            });
                            print("Set offline = $value");
                          }
                        });
                      }),
                  flex: 1,
                ),
              ],
            ),
          ),
        ]));
  }

  //初始化数据源
  void initData() {
    mData = new List();
    PieData p1 = new PieData();
    p1.name = 'DataSynchronization';
    p1.percentage = 0.0;
    p1.color = Colors.blueAccent;

    pieData = p1;
    mData.add(p1);
  }

  Future<bool> loadData() async {
    msgLoading = "数据同步中...";
    processChange(0.00);
    Database db;
    try {
      db = await dbAccess().createNewDb();
      processChange(0.10);

      // 巡检计划表
      bool ret = await dbAccess().createPlanInspectionTable(db);
      processChange(0.20);

      // 巡检点表
      bool rt2 = await dbAccess().createPointTable(db);
      processChange(0.30);

      // 检查项分类表
      bool rt5 = await dbAccess().createClassifyTable(db);
      processChange(0.50);

      // 检查项表
      bool rt6 = await dbAccess().createInputItemTable(db);
      processChange(0.60);

      // 任务表
      bool rt7 = await dbAccess().createTasksTable(db);
      processChange(0.65);

      //任务反馈
      await dbAccess().createFeedbackTaskTable(db);
      processChange(0.70);

      // 巡检记录表
      // 判断表是否存在，不存在则创建
      bool exists = await dbAccess().checkTableExists(db,"CheckReord");
      if (!exists) {
        await dbAccess().createCheckReordTable(db);
        processChange(0.75);
      }

      // 同步当前登陆人的巡检计划
      bool rt8 = await dbAccess().loadPlanData(db);
      if(!rt8){
        msgLoading = "数据同步失败";
        await dbAccess().closeDb(db);
        return false;
      }
      processChange(0.80);

      // 同步当前登陆人的巡检点
//      bool rt9 = await dbAccess().loadPointData(db);
//      if(!rt9){
//        msgLoading = "数据同步失败";
//        await dbAccess().closeDb(db);
//        return false;
//      }
//      processChange(0.90);

      // 同步当前登陆人的任务数据
      bool rt10 = await dbAccess().loadTaskData(db);
      if(!rt10){
        msgLoading = "数据同步失败";
        await dbAccess().closeDb(db);
        return false;
      }
      processChange(1.00);
      await dbAccess().closeDb(db);
      return true;
    } catch (e) {
      processChange(0.00);
      if(null != db){
        await dbAccess().closeDb(db);
      }
      return false;
    }
  }
}
