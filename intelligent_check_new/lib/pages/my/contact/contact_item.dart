import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/CheckExecute/ContactInfo.dart';
import 'package:intelligent_check_new/pages/my/contact/contactinfo.dart';

//通讯录列表项
//qi 2019.03.03

class ContactItem extends StatelessWidget {
  //好友数据
  final ChildInfo item;

  //构建方法
  ContactItem({this.item});

  //渲染好友列表项
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        //每条列表项底部家一个边框
        border:
            Border(bottom: BorderSide(width: 0.5, color: Color(0xffd9d9d9))),
      ),
      height: 80.0,
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new Contactinfo(
                      info: item,
                    )),
          );
          //跳转到联系人信息页面
        },
        child: Row(
          children: [
            new Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new CircleAvatar(
                  radius: 25.0,
//                  backgroundColor: Colors.blue,
                  child: Text(item.label[0])
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(left: 5.0)),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: new Text(
                    item.label,
//                    style: new TextStyle(
//                      fontWeight: FontWeight.bold,
//                    ),
                  ),
                ),
//                new Text(
//                  item.info,
//                  style: new TextStyle(
//                    color: Colors.grey[500],
//                  ),
//                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
