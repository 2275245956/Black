import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/name_value.dart';
import 'package:intelligent_check_new/services/route_list_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';

class LinesPage extends StatefulWidget {

  final List<String> selectedRoute;
  LinesPage(this.selectedRoute);

  @override
  _LinesPageState createState() => _LinesPageState();
}

class _LinesPageState extends State<LinesPage> {

  final TextEditingController _controller = new TextEditingController();
  List<bool> checklist = new List();
//  bool listClicked=false;
  String theme="";

  _checkIdInSelected(num id){
    bool selected = false;
    this.widget.selectedRoute.forEach((f){
      if(f == id.toString()){
        selected = true;
      }
    });
    return selected;
  }

  List<NameValue> routeList = List();
  List<NameValue> tmpRouteList = List();
  List<NameValue> selected = List();

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
    if(checklist.length <= 0){
      return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: AppBar(
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Color(0xFFFFFFFF),
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context,selected),
              child: Icon(Icons.arrow_back_ios,
                  color: GetConfig.getColor(theme),size: 26,),
            ),
          ),
          title: new  Container(
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
//                      focusNode: _focusNode,
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

//          new Container(
//            height: 40,
//            width: 350,
//            //padding: EdgeInsets.only(bottom: 15.0),
//            //margin: EdgeInsets.only(bottom: 5.0),
//            decoration: new BoxDecoration(
//              color: Colors.grey[100],
//              borderRadius: new BorderRadius.all(Radius.circular(30.0)),
//            ),
//            child: TextField(
//                controller: _controller,
//                autofocus: false,
//                style: TextStyle(fontSize: 15.0, color: Colors.black),
//                decoration: new InputDecoration(
//                    prefixIcon: new Icon(
//                      Icons.search,
//                      color: Colors.black26,
//                    ),
//                    border: InputBorder.none,
//                    hintText: "请输入搜索内容")),
//          ),
          centerTitle: true,
          actions: <Widget>[
            Align(
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if(this._controller.text.isEmpty){
                          this.routeList = tmpRouteList;
                        }else{
                          this.routeList = tmpRouteList.where((f)=>f.name.indexOf(this._controller.text) != -1).toList();
                        }
                      });
                    },
                    child: Text(
                      "搜索",
                      style: TextStyle(color: Colors.black26, fontSize: 16.0),
                    ),
                  ),
                ))
          ],
        ),
      );
    }
    return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: AppBar(
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Color(0xFFFFFFFF),
          leading: new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context,selected),
              child: Icon(Icons.arrow_back_ios,
                  color: GetConfig.getColor(theme),size: 26,),
            ),
          ),
          title: new  Container(
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
//                      focusNode: _focusNode,
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

//          new Container(
//            height: 40,
//            width: 350,
//            //padding: EdgeInsets.only(bottom: 15.0),
//            //margin: EdgeInsets.only(bottom: 5.0),
//            decoration: new BoxDecoration(
//              color: Colors.grey[100],
//              borderRadius: new BorderRadius.all(Radius.circular(30.0)),
//            ),
//            child: Row(
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.only(left: 5,right: 5,top:5),
//                  child: Image.asset("assets/images/search_"+theme+".png",width: 20,color: Colors.black26),
//                ),
//                Container(
//                  width: 190,
//                  child: TextField(
//                      controller: _controller,
//                      autofocus: false,
//                      style: TextStyle(fontSize: 15.0, color: Colors.black),
//                      decoration: new InputDecoration(
////                    prefixIcon: new Icon(
////                      Icons.search,
////                      color: Colors.black26,
////                    ),
//                          border: InputBorder.none,
//                          hintText: "请输入搜索内容")),
//                )
//              ],
//            )
//          ),
          centerTitle: true,
          actions: <Widget>[
            Align(
                child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if(this._controller.text.isEmpty){
                      this.routeList = tmpRouteList;
                    }else{
                      this.routeList = tmpRouteList.where((f)=>f.name.indexOf(this._controller.text) != -1).toList();
                    }
                  });
                },
                child: Text(
                  "搜索",
                  style: TextStyle(color: Colors.black26, fontSize: 16.0),
                ),
              ),
            ))
          ],
        ),
        body: new ListView.builder(
            itemCount: routeList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
//                  height: 50.0,
                  color: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 250.0,
//                                height: 32.0,
                                margin: EdgeInsets.only(left: 20.0, top: 10.0),
                                child: Text(
                                  routeList[index].name,
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black),
                                ),
                              ),
                              new Checkbox(
                                  value: checklist[index],
                                  onChanged: (bool val) {
                                    setState(() {
//                                      listClicked = true;
                                      checklist[index] = !checklist[index];
                                      // 保存数据
                                      if(val){
                                        selected.add(routeList[index]);
                                      }else{
                                        selected.remove(routeList[index]);
                                      }
                                    });
                                  })
                            ]),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Divider(
                            height: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                      ]));
            }));
  }

  void getInitInfo() async {
    // 获取线路数据
    await getRouteList().then((data) {
      setState(() {
        routeList = data;
        tmpRouteList = data;

        for (int i = 0; i < routeList.length; i++){
          if(_checkIdInSelected(routeList[i].value)){
            checklist.add(true);
            selected.add(routeList[i]);
          }else{
            checklist.add(false);
          }
        }
      });
    });
  }
}
