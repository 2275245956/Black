import 'package:intelligent_check_new/model/APIResponse.dart';
import 'package:intelligent_check_new/model/Task/FeedbackDto.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import "package:intelligent_check_new/model/Task/TaskModel.dart";
import 'package:intelligent_check_new/model/Task/TaskContentResult.dart';
import 'package:intelligent_check_new/model/Task/TaskContentInput.dart';
import 'dart:convert' show json;
import 'package:intelligent_check_new/model/Task/ChartResult.dart';
import 'package:intelligent_check_new/model/Task/ProcessInfo.dart';
import 'package:intelligent_check_new/model/Task/TaskAddModel.dart';

//获取全部任务列表
Future<List<TaskContent>> getAllTaskList(
    TaskContentInput taskContentInput,String userId,num type) async {
  // 0 全部 1我接收 2我发起
  try {
    // 根据输入参数拼接请求body
    List<Map> request = new List();

    if(type ==1){
      // executorID
      if (null != userId && -1 != userId) {
        request.add({"name": "executorId", "value": userId});
      }
    }

    if(type ==2){
      // publisher
      if (null != userId && -1 != userId) {
        request.add({"name": "publisher", "value": userId});
      }
    }

    // 开始时间
    if (null != taskContentInput.startTime &&
        "" != taskContentInput.startTime) {
      request.add({"name": "startTime", "value": taskContentInput.startTime});
    }
    // 结束时间
    if (null != taskContentInput.endTime && "" != taskContentInput.endTime) {
      request.add({"name": "endTime", "value": taskContentInput.endTime});
    }

    // 部门
    if(null != taskContentInput.departmentId /*&& -1 != filter.departmentId*/){
      request.add({"name": "departmentId", "value" :taskContentInput.departmentId});
    }

//    print(json.encode(request));
    // 调用接口查询数据
    var data = await HttpUtil().post(ApiAddress.TASK_INFO_BYFILTER, data: json.encode(request));
    List<TaskContent> list = List();
    if (data["result"] == "SUCCESS") {
      var quan = data["dataList"];
      if (data["dataList"].toString() != "[]") {
        print(quan.toString());
        List responseJsons;
        responseJsons = data["dataList"];
        print("qyq" + responseJsons[0].toString());
        for (var responseJson in responseJsons) {
          list.add(TaskContent.fromJson(responseJson));
        }
        print("qyq" + list[0].toString());
      }
    }
    return list;
  } catch (e) {
    throw (e);
  }
}

Future<ChartResult> getChart(TaskContentInput taskContentInput,String userId,num type) async {
  try {
    // 根据输入参数拼接请求body
    List<Map> request = new List();

    if(type ==1){
      // executorID
      if (null != userId && "" != userId) {
        request.add({"name": "executorId", "value": userId});
      }
    }

    if(type ==2){
      // publisher
      if (null != userId && -1 != userId) {
        request.add({"name": "publisher", "value": userId});
      }
    }
//    // executorID
//    if (null != taskContentInput.executorId &&
//        -1 != taskContentInput.executorId) {
//      request.add({"name": "executorId", "value": taskContentInput.executorId});
//    }
    // 开始时间
    if (null != taskContentInput.startTime &&
        "" != taskContentInput.startTime) {
      request.add({"name": "startTime", "value": taskContentInput.startTime});
    }
    // 结束时间
    if (null != taskContentInput.endTime && "" != taskContentInput.endTime) {
      request.add({"name": "endTime", "value": taskContentInput.endTime});
    }

    // 部门
    if(null != taskContentInput.departmentId /*&& -1 != filter.departmentId*/){
      request.add({"name": "departmentId", "value" :taskContentInput.departmentId});
    }
//    // publisher
//    if (null != taskContentInput.publisher &&
//        -1 != taskContentInput.publisher) {
//      request.add({"name": "publisher", "value": taskContentInput.publisher});
//    }
//    print(json.encode(request));
    // 调用接口查询数据
    var data = await HttpUtil()
        .post(ApiAddress.TASK_CHARTS, data: json.encode(request));
    ChartResult chartResult;
    if (data["result"] == "SUCCESS") {
      if (data["dataList"].toString() != "[]") {
        chartResult = ChartResult(data["dataList"]);
      }
    }
    print(data);
    return chartResult;
  } catch (e) {
    throw (e);
  }
}

Future<TaskModel> getTask(String taskid) async {
  /* final pref = await SharedPreferences.getInstance();
  String token = pref.get("user_token");
  Options options = Options(headers: { "X-Access-Token": token,"taskID": taskid});*/
  try {
    // 调用接口查询数据
    // var data = await HttpUtil().getOptional(ApiAddress.TASK_Details, options: options);
    var data =
        await HttpUtil().get(ApiAddress.TASK_Details, data: {"taskID": taskid});
    TaskModel taskModel;
    if (data["result"] == "SUCCESS") {
      if (data["dataList"].toString() != "[]") {
        taskModel = TaskModel(data["dataList"]);
      }
    }
    //print(data);
    return taskModel;
  } catch (e) {
    throw (e);
  }
}

Future getForward(int taskid, String userid) async {
  try {
    // 调用接口查询数据
    var data = await HttpUtil().get(ApiAddress.TASK_Forward,
        data: {"taskID": taskid, "userId": userid});
    if(data["result"].toString()=="SUCCESS" && data["success"].toString()== "true"){
      return true;
    }else{
      return false;
    }
  } catch (e) {
    throw (e);
  }
}

Future<List<ProssingInfo>> getProcessInfo(int taskid) async {
  /* final pref = await SharedPreferences.getInstance();
  String token = pref.get("user_token");
  Options options = Options(headers: { "X-Access-Token": token,"taskID": taskid});*/
  try {
    // 调用接口查询数据
    // var data = await HttpUtil().getOptional(ApiAddress.TASK_Details, options: options);
    var data =
        await HttpUtil().get(ApiAddress.PROCESSINFO, data: {"taskId": taskid});
    List<ProssingInfo> list = List();
    if (data["result"] == "SUCCESS") {
      if (data["dataList"].toString() != "[]") {
        print(data["dataList"].toString());
        List responseJsons;
        responseJsons = data["dataList"];
        print(responseJsons[0].toString());
        for (var responseJson in responseJsons) {
          list.add(ProssingInfo.fromJson(responseJson));
        }
        print(list[0].toString());
      }
    }
    return list;
  } catch (e) {
    throw (e);
  }
}

Future postTaskAdd(TaskAddModel task) async {
  /* final pref = await SharedPreferences.getInstance();
  String token = pref.get("user_token");
  Options options = Options(headers: { "X-Access-Token": token,"taskID": taskid});*/
  try {
    // 调用接口查询数据
    // var data = await HttpUtil().getOptional(ApiAddress.TASK_Details, options: options);
    var data =
        await HttpUtil().post(ApiAddress.TASK_ADD, data: task.toString());
    //print(data);
  } catch (e) {
    throw (e);
  }
}

Future<bool> taskAddNew(TaskInfoForAdd _taskInfoForAdd, List<TaskDetailForAdd> details) async {
  TaskAdd _taskAdd = TaskAdd();
  _taskAdd.taskInfo = _taskInfoForAdd;
  _taskAdd.taskDetails = details;

  var data =
      await HttpUtil().post(ApiAddress.TASK_ADD_NEW, data: _taskAdd.toString());
  if (data["result"] == "FAILURE") {
    return false;
  } else {
    if (data["success"] == "false") {
      return false;
    } else {
      return true;
    }
  }
}

// 巡检记录不合格项（从不合格记录中添加任务时，调用查询不合格项）
Future<List<TaskErrorItem>> queryUnqualifiedInputItem(num checkId) async {
  var data = await HttpUtil()
      .get(ApiAddress.QUERY_UNQUALIFIED_INPUT_ITEM, data: {"checkId": checkId});
  List<TaskErrorItem> rst = List();
  if (data["result"] == "SUCCESS") {
    var dataList = data["dataList"];
    if (dataList.toString() != "[]") {
      for (var item in dataList) {
        rst.add(TaskErrorItem.fromJson(item));
      }
    }
  }

  return rst;
}

Future<bool> cancelTask(num taskId) async{
  var data = await HttpUtil().put(ApiAddress.CANCEL_TASK+"?taskIds=$taskId&status=2");
  return data["success"];
}


Future<APIResponse> savePorcessInfo(FeedbackDto dto) async {
  try {
    if(null == dto){
      return APIResponse.error("必填参数不能为空！");
    }
    var data = await HttpUtil().post(ApiAddress.TASK_FEEDBACKTASK, data: dto.toString());
    return APIResponse(data);
  } catch (e) {
    return APIResponse.error("保存失败！");
  }
}
