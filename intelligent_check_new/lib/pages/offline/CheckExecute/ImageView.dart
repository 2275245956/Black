import 'package:flutter/material.dart';

class ImageView extends StatefulWidget{

  final Image file;
  ImageView(this.file);

  @override
  State<StatefulWidget> createState() {
    return _ImageViewState();
  }
}

class _ImageViewState extends State<ImageView>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("图片浏览",style: TextStyle(color: Colors.black,fontSize: 19),),
          centerTitle: true,
          elevation: 0.7,
          brightness: Brightness.light,
          backgroundColor:  Colors.white,
          leading:new Container(
            child: GestureDetector(
              onTap: (){Navigator.pop(context);},
              child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
            ),
          ),
        ),
        body: this.widget.file
    );
  }
}