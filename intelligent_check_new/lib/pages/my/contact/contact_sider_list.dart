import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/contact_vo.dart'; //好友列表项数据

class ContactSiderList extends StatefulWidget {
  final List<ContactVO> items;

  //好友列表项构造器
  final IndexedWidgetBuilder itemBuilder;

  //构造方法
  ContactSiderList({
    Key key,
    @required this.items,
    @required this.itemBuilder,
  }) : super(key: key);

  @override
  _ContactSiderListState createState() => _ContactSiderListState();
}

class _ContactSiderListState extends State<ContactSiderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.items.length,
            //列表项构造器
            itemBuilder: (BuildContext context, int index) {
              //列表项容器
              return Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: <Widget>[
                    widget.itemBuilder(context, index),
                  ],
                ),
              );
            }),
      ]),
    );
  }
}
