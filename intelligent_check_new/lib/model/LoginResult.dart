import 'dart:convert' show json;

class LoginResult {

  String X_Access_Token;
  int X_Api_Key;
  String result;
  User user;

  LoginResult.fromParams({this.X_Access_Token, this.X_Api_Key, this.result, this.user});

  factory LoginResult(jsonStr) => jsonStr == null ? null : jsonStr is String ? new LoginResult.fromJson(json.decode(jsonStr)) : new LoginResult.fromJson(jsonStr);

  LoginResult.fromJson(jsonRes) {
    X_Access_Token = jsonRes['X-Access-Token'];
    X_Api_Key = jsonRes['X-Api-Key'];
    result = jsonRes['result'];
    user = jsonRes['user'] == null ? null : new User.fromJson(jsonRes['user']);
  }

  @override
  String toString() {
    return '{"X-Access-Token": ${X_Access_Token != null?'${json.encode(X_Access_Token)}':'null'},"X-Api-Key": ${X_Api_Key != null?'${json.encode(X_Api_Key)}':'null'},"result": ${result != null?'${json.encode(result)}':'null'},"user": $user}';
  }
}

class User {

  bool accountNonExpired;
  bool accountNonLocked;
  String contact;
  int createDate;
  String createUser;
  bool credentialsNonExpired;
  bool deletable;
  String email;
  bool enabled;
  String id;
  String identificationId;
  bool isDelete;
  bool isOnline;
  String mobile;
  String name;
  String orgCode;
  String password;
  String registerCode;
  String telephone;
  int updateDate;
  String updateUser;
  String userName;
  String username;
  List<Authorities> authorities;
  Company company;
  Department department;
  Role role;
  String sequenceNbr;

  User.fromParams({this.accountNonExpired, this.accountNonLocked, this.contact, this.createDate, this.createUser, this.credentialsNonExpired, this.deletable, this.email, this.enabled, this.id, this.identificationId, this.isDelete, this.isOnline, this.mobile, this.name, this.orgCode, this.password, this.registerCode, this.telephone, this.updateDate, this.updateUser, this.userName, this.username, this.authorities, this.company, this.department, this.role});

  User.fromJson(jsonRes) {
//    accountNonExpired = jsonRes['accountNonExpired'];
//    accountNonLocked = jsonRes['accountNonLocked'];
//    contact = jsonRes['contact'];
//    createDate = jsonRes['createDate'];
//    createUser = jsonRes['createUser'];
//    credentialsNonExpired = jsonRes['credentialsNonExpired'];
//    deletable = jsonRes['deletable'];
    email = jsonRes['email'];
  //  enabled = jsonRes['enabled'];
    id = jsonRes['id'];
//    identificationId = jsonRes['identificationId'];
//    isDelete = jsonRes['isDelete'];
//    isOnline = jsonRes['isOnline'];
    mobile = jsonRes['mobile'];
    name = jsonRes['name'];
//    orgCode = jsonRes['orgCode'];
//    password = jsonRes['password'];
//    registerCode = jsonRes['registerCode'];
//    telephone = jsonRes['telephone'];
//    updateDate = jsonRes['updateDate'];
//    updateUser = jsonRes['updateUser'];
    userName = jsonRes['userName'];
//    username = jsonRes['username'];
//    authorities = jsonRes['authorities'] == null ? null : [];
    sequenceNbr = jsonRes['sequenceNbr'].toString();

    for (var authoritiesItem in authorities == null ? [] : jsonRes['authorities']){
      authorities.add(authoritiesItem == null ? null : new Authorities.fromJson(authoritiesItem));
    }

    company = jsonRes['company'] == null ? null : new Company.fromJson(jsonRes['company']);
    department = jsonRes['department'] == null ? null : new Department.fromJson(jsonRes['department']);
    role = jsonRes['role'] == null ? null : new Role.fromJson(jsonRes['role']);
  }

  @override
  String toString() {
    return '{"accountNonExpired": $accountNonExpired,"accountNonLocked": $accountNonLocked,"contact": ${contact != null?'${json.encode(contact)}':'null'},"createDate": ${createDate != null?'${json.encode(createDate)}':'null'},"createUser": ${createUser != null?'${json.encode(createUser)}':'null'},"credentialsNonExpired": ${credentialsNonExpired != null?'${json.encode(credentialsNonExpired)}':'null'},"deletable": ${deletable != null?'${json.encode(deletable)}':'null'},"email": ${email != null?'${json.encode(email)}':'null'},"enabled": ${enabled != null?'${json.encode(enabled)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"identificationId": ${identificationId != null?'${json.encode(identificationId)}':'null'},"isDelete": $isDelete,"isOnline": ${isOnline != null?'${json.encode(isOnline)}':'null'},"mobile": ${mobile != null?'${json.encode(mobile)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"orgCode": ${orgCode != null?'${json.encode(orgCode)}':'null'},"password": ${password != null?'${json.encode(password)}':'null'},"registerCode": ${registerCode != null?'${json.encode(registerCode)}':'null'},"telephone": ${telephone != null?'${json.encode(telephone)}':'null'},"updateDate": ${updateDate != null?'${json.encode(updateDate)}':'null'},"updateUser": ${updateUser != null?'${json.encode(updateUser)}':'null'},"userName": ${userName != null?'${json.encode(userName)}':'null'},"username": ${username != null?'${json.encode(username)}':'null'},"authorities": $authorities,"company": $company,"department": $department,"role": $role}';
  }
}

class Role {

  int createDate;
  String createUser;
  String description;
  int id;
  bool isDelete;
  String name;
  int roleType;
  String roleTypeName;
  int updateDate;
  String updateUser;
  RoleTypeEnum roleTypeEnum;

  Role.fromParams({this.createDate, this.createUser, this.description, this.id, this.isDelete, this.name, this.roleType, this.roleTypeName, this.updateDate, this.updateUser, this.roleTypeEnum});

  Role.fromJson(jsonRes) {
    createDate = jsonRes['createDate'];
    createUser = jsonRes['createUser'];
    description = jsonRes['description'];
    id = jsonRes['id'];
    isDelete = jsonRes['isDelete'];
    name = jsonRes['name'];
    roleType = jsonRes['roleType'];
    roleTypeName = jsonRes['roleTypeName'];
    updateDate = jsonRes['updateDate'];
    updateUser = jsonRes['updateUser'];
    roleTypeEnum = jsonRes['roleTypeEnum'] == null ? null : new RoleTypeEnum.fromJson(jsonRes['roleTypeEnum']);
  }

  @override
  String toString() {
    return '{"createDate": ${createDate != null?'${json.encode(createDate)}':'null'},"createUser": ${createUser != null?'${json.encode(createUser)}':'null'},"description": ${description != null?'${json.encode(description)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"isDelete": ${isDelete != null?'${json.encode(isDelete)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"roleType": ${roleType != null?'${json.encode(roleType)}':'null'},"roleTypeName": ${roleTypeName != null?'${json.encode(roleTypeName)}':'null'},"updateDate": ${updateDate != null?'${json.encode(updateDate)}':'null'},"updateUser": ${updateUser != null?'${json.encode(updateUser)}':'null'},"roleTypeEnum": $roleTypeEnum}';
  }
}

class RoleTypeEnum {

  int createDate;
  String createUser;
  String fbigint;
  String fchar;
  int id;
  bool isDelete;
  String name;
  String type;
  int updateDate;
  String updateUser;

  RoleTypeEnum.fromParams({this.createDate, this.createUser, this.fbigint, this.fchar, this.id, this.isDelete, this.name, this.type, this.updateDate, this.updateUser});

  RoleTypeEnum.fromJson(jsonRes) {
    createDate = jsonRes['createDate'];
    createUser = jsonRes['createUser'];
    fbigint = jsonRes['fbigint'];
    fchar = jsonRes['fchar'];
    id = jsonRes['id'];
    isDelete = jsonRes['isDelete'];
    name = jsonRes['name'];
    type = jsonRes['type'];
    updateDate = jsonRes['updateDate'];
    updateUser = jsonRes['updateUser'];
  }

  @override
  String toString() {
    return '{"createDate": ${createDate != null?'${json.encode(createDate)}':'null'},"createUser": ${createUser != null?'${json.encode(createUser)}':'null'},"fbigint": ${fbigint != null?'${json.encode(fbigint)}':'null'},"fchar": ${fchar != null?'${json.encode(fchar)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"isDelete": ${isDelete != null?'${json.encode(isDelete)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"type": ${type != null?'${json.encode(type)}':'null'},"updateDate": ${updateDate != null?'${json.encode(updateDate)}':'null'},"updateUser": ${updateUser != null?'${json.encode(updateUser)}':'null'}}';
  }
}

class Department {

  int createDate;
  String createUser;
  String departmentName;
  String depmCode;
  String description;
  int id;
  bool isDelete;
  int parentId;
  int updateDate;
  String updateUser;
  DeptCompany company;

  Department.fromParams({this.createDate, this.createUser, this.departmentName, this.depmCode, this.description, this.id, this.isDelete, this.parentId, this.updateDate, this.updateUser, this.company});

  Department.fromJson(jsonRes) {
    createDate = jsonRes['createDate'];
    createUser = jsonRes['createUser'];
    departmentName = jsonRes['departmentName'];
    depmCode = jsonRes['depmCode'];
    description = jsonRes['description'];
    id = jsonRes['id'];
    isDelete = jsonRes['isDelete'];
    parentId = jsonRes['parentId'];
    updateDate = jsonRes['updateDate'];
    updateUser = jsonRes['updateUser'];
    company = jsonRes['company'] == null ? null : new DeptCompany.fromJson(jsonRes['company']);
  }

  @override
  String toString() {
    return '{"createDate": ${createDate != null?'${json.encode(createDate)}':'null'},"createUser": ${createUser != null?'${json.encode(createUser)}':'null'},"departmentName": ${departmentName != null?'${json.encode(departmentName)}':'null'},"depmCode": ${depmCode != null?'${json.encode(depmCode)}':'null'},"description": ${description != null?'${json.encode(description)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"isDelete": ${isDelete != null?'${json.encode(isDelete)}':'null'},"parentId": ${parentId != null?'${json.encode(parentId)}':'null'},"updateDate": ${updateDate != null?'${json.encode(updateDate)}':'null'},"updateUser": ${updateUser != null?'${json.encode(updateUser)}':'null'},"company": $company}';
  }
}

class DeptCompany {

  String address;
  String compCode;
  String companyLevel;
  String companyName;
  String contact;
  int createDate;
  String createUser;
  String description;
  String email;
  int id;
  bool isDelete;
  num latitude;
  int level;
  num longitude;
  int parentId;
  int registerTypeId;
  String remark;
  String site;
  String siteId;
  String telephone;
  int updateDate;
  String updateUser;
  RegisterType registerType;

  DeptCompany.fromParams({this.address, this.compCode, this.companyLevel, this.companyName, this.contact, this.createDate, this.createUser, this.description, this.email, this.id, this.isDelete, this.latitude, this.level, this.longitude, this.parentId, this.registerTypeId, this.remark, this.site, this.siteId, this.telephone, this.updateDate, this.updateUser, this.registerType});

  DeptCompany.fromJson(jsonRes) {
    address = jsonRes['address'];
    compCode = jsonRes['compCode'];
    companyLevel = jsonRes['companyLevel'];
    companyName = jsonRes['companyName'];
    contact = jsonRes['contact'];
    createDate = jsonRes['createDate'];
    createUser = jsonRes['createUser'];
    description = jsonRes['description'];
    email = jsonRes['email'];
    id = jsonRes['id'];
    isDelete = jsonRes['isDelete'];
    latitude = jsonRes['latitude'];
    level = jsonRes['level'];
    longitude = jsonRes['longitude'];
    parentId = jsonRes['parentId'];
    registerTypeId = jsonRes['registerTypeId'];
    remark = jsonRes['remark'];
    site = jsonRes['site'];
    siteId = jsonRes['siteId'];
    telephone = jsonRes['telephone'];
    updateDate = jsonRes['updateDate'];
    updateUser = jsonRes['updateUser'];
    registerType = jsonRes['registerType'] == null ? null : new RegisterType.fromJson(jsonRes['registerType']);
  }

  @override
  String toString() {
    return '{"address": ${address != null?'${json.encode(address)}':'null'},"compCode": ${compCode != null?'${json.encode(compCode)}':'null'},"companyLevel": ${companyLevel != null?'${json.encode(companyLevel)}':'null'},"companyName": ${companyName != null?'${json.encode(companyName)}':'null'},"contact": ${contact != null?'${json.encode(contact)}':'null'},"createDate": ${createDate != null?'${json.encode(createDate)}':'null'},"createUser": ${createUser != null?'${json.encode(createUser)}':'null'},"description": ${description != null?'${json.encode(description)}':'null'},"email": ${email != null?'${json.encode(email)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"isDelete": ${isDelete != null?'${json.encode(isDelete)}':'null'},"latitude": ${latitude != null?'${json.encode(latitude)}':'null'},"level": ${level != null?'${json.encode(level)}':'null'},"longitude": ${longitude != null?'${json.encode(longitude)}':'null'},"parentId": ${parentId != null?'${json.encode(parentId)}':'null'},"registerTypeId": ${registerTypeId != null?'${json.encode(registerTypeId)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"site": ${site != null?'${json.encode(site)}':'null'},"siteId": ${siteId != null?'${json.encode(siteId)}':'null'},"telephone": ${telephone != null?'${json.encode(telephone)}':'null'},"updateDate": ${updateDate != null?'${json.encode(updateDate)}':'null'},"updateUser": ${updateUser != null?'${json.encode(updateUser)}':'null'},"registerType": $registerType}';
  }
}

class RegisterType {

  String code;
  int dateCreated;
  int id;
  String name;
  String remark;
  String type;

  RegisterType.fromParams({this.code, this.dateCreated, this.id, this.name, this.remark, this.type});

  RegisterType.fromJson(jsonRes) {
    code = jsonRes['code'];
    dateCreated = jsonRes['dateCreated'];
    id = jsonRes['id'];
    name = jsonRes['name'];
    remark = jsonRes['remark'];
    type = jsonRes['type'];
  }

  @override
  String toString() {
    return '{"code": ${code != null?'${json.encode(code)}':'null'},"dateCreated": ${dateCreated != null?'${json.encode(dateCreated)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"type": ${type != null?'${json.encode(type)}':'null'}}';
  }
}

class Company {
//  "address": "北京市亦庄经济开发区中和科技园5号楼亿江大厦",
//  "companyOrgCode": 1,
//  "level": "GROUP",
//  "orgCode": "1",
//  "companyName": "亿江集团",
//  "latitude": "42.32354243",
//  "landlinePhone": "010-67889346",
//  "sequenceNbr": "12321",
//  "parentId": "0",
//  "email": "",
//  "longitude": "24.2322432"
  String address;
  String compCode;
  String companyLevel;
  String companyName;
  String contact;
  int createDate;
  String createUser;
  String description;
  String email;
  int id;
  bool isDelete;
  num latitude;
  int level;
  num longitude;
  int parentId;
  int registerTypeId;
  String remark;
  String site;
  String siteId;
  String telephone;
  int updateDate;
  String updateUser;
  RegisterType registerType;
  String sequenceNbr;

  Company.fromParams({this.address, this.compCode, this.companyLevel, this.companyName, this.contact, this.createDate, this.createUser, this.description, this.email, this.id, this.isDelete, this.latitude, this.level, this.longitude, this.parentId, this.registerTypeId, this.remark, this.site, this.siteId, this.telephone, this.updateDate, this.updateUser, this.registerType});

  Company.fromJson(jsonRes) {
    address = jsonRes['address'];
    compCode = jsonRes['compCode'];
    companyLevel = jsonRes['companyLevel'];
    companyName = jsonRes['companyName'];
    contact = jsonRes['contact'];
    createDate = jsonRes['createDate'];
    createUser = jsonRes['createUser'];
    description = jsonRes['description'];
    email = jsonRes['email'];
    id = jsonRes['id'];
    isDelete = jsonRes['isDelete'];
    latitude = jsonRes['latitude'];
    level = jsonRes['level'];
    longitude = jsonRes['longitude'];
    parentId = jsonRes['parentId'];
    registerTypeId = jsonRes['registerTypeId'];
    remark = jsonRes['remark'];
    site = jsonRes['site'];
    siteId = jsonRes['siteId'];
    telephone = jsonRes['telephone'];
    updateDate = jsonRes['updateDate'];
    updateUser = jsonRes['updateUser'];
    sequenceNbr = jsonRes['sequenceNbr'];
    registerType = jsonRes['registerType'] == null ? null : new RegisterType.fromJson(jsonRes['registerType']);
  }

  @override
  String toString() {
    return '{"address": ${address != null?'${json.encode(address)}':'null'},"compCode": ${compCode != null?'${json.encode(compCode)}':'null'},"companyLevel": ${companyLevel != null?'${json.encode(companyLevel)}':'null'},"companyName": ${companyName != null?'${json.encode(companyName)}':'null'},"contact": ${contact != null?'${json.encode(contact)}':'null'},"createDate": ${createDate != null?'${json.encode(createDate)}':'null'},"createUser": ${createUser != null?'${json.encode(createUser)}':'null'},"description": ${description != null?'${json.encode(description)}':'null'},"email": ${email != null?'${json.encode(email)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"isDelete": ${isDelete != null?'${json.encode(isDelete)}':'null'},"latitude": ${latitude != null?'${json.encode(latitude)}':'null'},"level": ${level != null?'${json.encode(level)}':'null'},"longitude": ${longitude != null?'${json.encode(longitude)}':'null'},"parentId": ${parentId != null?'${json.encode(parentId)}':'null'},"registerTypeId": ${registerTypeId != null?'${json.encode(registerTypeId)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"site": ${site != null?'${json.encode(site)}':'null'},"siteId": ${siteId != null?'${json.encode(siteId)}':'null'},"telephone": ${telephone != null?'${json.encode(telephone)}':'null'},"updateDate": ${updateDate != null?'${json.encode(updateDate)}':'null'},"updateUser": ${updateUser != null?'${json.encode(updateUser)}':'null'},"registerType": $registerType}';
  }
}

class DeptRegisterType {

  String code;
  int dateCreated;
  int id;
  String name;
  String remark;
  String type;

  DeptRegisterType.fromParams({this.code, this.dateCreated, this.id, this.name, this.remark, this.type});

  DeptRegisterType.fromJson(jsonRes) {
    code = jsonRes['code'];
    dateCreated = jsonRes['dateCreated'];
    id = jsonRes['id'];
    name = jsonRes['name'];
    remark = jsonRes['remark'];
    type = jsonRes['type'];
  }

  @override
  String toString() {
    return '{"code": ${code != null?'${json.encode(code)}':'null'},"dateCreated": ${dateCreated != null?'${json.encode(dateCreated)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"type": ${type != null?'${json.encode(type)}':'null'}}';
  }
}

class Authorities {

  String authority;

  Authorities.fromParams({this.authority});

  Authorities.fromJson(jsonRes) {
    authority = jsonRes['authority'];
  }

  @override
  String toString() {
    return '{"authority": ${authority != null?'${json.encode(authority)}':'null'}}';
  }
}

