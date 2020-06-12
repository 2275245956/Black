import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckPoint.dart';
import 'package:intelligent_check_new/pages/CheckExecute/checkexec_spot_detail.dart';
import 'package:intelligent_check_new/services/check_point_service.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovePointSearch extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _MovePointSearch();
}

class _MovePointSearch extends State<MovePointSearch> with SingleTickerProviderStateMixin{
  TabController _tabController;
  int _selectedIndex = 0;

  var titles = ['全部','巡检点', "检查项"];
  Map<int, PageData> allData = new Map();

  bool isAnimating = false;
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  TextEditingController _controller = new TextEditingController();
  FocusNode _focusNode = new FocusNode();

  String theme="";
  bool searchBtnPressed = false;

  @override
  void initState() {
    super.initState();

    initConfig();

    _tabController = new TabController(vsync: this, initialIndex: 0, length: titles.length);
    _tabController.addListener(() {
      if(_tabController.indexIsChanging){
        setState(() => _selectedIndex = _tabController.index);
//        searchData();
      }
    });
    setState(() {
      allData[0] = new PageData();
      allData[1] = new PageData();
      allData[2] = new PageData();
    });
//    searchData();
  }

  // 检索数据
  void searchData() async {
    setState(() {
      isAnimating = true;
    });
    // TODO:根据类型确定检索接口
    // '巡检点', "检查项",
    int pageindex = allData[_selectedIndex].pageindex??0;
//    allData[_selectedIndex].content = [];

    if(this._selectedIndex == 0){
      await queryPointPageForSearch("all",pageindex,10,keywords: _controller.text,isFix: false ).then((data){
        setState(() {
          if(null == allData[_selectedIndex].content){
            allData[_selectedIndex].content = new List();
          }
          allData[_selectedIndex].content.addAll(data.content);
          allData[_selectedIndex].hasnext = !data.last;

          isAnimating = false;
          searchBtnPressed = false;
        });
      });
    }else if(this._selectedIndex == 1){
      await queryPointPageForSearch("point",pageindex,10,keywords: _controller.text,isFix: false ).then((data){
        setState(() {
          if(null == allData[_selectedIndex].content){
            allData[_selectedIndex].content = new List();
          }
          allData[_selectedIndex].content.addAll(data.content);
          allData[_selectedIndex].hasnext = !data.last;

          isAnimating = false;
          searchBtnPressed = false;

        });
      });
    }else if(this._selectedIndex == 2){
      await queryPointPageForSearch("inputItem",pageindex,10,keywords: _controller.text,isFix: false ).then((data){
        setState(() {
          if(null == allData[_selectedIndex].content){
            allData[_selectedIndex].content = new List();
          }
          allData[_selectedIndex].content.addAll(data.content);
          allData[_selectedIndex].hasnext = !data.last;

          isAnimating = false;
          searchBtnPressed = false;

        });
      });
    }
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
      appBar: new AppBar(
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading:new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child:Icon(Icons.keyboard_arrow_left, color:GetConfig.getColor(theme), size: 32),
          ),
        ),
        title:new  Container(
            height: 30,
            width: 250,
            padding: EdgeInsets.only(bottom: 5),
            decoration: new BoxDecoration(
              color: Colors.grey[100],
              borderRadius: new BorderRadius.all(Radius.circular(25.0)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5,right: 5,top:6),
                  child: Image.asset("assets/images/search_"+theme+".png",width: 20,color: Colors.black26),
                ),
                new Container(
                  width: 190,
                  child:TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: new InputDecoration(
//                    prefixIcon: new Icon(Icons.search,color: Colors.black26,),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 1,top:7)
                      )
                  ),
                )
              ],
            )
        ),
        actions: <Widget>[
          Align(
              child:Padding(padding: EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    if(searchBtnPressed){

                    }else{
                      setState(() {
                        allData[_selectedIndex].content = [];
                        allData[_selectedIndex].pageindex = 0;
                        allData[_selectedIndex].hasnext = false;
                        searchBtnPressed = true;
                      });
                      searchData();
                    }
                  },
                  child:Text("搜索",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16.0),),
                ),
              )
          )
        ],
        bottom: new TabBar(
          unselectedLabelColor: Colors.black26,
          labelColor: Theme.of(context).primaryColor,
          isScrollable: true,
          tabs: titles.map((t){
            return new Tab(
              text: t,
            );
          }).toList(),
          controller: _tabController,
        ),
      ),
      body: ModalProgressHUD(
        child:  Container(
          child: Column(
            children: <Widget>[
              Expanded(child: EasyRefresh(
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
                child:new ListView.builder(
                  //ListView的Item
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                      return Column(
                          children: allData[_selectedIndex].content.map((data){
                            return buildListView(index, data);
                          }).toList(),
                      );
                  },
                ),
                loadMore: () async {
                  await new Future.delayed(const Duration(seconds: 1), () {
                    if(allData[_selectedIndex].hasnext){
                      setState(() {
                        allData[_selectedIndex].pageindex = allData[_selectedIndex].pageindex + 1;
                      });
                      searchData();
                    }
                  });
                },
              ),
              flex: 4,),
            ],
          ),
        ),
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }
  //['巡检点', '计划', '线路', "记录", "任务", "检查项", "人员"];
  Widget buildListView(int index, dynamic data){
    return buildPointList(index, data);
  }
  // 构造巡检点listview
  Widget buildPointList(int index, dynamic data){
    CheckPoint point = CheckPoint.fromJson(data);
    return Card(
        elevation:0.2,
        child: new ListTile(
          isThreeLine: true,
          dense: false,
          subtitle: new Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                    point.name,
                style: new TextStyle(
                    fontSize: 18.0,
                    fontWeight:
                    FontWeight.w600),
              ),
              Padding(
                padding:
                EdgeInsets.only(top: 5),
              ),
              Text(
                "编号:" +
                    point.pointNo,
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey),
              ),
            ],
          ),
          trailing: new Padding(
            child: new Icon(
                Icons.keyboard_arrow_right),
            padding: EdgeInsets.only(top: 15),
          ),
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(
                    builder: (context) {
                      return new CheckExecSpotDetail(
                          point.id,false);
                    }));
          })
    );
  }
}


class PageData{
  int pageindex = 0;
  bool hasnext = false;
  List<dynamic> content = new List();
}