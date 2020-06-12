import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/pages/CheckExecute/ImageView.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageListView extends StatefulWidget{

  final List<Image> imageList;
  ImageListView(this.imageList);

  @override
  State<StatefulWidget> createState() {
    return _ImageListViewState();
  }
}

class _ImageListViewState extends State<ImageListView>{

  List<Image> _imageList = List();
  String theme="";
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

  @override
  Widget build(BuildContext context) {
    if(this.theme.isEmpty){
      return Scaffold(
          body:Text("")
      );
    }
      return Scaffold(
      appBar: AppBar(
        title: Text("照片列表",style: TextStyle(color: Colors.black,fontSize: 19),),
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
      ),
      body: (_imageList == null || _imageList.length == 0) ? Container():
      Wrap(
          children:_imageList.map((f){
            return Stack(
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(right: 5),
                      child: f,
                      width: 160,
                      height: 100,
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context){
                        return ImageView(f);
                      }));
                    },
                  ),
                )
              ],
            );
          }
          ).toList()
      )
//          GridView.count(
//              shrinkWrap:true,
////            padding: const EdgeInsets.only(left:15,right: 15),
//            crossAxisCount: 3,                  // 横向 Item 的个数
//            children:_imageList.map((f){
//              return Stack(
//                children: <Widget>[
//                  Container(
//                    child: GestureDetector(
//                      child: Container(
//                        padding: EdgeInsets.only(right: 5),
//                        child: f,
//                        width: 160,
//                        height: 100,
//                      ),
//                      onTap: (){
//                        Navigator.push(context, MaterialPageRoute(builder:(context){
//                          return ImageView(f);
//                        }));
//                      },
//                    ),
//                  )
//                ],
//              );
//            }
//          ).toList()
//      ),
    );
  }
}