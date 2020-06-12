import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intelligent_check_new/model/Task/TaskAddModel.dart';
import 'package:intelligent_check_new/pages/inspection_record/contact.dart';
import 'package:intelligent_check_new/services/TaskServices.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:intelligent_check_new/tools/MessageBox.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intelligent_check_new/constants/color.dart';

class TaskAdditionScreen extends StatefulWidget {

  final num checkId;
  TaskAdditionScreen({this.checkId});

  @override
  _TaskAdditionScreenState createState() => _TaskAdditionScreenState();
}

class _TaskAdditionScreenState extends State<TaskAdditionScreen> {

  TextEditingController _namecontroller = new TextEditingController();
  TextEditingController _statementcontroller = new TextEditingController();
  TextEditingController _timescontroller = new TextEditingController();
  TextEditingController _lowcontroller = new TextEditingController(text: "1");
  TextEditingController _highcontroller = new TextEditingController(text: "5");

  bool radioval = true;
  bool radioval2 = true;

  String _completeDate;
  int _completeDateM;
  String _alertDate;
  int _alertDateM;
  String _contactName="";
  String  _contactId = "";

  List<TaskErrorItem> items =List();

  //////////////////////////////////////
  bool isSavedPressed = false;

  bool isAnimating = false;

  String theme="";


  @override
  void initState() {
    super.initState();
    if(this.widget.checkId != null && this.widget.checkId > 0){
      getQueryUnqualifiedInputItem(this.widget.checkId);
    }
    _timescontroller.text = "2";
    initConfig();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "任务添加",
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isAnimating,
        // demo of some additional parameters
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
        child:  new Form(
          child: new ListView(
            children: <Widget>[
              //任务名称
              Container(
                height: 30.0,
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '*',
                      style: new TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '任务名称',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                color: Colors.grey[100],
                child: TextField(
                  controller: _namecontroller,
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: '输入',
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                ),
              ),
              //不合格检查项
              items.length > 0?Container(
                height: 30.0,
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '*',
                      style: new TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '不合格检查项',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ):Container(),
              Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
//                      height: 25.0,
                        child: new Row(
                          children: <Widget>[
                            new Checkbox(
                                value: items[index].selected,
                                onChanged: (bool) {
                                  setState(() {
                                    items[index].selected = !items[index].selected;
                                  });
                                }),
                            Container(
                              width: 260,
                              child:  new Text(
                                items[index].name,
                                style: new TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            )
                            ,
                          ],
                        ),
                      );
                    }),
              ),
              //设置完成时间
              Container(
                height: 30.0,
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '*',
                      style: new TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '设置完成时间',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.all(10.0),
                  child:GestureDetector(
                    child:  Container(
                      height: 40,
                      width: 340,
                      padding: EdgeInsets.only(bottom: 5),
                      decoration: new BoxDecoration(
                        color: Colors.grey[100],
                      ),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:EdgeInsets.only(left: 5),
                            child: Text(_completeDate??""),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child:  new Image.asset('assets/images/icons/calendar_'+theme+'.png',width: 18,height: 18,),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          theme: DatePickerTheme(),
                          onChanged: (date) {
                          }, onConfirm: (date) {
                            setState(() {
                              _completeDate = date.toString().substring(0,16);
                              _completeDateM = date.millisecondsSinceEpoch;
                            });
                          }, currentTime: DateTime.now(), locale: LocaleType.zh);
                    },
                  )
              ),
              //是否需要提醒
              Container(
                height: 30.0,
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '是否需要提醒',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              Container(
//              height: 25.0,
//              margin: EdgeInsets.only(bottom: 10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: new RadioListTile(
                          value: true,
                          title: new Text('是'),
                          groupValue: radioval,
                          onChanged: (val) {
                            setState(() {
                              radioval = val;
                            });
                          }),
                    ),
                    Expanded(
                      flex: 1,
                      child: new RadioListTile(
                          value: false,
                          title: new Text('否'),
                          groupValue: radioval,
                          onChanged: (val) {
                            setState(() {
                              radioval = val;
                            });
                          }),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(),
                    )
                  ],
                ),
              ),
              //设置提醒时间
              Offstage(
                offstage: !radioval,
                child:Container(
                  height: 30.0,
                  margin: EdgeInsets.only(left: 10.0, top: 10.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '设置提醒时间',
                        style: new TextStyle(fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
              ),
              Offstage(
                offstage: !radioval,
                child: Container(
                    margin: EdgeInsets.all(10.0),
                    child:GestureDetector(
                      child:  Container(
                        height: 40,
                        width: 340,
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: new BoxDecoration(
                          color: Colors.grey[100],
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding:EdgeInsets.only(left: 5),
                              child: Text(_alertDate??""),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child:  new Image.asset('assets/images/icons/calendar_'+theme+'.png',width: 18,height: 18,),
                            )
                          ],
                        ),
                      ),
                      onTap: (){
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            theme: DatePickerTheme(),
                            onChanged: (date) {
                            }, onConfirm: (date) {
                              setState(() {
                                _alertDateM = date.millisecondsSinceEpoch;
//                            print(date.millisecondsSinceEpoch);
                                _alertDate = date.toString().substring(0,16);
                              });
                            }, currentTime: DateTime.now(), locale: LocaleType.zh);
                      },
                    )
                ),
              ),
              //任务说明
              Container(
                height: 30.0,
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '任务说明',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                color: Colors.grey[200],
                child: TextField(
                  controller: _statementcontroller,
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: '输入',
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                ),
              ),
              //执行人员
              Container(
                height: 30.0,
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '执行人员',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                color: Colors.grey[200],
                child: GestureDetector(
                  child:  Container(
                    height: 40,
                    width: 340,
                    padding: EdgeInsets.only(bottom: 5),
                    decoration: new BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding:EdgeInsets.only(left: 5),
                          child: Text(_contactName),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child:  Icon(Icons.keyboard_arrow_right,size: 14,color: GetConfig.getColor(theme),),
                        )
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.push( context,
                        new MaterialPageRoute(builder: (context) {
                          return Contact();
                        })).then((value){
                      if(value != null){
                        setState(() {
                          _contactName = value.name;
                          _contactId = value.value;
                        });
                      }
                    });
                  },
                ),
              ),
              //可转发次数
              Container(
                height: 30.0,
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '可转发次数',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                color: Colors.grey[200],
                child: TextField(
                  controller: _timescontroller,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: '输入框为空，不限制转发次数',
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                ),
              ),
              //是否必需拍照
              Container(
                height: 30.0,
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '是否必需拍照',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              Container(
//              height: 25.0,
//              margin: EdgeInsets.only(bottom: 20.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: new RadioListTile(
                          value: true,
                          title: new Text('是'),
                          groupValue: radioval2,
                          onChanged: (val) {
                            setState(() {
                              radioval2 = val;
                              if(null == _lowcontroller.text || _lowcontroller.text == ""){
                                _lowcontroller.text = "1";
                              }
                              if(null == _highcontroller.text ||  _highcontroller.text == ""){
                                _highcontroller.text = "5";
                              }
                            });
                          }),
                    ),
                    Expanded(
                      flex: 1,
                      child: new RadioListTile(
                          value: false,
                          title: new Text('否'),
                          groupValue: radioval2,
                          onChanged: (val) {
                            setState(() {
                              radioval2 = val;
                              _lowcontroller.text = "";
                              _highcontroller.text = "";
                            });
                          }),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(),
                    )
                  ],
                ),
              ),
              //拍照数量
              Container(
                height: 30.0,
                margin: EdgeInsets.only(left: 10.0, top: 10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '拍照数量',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: new Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 5,
                        child: Container(
                            color: Colors.grey[200],
                            margin: EdgeInsets.all(10.0),
                            child: new TextField(
                              controller: _lowcontroller,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: '输入',
                                contentPadding: EdgeInsets.all(10.0),
                              ),
                            ))),
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              color: Colors.grey[200],
                              width: 50.0,
                              height: 2.0,
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 5,
                        child: new Container(
                          margin: EdgeInsets.all(10.0),
                          color: Colors.grey[200],
                          child: new TextField(
                            controller: _highcontroller,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              hintText: '输入',
                              contentPadding: EdgeInsets.all(10.0),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 180,
              height: 50,
              color: Color.fromRGBO(242, 246, 249, 1),
              child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      this._namecontroller.text = "";
                      this._statementcontroller.text="";
                      _completeDate = "";
                      _alertDate="";
                      _contactName="";
                      _contactId = "";
                      radioval = true;
                      radioval2 = true;
                      _lowcontroller.text = "";
                      _highcontroller.text = "";
                    });
                  },
                  child: Text("重置",
                      style: TextStyle(color: Colors.black,fontSize: 18)
                  )
              ),
            ),
            isSavedPressed?
              Container(
                width: 180,
                height: 50,
                color: GetConfig.getColor(theme),
              child: MaterialButton(
                onPressed: () {
                },
                child: Text("确定",
                    style: TextStyle(color: Colors.white,fontSize: 18)
                ),
              ),
            ):Container(
              width: 160,
              color: GetConfig.getColor(theme),
              child: MaterialButton(
                onPressed: () {
                  if(items.length > 0){
                    if(items.where((f)=>f.selected).length <= 0){
                      MessageBox.showMessageOnly("任务名称、完成时间、不合格检查项必须输入、执行人员，请确认后重新提交！", context);
                      return;
                    }
                  }
                  if(this._namecontroller.text.isEmpty || _completeDate == null || _completeDate.isEmpty || _contactId ==""){
                    MessageBox.showMessageOnly("任务名称、完成时间、执行人员必须输入，请确认后重新提交！", context);
                    return;
                  }else{
                    TaskConfig config = TaskConfig.fromParams(
                        start: num.tryParse(this._lowcontroller.text),
                        end:num.tryParse(this._highcontroller.text),
                        isMust: radioval2?"是":"否",
                        name:""
                    );
                    List<TaskConfig> lstConfig = List();
                    lstConfig.add(config);
                    TaskInfoForAdd _taskInfoForAdd = TaskInfoForAdd();
                    _taskInfoForAdd.config = lstConfig;
                    _taskInfoForAdd.title = this._namecontroller.text;
                    _taskInfoForAdd.finishTime = this._completeDateM;
                    _taskInfoForAdd.remark = _statementcontroller.text;
                    _taskInfoForAdd.executor = _contactName;
                    _taskInfoForAdd.executorId = _contactId;
                    _taskInfoForAdd.maxDepth = num.tryParse(_timescontroller.text);
                    _taskInfoForAdd.isWarn = radioval?"是":"否";
                    _taskInfoForAdd.warnTime = _alertDateM;
                    _taskInfoForAdd.checkId = this.widget.checkId??0;
                    // 添加
                    List<TaskDetailForAdd> details=List();
                    if(items.length >0){
                      items.forEach((f){
                        if(f.selected){
                          details.add(TaskDetailForAdd.fromParams(
                              checkId: this.widget.checkId,
                              pointId: f.pointId,
                              routeId: f.routeId,
                              itemId: f.itemId
                          ));
                        }
                      });
//                      _taskInfoForAdd.taskDetails = details;
                    }
                    addTask(_taskInfoForAdd,details);
                  }
                },
                child: Text("确定",
                    style: TextStyle(color: Colors.white,fontSize: 18)
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  addTask(TaskInfoForAdd _taskInfoForAdd,List<TaskDetailForAdd> details) async{
    setState(() {
      isSavedPressed = true;
      isAnimating = true;
    });
    await taskAddNew(_taskInfoForAdd,details).then((bool){
      setState(() {
        isAnimating = false;
        isSavedPressed = false;
      });
      if(bool){
        MessageBox.showMessageAndExitCurrentPage("任务添加完成！", true, context);
      }else{
        MessageBox.showMessageOnly("任务添加失败，请稍后重试！", context);
      }
    });
  }

 getQueryUnqualifiedInputItem(num checkId) async{
    await queryUnqualifiedInputItem(checkId).then((data){
      setState(() {
        items = data;
      });
    });
  }

}
