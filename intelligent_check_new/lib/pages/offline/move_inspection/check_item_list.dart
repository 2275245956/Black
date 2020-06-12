import 'package:flutter/material.dart';
import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:intelligent_check_new/model/CheckItem.dart';
import 'package:intelligent_check_new/model/ExtClass.dart';
import 'package:intelligent_check_new/services/catalog_list_services.dart';
import 'package:intelligent_check_new/services/check_item_services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CheckItemList extends StatefulWidget {
  // 选择数据
  List<CheckItem> selectedData;

  CheckItemList(this.selectedData);

  @override
  _CheckItemListState createState() => _CheckItemListState(this.selectedData);
}

class _CheckItemListState extends State<CheckItemList>
    with AutomaticKeepAliveClientMixin {

  _CheckItemListState(this.selectedData);

  List<CheckItem> selectedData;
  // 当前页码
  int pageIndex = 0;

  bool isAnimating = false;

  int totalElements = 0;
  // 是否有下一页
  bool hasNext = true;

  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  final TextEditingController _searchController = new TextEditingController();
  // 页面数据
  List<CheckItem> listData = new List();

  // 模糊搜索文字
  String keywords = "";
  // 检查项类型
  String itemType = "";
  // 检查项分类id
  int itemCagetoryId = 0;

  String titleType = '检查项类型';
  String titleClass = '检查项分类';

  static const int TYPE_INDEX = 0;

  static const List<Map<String, dynamic>> TITLE_TYPE_CONTENT = [
    {"title": "所有", "id": ""},
    {"title": "选择", "id": "选择"},
    {"title": "文本", "id": "文本"},
    {"title": "数字", "id": "数字"},
  ];

  // 扩展分类数据
  List<ExtClass> extClassList = new List();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    super.initState();
    initExtClassList();
  }

  initExtClassList() async {
    await queryCatalogList().then((data){
      setState(() {
        this.extClassList = data;
        this.extClassList.insert(0, ExtClass({"id":0,"name":"所有"}));
      });
      // 查询列表数据
      initData();
    });
  }

  initData() async{
    await queryItemByPage(this.keywords, this.itemType, this.itemCagetoryId,this.pageIndex).then((data){
      setState(() {
        if(null != data){
          for(var p in data.content){
            CheckItem item = CheckItem.fromJson(p);
            for(var i in selectedData){
              if(item.id == i.id){
                item.isChecked = true;
                break;
              }
            }
            listData.add(item);
          }
        }
        // 总条数
        totalElements = data.totalElements;
        isAnimating = false;
        // 是否有下一页
        hasNext = !data.last;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "检查项列表",
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        centerTitle: true,
        elevation: 0.7,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: new Text('确定',style: TextStyle(fontSize: 16),),
            textColor: Colors.red,
            color: Colors.white,
            onPressed: () {
              setState(() {
                for(var i in listData){
                  bool isSelected = false;
                  for(var s in selectedData){
                    if(i.id == s.id){
                      isSelected = true;
                      break;
                    }
                  }
                  if(i.isChecked && !isSelected){
                    selectedData.add(i);
                  }
                }
              });
              Navigator.pop(context, selectedData);
            },
          )
        ],
      ),
      body: ModalProgressHUD(
        child: _getWidget(),
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }

  Widget _getWidget() {
    return buildInnerListHeaderDropdownMenu();
  }

  ScrollController scrollController = new ScrollController();
  GlobalKey globalKey2 = new GlobalKey();

  Widget buildInnerListHeaderDropdownMenu() {

    return new DefaultDropdownMenuController(
      // 下拉框选择事件
        onSelected: ({int menuIndex, int index, int subIndex, dynamic data}) {
          if(menuIndex == 0){
            setState(() {
              this.itemType = data["id"] as String;
              pageIndex = 0;
              listData = [];
            });
            initData();
          }else if(menuIndex == 1){
            setState(() {
              this.itemCagetoryId = data.id as int;
              pageIndex = 0;
              listData = [];
            });
            initData();
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
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: buildDropdownHeader(onTap: this._onTapHead));
                        }),
                    pinned: true,
                    floating: true,
                  ),
                  new SliverList(
                      delegate: new SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                          }, childCount: 10)),
                ]),
            new Padding(
                padding: new EdgeInsets.only(top: 46.0),
                child: new Stack(
                    children: <Widget>[
                      new Padding(padding: new EdgeInsets.only(top: 46.0)),
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
                          itemCount: 1  ,
                          itemBuilder:
                              (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                Column(
                                  children: listData.map((f){
                                    return Card(
                                      elevation:0.2,
                                      margin: EdgeInsets.only(
                                          top: 5, left: 10, right: 10),
                                      child: new Container(
                                          height: 80.0,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Text(
                                                      f.name,
                                                      style: new TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 1),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(f.itemType + "检查项"),
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              left: 5),
                                                        ),
                                                        Text(f.isMust == "是" ? "必填" : "非必填"),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 50),
                                                        ),
                                                        new Checkbox(
                                                          value: f.isChecked,
                                                          activeColor:
                                                          Colors.blue,
                                                          onChanged:(val) {
                                                            setState(() {
                                                              f.isChecked = val;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                    );
                                  }).toList(),
                                )
                              ],
                            );
                          },
                        ),
                        onRefresh: () async {
                          await new Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              pageIndex = 0;
                              listData = [];
                            });
                            initData();
                          });
                        },
                        loadMore: () async {
                          await new Future.delayed(const Duration(seconds: 1), () {
                            if(hasNext){
                              setState(() {
                                pageIndex = pageIndex + 1;
                              });
                              initData();
                            }
                          });
                        },
                      ),
                      buildDropdownMenu(),
                      Container(
                          height: 45,
                          width: double.infinity,
                          margin: EdgeInsets.only(top:3,left: 10,right: 10),
                          decoration: new BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: new BorderRadius.all(Radius.circular(6.0)),
                          ),
                          child: new Container(
                            padding: EdgeInsets.only(left: 5),
                            child:TextField(
                              controller: _searchController,
                              autofocus: false,
                              style: TextStyle(fontSize: 18.0, color: Colors.black),
                              decoration: new InputDecoration(
                                  suffixIcon: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          pageIndex = 0;
                                          listData = [];
                                        });
                                        initData();
                                      },
                                      child:new Icon(Icons.search,color: Colors.black26,)
                                  ),
                                  border: InputBorder.none,
                                  hintText: "已有检索项" + this.totalElements.toString() + "个"
                              ),
                              onChanged: (val){
                                setState(() {
                                  this.keywords = val;
                                });
                              },
                            ),
                          )
                      ),
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

  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    return new DropdownHeader(
      onTap: onTap,
      titles: [titleType, titleClass],
    );
  }

  DropdownMenu buildDropdownMenu() {
    return new DropdownMenu(
        maxMenuHeight: kDropdownMenuItemHeight * 10,
        menus: [
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: TYPE_INDEX,
                  data: TITLE_TYPE_CONTENT,
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
              height: kDropdownMenuItemHeight * TITLE_TYPE_CONTENT.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: TYPE_INDEX,
                  data: extClassList,
                  itemBuilder:
                      (BuildContext context, dynamic data, bool selected) {
                    return new Padding(
                        padding: new EdgeInsets.all(10.0),
                        child: new Row(
                          children: <Widget>[
                            new Text(
                              data.name,
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
              height: kDropdownMenuItemHeight * extClassList.length),
        ]);
  }
}
