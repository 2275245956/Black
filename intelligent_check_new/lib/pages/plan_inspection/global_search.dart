import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/model/plan_list_input.dart';
import 'package:intelligent_check_new/model/plan_list_output.dart';
import 'package:intelligent_check_new/pages/plan_inspection/plan_list_content.dart';
import 'package:intelligent_check_new/services/plan_inspection_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';

class GlobalSearch extends StatefulWidget{

  final num type;// 0:计划巡检,1:安全执行
  final PlanListInput planListInput;

  GlobalSearch(this.type,this.planListInput);
  @override
  State<StatefulWidget> createState() => _GlobalSearch();
}

class _GlobalSearch extends State<GlobalSearch> with SingleTickerProviderStateMixin{
  TabController _tabController;
  int _selectedIndex = 0;

  var titles = ['全部','线路', '计划',/*"检查项",*/ "检查点"/*,"执行人"*/];
  Map<int, PageData> allData = new Map();

  bool isAnimating = false;
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  TextEditingController _controller = new TextEditingController();
  FocusNode _focusNode = new FocusNode();

  String theme="";
  bool searchBtnPressed = false;


//  // 当前页码
//  int pageIndex=0;
//  // 是否有下一页
//  bool hasNext=false;

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
      allData[3] = new PageData();
      allData[4] = new PageData();
//      allData[5] = new PageData();
    });
//    searchData();
  }

  // 检索数据
  void searchData() async {
    // TODO:根据类型确定检索接口
    setState(() {
      isAnimating = true;
    });
    // '全部','线路', '计划',"检查项", "检查点"
    int pageindex = allData[_selectedIndex].pageindex??0;
//    allData[_selectedIndex].content = [];
    if(this._selectedIndex == 0){
      await getPlanListForSelect("all",pageindex,10,this.widget.planListInput,keywords: _controller.text ).then((data){
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
      await getPlanListForSelect("route",pageindex,10,this.widget.planListInput,keywords: _controller.text ).then((data){
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
      await getPlanListForSelect("plan",pageindex,10,this.widget.planListInput,keywords: _controller.text ).then((data){
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
    }else if(this._selectedIndex == 3){
      await getPlanListForSelect("point",pageindex,10,this.widget.planListInput,keywords: _controller.text ).then((data){
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
    //执行人
//    else if(this._selectedIndex == 4){
//      await getPlanListForSelect("executiveName",pageindex,10,this.widget.planListInput,keywords: _controller.text ).then((data){
//        setState(() {
//          if(null == allData[_selectedIndex].content){
//            allData[_selectedIndex].content = new List();
//          }
//          allData[_selectedIndex].content.addAll(data.content);
//          allData[_selectedIndex].hasnext = !data.last;
//          isAnimating = false;
//          searchBtnPressed = false;
//        });
//      });
//    }
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
                          contentPadding:EdgeInsets.only(top: 8)
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
          margin: EdgeInsets.only(top: 4),
          child: Column(
            children: <Widget>[
              Expanded(
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
//                  onRefresh: () async {
//                    await new Future.delayed(const Duration(seconds: 1), () {
//                      searchData();
//                    });
//                  },
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
    ) ;
  }
  //['巡检点', '计划', '线路', "记录", "任务", "检查项", "人员"];
  Widget buildListView(int index, dynamic data){
    return buildPointList(index, data);
  }
  // 构造巡检点listview
  Widget buildPointList(int index, dynamic data){
    PlanListOutput plan = PlanListOutput.fromJson(data);
    return Container(
      height: 130.0,
      margin: EdgeInsets.only(left: 16,right: 16),
      child: GestureDetector(
        child: Card(
            elevation:0.2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 8,
                  height: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(4),bottomLeft:  Radius.circular(4)),
                      color: getBgColor(plan.finishStatus)
                  ),
//                                              color: getBgColor(initData[index].finishStatus),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 3),),
                    Container(
                      width:280,
                      padding: EdgeInsets.only(left: 10),
                      child: Text(plan.taskName??"",style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),
                    ),
                    Padding(padding: EdgeInsets.only(top: 5),),
                    Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 140,
                                      child: Text("计划批号:" + plan.batchNo.toString(),
                                        style: TextStyle(color:Colors.grey,fontSize: 12),),
                                    ),
                                    Container(
                                      width: 100,
                                      child: Text(getStatus(plan.finishStatus),
                                        style: TextStyle(color: getBgColor(plan.finishStatus),fontSize: 12),),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 140,
                                      child: Text("计划巡检:" + plan.taskPlanNum.toString(),
                                          style: TextStyle(color:Colors.grey,fontSize: 12)),
                                    ),
                                    Container(
                                      width: 100,
                                      child:Text("剩余:" + (plan.taskPlanNum - plan.finshNum).toString(),
                                          style: TextStyle(color:Colors.grey,fontSize: 12)),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 240,
                                      child: plan.executiveName == null?Text("执行人:",style: TextStyle(color:Colors.grey,fontSize: 12))
                                          :Text("执行人:" + plan.executiveName,
                                          style: TextStyle(color:Colors.grey,fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                                width: 50,
//                                                          height: 140,
                                child: Icon(Icons.keyboard_arrow_right,color:  GetConfig.getColor(theme),),
                                alignment: Alignment.centerRight
                            ),
                          ],
                        )
                    )
                    ,
                    Padding(padding: EdgeInsets.only(top: 10),),
                    Container(
                      height: 25,
                      width: 312,
                      color: Colors.grey[100],
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(plan.beginTime + " - " + plan.endTime,style: TextStyle(color: Colors.grey[500],fontSize: 12),),
                    )
                  ],
                ),
              ],
            )
        ),
        onTap: (){
          Navigator.push( context,
              new MaterialPageRoute(builder: (context) {
                return new PlanListContent(plan.planTaskId);
              }));
        },
      ),
    );
  }

  Color getBgColor(int finishStatus){
    if(finishStatus == 0) { // 未开始
      return Colors.grey;
    }else if(finishStatus == 1) { // 进行中
      return Colors.orange;
    }else if(finishStatus == 2) { // 已结束
      return Colors.red[800];
    }else if(finishStatus == 3) { // 已超时
      return Colors.redAccent;
    }else{
      return Colors.white;
    }
  }

  String getStatus(int finishStatus){
    if(finishStatus == 0) { // 未完成
      return "未开始";
    }else if(finishStatus == 1) { // 进行中
      return "进行中";
    }else if(finishStatus == 2) { // 未开始
      return "已结束";
    }else if(finishStatus == 3) { // 已超时
      return "已超时";
    }else{
      return "";
    }
  }
}


class PageData{
  int pageindex = 0;
  bool hasnext = false;
  List<dynamic> content = new List();
}