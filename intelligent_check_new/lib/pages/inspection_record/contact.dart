import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckExecute/ContactInfo.dart';
import 'package:intelligent_check_new/model/LoginResult.dart';
import 'package:intelligent_check_new/model/name_value.dart';
import 'package:intelligent_check_new/services/company_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contact extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<Contact>
/*with AutomaticKeepAliveClientMixin*/ {

  List<ContractInfo> pageData = List();
  List<ContractInfo> tmpData = List();
  LoginResult loginResult;

  ScrollController _scrollController = ScrollController();
  var  companyName;

  getUserInfo()  {
    SharedPreferences.getInstance().then((sp){
      String str= sp.get('LoginResult');
      setState(() {
        loginResult = LoginResult(str);
        this.theme = sp.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
      getData();
    });
  }

  @override
  void initState() {
    super.initState();

    getUserInfo();
  }

  getData() async{
    String orgCode="";
    await   SharedPreferences.getInstance().then((sp) {
      companyName=(sp.getString("sel_com")==null || sp.getString("sel_com")=="")?"--":json.decode(sp.getString("sel_com"))["companyName"];

      orgCode= json.decode(sp.getString("sel_com"))["sequenceNbr"].toString();}).then((data){
      getContractInfo(orgCode).then((data){
        setState(() {
          pageData  = data;
          tmpData = data;
        });
      });
    });

  }

  final TextEditingController _controller = new TextEditingController();
  String theme="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(242, 246, 249, 1),
        appBar: AppBar(
          title: Text("巡检人员列表",style: TextStyle(color: Colors.black,fontSize: 19,),),

          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading:new Container(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child:Icon(Icons.keyboard_arrow_left, color:GetConfig.getColor(theme) /*GetConfig.getColor(theme)*/, size: 32),
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15.0),
                  height: 50.0,
                  color: Colors.white,
                  child: new Row(
                    children: <Widget>[
                      Text(
                        companyName== null?"": companyName,
                        style: TextStyle(color: Colors.grey,fontSize: 19),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Divider(
                    height: 0.5,
                    //                color: Colors.grey,
                  ),
                ),
                Container(
                  child:ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: pageData.length,
                    itemBuilder:(BuildContext context,int index) => CompanyContects(pageData[index]),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                ),


              ],
            )));
  }
}


class CompanyContects extends StatefulWidget {

  var bean;
  CompanyContects(this.bean);

  @override
  _CompanyContects createState() => _CompanyContects();
}

class _CompanyContects extends State<CompanyContects> {

  @override
  Widget build(BuildContext context) {
    return ListTile(

      title: _buildItem(widget.bean),
    );
  }

  Widget _buildItem(var bean){


    if(bean.children.isEmpty && bean.parentId!="0") {
      return Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 40.0,bottom: 10),
            child:CircleAvatar(
              backgroundColor:Colors.blue,
              child: Text(bean.name.substring(0,1),style: TextStyle(color: Colors.white),),
            ),
          ),

          GestureDetector(
              child:
              Container(
                margin: const EdgeInsets.only(left: 20.0,bottom: 10),
                child: Text(bean.name,style: TextStyle(color: Colors.black),),
              ),
              onTap:  (){
                Navigator.pop(context,NameValue(bean.name, num.tryParse(bean.id)));
              }
          ),
        ],

      );
    }
    return ExpansionTile(
      // key: PageStorageKey<NameBean>(bean),
      title: Text(bean.name),
      children: bean.children.map<Widget>(_buildItem).toList(),
      leading: CircleAvatar(
        backgroundColor:Colors.green,
        child: Text(bean.name.substring(0,1),style: TextStyle(color: Colors.white),),
      ),
    );
  }

}

