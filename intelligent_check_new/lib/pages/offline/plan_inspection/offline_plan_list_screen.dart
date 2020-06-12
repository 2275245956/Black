import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/pages/offline/plan_inspection/offline_plan_list_content.dart';
import 'package:intelligent_check_new/services/offline/offline_plan_inspection_services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class OfflinePlanListScreen extends StatefulWidget {
  @override
  _PlanListScreenState createState() => _PlanListScreenState();
}

class _PlanListScreenState extends State<OfflinePlanListScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  bool isAnimating = false;

  String myUserId;

  List<dynamic> initData = List();

  // 当前页码
  int pageIndex=1;
  // 是否有下一页
  bool hasNext=false;
  // 分页所需控件
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getInitInfo();
  }

  void getInitInfo() async{
    await SharedPreferences.getInstance().then((data){
      if(data != null){
        setState(() {
          myUserId = LoginResult(data.get('LoginResult')).user.id;
        });
      }
    }).then((data){
      loadData();
    });
  }

  void loadData () async{
    setState(() {
      isAnimating = true;
    });
    await getOfflinePlanListOutputList().then((data){
      setState(() {
        if(data != null && data.content != null && data.content.length>0){
          initData = data.content;
          hasNext = !data.last;
        }
        isAnimating = false;
      });

    });
  }

  searchData(){
    this.initData = [];
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if(this.initData.length == 0){
      return Scaffold(
        appBar: AppBar(
          title: Text("计划巡检",style: TextStyle(color: Colors.black,fontSize: 19),),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading:new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
            ),
          ),
        )
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("计划巡检",style: TextStyle(color: Colors.black,fontSize: 19),),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading:new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
          ),
        ),
      ),
      body: ModalProgressHUD(
        child:_getWidget(),
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
//        content: '加载中...',
      ),
      resizeToAvoidBottomPadding: false,
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
    if(finishStatus == 0) {
      return "未执行";
    }else if(finishStatus == 1) {
      return "执行中";
    }else if(finishStatus == 2) {
      return "已执行";
    }else if(finishStatus == 3) {
      return "已超时";
    }else{
      return "";
    }
  }

  Widget _getWidget(){
    return new Stack(
      children: <Widget>[
        new Padding(
            padding: new EdgeInsets.only(top: 5.0),
            child: new Column(
              children: <Widget>[
                new Expanded(
                    child: new Stack(
                      children: <Widget>[
                        EasyRefresh(
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
                          child: new ListView.builder(
                            //ListView的Item
                            itemCount: initData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return  GestureDetector(
                                onTap: (){
                                  Navigator.push( context,
                                      new MaterialPageRoute(builder: (context) {

                                        return new OfflinePlanListContent(initData[index]);
                                        //return new PlanListContent(initData[index].planTaskId, initData[index].taskName);
                                      })).then((result){
                                        loadData();
                                  });
                                },
                                child: Container(
                                  height: 150.0,
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  child: Card(
                                      elevation:0.2,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 8,
                                            height: 150,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(4),bottomLeft:  Radius.circular(4)),
                                                color: getBgColor(initData[index].finishStatus)
                                            ),
//                                              color: getBgColor(initData[index].finishStatus),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.only(top: 8),),
                                              Container(
                                                width:280,
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text(initData[index].taskName,style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),
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
                                                                child: Text("计划批号:" + initData[index].batchNo.toString(),
                                                                  style: TextStyle(color:Colors.grey,fontSize: 15),),
                                                              ),
                                                              Container(
                                                                width: 100,
                                                                child: Text(getStatus(initData[index].finishStatus),
                                                                  style: TextStyle(color: getBgColor(initData[index].finishStatus),fontSize: 15),),
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Container(
                                                                width: 140,
                                                                child: Text("计划巡检:" + initData[index].taskPlanNum.toString(),
                                                                    style: TextStyle(color:Colors.grey,fontSize: 15)),
                                                              ),
                                                              Container(
                                                                width: 100,
                                                                child:Text("剩余:" + (initData[index].taskPlanNum - initData[index].finshNum).toString(),
                                                                    style: TextStyle(color:Colors.grey,fontSize: 15)),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                          width: 50,
//                                                          height: 140,
                                                          child: Icon(Icons.keyboard_arrow_right,color: Colors.red,),
                                                          alignment: Alignment.centerRight
                                                      ),
                                                    ],
                                                  )
                                              )
                                              ,
                                              Padding(padding: EdgeInsets.only(top: 25),),
                                              Container(
                                                height: 35,
                                                width: 323,
                                                color: Colors.grey[100],
                                                padding: EdgeInsets.only(left: 10),
                                                alignment: Alignment.centerLeft,
                                                child: Text(initData[index].beginTime + " - " + initData[index].endTime,style: TextStyle(color: Colors.grey[500]),),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              );
                            },
                          ),
                          onRefresh: () async {
                            await new Future.delayed(const Duration(seconds: 1), () {
                              setState(() {
                                pageIndex = 1;
                                initData = [];
                              });
                              loadData();
                            });
                          },
                          loadMore: () async {
                            await new Future.delayed(const Duration(seconds: 1), () {
                              if(hasNext){
                                setState(() {
                                  pageIndex = pageIndex + 1;
                                });
                                loadData();
                              }
                            });
                          },
                        ),
                        //buildDropdownMenu()
                      ],
                    ))
              ],
            )
        ),
      ],
    );
  }
}