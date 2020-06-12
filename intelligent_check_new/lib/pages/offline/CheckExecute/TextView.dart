import 'package:flutter/material.dart';

class TextView extends StatefulWidget{

  final String text;
  final bool readonly;
  TextView({this.text,this.readonly = false});

  @override
  State<StatefulWidget> createState() {
    return _TextView();
  }
}

class _TextView extends State<TextView>{

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    this.widget.text == null || this.widget.text.isEmpty?_textEditingController.text=""
                  :_textEditingController.text=this.widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("备注说明",style: TextStyle(color: Colors.black,fontSize: 19),),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor:  Colors.white,
        leading:new Container(
          child: GestureDetector(
            onTap: (){Navigator.pop(context,"back");},
            child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
          ),
        ),
        actions: <Widget>[
          (this.widget.readonly) ?  Container() : IconButton(
            icon: Icon(Icons.save),color: Colors.red,onPressed: (){
            Navigator.pop(context,this._textEditingController.text);
          },)
        ],
      ),
      body: TextField(
        maxLines: 10,
        controller: _textEditingController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10,right: 10)
        ),
      ),
    );
  }
}