import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/model/CheckExecute/ContactInfo.dart';
import 'package:intelligent_check_new/model/name_value.dart';
import 'package:intelligent_check_new/services/company_services.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;

class MultySelContact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MultySelContact();
  }
}

class _MultySelContact extends State<MultySelContact> {
  bool isAnimating = false;
  int pageIndex = 1;
  bool hasNext = true;
  List<ContractInfo> pageData = List();
  List<ContractInfo> tmpData = List();

  List<String> selDeptList = List(); //获取选中的用户的Dept
  List<String> selUserList = List(); //获取选中的用户
  List<String> selUserIdList = List(); //获取选中的用户

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  String theme = "";

  @override
  Widget build(BuildContext context) {
    if (this.theme.isEmpty) {
      return Scaffold(body: Text(""));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "执行人/部门选择",
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.keyboard_arrow_left,
                color: GetConfig.getColor(theme) /*GetConfig.getColor(theme)*/,
                size: 32),
          ),
        ),
      ),
      body: ModalProgressHUD(
        child: Container(
          color: Colors.white,
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
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) =>
                  NameItemWidget(pageData[index]),
              itemCount: pageData.length,
            ),
            onRefresh: () async {
              await new Future.delayed(const Duration(seconds: 1), () {
                setState(() {
//                  pageIndex = 1;
//                  initData = [];
                });
//                getData();
              });
            },
            loadMore: () async {
              await new Future.delayed(const Duration(seconds: 1), () {
                if (hasNext) {
                  setState(() {
//                    pageIndex = pageIndex + 1;
                  });
//                  getData();
                }
              });
            },
          ),
        ),
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
//          content: '加载中...',
      ),
      persistentFooterButtons: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 20,
              child: new MaterialButton(
                color: GetConfig.getColor(theme),
                height: 60,
                textColor: Colors.white,
                child: new Text('确定', style: TextStyle(fontSize: 24)),
                onPressed: () {
                  ///去除重复的部门
                  List<String> sigalList = new List();
                  for (String dept in mSel.selDeptList) {
                    if (!sigalList.contains(dept)) {
                      sigalList.add(dept);
                    }
                  }
                  var deptUserInfo = {
                    "uName": mSel.selUserList.join(","),
                    "uDept":sigalList.join(","),
                    "uIds": mSel.selUserIdList.join(",")
                  };

                  Navigator.pop(
                      context, NameValue(json.encode(deptUserInfo), 0));
                },
              ),
            ),
          ],
        ),
      ],
      resizeToAvoidBottomPadding: false,
    );
  }

  @override
  void initState() {
    super.initState();

    getData();

    initConfig();
  }

  getData() async {
    String orgCode = "";
    await SharedPreferences.getInstance().then((sp) {
      orgCode = json.decode(sp.getString("sel_com"))["sequenceNbr"].toString();
    }).then((data) {
      getContractInfo(orgCode).then((data) {
        if (mounted) {
          setState(() {
            pageData = data;
            tmpData = data;
            mSel.selUserIdList = new List();
            mSel.selDeptList = new List();
            mSel.selUserList = new List();
          });
        }
      });
    });
  }

  initConfig() async {
    SharedPreferences.getInstance().then((preferences) {
      setState(() {
        this.theme =
            preferences.getString("theme") ?? KColorConstant.DEFAULT_COLOR;
      });
    });
  }
}

_MultySelContact mSel = new _MultySelContact();

class NameItemWidget extends StatefulWidget {
  var bean;

  NameItemWidget(this.bean);

  @override
  _NameItemWidgetState createState() => _NameItemWidgetState();
}

class _NameItemWidgetState extends State<NameItemWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildItem(widget.bean),
    );
  }

  Widget _buildItem(var bean) {
    if (bean.type=="user") {
      return ListTile(
        title: CheckboxListTile(
          value: bean.isSelected,
          onChanged: (bool) {
            setState(() {
              bean.isSelected = !bean.isSelected;
              //保存已选中的
              if (bean.isSelected) {
                mSel.selDeptList.add(bean.departmentName);
                if (!mSel.selUserList.contains(bean.name))
                  mSel.selUserList.add(bean.name);
                if (!mSel.selUserIdList.contains(bean.id))
                  mSel.selUserIdList.add(bean.id);
              } //删除
              else {
                if (mSel.selDeptList != null &&
                    mSel.selDeptList.contains(bean.departmentName))
                  mSel.selDeptList.remove(bean.departmentName);
                if (mSel.selUserList != null &&
                    mSel.selUserList.contains(bean.name))
                  mSel.selUserList.remove(bean.name);
                if (mSel.selUserIdList != null &&
                    mSel.selUserIdList.contains(bean.id))
                  mSel.selUserIdList.remove(bean.id);
              }
            });
          },
          title: new Text(
            bean.name,
            style: new TextStyle(fontWeight: FontWeight.w500),
          ),
          controlAffinity: ListTileControlAffinity.platform,
          activeColor: Colors.green,
        ),
        onTap: () {},
      );
    }

    return ExpansionTile(
      // key: PageStorageKey<NameBean>(bean),
      title: Text(bean.name),
      children: bean.children.map<Widget>(_buildItem).toList(),
      leading: CircleAvatar(
        backgroundColor: Colors.green,
        child: Text(
          bean.name.substring(0, 1),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
