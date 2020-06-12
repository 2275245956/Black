import 'package:flutter/material.dart';

class CheckRecord extends StatefulWidget {
  @override
  _CheckRecordState createState() => _CheckRecordState();
}

class _CheckRecordState extends State<CheckRecord>
    with AutomaticKeepAliveClientMixin {


  List<DropdownMenuItem> getListData() {
    List<DropdownMenuItem> items = new List();

    DropdownMenuItem dropdownMenuItem1 = new DropdownMenuItem(
      child: new Text('我的'),
      value: '1',
    );
    items.add(dropdownMenuItem1);

    DropdownMenuItem dropdownMenuItem2 = new DropdownMenuItem(
      child: new Text('全部'),
      value: '2',
    );
    items.add(dropdownMenuItem2);

    return items;
  }

  List<DropdownMenuItem> getListData2() {
    List<DropdownMenuItem> items = new List();

    DropdownMenuItem dropdownMenuItem1 = new DropdownMenuItem(
      child: new Text('所有'),
      value: '1',
    );
    items.add(dropdownMenuItem1);

    DropdownMenuItem dropdownMenuItem2 = new DropdownMenuItem(
      child: new Text('合格'),
      value: '2',
    );
    items.add(dropdownMenuItem2);

    DropdownMenuItem dropdownMenuItem3 = new DropdownMenuItem(
      child: new Text('不合格'),
      value: '3',
    );
    items.add(dropdownMenuItem3);

    return items;
  }

  List<DropdownMenuItem> getListData3() {
    List<DropdownMenuItem> items = new List();

    DropdownMenuItem dropdownMenuItem1 = new DropdownMenuItem(
      child: new Text('计划内'),
      value: '1',
    );
    items.add(dropdownMenuItem1);

    DropdownMenuItem dropdownMenuItem2 = new DropdownMenuItem(
      child: new Text('计划外'),
      value: '2',
    );
    items.add(dropdownMenuItem2);

    return items;
  }

  String _bodyStr = "显示菜单内容";
  var value;

  //SearchResult searchResult = new SearchResult();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('巡检记录'),
        centerTitle: true,
        actions: <Widget>[
          new PopupMenuButton(
              onSelected: (String value) {
                setState(() {
                  _bodyStr = value;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                    new PopupMenuItem(value: "选项一的内容", child: new Text("选项一")),
                    new PopupMenuItem(value: "选项二的内容", child: new Text("选项二"))
                  ]),

          /* new DropdownButton(
              items: getListData(),
              hint:new Text('下拉选择你想要的数据'),//当没有默认值的时候可以设置的提示
              value: value,//下拉菜单选择完之后显示给用户的值
              onChanged: (T){//下拉菜单item点击之后的回调
                    setState(() { value=T; }); },
              elevation: 24,//设置阴影的高度
              style: new TextStyle(//设置文本框里面文字的样式
                                    color: Colors.red ),
              isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
              iconSize: 50.0,//设置三角标icon的大小
          ), */
        ],
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new DropdownButton(
                      items: getListData(),
                      hint: new Text('我的'),
                      //当没有默认值的时候可以设置的提示
                      value: value,
                      //下拉菜单选择完之后显示给用户的值
                      onChanged: (T) {
                        //下拉菜单item点击之后的回调
                        setState(() {
                          value = T;
                        });
                      },
                      elevation: 24,
                      //设置阴影的高度
                      style: new TextStyle(
                          //设置文本框里面文字的样式
                          color: Colors.red),
                      isDense: false,
                      //减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
                      iconSize: 50.0, //设置三角标icon的大小
                    ),
                    new DropdownButton(
                      items: getListData2(),
                      hint: new Text('所有'),
                      //当没有默认值的时候可以设置的提示
                      value: value,
                      //下拉菜单选择完之后显示给用户的值
                      onChanged: (T) {
                        //下拉菜单item点击之后的回调
                        setState(() {
                          value = T;
                        });
                      },
                      elevation: 24,
                      //设置阴影的高度
                      style: new TextStyle(
                          //设置文本框里面文字的样式
                          color: Colors.red),
                      isDense: false,
                      //减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
                      iconSize: 50.0, //设置三角标icon的大小
                    ),
                    new DropdownButton(
                      items: getListData3(),
                      hint: new Text('筛选'),
                      //当没有默认值的时候可以设置的提示
                      value: value,
                      //下拉菜单选择完之后显示给用户的值
                      onChanged: (T) {
                        //下拉菜单item点击之后的回调
                        setState(() {
                          value = T;
                        });
                      },
                      elevation: 24,
                      //设置阴影的高度
                      style: new TextStyle(
                          //设置文本框里面文字的样式
                          color: Colors.red),
                      isDense: false,
                      //减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
                      iconSize: 50.0, //设置三角标icon的大小
                    ),
                  ])
            ]
            //child:_getWidget(),
            //opacity: 0.7,
            //progressIndicator: CircularProgressIndicator(),
            ),
      ),
    );
  }
  /* Widget _getWidget(){
    return buildInnerListHeaderDropdownMenu();
  }

  ScrollController scrollController = new ScrollController();
  GlobalKey globalKey2 = new GlobalKey();
  Widget buildInnerListHeaderDropdownMenu() {
    return new DefaultDropdownMenuController(
        onSelected: ({int menuIndex, int index, int subIndex, dynamic data}) {
          if(menuIndex == 0){
            setState(() {
              searchResult.defaultOrder = data["id"] as int;
            });
            searchData();
          }
          if(menuIndex == 1){
            setState(() {
              searchResult.equipmentDiv = data["id"] as int;
            });
            searchData();
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
//                              child: new Image.asset(
//                                "images/header.jpg",
//                                fit: BoxFit.fill,
//                              ),
                            );
                          }, childCount: 1)),
                  new SliverPersistentHeader(
                    delegate: new DropdownSliverChildBuilderDelegate(
                        builder: (BuildContext context) {
                          return new Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
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
                child: new Column(
                  children: <Widget>[
                    new Expanded(
                        child: new Stack(
                          children: <Widget>[
                            Center(
                                child: new EasyRefresh(
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
                                      return new Container(
                                          height: 100.0,
                                          margin: EdgeInsets.only(top: 5,left: 10,right: 10),
                                          child: Card(
                                              child: new ListTile(
                                                  isThreeLine: true,
                                                  dense: false,
                                                  subtitle: new Row(
                                                    children: <Widget>[
                                                      new Container(
                                                          width:100,
                                                          child: Image.network("http://210.76.67.122:8899/supplier/"+initData[index].imgUrl.split(",")[0],height: 80,)
                                                      ),
                                                      Padding(padding: EdgeInsets.only(right: 5),),
                                                      new Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
//                                                          new Text(initData[index].name,style: new TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500),),
//                                                          new Text(initData[index].model,style: new TextStyle(fontSize: 12.0),),
//                                                          new Text(initData[index].supplierName,style: new TextStyle(fontSize: 12.0),),
//                                                          new Text(initData[index].price,style: new TextStyle(color: Colors.red,fontSize: 16.0),)
                                                          Container(width: 150,
                                                            child: new Text(initData[index].name,
                                                              style: new TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                          ),
                                                          Container(width: 150,
                                                            child: new Text(initData[index].model,
                                                              style: new TextStyle(fontSize: 12.0,fontWeight: FontWeight.w500),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                          ),
                                                          Container(width: 150,
                                                            child: new Text(initData[index].supplierName,
                                                              style: new TextStyle(fontSize: 12.0,fontWeight: FontWeight.w500),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                          ),
                                                          Container(width: 150,
                                                            child: new Text(initData[index].price,
                                                              style: new TextStyle(color: Colors.red,fontSize: 16.0,fontWeight: FontWeight.w500),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  trailing: new Icon(Icons.keyboard_arrow_right),
                                                  onTap: (){
                                                    if(initData[index].type == 1){
                                                      Navigator.push( context,
                                                          new MaterialPageRoute(builder: (context) {
                                                            return new FindEquipmentBrandCarDetail(initData[index].id);
                                                          }));
                                                    }else{
                                                      Navigator.push( context,
                                                          new MaterialPageRoute(builder: (context) {
                                                            return new FindEquipmentBrandEquiDetail(initData[index].id);
                                                          }));
                                                    }
                                                  }
                                              )
                                          )
                                      );
                                    },
                                  ),
                                  onRefresh: () async {
                                    await new Future.delayed(const Duration(seconds: 1), () {
                                      setState(() {
                                        pageIndex = 1;
                                        initData = [];
                                      });
                                      getData();
                                    });
                                  },
                                  loadMore: () async {
                                    await new Future.delayed(const Duration(seconds: 1), () {
                                      if(hasNext){
                                        setState(() {
                                          pageIndex = pageIndex + 1;
                                        });
                                        getData();
                                      }
                                    });
                                  },
                                )
                            ),
                            buildDropdownMenu()
                          ],
                        ))
                  ],
                )
            ),
          ],
        ));
  }
  */
}
