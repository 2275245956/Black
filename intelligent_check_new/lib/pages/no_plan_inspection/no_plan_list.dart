import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/no_plan_inspection/NoPlanPlanInfo.dart';
import 'package:intelligent_check_new/pages/CheckExecute/navigation_checkexec.dart';

class NoPlanListPage extends StatefulWidget{

  final List<NoPlanPlanInfo> noPlanPlanInfo;
  NoPlanListPage(this.noPlanPlanInfo);

  @override
  State<StatefulWidget> createState() => _NoPlanListPageState();

}

class _NoPlanListPageState extends State<NoPlanListPage>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("无计划巡检列表",style: TextStyle(color: Colors.black,fontSize: 19),),
        centerTitle: true,
        elevation: 0.7,
        brightness: Brightness.light,
        backgroundColor:  Colors.grey,
        leading:new Container(
          child: GestureDetector(
            onTap: (){Navigator.pop(context);},
            child:Icon(Icons.keyboard_arrow_left, color: Colors.blue, size: 32),
          ),
        ),
      ),
      body: new ListView.builder(
        itemCount: this.widget.noPlanPlanInfo.length,
        itemBuilder: (context, index) {
          return new ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(this.widget.noPlanPlanInfo[index].taskName??""),
                Divider(height: 1,)
              ],
            ),
            onTap: (){
//
              Navigator.push( context,
                  new MaterialPageRoute(builder: (context) {
                    return NavigationCheckExec(this.widget.noPlanPlanInfo[index].pointId,
                        planId:this.widget.noPlanPlanInfo[index].planTaskId);
                  }));
            },
          );
        },
      ),
    );
  }
}