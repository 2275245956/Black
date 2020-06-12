import 'dart:convert' show json;

class MyInfoModel {
  String username;
  String userdepartment;
  String useremail;
  int userid;
  String sex;
  String avatarUrl;

  MyInfoModel.fromParams({
    this.username,
    this.userdepartment,
    this.useremail,
    this.userid,
    this.sex,
    this.avatarUrl,
  });

  factory MyInfoModel(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new MyInfoModel.fromJson(json.decode(jsonStr))
          : new MyInfoModel.fromJson(jsonStr);

  MyInfoModel.fromJson(jsonRes) {
    username = jsonRes['username'];
    userdepartment = jsonRes['userdepartment'];
    useremail = jsonRes['useremail'];
    userid = jsonRes['userid'];
    sex = jsonRes['sex'];
    avatarUrl = jsonRes['userhead'];
  }

  @override
  String toString() {
    return '{"userdepartment": ${userdepartment != null ? '${json.encode(userdepartment)}' : 'null'},"useremail": ${useremail != null ? '${json.encode(useremail)}' : 'null'},"userid": $userid,"sex": ${sex != null ? '${json.encode(sex)}' : 'null'},"userhead": ${avatarUrl != null ? '${json.encode(avatarUrl)}' : 'null'},"username": ${username != null ? '${json.encode(username)}' : 'null'}}';
  }
}
