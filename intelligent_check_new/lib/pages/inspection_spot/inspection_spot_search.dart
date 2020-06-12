import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/pages/inspection_spot/inspection_spot_search_result.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/widget/search/hotSug.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InspectionSpotSearchPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _InspectionSpotSearchPageState();
}

class _InspectionSpotSearchPageState extends State<InspectionSpotSearchPage>{

  final TextEditingController _controller = new TextEditingController();
  FocusNode _focusNode = new FocusNode();

  List<String> hotWords = List();
//  Map<String,int> searchKeyCount = Map<String,int> ();
  List<_SearchKey> searchKeyCount = List();
  List<String> orderKeyword = List();

  bool _isNotSearching = true;
//  List<String> brandName = List();
//  Map<String,dynamic> brandName = Map();

  String theme="blue";

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 243, 245, 1),
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
                child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
              ),
            ),
            title:new  Container(
                height: 30,

                padding: EdgeInsets.only(bottom: 5),
                decoration: new BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0,left: 10.0,top: 5),
                      child: Image.asset("assets/images/search_blue.png",width: 14,color: Colors.black26),
                    ),
                    new Container(
//                  child:Align(
                      width: MediaQuery.of(context).size.width-160,
                      child:TextField(
                        controller: _controller,
                        autofocus: true,
                        focusNode: _focusNode,
                        style: TextStyle(fontSize: 14.0, color: Color(0xFF999999)),
                        decoration: new InputDecoration(
//                          prefixIcon: new Icon(Icons.search,color: Colors.black26,),
                          suffixIcon: GestureDetector(
                              onTap: (){
                                _controller.text="";
                                setState(() {
                                  _isNotSearching = true;
//                                  brandName = [];
//                                  brandName = {};
                                });
                              },
                              child:Container(
                                padding: EdgeInsets.only(top:6),
                                child: new Icon(Icons.delete_forever,color: Color(0xFFB2B2B2),size: 18,),
                              )
                          ),
                          border: InputBorder.none,
                            hintText: "请输入搜索内容",
                            contentPadding: EdgeInsets.only(top: 6)
                        ),
                        onChanged: (val){
//                          if(this._controller.text.isNotEmpty){
//                            setState(() {
//                              _isNotSearching = false;
//                            });
//                            getBrandNameByKeyword(this._controller.text).then((data){
//                              setState(() {
//                                print(brandName);
//                                brandName = data;
//                              });
//                            });
//                          }else{
//                            setState(() {
//                              _isNotSearching = true;
////                            brandName = [];
//                              brandName = {};
//                            });
//                          }
                        },

                      ),
//                  )
                    )
                  ],
                )
            ),
            actions: <Widget>[
              Align(
                  child:Padding(padding: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            search(this._controller.text);
                            this._controller.text="";
                          });
                        },
                        child:Text("搜索",style: TextStyle(color: Color(0xFF999999),fontSize: 14.0,fontWeight: FontWeight.w500),),
                      ),
                  )
                )
            ],
          ),
//      ),
        body:ListView(
          children: <Widget>[
            Offstage(
              offstage: !_isNotSearching,
              child:Container(
                color: Colors.white,

                child:HotSugWidget(title:"搜索历史",hotWords:hotWords,searchData: searchByHistory,deleteBtnClick:deleteSearchHistory,theme:theme),
              )
            ),
          ],
        ),
      resizeToAvoidBottomPadding: false,
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
    initConfig();
  }

  void initData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String> data = prefs.getStringList("hotWordsHistory");
      if(data != null && data.length > 0){
        hotWords = data;
      }else{
        hotWords =[];
      }
    });
  }

  search(keyword) async{
    if(keyword != null && keyword.isNotEmpty){

      // 添加搜索历史
      if(hotWords.contains(keyword)){

      }else{
        setState(() {
          hotWords.add(keyword);
        });
        final prefs = await SharedPreferences.getInstance();
        prefs.setStringList("hotWordsHistory", hotWords);
      }

      // 页面跳转，查询并显示结果
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) {
            return new InspectionSpotSearchResultPage(keyword);
          })
      );
    }
  }

  searchByHistory(String text){
    // 页面跳转，查询并显示结果
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) {
          return new InspectionSpotSearchResultPage(text);
        })
    );
  }

  deleteSearchHistory() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("hotWordsHistory");
    initData();
  }
}

class _SearchKey {
  String keyword;
  int count;

  _SearchKey();

  _SearchKey.fromJson(jsonRes) {
    keyword = jsonRes['keyword'];
    count = jsonRes['count'];
  }

  @override
  String toString() {
    return '{"keyword":"$keyword","count": $count}';
  }
}