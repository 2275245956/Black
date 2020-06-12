import 'package:flutter/material.dart';

class NewScreen extends StatefulWidget {
  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen>
    with AutomaticKeepAliveClientMixin {
  @override

  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor:  Color(0xFFFFFFFF),
          title:new  Container(
              height: 40,
              width: 300,
              padding: EdgeInsets.only(bottom: 5),
              decoration: new BoxDecoration(
                color: Colors.grey[100],
                borderRadius: new BorderRadius.all(Radius.circular(25.0)),
              ),
              child: new Container(
//                  child:Align(
                //padding: EdgeInsets.only(bottom: 5),
                child:TextField(
                    autofocus: false,
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                    decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search,color: Colors.black26,),
                      suffixIcon: GestureDetector(
                          onTap: ()=>{},
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
                child:Padding(padding: EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: (){},
                    child:Text("搜索",style: TextStyle(color: Colors.black26,fontSize: 18.0),),
                  ),
                )
            )
          ],
        ),
//      )
    );
  }
}
