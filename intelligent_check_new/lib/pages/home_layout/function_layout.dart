import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/home_function_model.dart';

class FunctionLayout extends StatefulWidget{

  final String title;
  final List<HomeFunctionModel> functions;
  FunctionLayout(this.title,this.functions);

  @override
  State<StatefulWidget> createState() => new _FunctionLayoutPage();

}

class _FunctionLayoutPage extends State<FunctionLayout>{
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child:new Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 10),),
                new Text(this.widget.title)
              ],
            ),
            width: double.infinity,
            height: 40.0,
            margin: const EdgeInsets.only(left:20.0,right: 20.0,top: 20.0),
            decoration: new BoxDecoration(
                color: Color.fromRGBO(250, 251, 252, 1),
                borderRadius: new BorderRadius.vertical(top:Radius.circular(5.0)),
//                boxShadow: <BoxShadow>[
//                  new BoxShadow(
//                    spreadRadius: 1.0,
//                    blurRadius: 5.0,
//                    offset: const Offset(0.6, 1.2),
//                    color: Colors.white,
//                  )
//                ]
            ),
          ),
          new Container(
            width: double.infinity,
            height: 110.0,
            margin: const EdgeInsets.only(left:20.0,right: 20.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.vertical(bottom:Radius.circular(5.0)),
            ),
            child:new Row(
              children: this.widget.functions.map((f){
                return new Column(
                    children: <Widget>[
                      new Container(
                        width: 80.0,
                        height: 60.0,
                        margin: const EdgeInsets.only(top:20.0),
                        child: f.isBadgeIcon?
                        BadgeIconButton(
                            itemCount: f.itemCount, // required
                            icon: f.functionIcon, // required
                            badgeColor: Colors.red, // default: Colors.red
                            badgeTextColor: Colors.white, // default: Colors.white
                            hideZeroCount: true, // default: true
                            onPressed: (){
                              Navigator.push( context,
                                  new MaterialPageRoute(builder: (context) {
                                    return f.navPage;
                                  }));
                            }):
                        new IconButton(
                          icon: f.functionIcon,
                          onPressed: () {
                            Navigator.push(context,
                                new MaterialPageRoute(builder: (context) {
                                  return f.navPage;
                                }));
                          },
                        ),
                      ),
                      f.functionName
                    ]
                );
              }).toList()
            ),
          )
        ],
      ),
    );
  }
}