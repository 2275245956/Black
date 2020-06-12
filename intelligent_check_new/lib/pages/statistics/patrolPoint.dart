import 'package:flutter/material.dart';
import 'package:intelligent_check_new/pages/charts_pack/bar_chart_my.dart';
import 'package:intelligent_check_new/pages/charts_pack/bar_chart_department.dart';
import 'package:intelligent_check_new/pages/charts_pack/bar_chart_company.dart';
import 'package:intelligent_check_new/pages/charts_pack/cir_chart.dart';
import 'package:intelligent_check_new/pages/charts_pack/cir_chart_my.dart';
import 'package:intelligent_check_new/pages/charts_pack/cir_chart_department.dart';
import 'package:intelligent_check_new/pages/charts_pack/cir_chart_company.dart';
import 'package:intelligent_check_new/pages/charts_pack/hor_chart.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';

class MyItem extends StatefulWidget {
  final String title, context;
  final type;
  MyItem(
      {Key key,
      @required this.title,
      @required this.context,
      @required this.type})
      : super(key: key);

  @override
  _MyItemState createState() => _MyItemState();
}

class _MyItemState extends State<MyItem> {
  String theme="";

  @override
  Widget build(BuildContext context) {
    if(theme.isEmpty){
      return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        body: Text(""),
      );
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ItemDetail(
            type: widget.type,
            title: widget.title,
          );
        }));
      },
      child: Container(

        margin: EdgeInsets.only(left: 10,right: 10),
        child: Card(
            elevation:0.2,
          child: Container(
//            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 10),),
                    Image.asset(
                      'assets/images/statistics/statistics_'+theme+'.png',
                      width: 15,
                      ),
                    Text(
                      "  ${widget.title}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 10),),
                    Text(
                      "${widget.context}",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          )
        ),
        height: 80,
        padding: EdgeInsets.only(left: 5,right: 5),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initConfig();
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }
}

class ItemDetail extends StatefulWidget {
  final int type;
  final String title;
  ItemDetail({Key key, @required this.type, @required this.title})
      : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  List<Widget> myitem;
  String theme="";
  String roleType="";
  @override
  Widget build(BuildContext context) {
    if (widget.type == 1) {
      myitem = [
        //TODO:统计顶部的dropdownlist未实现
        // LearnDropdownButton(title: widget.title),
        ItemChart1(),
        this.roleType=="ADMIN"||this.roleType=="DEPTADMIN"?ItemChart2():Container(),//2
        Container(
          height: 200,
        ),
      ];
    } else if (widget.type == 2) {
      myitem = [
        //TODO:统计顶部的dropdownlist未实现
        // LearnDropdownButton(title: widget.title),
        ItemChart3(),//3
        this.roleType=="ADMIN"?ItemChart5():Container(),//4
        this.roleType=="ADMIN"||this.roleType=="DEPTADMIN"?ItemChart4():Container(),//5
        Container(
          height: 200,
        ),
      ];
    } else if (widget.type == 3) {
      myitem = [
        //TODO:统计顶部的dropdownlist未实现
        // LearnDropdownButton(title: widget.title),
        ItemChart6(),//6
        this.roleType=="ADMIN"||this.roleType=="DEPTADMIN"?ItemChart7():Container(),//7
        this.roleType=="ADMIN"?ItemChart8():Container(),//8
        Container(
          height: 200,
        ),
      ];
    }

    return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: AppBar(
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child:
                  Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
            ),
          ),
          elevation: 0.2,
          title: Text(
            "统计",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: ListView(
          // padding: EdgeInsets.only(top: 10),
          children: myitem,
        ));
  }

  @override
  void initState() {
    super.initState();
    initConfig();
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
        this.roleType = preferences.getString("roleType");
      });
    });
  }
}


class LearnDropdownButton extends StatefulWidget {
  final String title;
  LearnDropdownButton({Key key, @required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LearnDropdownButton();
  }
}

class _LearnDropdownButton extends State<LearnDropdownButton> {
  List<DropdownMenuItem> getListData() {
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem1 = new DropdownMenuItem(
      child: new Text('巡检点状态统计'),
      value: '1',
    );
    items.add(dropdownMenuItem1);
    DropdownMenuItem dropdownMenuItem2 = new DropdownMenuItem(
      child: new Text('计划执行情况统计'),
      value: '2',
    );
    items.add(dropdownMenuItem2);
    DropdownMenuItem dropdownMenuItem3 = new DropdownMenuItem(
      child: new Text('隐患治理任务统计'),
      value: '3',
    );
    items.add(dropdownMenuItem3);
    return items;
  }

  var value;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton(
        items: getListData(),
        hint: new Text('${widget.title}'), //当没有默认值的时候可以设置的提示
        value: value, //下拉菜单选择完之后显示给用户的值
        onChanged: (T) {
          //下拉菜单item点击之后的回调
          setState(() {
            value = T;
          });
        },
        elevation: 24, //设置阴影的高度
        //isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
        iconSize: 20.0, //设置三角标icon的大小
      ),
    );
  }
}
