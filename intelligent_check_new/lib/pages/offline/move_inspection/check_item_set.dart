
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/model/CheckItem.dart';
import 'package:intelligent_check_new/pages/move_inspection/check_item_list.dart';

class CheckItemSet extends StatefulWidget {

  CheckItemSet(this.selectedCheckItem);

  List<CheckItem> selectedCheckItem;
  @override
  _CheckItemSetScreenState createState() => _CheckItemSetScreenState(this.selectedCheckItem);
}

class _CheckItemSetScreenState extends State<CheckItemSet>
    with AutomaticKeepAliveClientMixin {

  final TextEditingController _searchController = new TextEditingController();

  List<CheckItem> selectedCheckItem;

  String keyWords = "";

  List<CheckItem> filterItems = new List();

  _CheckItemSetScreenState(this.selectedCheckItem);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    setState(() {
      if(null == this.selectedCheckItem){
        this.selectedCheckItem = new List();
      }
      this.filterItems = this.selectedCheckItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("检查项设置",style: TextStyle(color: Colors.black,fontSize: 19),),
        centerTitle: true,
        elevation: 0.7,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading:new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
          ),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add,color: Colors.red,),onPressed: (){
            Navigator.push( context,
                new MaterialPageRoute(builder: (context) {
                  return new CheckItemList(this.selectedCheckItem);
                })).then((data){
              this.selectedCheckItem = data == null ? new List(): data;
              this.filterItems = this.selectedCheckItem;
            });
          },),
          IconButton(icon: Icon(Icons.check,color: Colors.red,),onPressed: (){
            Navigator.pop(context, this.selectedCheckItem);
          },)
        ],
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
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
                        onChanged: (val){
                          setState(() {
                            this.keyWords  = val;
                            // 筛选
                            Iterable<CheckItem> skip = this.selectedCheckItem.where((f){
                              return f.name.indexOf(keyWords) != -1;
                            });
                            this.filterItems = skip.toList();
                          });
                        },
                        controller: _searchController,
                        autofocus: false,
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: "巡检点名称+编号"
                        )
                    ),
//                  )
                  )
              ),
              Column(
                  children: this.filterItems.map((f){
                    return Card(
                      elevation:0.2,
                      margin: EdgeInsets.only(
                          top: 5, left: 10, right: 10),
                      child: ListTile(
                        title: new Text(f.name,style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),
                        trailing:GestureDetector(
                          child: new Icon(Icons.close,color: Colors.red,size: 16,),
                          onTap: (){
                            setState(() {
                              this.selectedCheckItem.remove(f);
                              this.filterItems = this.selectedCheckItem;
                            });
                          },
                        ),
                      ),
                    );
                  }).toList(),
              ),
            ],
          );
        }
      ),
    );
  }
}