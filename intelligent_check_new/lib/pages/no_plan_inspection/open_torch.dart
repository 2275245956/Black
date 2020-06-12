import 'package:flutter/material.dart';

class OpenTorch extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _OpenTorchState();
}

class _OpenTorchState extends State<OpenTorch>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("手电筒操作",style: TextStyle(color: Colors.black,fontSize: 19),),
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
      body: Container(
        width: double.infinity,
        color: Colors.black54,
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 100),),
            Text("手电筒暂时无法打开！",style: TextStyle(color: Colors.red,fontSize: 16),),
            Image.asset("assets/images/flutter.png",width: 100,height: 200,),
          ],
        ),
      ),
    );
  }

}