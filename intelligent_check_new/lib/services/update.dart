import 'package:intelligent_check_new/model/version.dart';
import 'package:intelligent_check_new/tools/HttpUtil.dart';

Future<Version> checkNewVersion(String url) async {
  var res = await HttpUtil().getForUpdate(url,useLocalUrl: false);
//  var data = json.decode(res);
  Version version = new Version();
  version.version = res["version"];
  version.constraint = res["constraint"];
  version.apkUrl = res["apkUrl"];
  version.updateInfo=res["updateInfo"];
  return version;
}