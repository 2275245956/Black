import 'dart:convert' show json;
import 'package:intelligent_check_new/model/task_calendar/calendar_main_model.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

Future<CalendarModel> checkCalendar(String date, num routeId) async{
  // 根据输入参数拼接请求body
  List<Map> request = new List();

  // 时间
  if(null != date && "" != date){
    request.add({"name": "checkTime", "type": "EQUAL",  "value" :date});
  }

  // 巡检线路
  if(null != routeId && -1 != routeId){
    request.add({"name": "routeId", "type": "EQUAL", "value" :routeId});
  }

  CalendarModel resultData;
  List<CalendarDataModel> calendarData = List();

  var data = await HttpUtil().post(ApiAddress.CHECK_CALENDAR, data: json.encode(request));
  if(data["result"] == "SUCCESS"){
    var dataList = data["dataList"];

    resultData = CalendarModel.fromJson(dataList["charData"]);

    Map<String,dynamic> _data = dataList["calendarData"];
    _data.forEach((k,v){
      num qualified = 0;
      num unqualified = 0;
      num omission = 0;
      for(var _detail in v){
        if (_detail["status"] == "1") {
          qualified= _detail["count"];
        }
        if (_detail["status"] == "2") {
          unqualified= _detail["count"];
        }
        if (_detail["status"] == "3") {
          omission= _detail["count"];
        }
      }
      CalendarDataModel calendarDataModel = CalendarDataModel.fromParams(omission:omission, qualified:qualified, unqualified:unqualified,date:k);
      calendarData.add(calendarDataModel);
    });

    resultData.calendarData = calendarData;
    return resultData;
  }else{
    return resultData;
  }
}

