import 'dart:convert' show json;
import 'package:intelligent_check_new/common/JunCommon.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class dbAccess {
  String dbPath;
  Future<Database> createNewDb() async {
    String userid = await SharedPreferences.getInstance().then((sp) {
      String str = sp.get('LoginResult');
      return LoginResult(str).user.id;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$userid', 'my.db');
    SharedPreferences.getInstance().then((sp) {
      sp.setString("DBPath", path);
    });
    print("db path:$path");
    Database db = await openDatabase(path);

    return db;
  }

  Future<Database> openDb() async{
    String userid = await SharedPreferences.getInstance().then((sp) {
      String str = sp.get('LoginResult');
      return LoginResult(str).user.id;
    });
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$userid', 'my.db');
    SharedPreferences.getInstance().then((sp) {
      sp.setString("DBPath", path);
    });
    print("open db path:$path");
    Database db = await openDatabase(path);
    return db;
  }

  Future<bool> createPlanInspectionTable(Database db) async {
    // 计划表
    bool exists = await checkTableExists(db,"PlanInspection");
    if (exists) {
      await db.execute("DROP TABLE PlanInspection;");
      print("DROP TABLE PlanInspection OK!");
    }

    // 计划关联检查点表
    exists = await checkTableExists(db,"PlanInspectionPoint");
    if (exists) {
      await db.execute("DROP TABLE PlanInspectionPoint;");
      print("DROP TABLE PlanInspectionPoint OK!");
    }

    try {
      StringBuffer sql = new StringBuffer();
      sql.write(" CREATE TABLE PlanInspection(cid INTEGER PRIMARY KEY,");
      sql.write(" planTaskId varchar(10),");
      sql.write("	taskName varchar(100),");
      sql.write("	beginTime varchar(50),");
      sql.write("	endTime varchar(50),");
      sql.write("	batchNo varchar(10),");
      sql.write("	finishStatus varchar(10),");
      sql.write(" userId varchar(10),");
      sql.write(" finshNum varchar(10),");
      sql.write(" taskPlanNum varchar(10),");
      sql.write(" inOrder varchar(10),");
      sql.write("	orgCode varchar(50)");
      sql.write("	)");

      // 执行create语句
      await db.execute(sql.toString());
      print("CREATE TABLE PlanInspection OK!");

      sql = new StringBuffer();
      sql.write("CREATE TABLE PlanInspectionPoint(cid INTEGER PRIMARY KEY,");
      sql.write("  pointId vahrcahr(10),");
      sql.write("  planTaskId vahrcahr(10),");
      sql.write("  taskName varchar(50),");
      sql.write("  routeId vahrcahr(10),");
      sql.write("  name varchar(50),");
      sql.write("  pointNO varchar(50),");
      sql.write("  offline vahrcahr(10),");
      sql.write("  status vahrcahr(10),");
      sql.write("  isFixed varchar(10),");
      sql.write("  orderNo varchar(10),");
      sql.write("  classify TEXT,");
      sql.write("  inputItems TEXT");
      sql.write("  );");
      // 执行create语句
      await db.execute(sql.toString());
      print("CREATE TABLE PlanInspectionPoint OK!");
      return true;
    } catch (e) {
      print("CREATE TABLE PlanInspectionPoint Error:$e");
      return false;
    }
  }

  Future<bool> createPointTable(Database db) async {
    bool exists = await checkTableExists(db,"Point");
    if (exists) {
      await db.execute("DROP TABLE Point;");
      print("DROP TABLE Point OK!");
    }
    try {
      StringBuffer sql = new StringBuffer();
      sql.write("CREATE TABLE Point(cid INTEGER PRIMARY KEY,");
      sql.write("  pointId vahrcahr(10),");
      sql.write("  pointName varchar(50),");
      sql.write("  pointNo varchar(50),");
      sql.write("  level varchar(50),");
      sql.write("  isFiexed varchar(10),");
      sql.write("  shotMinNumber varchar(10),");
      sql.write("  shotMaxNumber varchar(10),");
      sql.write("  fixedShot varchar(10),");
      sql.write("  usuallyShot varchar(10),");
      sql.write("  routeName varchar(50),");
      sql.write("  classifyNames varchar(50),");
      sql.write("  chargePerson varchar(50),");
      sql.write("  departmentName varchar(50),");
      sql.write("  classify TEXT,");
      sql.write("  inputItems TEXT");
      sql.write("  );");
      await db.execute(sql.toString());
      print("CREATE TABLE Point OK!");
      return true;
    } catch (e) {
      print("CREATE TABLE Point Error:$e");
      return false;
    }
  }

  Future<bool> createClassifyTable(Database db) async {
    bool exists = await checkTableExists(db,"Classify");
    if (exists) {
      await db.execute("DROP TABLE Classify;");
      print("DROP TABLE Classify OK!");
    }
    try {
      StringBuffer sql = new StringBuffer();
      sql.write("CREATE TABLE Classify(cid INTEGER PRIMARY KEY,");
      sql.write("classifyId varchar(10),");
      sql.write("pointId varchar(10),");
      sql.write("classifyName varchar(50)");
      sql.write(");");
      await db.execute(sql.toString());
      print("CREATE TABLE Classify OK!");
      return true;
    } catch (e) {
      print("CREATE TABLE Classify Error:$e");
      return false;
    }
  }

  Future<bool> createInputItemTable(Database db) async {
    bool exists = await checkTableExists(db,"InputItem");
    if (exists) {
      await db.execute("DROP TABLE InputItem;");
      print("DROP TABLE InputItem OK!");
    }
    try {
      StringBuffer sql = new StringBuffer();
      sql.write(" CREATE TABLE InputItem(cid INTEGER PRIMARY KEY,");
      sql.write(" id varchar(10),");
      sql.write(" pointId varchar(10),  ");
      sql.write("	createDate varchar(50),");
      sql.write("	catalogId varchar(50),");
      sql.write("	createBy varchar(50),");
      sql.write("	dataJson varchar(1000),");
      sql.write("	defaultValue varchar(50),");
      sql.write("	inputJson varchar(1000),");
      sql.write("	isMultiline varchar(10),");
      sql.write("	isMust varchar(10),");
      sql.write("	isScore varchar(10),");
      sql.write("	itemType varchar(10),");
      sql.write("	name varchar(100),");
      sql.write("	orderNo varchar(10),");
      sql.write("	orgCode varchar(50),");
      sql.write("	pictureJson varchar(4000),");
      sql.write("	remark varchar(500),");
      sql.write("	isDelete varchar(10),");
      sql.write("	pOrderNo varchar(10),");
      sql.write("	pointItemId varchar(10),");
      sql.write("	classifyNames varchar(20),");
      sql.write("	classifyIds varchar(20)");
      sql.write("	)");

      await db.execute(sql.toString());
      print("CREATE TABLE InputItem OK!");
      return true;
    } catch (e) {
      print("CREATE TABLE InputItem Error:$e");
      return false;
    }
  }

  Future<bool> createCheckReordTable(Database db) async {
    bool exists = await checkTableExists(db,"CheckReord");
    if (exists) {
      db.execute("DROP TABLE CheckReord;");
      print("DROP TABLE CheckReord!");
    }
    try {
      StringBuffer sql = new StringBuffer();
      sql.write("CREATE TABLE CheckReord(cid INTEGER PRIMARY KEY,");
      sql.write("  recordJson text,");
      sql.write("  filePaths text");
      sql.write("  );");
      await db.execute(sql.toString());
      print("CREATE TABLE CheckReord OK!");
      return true;
    } catch (e) {
      print("CREATE TABLE CheckReord Error:$e");
      return false;
    }
  }

  Future<bool> createTasksTable(Database db) async{
    bool exists = await checkTableExists(db,"Tasks");
    if (exists) {
      db.execute("DROP TABLE Tasks;");
      print("DROP TABLE Tasks!");
    }
    try {
      StringBuffer sql = new StringBuffer();
      sql.write("CREATE TABLE Tasks(cid INTEGER PRIMARY KEY,");
      sql.write("  id varchar(10),");
      sql.write("  title varchar(50),");
      sql.write("  publishTime varchar(20),");
      sql.write("  executor varchar(10),");
      sql.write("  status varchar(10),");
      sql.write("  jsonTask text,");
      sql.write("  jsonTaskDetail text");
      sql.write("  );");
      await db.execute(sql.toString());
      print("CREATE TABLE Tasks OK!");
      return true;
    } catch (e) {
      print("CREATE TABLE Tasks Error:$e");
      return false;
    }
  }

  Future<bool> createFeedbackTaskTable(Database db) async{
    bool exists = await checkTableExists(db,"FeedbackTask");
    if (exists) {
      db.execute("DROP TABLE FeedbackTask;");
      print("DROP TABLE FeedbackTask!");
    }
    try {
      StringBuffer sql = new StringBuffer();
      sql.write("CREATE TABLE FeedbackTask(cid INTEGER PRIMARY KEY,");
      sql.write("  id varchar(10),");
      sql.write("  title varchar(50),");
      sql.write("  publishTime varchar(20),");
      sql.write("  executor varchar(10),");
      sql.write("  status varchar(10),");
      sql.write("  jsonData text,");
      sql.write("  jsonPictures text");
      sql.write("  );");
      await db.execute(sql.toString());
      print("CREATE TABLE FeedbackTask OK!");
      return true;
    } catch (e) {
      print("CREATE TABLE FeedbackTask Error:$e");
      return false;
    }
  }

  Future<bool> checkTableExists(Database db,String tableName) async {
    try {
      var sql =
          "select * from sqlite_master where type = 'table' and name = '$tableName'";
      List<Map<String, dynamic>> lst = await db.rawQuery(sql);
      if(null == lst){
        lst = new List();
      }
      if(lst.length > 0){
        return true;
      }else{
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loadPlanData(Database db) async {
    dynamic dataPlan;
    //访问API获取数据
    try {
      dataPlan = await HttpUtil().get(ApiAddress.OFFLINE_QUERYPLANTASK);
      print('获取同步数据，巡检计划：$dataPlan');
    } catch (e) {
      print("访问$ApiAddress.OFFLINE_QUERYPLANTASK 失败！");
      return false;
    }
    //清空表数据
    try {
      // 删除当前登陆用户的计划数据
      await db.execute("delete from PlanInspection");
      print("delete from PlanInspection OK!");
    } catch (e) {
      print("delete from PlanInspection Error:$e");
      return false;
    }
    //导入数据
    try {
      var count = 0;
      StringBuffer sql;
      for (var plan in dataPlan["dataList"]) {
        // 插入计划
        sql = new StringBuffer();
        sql.write("insert into PlanInspection(");
        sql.write("planTaskId,");
        sql.write("taskName,");
        sql.write("beginTime,");
        sql.write("endTime,");
        sql.write("batchNo,");
        sql.write("finishStatus,");
        sql.write("userId,");
        sql.write("finshNum,");
        sql.write("taskPlanNum,");
        sql.write("inOrder,");
        sql.write("orgCode");
        sql.write(")");
        sql.write("values");
        sql.write("(");
        sql.write("'" + plan['planTaskId'].toString() + "',");
        sql.write("'" + plan['taskName'].toString() + "',");
        sql.write("'" + plan['beginTime'].toString() + "',");
        sql.write("'" + plan['endTime'].toString() + "',");
        sql.write("'" + plan['batchNo'].toString() + "',");
        // 已超时，本地为 已执行
        if(plan['finishStatus'].toString() == '3'){
          sql.write("'2',"); // 已执行
        }else{
          sql.write("'" + plan['finishStatus'].toString() + "',"); // 计划所有点都巡检完成，此状态修改为 2：已执行
        }
        sql.write("'" + plan['userId'].toString() + "',");
        sql.write("'" + plan['finshNum'].toString() + "',");
        sql.write("'" + plan['taskPlanNum'].toString() + "',");
        sql.write("'" + plan['inOrder'].toString() + "',");
        sql.write("'" + plan['orgCode'].toString() + "'");
        sql.write(")");
        await db.execute(sql.toString());
        print("insert into PlanInspection id:${plan['planTaskId']} OK!");

        // 插入计划相关点
        var jsonPoints = plan["points"];
        for (var point in jsonPoints) {
          sql = new StringBuffer();
          sql.write("insert into PlanInspectionPoint(");
          sql.write("pointId,");
          sql.write("planTaskId,");
          sql.write("taskName,");
          sql.write("routeId,");
          sql.write("name,");
          sql.write("pointNO,");
          sql.write("offline,");
          sql.write("status,");
          sql.write("isFixed,");
          sql.write("orderNo,");
          sql.write("classify,");
          sql.write("inputItems");
          sql.write(")");
          sql.write("values");
          sql.write("(");
          sql.write("'" + point['pointId'].toString() + "',");
          sql.write("'" + point['planTaskId'].toString() + "',");
          sql.write("'" + point['taskName'].toString() + "',");
          sql.write("'" + point['routeId'].toString() + "',");
          sql.write("'" + point['name'].toString() + "',");
          sql.write("'" + point['pointNO'].toString() + "',");
          sql.write("'" + point['offline'].toString() + "',");
          // 0:未开始
          if("0" == point['status'].toString()){
            sql.write("'0',"); // 本地标识为 未巡检
          }else{
            sql.write("'1',"); // 本地标识为 已巡检
          }
          sql.write("'" + point['isFixed'].toString() + "',");

          sql.write("'" + point['orderNo'].toString() + "',");
          // 检查项分类
          var classify = json.encode(point['classify']);
          sql.write("'$classify',");
          // 所有检查项
          var inputItems = json.encode(point['inputItems']);
          sql.write("'$inputItems'");
          sql.write(")");
          await db.execute(sql.toString());
          print("insert into PlanInspectionPoint id:${point['pointId']} OK!");
        }
        count++;
      }
      print("insert into PlanInspection OK! Count:" + count.toString());
    } catch (e) {
      print("insert into PlanInspection Error:$e");
      return false;
    }
    return true;
  }

  Future<bool> loadTaskData(Database db) async {
    dynamic taskData;
    //获取API数据
    try {
      taskData = await HttpUtil().get(ApiAddress.QUERY_OFFLINE_TASKS);
      print('获取同步数据，任务：$taskData');
    } catch (e) {
      print("访问$ApiAddress.QUERY_OFFLINE_TASKS 失败！");
      return false;
    }
    //TODO 清空数据库数据
    try {
      await db.execute("delete from Tasks");
      print("delete from Tasks OK!");
    } catch (e) {
      print("delete from Tasks Error:$e");
      return false;
    }
    //TODO 导入数据
    try {
      var count = 0;
      StringBuffer sql;
      for (var task in taskData["dataList"]) {
        sql = new StringBuffer();
        sql.write("insert into Tasks(");
        sql.write("id,");
        sql.write("title,");
        sql.write("publishTime,");
        sql.write("executor,");
        sql.write("status,");
        sql.write("jsonTask,");
        sql.write("jsonTaskDetail");
        sql.write(")");
        sql.write("values");
        sql.write("(");
        sql.write("'" + task['id'].toString() + "',");
        sql.write("'" + task['title'].toString() + "',");
        sql.write("'" + task['publishTime'].toString() + "',");
        sql.write("'" + task['executor'].toString() + "',");
        sql.write("'" + task['status'].toString() + "',");

        var strTask = json.encode(task['task']);
        sql.write("'$strTask',");

        var strTaskDetail = json.encode(task['taskDetail']);
        sql.write("'$strTaskDetail'");

        sql.write(")");

        await db.execute(sql.toString());
        print("insert into Tasks id:${task['id']} OK!");
        count++;
      }
      print("insert into Tasks OK! Count:" + count.toString());
    } catch (e) {
      print("insert into Tasks Error:$e");
      return false;
    }
    return true;
  }

  Future<bool> loadPointData(Database db) async {
    dynamic pointData;
    try {
      pointData = await HttpUtil().get(ApiAddress.QUERY_OFFLINE_POINT);
      print('同步数据，巡检点：$pointData');
    } catch (e) {
      print("访问$ApiAddress.QUERY_OFFLINE_POINT 失败！");
      return false;
    }

    try {
      await db.execute("delete from Point");
      print("delete from Point OK!");
    } catch (e) {
      print("delete from Point Error:$e");
      return false;
    }

    try {
      var count = 0;
      StringBuffer sql;
      for (var point in pointData["dataList"]) {
        sql = new StringBuffer();
        sql.write("insert into Point(");
        sql.write("pointId,");
        sql.write("pointName,");
        sql.write("pointNo,");
        sql.write("level,");
        sql.write("isFiexed,");
        sql.write("shotMinNumber,");
        sql.write("shotMaxNumber,");
        sql.write("fixedShot,");
        sql.write("usuallyShot,");
        sql.write("routeName,");
        sql.write("classifyNames,");
        sql.write("chargePerson,");
        sql.write("departmentName,");
        sql.write("classify,");
        sql.write("inputItems");
        sql.write(")");
        sql.write("values");
        sql.write("(");
        sql.write("'" + point['pointId'].toString() + "',");
        sql.write("'" + point['pointName'].toString() + "',");
        sql.write("'" + point['pointNo'].toString() + "',");
        sql.write("'" + point['level'].toString() + "',");
        sql.write("'" + point['isFiexed'].toString() + "',");
        sql.write("'" + point['shotMinNumber'].toString() + "',");
        sql.write("'" + point['shotMaxNumber'].toString() + "',");
        sql.write("'" + point['fixedShot'].toString() + "',");
        sql.write("'" + point['usuallyShot'].toString() + "',");
        sql.write("'" + point['routeName'].toString() + "',");
        sql.write("'" + point['classifyNames'].toString() + "',");
        sql.write("'" + point['chargePerson'].toString() + "',");
        sql.write("'" + point['departmentName'].toString() + "',");

        var classify = json.encode(point['classify']);
        sql.write("'$classify',");

        var inputItems = json.encode(point['inputItems']);
        sql.write("'$inputItems'");

        sql.write(")");

        await db.execute(sql.toString());
        print("insert into Point PointId:$point['pointId'] OK!");
        count++;
      }
      print("insert into Point OK! Count:" + count.toString());
    } catch (e) {
      print("insert into Point Error:$e");
      return false;
    }
    return true;
  }

  // 保存巡检记录
  Future<bool> insertCheckRecord(Database db,String jsonData, String filesPaths) async {
    try {
      StringBuffer sql;
      sql = new StringBuffer();
      sql.write("insert into CheckReord(");
      sql.write("recordJson,");
      sql.write("filePaths");// 有ItemID的是属于检查项的，没有的是检查点的
      sql.write(")");
      sql.write("values");
      sql.write("(");
      sql.write("'$jsonData',");
      sql.write("'$filesPaths'");
      sql.write(")");
      await db.execute(sql.toString());

      // 更新状态
      var recordData = json.decode(jsonData);
      if(null != recordData["pointId"] && null != recordData["planTaskId"] && recordData["planTaskId"] != 0){
        // 更新本地，计划，以及其对应点的状态
        await db.execute("update PlanInspectionPoint set status = ? where pointId = ? and planTaskId = ? ", ["1", recordData["pointId"], recordData["planTaskId"]]);
        // 查询未巡检点个数
        List<Map<String, dynamic>> noexecpoints = await db.rawQuery("select count(1) as ct from PlanInspectionPoint where planTaskId = ? and status = '0'", [recordData["planTaskId"]]);
        print(noexecpoints);
        if(null != noexecpoints && noexecpoints.length > 0){
          Map<String, dynamic> count = noexecpoints[0];
          if(null != count && null != count["ct"]){
            int ct = JunMath.parseInt(count["ct"].toString());
            // 更新剩余数量
            await db.execute("update PlanInspection set finshNum = taskPlanNum - ? where planTaskId = ? ", [ct, recordData["planTaskId"]]);
            if(ct == 0){ // 更新计划状态为已结束
              await db.execute("update PlanInspection set finishStatus = ? where planTaskId = ? ", ["2", recordData["planTaskId"]]);
            }
          }
        }
      }
      print("insert into CheckReord OK!");
    } catch (e) {
      print("insert into Point Error:$e");
      return false;
    }
    return true;
  }


  Future<List<Map<String, dynamic>>> getCheckRecords(Database db) async {
    try {
      var sql = new StringBuffer();
      sql.write("select ");
      sql.write("* ");
      sql.write("from CheckReord;");
      List<Map<String, dynamic>> lst = await db.rawQuery(sql.toString());
      if(null == lst){
        lst = new List();
      }
     return lst;
    } catch (e) {
      print(e);
      return new List();
    }
  }

  Future<List<Map<String,dynamic>>> getPoints(Database db) async{
    try {
      var sql = new StringBuffer();
      sql.write("select ");
      sql.write("* ");
      sql.write("from Point");
      List<Map<String, dynamic>> lst = await db.rawQuery(sql.toString());
      if(null == lst){
        lst = new List();
      }
      return lst;
    } catch (e) {
      print(e);
      return new List();
    }
  }

  Future<List<Map<String,dynamic>>> getPlanInspections(Database db) async{
    try {
      var sql = new StringBuffer();
      sql.write("select ");
      sql.write("* ");
      sql.write("from PlanInspection");
      List<Map<String, dynamic>> lst = await db.rawQuery(sql.toString());
      if(null == lst){
        lst = new List();
      }
      return lst;
    } catch (e) {
      print(e);
      return new List();
    }
  }

  Future<Map<String,dynamic>> getPlanInspectionById(Database db, int planId) async{
    try {
      // 查询参数
      List<dynamic> arguments = new List();
      if(null == planId){
        planId = 0;
      }
      arguments.add(planId);
      var sql = new StringBuffer();
      sql.write("select ");
      sql.write("* ");
      sql.write("from PlanInspection where planTaskId = ?");
      List<Map<String, dynamic>> lst = await db.rawQuery(sql.toString(), arguments);
      if(null == lst){
        return null;
      }
      return lst[0];
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Map<String,dynamic>>> getPlanInspectionPoints(Database db, int planId) async{
    // 查询参数
    List<dynamic> arguments = new List();
    if(null == planId){
      planId = 0;
    }
    arguments.add(planId);
    try {
      var sql = new StringBuffer();
      sql.write("select ");
      sql.write("* ");
      sql.write("from PlanInspectionPoint where planTaskId = ?");
      List<Map<String, dynamic>> lst = await db.rawQuery(sql.toString(), arguments);
      if(null == lst){
        lst = new List();
      }
      return lst;
    } catch (e) {
      print(e);
      return new List();
    }
  }

  Future<List<Map<String,dynamic>>> queryData(String sql,[List<dynamic> arguments]) async{

    try {
      Database db = await openDb();
      List<Map<String, dynamic>> lst = await db.rawQuery(sql,arguments);
      await db.close();
      return lst;
    } catch (e) {
      print(e);
      return new List();
    }
  }

  Future<bool> excuteSql(String sql,[List<dynamic> arguments]) async{
    try{
      Database db = await openDb();
      await db.execute(sql,arguments);
      await db.close();
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> closeDb(Database db) async{
    try{
      await db.close();
      print("db.close OK");
      return true;
    }catch(e){
      print("close db Error:$e");
      return false;
    }
  }
}
