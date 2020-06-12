import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageView.dart';
import 'package:intelligent_check_new/pages/CheckExecute/VideoView.dart';
import 'package:intelligent_check_new/pages/CheckExecute/VideoViewSmall.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';

class ImageList extends StatefulWidget{

  final List<File> imageList;
  ImageList(this.imageList);

  @override
  State<StatefulWidget> createState() {
    return _ImageListState();
  }
}

class _ImageListState extends State<ImageList>{
  String theme="";
  List<File> _imageList = List();
  @override
  void initState() {
    super.initState();
    _imageList = this.widget.imageList??List();
    initConfig();
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  List<Widget> getImagesWidget(){
    List<Widget> widgets = List();
    _imageList.forEach((c){
      widgets.add(Stack(
        children: <Widget>[
          Container(
            width: 110,
            height: 140,
            margin: EdgeInsets.only(top: 15,left: 5),
            child: GestureDetector(
              child: c.path.substring(c.path.lastIndexOf("."))==".jpg"?Image.file(c):VideoViewSmallPage(c),
              onTap: (){
                String fileType=c.path.substring(c.path.lastIndexOf("."));
                if(fileType==".jpg"){
                  Navigator.push(context, MaterialPageRoute(builder:(context){
                    return ImageView(Image.file(c));
                  }));
                }else{
                  // 视频
                  Navigator.push(context, MaterialPageRoute(builder:(context){
                    return VideoViewPage(c);
                  }));
                }
              },
            ),
//            padding: EdgeInsets.only(top: 10),
          ),
          Positioned(
              right: 0.0,
              top: 0.0,
              left: 100,
              child:  InkWell(
                  child: Icon(Icons.cancel, color: Theme.of(context).disabledColor),
                  onTap: () {
                    setState(() {
                      _imageList.remove(c);
                    });
                  })
          )
        ],
      ));
    });

    // left: 10, top: 10,bottom:6按钮
    widgets.add(
        Container(
            width: 110,
            height: 140,
            margin: EdgeInsets.only(top: 15,left: 10),
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.grey[200], width: 0.5), // 边色与边宽度
                  color: Colors.grey[200]
              ),
              padding: EdgeInsets.only(top: 40),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      ImagePicker.pickImage(source: ImageSource.camera).then((c){
                        setState(() {
                          if(c!=null){
                            _imageList.insert(0,c);
                          }
                        });
                      });
                    },
                    onLongPress: (){
                      ImagePicker.pickVideo(source: ImageSource.camera).then((f){
                        setState(() {
                          if(f!=null){
                            _imageList.insert(0,f);
                          }
                        });
                      });
                    },
                    child: IconButton(icon: Icon(Icons.camera_alt,size: 28,color: GetConfig.getColor(theme),),
//                      onPressed: (){
//                        ImagePicker.pickImage(source: ImageSource.camera).then((c){
//                          setState(() {
//                            if(c!=null){
//                              _imageList.insert(0,c);
//                            }
//                          });
//                        });
//                      },
                    ),
                  )
                ],
              ),
            )
        )
    );
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    if(this.theme.isEmpty){
      return Scaffold(
          body:Text("")
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("现场照片",style: TextStyle(color: Colors.black,fontSize: 19),),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor:  Colors.white,
        leading:new Container(
          child: GestureDetector(
            onTap: (){Navigator.pop(context);},
            child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
          ),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: Text("提交",style: TextStyle(color: GetConfig.getColor(theme),fontSize: 18),),
              onTap: (){
                Navigator.pop(context,_imageList);
              },
            ),
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
      body:
      Wrap(
//              runSpacing: 3, //交叉轴上子控件之间的间距
          children:getImagesWidget()
      ),
//          GridView.count(
//            padding: const EdgeInsets.only(left:15,right: 15),
//            crossAxisCount: 3,                  // 横向 Item 的个数
//            children:_imageList.map((f){
//              return Stack(
//                children: <Widget>[
//                  Container(
//                    child: GestureDetector(
//                      child: Image.file(f,width: 160,height: 100,),
//                      onTap: (){
//                        Navigator.push(context, MaterialPageRoute(builder:(context){
//                          return ImageView(Image.file(f));
//                        }));
//                      },
//                    ),
//                    padding: EdgeInsets.only(top: 10),
//                  ),
//                  Positioned(
//                    right: 0.0,
//                    top: 0.0,
//                    child:  InkWell(
//                        child: Icon(Icons.cancel, color: Theme.of(context).disabledColor),
//                        onTap: () {
//                          setState(() {
//                            _imageList.remove(f);
//                          });
//                        })
//                  )
//                ],
//              );
//            }
//          ).toList()
//      ),
    );
  }
}