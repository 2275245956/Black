//通讯录数据准备
import 'package:flutter/material.dart';

class ContactVO {
  //部门值
  String depKey;

  //字母排列值
  String seationKey;

  //名字
  String name;

  //信息
  String info;

  //电话
  String tele;

  //头像URL
  String avatarUrl;

  String sex;

  String mail;

  //构造函数
  ContactVO(
      {@required this.depKey,
      this.seationKey,
      this.name,
      this.info,
      this.tele,
      this.sex,
      this.mail,
      this.avatarUrl});
}

//部门列表
List<String> depDdata = [
  '巡检部',
  '工程部',
  '生产部',
  '仓储部',
  '行政部',
  '冷饮部',
  '品控部',
  '物流部'
];
//联系人列表
List<ContactVO> contactData = [
  new ContactVO(
      depKey: '巡检部',
      seationKey: 'A',
      info: '巡检部员工',
      tele: '123456789',
      name: '阿1',
      avatarUrl: '',
      sex: '男',
      mail: '1234@123.com'),
  new ContactVO(
      depKey: '巡检部',
      seationKey: 'B',
      info: '巡检部员工',
      tele: '123456789',
      name: '布1',
      avatarUrl: '',
      sex: '男',
      mail: '1234@123.com'),
  new ContactVO(
      depKey: '工程部',
      seationKey: 'A',
      name: '阿2',
      info: '工程部员工',
      tele: '123456789',
      avatarUrl: '',
      sex: '男',
      mail: '1234@123.com'),
  new ContactVO(
      depKey: '生产部',
      seationKey: 'A',
      name: '阿3',
      info: '生产部员工',
      tele: '123456789',
      avatarUrl: '',
      sex: '男',
      mail: '1234@123.com'),
  new ContactVO(
      depKey: '仓储部',
      seationKey: 'A',
      name: '阿4',
      info: '仓储部员工',
      tele: '123456789',
      avatarUrl: '',
      sex: '男',
      mail: '1234@123.com'),
  new ContactVO(
      depKey: '行政部',
      seationKey: 'A',
      name: '阿5',
      info: '行政部员工',
      tele: '123456789',
      avatarUrl: '',
      sex: '男',
      mail: '1234@123.com'),
  new ContactVO(
      depKey: '冷饮部',
      seationKey: 'A',
      name: '阿6',
      info: '冷饮部员工',
      tele: '123456789',
      avatarUrl: '',
      sex: '男',
      mail: '1234@123.com'),
  new ContactVO(
      depKey: '品控部',
      seationKey: 'A',
      name: '阿7',
      info: '品控部员工',
      tele: '123456789',
      avatarUrl: '',
      sex: '男',
      mail: '1234@123.com'),
  new ContactVO(
      depKey: '物流部',
      seationKey: 'A',
      name: '阿8',
      info: '物流部员工',
      tele: '123456789',
      avatarUrl: '',
      sex: '男',
      mail: '1234@123.com'),
  new ContactVO(
      depKey: '品控部',
      seationKey: 'A',
      name: '阿9',
      info: '品控部员工',
      tele: '123456789',
      avatarUrl: '',
      sex: '男',
      mail: '1234@123.com'),
  new ContactVO(
      depKey: '行政部',
      seationKey: 'A',
      name: '阿10',
      info: '行政部长',
      tele: '123456789',
      avatarUrl: '',
      sex: '女',
      mail: '1234@123.com'),
  new ContactVO(
      depKey: '行政部',
      seationKey: 'A',
      name: '阿11',
      info: '行政部员工',
      tele: '123456789',
      avatarUrl: '',
      sex: '男',
      mail: '1234@123.com'),
  new ContactVO(
      depKey: '',
      seationKey: 'A',
      name: '阿12',
      info: '总裁',
      tele: '123456789',
      avatarUrl: '',
      sex: '女',
      mail: '1234@123.com'),
];
