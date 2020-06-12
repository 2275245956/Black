import 'package:flutter/material.dart';
//实现触摸回调的组件
//qi  2019-03-03

class TouchCallBack extends StatefulWidget {
  //子组件
  final Widget child;

  //回调函数
  final VoidCallback onPressed;
  final bool isfeed;

  //背景色
  final Color background;
  //传入参数列表
  TouchCallBack({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.isfeed: true,
    this.background: Colors.white,
  }) : super(key: key);
  @override
  _TouchCallBackState createState() => _TouchCallBackState();
}

class _TouchCallBackState extends State<TouchCallBack> {
  Color color = Colors.transparent;
  @override
  Widget build(BuildContext context) {
    //返回GestureDetector对象
    return GestureDetector(
      child: Container(
        color: color,
        child: widget.child,
      ),
      //onTap回调
      onTap: widget.onPressed,
      onPanDown: (d) {
        if (widget.isfeed == false) return;
        setState(() {
          color = widget.background;
        });
      },
      onPanCancel: () {
        setState(() {
          color = Colors.transparent;
        });
      },
    );
  }
}
