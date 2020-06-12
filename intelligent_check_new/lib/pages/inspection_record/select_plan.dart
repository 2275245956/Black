import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/name_value.dart';
import 'package:intelligent_check_new/services/plan_list_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectPlanPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SelectPlanPageState();

}

class _SelectPlanPageState extends State<SelectPlanPage>{

  final TextEditingController _controller = new TextEditingController();
  FocusNode _focusNode = new FocusNode();
  List<NameValue> planList = List();
  List<NameValue> tmpPlanList = List();
  String theme="blue";

  @override
  void initState() {
    super.initState();
    getInitInfo();
    initConfig();
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        brightness: Brightness.light,
        backgroundColor:  Color(0xFFFFFFFF),
        leading:new Container(
          child: GestureDetector(
            onTap: () {
              _focusNode.unfocus();
              Navigator.pop(context);
            },
            child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
          ),
        ),
        title:new  Container(
          height: 30,
          width: 250,
          padding: EdgeInsets.only(bottom: 5),
          decoration: new BoxDecoration(
            color: Colors.grey[100],
            borderRadius: new BorderRadius.all(Radius.circular(25.0)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 5,right: 5,top:6),
                child: Image.asset("assets/images/search_"+theme+".png",width: 20,color: Colors.black26),
              ),
              new Container(
//                  child:Align(
                width: 190,
                child:TextField(
                    controller: _controller,
//                  autofocus: true,
                    focusNode: _focusNode,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        contentPadding:EdgeInsets.only(top: 8)
                    )
                ),
//                  )
              )
            ],
          ),
        ),

//        new  Container(
//            height: 30,
//            width: 250,
//            padding: EdgeInsets.only(bottom: 5),
//            decoration: new BoxDecoration(
//              color: Colors.grey[100],
//              borderRadius: new BorderRadius.all(Radius.circular(25.0)),
//            ),
//            child: new Container(
////                  child:Align(
//              child:TextField(
//                  controller: _controller,
////                  autofocus: true,
//                  focusNode: _focusNode,
//                  style: TextStyle(fontSize: 18.0, color: Colors.black),
//                  decoration: new InputDecoration(
//                    prefixIcon: new Icon(Icons.search,color: Colors.black26,),
////                    suffixIcon: GestureDetector(
////                        onTap: ()=>_controller.text="",
////                        child:new Icon(Icons.delete_forever,color: Colors.black26,)
////                    ),
//                    border: InputBorder.none,
//                  )
//              ),
////                  )
//            )
//        ),
        actions: <Widget>[
          Align(
              child:Padding(padding: EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if(this._controller.text.isEmpty){
                        this.planList = tmpPlanList;
                      }else{
                        this.planList = tmpPlanList.where((f)=>f.name.indexOf(this._controller.text) != -1).toList();
                      }
                    });
                  },
                  child:Text("搜索",style: TextStyle(color: Colors.black26,fontSize: 16.0),),
                ),
              )
          )
        ],
      ),
      body: new ListView.builder(
        itemCount: planList.length,
        itemBuilder: (context, index) {
          return new ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text('${planList[index].name}'),
                Divider(height: 1,)
              ],
            ),
            onTap: (){
              Navigator.pop(context,NameValue(planList[index].name, planList[index].value));
            },
          );
        },
      ),
    );
  }

  void getInitInfo() async {
    // 获取线路数据
    await getPlanList().then((data) {
      setState(() {
        planList = data;
        tmpPlanList = data;
      });
    });
  }
}