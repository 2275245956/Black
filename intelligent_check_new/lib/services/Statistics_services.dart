import 'package:intelligent_check_new/model/APIResponse.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

Future<APIResponse> getStatisticsList() async {
  try {
    var data = await HttpUtil().get(ApiAddress.STATISTICS_LIST);

    return APIResponse.fromJson(data);
  } catch (e) {
    throw e;
  }
}

Future<APIResponse> getStatisticsDetailByType(String type) async {
  try {
    var data = await HttpUtil().get(ApiAddress.STATISTICS_TYPE_DETAIL + "/$type");
    return APIResponse.fromJson(data);
  } catch (e) {
    throw e;
  }
}
