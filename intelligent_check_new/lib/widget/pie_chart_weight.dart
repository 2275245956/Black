import 'package:flutter/material.dart';
import 'package:intelligent_check_new/widget/pie_chart.dart';
import 'package:intelligent_check_new/model/piedata.dart';

class MyCustomCircle extends StatelessWidget {
  MyCustomCircle({this.lstPieData,this.pieData});
  final List<PieData> lstPieData;
  final PieData pieData;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: MyView(lstPieData, pieData, true));
  }
}


