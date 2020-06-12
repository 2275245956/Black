import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/Statistics/StatisticsRiskDetail.dart';
import 'package:intelligent_check_new/pages/hidedanger_manage/hidden_danger_found.dart';
import 'package:intelligent_check_new/services/Statistics_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/tools/custom_stepper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsJudge extends StatefulWidget {
  final num value;
  final String title;
  StatisticsJudge(this.value,{this.title});
  @override
  _StatisticsJudge createState() => _StatisticsJudge();
}

class _StatisticsJudge extends State<StatisticsJudge>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String theme = "";
  bool isAnimating = false;
  JudgementDetailModel iniData;

  @override
  void initState() {
    super.initState();

    getInitInfo();
  }
  void getInitInfo() async {
    await SharedPreferences.getInstance().then((data) {
      if (data != null) {
        setState(() {
          this.theme = data.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
        });
      }
    }).then((data) {
      loadData();
    });
  }


  void loadData() async {
    setState(() {
      isAnimating = true;
    });
    await getStatisticsDetailByType("judgment").then((data) {
      setState(() {
        if (data.success) {
          if (data.dataList != null) {
            iniData = JudgementDetailModel.fromJson(data.dataList);
          }

        } else {
          HiddenDangerFound.popUpMsg(data.message ?? "获取数据失败");
        }
        isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (iniData==null) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        body: Text(""),
      );
    }
    //获取统计数据
//    StatisticsPage.queryAuthCompanyLeaves();
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 246, 249, 1),
      appBar: AppBar(
        title: Text(
         this.widget.title??"--",
          style: TextStyle(
            height: 1.25,
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: new Container(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.keyboard_arrow_left,
                color: GetConfig.getColor(theme), size: 32),
          ),
        ),
      ),
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
              child: Column(
            children: <Widget>[
              //按等级
              Container(
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  margin: EdgeInsets.all(10),

                  //设置四周圆角 角度
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(219, 222, 225, 1),
                        offset: Offset(3.0, 3.0),
                        blurRadius: 5.0,
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(219, 222, 225, 1),
                        offset: Offset(3.0, 3.0),
                        blurRadius: 5.0,
                      )
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7.0),
                              topRight: Radius.circular(7.0)),
                          color: Color.fromRGBO(230, 230, 230, 1),
                        ),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Container(
                                child: Icon(
                                  Icons.trending_up,
                                  color: GetConfig.getColor(theme),
                                  size: 15,
                                )),
                            Container(
                              child: Text(
                                this.widget.title??"--",
                                style: TextStyle(
                                    height: 1.25,
                                    color: GetConfig.getColor(theme)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height:
                            (MediaQuery.of(context).size.width / 2 - 150) < 130
                                ? 130
                                : (MediaQuery.of(context).size.width / 2 - 150),
                        child: Stack(
                          alignment: const FractionalOffset(0.5, 0.5),
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerRight,
                              child: new charts.PieChart(
                                  _createSampleData(
                                      "通过",
                                      this.widget.value,
                                      charts
                                          .MaterialPalette.green.shadeDefault),
                                  animate: true,
                                  defaultRenderer: new charts.ArcRendererConfig(
                                    arcWidth: 13,
//                                          arcRendererDecorators: [
//                                            new charts.ArcLabelDecorator(
//                                                leaderLineStyleSpec:
//                                                charts.ArcLabelLeaderLineStyleSpec(
//                                                    length: 10,
//                                                    color: charts.MaterialPalette
//                                                        .green.shadeDefault),
//                                                labelPosition:
//                                                charts.ArcLabelPosition.outside,
//                                                outsideLabelStyleSpec:
//                                                new charts.TextStyleSpec(
//                                                    fontSize: 12,
//                                                    color: charts.MaterialPalette
//                                                        .green.shadeDefault)
//                                            )
//                                          ]
                                  )),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text("${this.widget.value}%",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600)),
                                )),
                          ],
                        ),
                      ),
        this.iniData.byDepartmentStatus==null?Container(): Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children:this.iniData.byDepartmentStatus.map((f){
                            return   Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromRGBO(230, 230, 230, 1),
                                      width: 0.5,
                                      style: BorderStyle.solid)),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      child: Text(
                                       f.deptName??"--",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                153, 153, 153, 1),
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 9,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: Color.fromRGBO(
                                                        230, 230, 230, 1),
                                                    width: 0.5,
                                                    style: BorderStyle.solid))),
                                        child: CustomStepper(
                                          currentStep: int.tryParse(f.status),
                                          type: CustomStepperType.horizontal,
                                          steps: ['采集', '车间审核', '汇总']
                                              .map(
                                                (s) => CustomStep(
                                                title: Text(
                                                  s,
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                                content: Container(),
                                                isActive: true),
                                          )
                                              .toList(),
                                          controlsBuilder:
                                              (BuildContext context,
                                              {VoidCallback onStepContinue,
                                                VoidCallback onStepCancel}) {
                                            return Container();
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }

}

List<charts.Series<LinearSales, String>> _createSampleData(
    String desc, num value, charts.Color col) {
  List<LinearSales> data = [];
//  data.add(new LinearSales("", -1,charts.MaterialPalette.gray.shadeDefault));
  data.add(new LinearSales(desc, value, col));
  data.add(new LinearSales("", 100 - value <= 0 ? 0 : 100 - value,
      charts.MaterialPalette.gray.shadeDefault));

  return [
    new charts.Series<LinearSales, String>(
      id: 'Sales',
      //  labelAccessorFn: (LinearSales row, _) => row.sales == -1 ? "" : '${row.year}: ${row.sales}',
      colorFn: (LinearSales data, _) => data.color,
      domainFn: (LinearSales data, _) => data.remark,
      measureFn: (LinearSales data, _) => data.val,

      data: data,
      // Set a label accessor to control the text of the arc label.
    )
  ];
}

class LinearSales {
  final String remark;
  final num val;
  final charts.Color color;

  LinearSales(this.remark, this.val, this.color);
}
