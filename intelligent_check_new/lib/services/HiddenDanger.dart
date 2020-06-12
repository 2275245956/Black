import 'dart:convert' show json;
import 'package:dio/dio.dart';
import 'package:intelligent_check_new/model/APIResponse.dart';
import 'package:intelligent_check_new/model/Hidden_Danger/hidden_danger_model.dart';
import 'package:intelligent_check_new/model/MovePointAttachment.dart';
import 'package:intelligent_check_new/model/PageDto.dart';
import 'package:intelligent_check_new/model/Task/TaskAddModel.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

//列表查询
Future<PageDto> getHiddenDangerList(HiddenDangerFilter filter) async {
  try {
    // 根据输入参数拼接请求body

    var datas = {
      "dangerLevel": filter.dangerLevel,
      "pageSize": filter.pageSize,
      "pageNumber": filter.pageIndex,
      "isHandle": filter.isHandle,
      "dangerState": filter.dangerState,
      "belongType": filter.belongType,
    };

    var data = await HttpUtil()
        .post(ApiAddress.HIDDEN_DANGER_LIST, data: json.encode(datas));

    PageDto pageDto;
    //具体实现函数待编写
    if (data["result"] == "SUCCESS") {
      pageDto = PageDto.fromJson(data["dataList"]);
    } else {
      pageDto = PageDto.fromJson({});
    }
    return pageDto;
  } catch (e) {
    throw e;
  }
}

//模糊查询
Future<PageDto> getHiddenDangerByLikeName(HiddenDangerFilter filter) async {
  try {
    // 根据输入参数拼接请求body

    var datas = {
      "dangerLevel": filter.dangerLevel,
      "pageSize": filter.pageSize,
      "pageNumber": filter.pageIndex,
      "dangerName": filter.dangerName,
      "dangerState": filter.dangerState,
      "belongType": filter.belongType,
    };
    var data = await HttpUtil()
        .post(ApiAddress.HIDDEN_DANGER_LIST, data: json.encode(datas));
    // var data=await HttpUtil().get('/api/latent/danger/detail?id=14');
    PageDto pageDto;
    //具体实现函数待编写
    if (data["result"] == "SUCCESS") {
      pageDto = PageDto.fromJson(data["dataList"]);
    } else {
      pageDto = PageDto.fromJson({});
    }
    return pageDto;
  } catch (e) {
    throw e;
  }
}

//获取隐患信息
Future<HideDangerInfoModel> getHiddenDangerModel(int dangerId) async {
  try {
    var data =
        await HttpUtil().get(ApiAddress.HIDDEN_DANGER_DETAIL + "?id=$dangerId");

    if (data["result"] == "SUCCESS" && data["dataList"] != null) {
      var infoModels = HideDangerInfoModel.fromJson(data["dataList"]);


      return infoModels;
    } else {
      return null;
    }
  } catch (e) {
    throw e;
  }
}

//保存普通隐患信息
Future<bool> saveHideDangerInfo(HideDanger hidedanger) async {
  try {
    // 根据输入参数拼接请求body
    var jsonData = {
      "dangerLevel": hidedanger.dangerLevel,
      "dangerName": hidedanger.dangerName.text,
      "dangerPosition": hidedanger.dangerPlace.text,
      "limitDate": hidedanger.limitDate.text,
      "photoUrls": hidedanger.photoUrls,
      "remark": hidedanger.remark.text,
      "reviewUserIds": hidedanger.reviewUserIds
    };

    var data = await HttpUtil().post(ApiAddress.HIDDEN_DANGER_CREATE_NORMAL,
        data: json.encode(jsonData));
    if (data["result"] == "SUCCESS") {
      return true;
    }
    return false;
  } catch (e) {
    throw e;
  }
}

Future<APIResponse> saveInspectionDangerInfo(
  int checkedId, List<TaskDetailForAdd> details) async {
  try {
     var itemListStr=List();
      var checkId=checkedId;
      for(TaskDetailForAdd item in details){
        var itemStr={
          "dangerLevel":item.dangerLevel,
          "itemId":item.itemId,
          "limitDate":item.limitDate,
          "routePointItemId":item.routePointItemId
        };
        itemListStr.add(itemStr);
      }

      var jsonStr={
        "checkId": checkId,
        "itemList":  itemListStr
      };

    var data = await HttpUtil().post(ApiAddress.HIDDEN_DANGER_CREATE_PATROL,
        data: json.encode(jsonStr));
    return APIResponse.fromJson(data);
  } catch (e) {
    throw e;
  }
}

//保存图片
Future<APIResponse> updataImg(List<Attachment> fileList, String bizCode) async {
  try {
    List<String> imgUrls = new List();
    // 循环上传
    for (int i = 0; i < fileList.length; i++) {
      var uploadUrl = ApiAddress.HIDDEN_DANGER_IMGUPDATE + "?bizCode=$bizCode";

      String filename = fileList[i]
          .file
          .path
          .substring(fileList[i].file.path.lastIndexOf("/") + 1);
      // 开始上传
      FormData formData = new FormData.from(
          {"file": new UploadFileInfo(fileList[i].file, filename)});
      var data = await new HttpUtil().post(uploadUrl, data: formData);
      if (data["result"] == "SUCCESS") {
        //拼接文件路径名
        imgUrls.add(data["dataList"]);
      } else {
        return APIResponse.error("图片上传失败");
      }
    }

    if (imgUrls.length == 1) {
      return APIResponse.success(imgUrls[0]);
    }
    return APIResponse.success(imgUrls.join(","));
  } catch (e) {
    throw e;
  }
}

//保存评审、治理、验证 流程结果
Future<APIResponse> saveReviewResult(HideDanger hd, result, flowId, flowJson) async {
  try {
    var jsonData = {
      "excuteType": result,
      "flowJson": flowJson,
      "flowRecordId": flowId,
      "nextCanActionUser": hd.reviewUserIds.toString(),
      "reformLimitDate": hd.limitDate.text,
      "remark": hd.remark.text
    };
    var data = await HttpUtil()
        .post(ApiAddress.HIDDEN_DANGER_EXECUTE, data: json.encode(jsonData));
    if (data["result"] == "SUCCESS") {
     return APIResponse.success("执行成功！");
    } else {
      return APIResponse.error(data["message"]);
    }
  } catch (e) {
    throw e;
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



//获取隐患执行日志

Future<HideDangerInfoModel> getDangerFlowRrecord(int dangerId) async {
  try {
    var data =
    await HttpUtil().get(ApiAddress.HIDDEN_DANGER_FLOWRECORDS + "?id=$dangerId");

    if (data["result"] == "SUCCESS" && data["dataList"] != null) {
      var infoModels = HideDangerInfoModel.fromJson(data["dataList"]);
      return infoModels;
    } else {
      HiddenDangerFound.popUpMsg(data["message"]??"获取失败！");
      return null;
    }
  } catch (e) {
    throw e;
  }
}

