import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/name_value.dart';
import 'package:intelligent_check_new/services/route_list_services.dart';

class SelectRoutePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SelectRoutePageState();

}

class _SelectRoutePageState extends State<SelectRoutePage>{

  final TextEditingController _controller = new TextEditingController();
  FocusNode _focusNode = new FocusNode();
  List<NameValue> routeList = List();
  List<NameValue> tmpRouteList = List();

  @override
  void initState() {
    super.initState();
    getInitInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor:  Color(0xFFFFFFFF),
        leading:new Container(
          child: GestureDetector(
            onTap: () {
              _focusNode.unfocus();
              Navigator.pop(context);
            },
            child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
          ),
        ),
        title:new  Container(
            height: 40,
            width: 250,
            padding: EdgeInsets.only(bottom: 5),
            decoration: new BoxDecoration(
              color: Colors.grey[100],
              borderRadius: new BorderRadius.all(Radius.circular(25.0)),
            ),
            child: new Container(
//                  child:Align(
              child:TextField(
                  controller: _controller,
//                  autofocus: true,
                  focusNode: _focusNode,
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                  decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search,color: Colors.black26,),
                    suffixIcon: GestureDetector(
                        onTap: ()=>_controller.text="",
                        child:new Icon(Icons.delete_forever,color: Colors.black26,)
                    ),
                    border: InputBorder.none,
                  )
              ),
//                  )
            )
        ),
        actions: <Widget>[
          Align(
              child:Padding(padding: EdgeInsets.only(right: 8),
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
                  child:Text("搜索",style: TextStyle(color: Colors.black26,fontSize: 18.0),),
                ),
              )
          )
        ],
      ),
      body: new ListView.builder(
        itemCount: routeList.length,
        itemBuilder: (context, index) {
          return new ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text('${routeList[index].name}'),
                Divider(height: 1,)
              ],
            ),
            onTap: (){
              Navigator.pop(context,NameValue(routeList[index].name, routeList[index].value));
            },
          );
        },
      ),
    );
  }

  void getInitInfo() async {
    // 获取线路数据
    await getRouteList().then((data) {
      setState(() {
        routeList = data;
        tmpRouteList = data;
      });
    });
  }
}