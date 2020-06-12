import 'package:intelligent_check_new/model/PageDto.dart';
import 'package:intelligent_check_new/model/message/MessageDetail.dart';
import 'package:intelligent_check_new/model/message/MessageType.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

Future<Map<String,dynamic>> getMessgaeType() async{

  Map<String,dynamic> rstData = Map();
  var data = await HttpUtil().get(ApiAddress.MESSAGE_TYPE);
  if(data["result"]=="SUCCESS"){
    var datalist = data["dataList"];
    if(datalist != null && datalist.toString()!="[]"){
      for(var _item in datalist){
        rstData.addAll(_item);
      }
    }
  }
 return rstData;
}

Future<PageDto> getMessageList(MessageType condition,[num pageNumber=0,num pageSize=10])async{
  Map request = Map();
  request["type"] = "EQUAL";
  request["name"] = "msgType";
  if(condition != null && condition.id != "-1"){
    request["value"] = condition.id;
  }
  List<Map> request_data = List();
  request_data.add(request);
  var data = await HttpUtil().post(ApiAddress.MESSAGE_LIST+"?pageNumber=$pageNumber",data: request_data);
  if (data["result"] == "SUCCESS" ) {
    return PageDto.fromParams(content: data["dataList"]["content"],last: data["dataList"]["last"]);
  }else{
    return null;
  }
}

Future<MessageDetail> getMessageById(int id)async{
  Map request = Map();
  request["name"] = "id";
  if(id > 0){
    request["value"] = id;
  }
  List<Map> request_data = List();
  request_data.add(request);
  var data = await HttpUtil().post(ApiAddress.MESSAGE_LIST,data: request_data);
  if (data["result"] == "SUCCESS" ) {
    List<dynamic> ccontent = data["dataList"]["content"];
    if(null != ccontent && ccontent.length > 0){
      return MessageDetail.fromJson(ccontent[0]);
    }else{
      return null;
    }
  }else{
    return null;
  }
}

Future getMessgaeRead(num MsgId) async{
  HttpUtil().post(ApiAddress.MESSAGE_READ,data:MsgId);
}