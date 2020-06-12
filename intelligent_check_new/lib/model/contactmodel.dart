import 'dart:convert' show json;

class DepartmentList {
  List<ContactsByDep> list;

  DepartmentList.fromParams({this.list});

  factory DepartmentList(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new DepartmentList.fromJson(json.decode(jsonStr))
          : new DepartmentList.fromJson(jsonStr);

  DepartmentList.fromJson(jsonRes) {
    list = jsonRes == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes['list']) {
      list.add(listItem == null ? null : new ContactsByDep.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '{"json_list": $list}';
  }
}

class ContactsByDep {
  String department;
  List<ContactDetail> contact;

  ContactsByDep.fromParams({this.department, this.contact});

  ContactsByDep.fromJson(jsonRes) {
    department = jsonRes['department'];
    contact = jsonRes['contact'] == null ? null : [];

    for (var contactItem in contact == null ? [] : jsonRes['contact']) {
      contact.add(
          contactItem == null ? null : new ContactDetail.fromJson(contactItem));
    }
  }

  @override
  String toString() {
    return '{"department": ${department != null ? '${json.encode(department)}' : 'null'},"contact": $contact}';
  }
}

class ContactDetail {
  String avatarUrl;
  String info;
  String mail;
  String name;
  String sex;
  String tele;

  ContactDetail.fromParams(
      {this.avatarUrl, this.info, this.mail, this.name, this.sex, this.tele});

  ContactDetail.fromJson(jsonRes) {
    avatarUrl = jsonRes['avatarUrl'];
    info = jsonRes['info'];
    mail = jsonRes['mail'];
    name = jsonRes['name'];
    sex = jsonRes['sex'];
    tele = jsonRes['tele'];
  }

  @override
  String toString() {
    return '{"avatarUrl": ${avatarUrl != null ? '${json.encode(avatarUrl)}' : 'null'},"info": ${info != null ? '${json.encode(info)}' : 'null'},"mail": ${mail != null ? '${json.encode(mail)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'},"sex": ${sex != null ? '${json.encode(sex)}' : 'null'},"tele": ${tele != null ? '${json.encode(tele)}' : 'null'}}';
  }
}
