import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/piedata.dart';

class MyView extends CustomPainter {
  //中间文字
  var text = '111';
  bool isChange = false;
  //画笔
  Paint _mPaint;
  Paint textPaint;
  // 扇形大小
  int mWidth, mHeight;
  // 圆半径
  num mRadius, mInnerRadius, mBigRadius;
  // 扇形起始弧度（Andorid中是角度）
  num mStartAngle = 0;
  // 矩形（扇形绘制的区域）
  Rect mOval;
// 扇形 数据
  List<PieData> mData;
  PieData pieData;
  // 构造函数，接受需要的参数值
  MyView(this.mData, this.pieData, this.isChange);
  @override
  void paint(Canvas canvas, Size size) {
    // 初始化各类工具等
    _mPaint = new Paint();
    textPaint = new Paint();
    mHeight = 100;
    mWidth = 100;

    //生成纵轴文字的TextPainter
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    // 文字画笔 风格定义
    TextPainter _newVerticalAxisTextPainter(String text) {
      return textPainter
        ..text = TextSpan(
          text: text,
          style: new TextStyle(
            color: Colors.black,
            fontSize: 30.0,
          ),
        );
    }

    // 正常半径
    mRadius = 80.0;
    //內园半径
    mInnerRadius = 70.0;
    //当没有数据时 直接返回
    if (mData.length == null || mData.length <= 0) {
      return;
    }
    mOval = Rect.fromLTRB(-mRadius, -mRadius, mRadius, mRadius);
    //绘制逻辑与Android差不多
    canvas.save();
    // 将坐标点移动到View的中心
    canvas.translate(50.0, 50.0);
    // 1. 画扇形
    num startAngle = 0.0;
    for (int i = 0; i < mData.length; i++) {
      PieData p = mData[i];
      double hudu = p.percentage;
      //计算当前偏移量（单位为弧度）
      double sweepAngle = 2 * pi * hudu;
      //画笔的颜色
      _mPaint..color = p.color;
      canvas.drawArc(mOval, startAngle, sweepAngle, true, _mPaint);
      //计算每次开始绘制的弧度
      startAngle += sweepAngle;
    }

//    canvas.drawRect(mOval, _mPaint);  // 矩形区域

    // 2.画内圆
    _mPaint..color = Colors.white;
    canvas.drawCircle(Offset.zero, mInnerRadius, _mPaint);

    canvas.restore();

    //当前百分比值
    double percentage = pieData.percentage * 100;
    // 绘制文字内容
    var texts = '${percentage}%';
    var tp = _newVerticalAxisTextPainter(texts)..layout();

    // Text的绘制起始点 = 可用宽度 - 文字宽度 - 左边距
    var textLeft = 15.0;
    tp.paint(canvas, Offset(textLeft, 50.0 - tp.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
