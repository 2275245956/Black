import 'dart:convert' show json;

class CompanyInfo {
  String level;
  bool checked;
  String code;
  String key;
  String label;
  String type;
  String value;

  CompanyInfo.fromParams({this.level, this.checked, this.code, this.key, this.label, this.type, this.value});

  factory CompanyInfo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CompanyInfo.fromJson(json.decode(jsonStr)) : new CompanyInfo.fromJson(jsonStr);

  CompanyInfo.fromJson(jsonRes) {
    level = jsonRes['level'];
    checked = jsonRes['checked'];
    code = jsonRes['code'];
    key = jsonRes['key'];
    label = jsonRes['label'];
    type = jsonRes['type'];
    value = jsonRes['value'];
  }

  @override
  String toString() {
    return '{"level": $level,"checked": $checked,"code": ${code != null?'${json.encode(code)}':'null'},"key": ${key != null?'${json.encode(key)}':'null'},"label": ${label != null?'${json.encode(label)}':'null'},"type": ${type != null?'${json.encode(type)}':'null'},"value": ${value != null?'${json.encode(value)}':'null'}}';
  }
}

class CompanyInfos{

  int companyOrgCode;
  String address;
  String companyName;
  String email;
  String landlinePhone;
  String latitude;
  String level;
  String longitude;
  String orgCode;
  String parentId;
  String sequenceNbr;

  CompanyInfos.fromParams({this.companyOrgCode, this.address, this.companyName, this.email, this.landlinePhone, this.latitude, this.level, this.longitude, this.orgCode, this.parentId, this.sequenceNbr});

  factory CompanyInfos(jsonStr) => jsonStr == null ? null : jsonStr is String ? new CompanyInfos.fromJson(json.decode(jsonStr)) : new CompanyInfos.fromJson(jsonStr);

  CompanyInfos.fromJson(jsonRes) {
    companyOrgCode = int.tryParse(jsonRes['companyOrgCode'].toString());
    address = jsonRes['address'];
    companyName = jsonRes['companyName'];
    email = jsonRes['email'];
    landlinePhone = jsonRes['landlinePhone'];
    latitude = jsonRes['latitude'];
    level = jsonRes['level'];
    longitude = jsonRes['longitude'];
    orgCode = jsonRes['orgCode'];
    parentId = jsonRes['parentId'];
    sequenceNbr = jsonRes['sequenceNbr'].toString();
  }

  @override
  String toString() {
    return '{"companyOrgCode": $companyOrgCode,"address": ${address != null?'${json.encode(address)}':'null'},"companyName": ${companyName != null?'${json.encode(companyName)}':'null'},"email": ${email != null?'${json.encode(email)}':'null'},"landlinePhone": ${landlinePhone != null?'${json.encode(landlinePhone)}':'null'},"latitude": ${latitude != null?'${json.encode(latitude)}':'null'},"level": ${level != null?'${json.encode(level)}':'null'},"longitude": ${longitude != null?'${json.encode(longitude)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"parentId": ${parentId != null?'${json.encode(parentId)}':'null'},"sequenceNbr": ${sequenceNbr != null?'${json.encode(sequenceNbr)}':'null'}}';
  }
}

class DeptInfo {

  int deptOrgCode;
  String companySeq;
  String departmentDesc;
  String departmentName;
  String orgCode;
  String parentId;
  String sequenceNbr;

  DeptInfo.fromParams({this.deptOrgCode, this.companySeq, this.departmentDesc, this.departmentName, this.orgCode, this.parentId, this.sequenceNbr});

  factory DeptInfo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new DeptInfo.fromJson(json.decode(jsonStr)) : new DeptInfo.fromJson(jsonStr);

  DeptInfo.fromJson(jsonRes) {
    deptOrgCode = int.tryParse(jsonRes['deptOrgCode'].toString());
    companySeq = jsonRes['companySeq'].toString();
    departmentDesc = jsonRes['departmentDesc'];
    departmentName = jsonRes['departmentName'];
    orgCode = jsonRes['orgCode'];
    parentId = jsonRes['parentId'].toString();
    sequenceNbr = jsonRes['sequenceNbr'].toString();
  }

  @override
  String toString() {
    return '{"deptOrgCode": $deptOrgCode,"companySeq": ${companySeq != null?'${json.encode(companySeq)}':'null'},"departmentDesc": ${departmentDesc != null?'${json.encode(departmentDesc)}':'null'},"departmentName": ${departmentName != null?'${json.encode(departmentName)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"parentId": ${parentId != null?'${json.encode(parentId)}':'null'},"sequenceNbr": ${sequenceNbr != null?'${json.encode(sequenceNbr)}':'null'}}';
  }
}

class RoleInfo {

  String roleName;
  String roleType;
  String sequenceNbr;

  RoleInfo.fromParams({this.roleName, this.roleType, this.sequenceNbr});

  factory RoleInfo(jsonStr) => jsonStr == null ? null : jsonStr is String ? new RoleInfo.fromJson(json.decode(jsonStr)) : new RoleInfo.fromJson(jsonStr);

  RoleInfo.fromJson(jsonRes) {
    roleName = jsonRes['roleName'];
    roleType = jsonRes['roleType'];
    sequenceNbr = jsonRes['sequenceNbr'].toString();
  }

  @override
  String toString() {
    return '{"roleName": ${roleName != null?'${json.encode(roleName)}':'null'},"roleType": ${roleType != null?'${json.encode(roleType)}':'null'},"sequenceNbr": ${sequenceNbr != null?'${json.encode(sequenceNbr)}':'null'}}';
  }
}







