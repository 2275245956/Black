import 'package:dropdown_menu/_src/dropdown_header.dart';
import 'package:dropdown_menu/_src/dropdown_menu.dart';
import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/message/MessageDetail.dart';
import 'package:intelligent_check_new/model/message/MessageType.dart';
import 'package:intelligent_check_new/pages/message/message_detail.dart';
import 'package:intelligent_check_new/services/message_service.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MessageListPageState();
  }

}

class _MessageListPageState extends State<MessageListPage>{

  List<Map<String, dynamic>> types = List();
  List<MessageDetail> initData = List();
  // 当前页码
  int pageIndex=0;
  // 是否有下一页
  bool hasNext=false;
  // 分页所需控件
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  bool isAnimating = false;
  MessageType condition;
  String theme="";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 246, 249, 1),
      appBar: AppBar(
        title: Text(
          "消息提醒",
          style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1), fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context,"return"),
            child: Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
          ),
        ),
      ),
      body: ModalProgressHUD(
        child: _getWidget(),
        inAsyncCall: isAnimating,
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
      )
    );
  }

  Widget _getWidget() {
    return buildInnerListHeaderDropdownMenu();
  }

  ScrollController scrollController = new ScrollController();
  GlobalKey globalKey2 = new GlobalKey();

  Widget buildInnerListHeaderDropdownMenu() {
    return new DefaultDropdownMenuController(
        onSelected: ({int menuIndex, int index, int subIndex, dynamic data}) {
          print(data);
          setState(() {
            pageIndex = 0;
            this.condition = MessageType.fromParams(data["title"],data["id"].toString());
//            this.condition.id = data["id"];
//            this.condition.title = data["title"];
            initData = [];
          });
          if(condition.id == "-1"){
            getData(null);
          }else{
            getData(condition);
          }
        },
        child: new Stack(
          children: <Widget>[
            new CustomScrollView(
                controller: scrollController,
                slivers: <Widget>[
                  new SliverList(
                      key: globalKey2,
                      delegate: new SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return new Container(
                              color: Colors.black26,
                            );
                          }, childCount: 1)),
                  new SliverPersistentHeader(
                    delegate: new DropdownSliverChildBuilderDelegate(
                        builder: (BuildContext context) {
                          return new Container(
                              color: Colors.white,
                              child: buildDropdownHeader(onTap: this._onTapHead));
                        }),
                    pinned: true,
                    floating: true,
                  ),
                  new SliverList(
                      delegate: new SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
//                            return new Container(
//                              color: Theme.of(context).scaffoldBackgroundColor,
//                              child: new Image.asset(
//                                "images/body.jpg",
//                                fit: BoxFit.fill,
//                              ),
//                            );
                          }, childCount: 10)),
                ]),
            new Padding(
                padding: new EdgeInsets.only(top: 46.0),
                child: new Stack(children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Expanded(child: new Container(
                        child: GestureDetector(
                          child: Center(
                            child: EasyRefresh(
                              key: _easyRefreshKey,
                              behavior: ScrollOverBehavior(),
                              refreshHeader: ClassicsHeader(
                                key: _headerKey,
                                bgColor: Colors.transparent,
                                textColor: Colors.black87,
                                moreInfoColor: Colors.black54,
                                showMore: true,
                              ),
                              refreshFooter: ClassicsFooter(
                                key: _footerKey,
                                bgColor: Colors.transparent,
                                textColor: Colors.black87,
                                moreInfoColor: Colors.black54,
                                showMore: true,
                              ),
                              child: ListView.builder(
                                //ListView的Item
                                itemCount: initData==null?0:initData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                        child:  Container(
                                          margin: EdgeInsets.only(left: 10,right:10),

                                          child: Card(
                                              elevation:0.2,
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    height: 30,
                                                    color: Colors.grey[100],
                                                    child: Row(
                                                      children: <Widget>[
                                                        getTitle(initData[index].msgType,initData[index].title)
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          flex: 9,
                                                          child:  Container(

                                                              child: Text(initData[index].body.replaceAll(r"<br />", "\r\n").replaceAll(r"<br>", "\r\n"),
                                                                style: TextStyle(color: initData[index].isRead?Colors.grey:Colors.black),
                                                                maxLines: 10,overflow: TextOverflow.ellipsis,)
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child:   Container(
                                                            child: Icon(Icons.keyboard_arrow_right,color: GetConfig.getColor(theme),),
                                                            alignment: Alignment.centerRight,
                                                          ),
                                                        ),


                                                      ],
                                                    ),

                                                  )
                                                ],
                                              )
                                          ),

                                        ),
                                        onTap: (){
                                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                                            return new MessageDetailPage(initData[index]);
                                          })).then((v){
                                            setState(() {
                                              MessageDetail msg = initData.singleWhere((f)=>f.id == v);
                                              msg.isRead = true;
                                            });
                                          });
                                        },
                                      );

                                },
                              ),
                              onRefresh: () async {
                                await new Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    pageIndex = 0;
                                    initData = [];
                                  });
                                  getData(condition);
                                });
                              },
                              loadMore: () async {
                                await new Future.delayed(const Duration(seconds: 1), () {
                                  if(hasNext){
                                    setState(() {
                                      pageIndex = pageIndex + 1;
                                    });
                                    getData(condition);
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                  buildDropdownMenu(),
                ])),
          ],
        ));
  }

  void _onTapHead(int index) {
    RenderObject renderObject = globalKey2.currentContext.findRenderObject();
    DropdownMenuController controller =
    DefaultDropdownMenuController.of(globalKey2.currentContext);

    scrollController
        .animateTo(scrollController.offset + renderObject.semanticBounds.height,
        duration: new Duration(milliseconds: 150), curve: Curves.ease)
        .whenComplete(() {
      controller.show(index);
    });
  }

  String titleRoot = '全部消息';

  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    return new DropdownHeader(
      onTap: onTap,
      titles: [titleRoot],
    );
  }

  static const int TYPE_INDEX = 0;

  DropdownMenu buildDropdownMenu() {
    return new DropdownMenu(
        maxMenuHeight: kDropdownMenuItemHeight * 10,
        menus: [
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: TYPE_INDEX,
                  data: types,
                  itemBuilder:
                      (BuildContext context, dynamic data, bool selected) {
                    return new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Row(
                          children: <Widget>[
                            new Text(
                              defaultGetItemLabel(data),
                              style: selected
                                  ? new TextStyle(
                                  fontSize: 14.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400)
                                  : new TextStyle(fontSize: 14.0),
                            ),
                            new Expanded(
                                child: new Align(
                                  alignment: Alignment.centerRight,
                                  child: selected
                                      ? new Icon(
                                    Icons.check,
                                    color: Theme.of(context).primaryColor,
                                  )
                                      : null,
                                )),
                          ],
                        ));
                  },
                );
              },
              height: kDropdownMenuItemHeight * types.length),
        ]);
  }

  @override
  void initState() {
    super.initState();
    getMsgType();
    initConfig();
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  getMsgType() async{
    setState(() {
      isAnimating = true;
    });
    await getMessgaeType().then((data){
      setState(() {
//        types.add(MessageType.fromParams("全部", "-1"));
//        data.keys.forEach((f){
//          MessageType d = MessageType.fromParams(data[f],f);
//          types.add(d);
//        });
        data.forEach((k,v){
          Map<String, dynamic> _map = Map();
          _map["title"] = v;
          _map["id"] = k;
          types.add(_map);
        });
        Map<String, dynamic> _allMap = Map();
        _allMap["title"] = "全部";
        _allMap["id"] = -1;
        types.insert(0, _allMap);

      });
    }).then((data){
      getData(null);
    });
  }

  getData(MessageType condition)async{
    setState(() {
      isAnimating = true;
    });
    await getMessageList(condition,pageIndex).then((data){
      if(data != null && data.content != null && data.content.length>0){
        hasNext = !data.last;
        setState(() {
          for(var _data in data.content){
            initData.add(MessageDetail.fromJson(_data));
          }
        });
      }
      setState(() {
        isAnimating = false;
      });
    });
  }

  getTitle(String type,String title){
    var row=Row(children: <Widget>[
        Image.asset("assets/images/message/planEnd_"+theme+".png",height: 20,),
        Text(title)
      ],);
//    if(type=="check"){
//      row = Row(
//        children: <Widget>[
//          Image.asset("assets/images/message/check_"+theme+".png",height: 20,),
//          Text("隐患排查")
//        ],
//      );
//    }else if(type=="task"){
//      row = Row(
//        children: <Widget>[
//          Image.asset("assets/images/message/task_"+theme+".png",height: 20,),
//          Text("隐患治理")
//        ],
//      );
//    }else if(type=="planBegin"){
//      row = Row(
//        children: <Widget>[
//          Image.asset("assets/images/message/planBegin_"+theme+".png",height: 20,),
//          Text("计划开始")
//        ],
//      );
//    }else if(type=="planWarn"){
//      row = Row(
//        children: <Widget>[
//          Image.asset("assets/images/message/planWarn_"+theme+".png",height: 20,),
//          Text("计划提醒")
//        ],
//      );
//    }else if(type=="planEnd"){
//      row = Row(
//        children: <Widget>[
//          Image.asset("assets/images/message/planEnd_"+theme+".png",height: 20,),
//          Text("漏检提醒")
//        ],
//      );
//    }else if(type=="notify"){
//      row = Row(
//        children: <Widget>[
////          Image.asset("assert/images/message/漏检提醒.png"),
//          Text("通知公告")
//        ],
//      );
//    }else{
//      row=Row(children: <Widget>[
//        Image.asset("assets/images/message/planEnd_"+theme+".png",height: 20,),
//        Text("test 名字")
//      ],);
//    }
    return row;
  }
}