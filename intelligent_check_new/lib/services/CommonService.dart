import 'package:intelligent_check_new/model/Config.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

Future<List<Config>> getConfig() async{
  List<Config> configs = List();
  var data = await HttpUtil().get(ApiAddress.SYSTEM_CONFIG);


  if (data["result"] == "SUCCESS" ) {
    if(data["dataList"].toString() != "[]"){
      for(var _dataList in data["dataList"]) {
        Config config = Config.fromParams(
            id:_dataList["id"],
            createDate: _dataList["createDate"].toString(),
            des:_dataList["des"].toString(),
            name:_dataList["name"].toString(),
            attribute:_dataList["attribute"].toString());
        configs.add(config);
      }
    }
  }
  return configs;
}