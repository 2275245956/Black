import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/pages/login_page.dart';
import 'package:intelligent_check_new/services/api_address.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSettingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _CustomSettingPageState();

}

class _CustomSettingPageState extends State<CustomSettingPage>{

  TextEditingController _textEditingAuthController = new TextEditingController();
  TextEditingController _textEditingBizController = new TextEditingController();

  TextEditingController _updateController = new TextEditingController();
  String theme="";

  @override
  Widget build(BuildContext context) {
    if(this.theme.isEmpty){
      return Scaffold(
          body:Text("")
      );
    }
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        title: Text("服务设置",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18),),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        leading:new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///权限服务不需要  屏蔽   只使用业务来操作
//                Text("权限服务器地址:",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
//                new Container(
//                  height: 36,
//                  margin: EdgeInsets.only(top: 10),
//                  decoration: new BoxDecoration(
//                    color: Color.fromRGBO(247, 249, 250, 1),
//                    border: new Border.all(
//                      color: Colors.grey[100],
//                      width: 1,
//                    ),
//                    borderRadius: new BorderRadius.all(Radius.circular(2)),
//                  ),
//                  child: new Container(child: TextField(
//                      controller: _textEditingAuthController,
//                      decoration: new InputDecoration(
//                        border: InputBorder.none,
//                        hintText: '',
//                        hintStyle:TextStyle(fontSize: 14.0, color: Color.fromRGBO(0, 0, 0, 0.2)),
//                        contentPadding: EdgeInsets.all(8.0),
//                      )
//                  ),)
//                ),
                Padding(padding: EdgeInsets.only(top: 10),),
                Text("业务服务器地址:",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                new Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 36,
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(247, 249, 250, 1),
                      border: new Border.all(
                        color: Colors.grey[100],
                        width: 1,
                      ),
                      borderRadius: new BorderRadius.all(Radius.circular(2)),
                    ),
                    child: new Container(child: TextField(
                        controller: _textEditingBizController,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: '',
                          hintStyle:TextStyle(fontSize: 14.0, color: Color.fromRGBO(0, 0, 0, 0.2)),
                          contentPadding: EdgeInsets.all(8.0),
                        )
                    ),)
                ),

                Padding(padding: EdgeInsets.only(top: 10),),
               Text("升级地址:",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                new Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 36,
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(247, 249, 250, 1),
                      border: new Border.all(
                        color: Colors.grey[100],
                        width: 1,
                      ),
                      borderRadius: new BorderRadius.all(Radius.circular(2)),
                    ),
                    child: new Container(child: TextField(
                        controller: _updateController,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: '',
                          hintStyle:TextStyle(fontSize: 14.0, color: Color.fromRGBO(0, 0, 0, 0.2)),
                          contentPadding: EdgeInsets.all(8.0),
                        )
                    ),)
                ),
                Padding(
                  padding: EdgeInsets.only(left: 21,right: 21,top:33),
                  child: Row(children: <Widget>[
                    Container(
//          padding: EdgeInsets.all(5),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(4)),
                          color: Color.fromRGBO(113, 113, 113, 1),
                        ),
                        width: 144,
                        child: FlatButton(child: Text('恢复默认',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                          onPressed: (){
                           // this._textEditingAuthController.text = ApiAddress.DEFAULT_AUTH_API_URL;
                            setState(() {
                              this._textEditingBizController.text = ApiAddress.DEFAULT_BIZ_API_URL;
                              this._updateController.text = ApiAddress.DEFAULT_UPDATE_URL;
                            });

                          })
                    ),
                    Container(
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(4)),
                          color: GetConfig.getColor(theme),
                        ),
                        width: 144,
                        margin: EdgeInsets.only(left: 10),
                        child: FlatButton(child: Text('确定',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                          onPressed: (){
                            saveServerUrl();
                            Navigator.of(context).pushAndRemoveUntil(
                                new MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                    (route) => route == null);
                          },)
                    )
                  ],),
                )
              ],
            ),
          )
        ],
      ),
//      persistentFooterButtons: <Widget>[
//        Container(
////          padding: EdgeInsets.all(5),
//          width: 100,
//          color: Color.fromRGBO(218, 37, 30, 1),
//          child: FlatButton(child: Text('保存',
//              style: TextStyle(
//                  color: Colors.white,
//                  fontSize: 16,
//                  fontWeight: FontWeight.w700)),
//            onPressed: (){
//              saveServerUrl();
//              Navigator.pop(context);
//            },)
//        )
//      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getTheme();
    getServerUrl();
//    saveServerUrl();
  }

  saveServerUrl() async {
    await SharedPreferences.getInstance().then((pref){
      pref.setString("authServerUrl", this._textEditingAuthController.text);
      pref.setString("bizServerUrl", this._textEditingBizController.text);
      pref.setString("updateUrl", this._updateController.text);
    });
  }

  getServerUrl() async{
    await SharedPreferences.getInstance().then((pref){
//      this._textEditingAuthController.text = pref.getString("authServerUrl")==null||pref.getString("authServerUrl").isEmpty?
//                                                ApiAddress.DEFAULT_AUTH_API_URL:pref.getString("authServerUrl");
      this._textEditingBizController.text = pref.getString("bizServerUrl")==null||pref.getString("bizServerUrl").isEmpty?
                                                ApiAddress.DEFAULT_BIZ_API_URL:pref.getString("bizServerUrl");
     this._updateController.text =  pref.getString("updateUrl")==null|| pref.getString("updateUrl").isEmpty?
                                                ApiAddress.DEFAULT_UPDATE_URL:pref.getString("updateUrl");
    });
  }

  // 获取主题
  getTheme() async{
    await SharedPreferences.getInstance().then((pref){
      setState(() {
        this.theme = pref.getString("theme")??KColorConstant.DEFAULT_COLOR; //pref.get("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }
}