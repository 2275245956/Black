import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_tools/flutter_nfc_tools.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SendCard extends StatefulWidget{

  String pointNo;
  SendCard(this.pointNo);

  @override
  State<StatefulWidget> createState() => _SendCardState();

}

class _SendCardState extends State<SendCard>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("NFC",style: TextStyle(color: Colors.black,fontSize: 19),),
          centerTitle: true,
          elevation: 0.2,
          brightness: Brightness.light,
          backgroundColor:  Colors.grey,
          leading:new Container(
            child: GestureDetector(
              onTap: (){Navigator.pop(context);},
              child:Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
            ),
          ),
        ),
        body:Container(
          color: Colors.black54,
          child:  Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: const Alignment(0, -1),
                      child: Padding(padding: EdgeInsets.only(top: 50),
                        child:Container(
                          height: 40,
                          width: 200,
                          child:Align(
                            alignment: Alignment.center,
                            child: Text("靠近巡检标签",style: TextStyle(fontSize: 16,color: Colors.white),),
                          ),
                          decoration: new BoxDecoration(
                            color: Colors.black38,
                            borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Stack(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(bottom: 10),),
                          SizedBox(
                              height: 200.0,
                              width: 270.0,
                              child: Image.asset("assets/images/noplan/nfc_m.png",)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                flex: 1,
              )
            ],
          ),
        )
    );
  }

  String _platformVersion = 'Unknown';

  Future<void> initPlatformState() async {
    String response = "No error";

    try {
      FlutterNfcTools.init().then((m) {
        print("initialiazed : "+m);
      }).catchError((err) {
        print("err : "+err.toString());
      });
    } on PlatformException {
      response = 'Failed to scan tag.';
    }

    try {
      FlutterNfcTools.tagsEventsStream.listen((m) {
        print("tag scanned : "+m);
      });
    } on PlatformException {
      response = 'Failed to scan tag.';
    }

    try {
      FlutterNfcTools.ndefEventsStream.listen((m){
        print(this.widget.pointNo);
        List<int> data = new List();
        data.add(2);
        data.add(99);
        data.add(110);
        data.addAll(utf8.encode(this.widget.pointNo));

        if(m['ndefMessage'] == null){
          Map dataMap = Map();
          dataMap["payload"] = data;
          dataMap["type"] = [84];
          dataMap["tnf"] = 1;
          dataMap["id"]=[];
          List<Map> msg = [dataMap];
          m['ndefMessage'] = msg;
        }else{
          List<int> data = new List();
          data.add(2);
          data.add(99);
          data.add(110);
          data.addAll(utf8.encode(this.widget.pointNo));
          m["ndefMessage"][0]["type"]=[84];
          m["ndefMessage"][0]["payload"] = data;
          m["ndefMessage"][0]["tnf"]="1";
        }

        print(m['ndefMessage']);
        FlutterNfcTools.writeTag(m['ndefMessage']);

        Fluttertoast.showToast(
          msg: '发卡成功！',
          toastLength: Toast.LENGTH_SHORT,
        );

      });
    } on PlatformException {
      response = 'Failed to scan ndef.';
    }

    try {
      FlutterNfcTools.ndefFormatableEventsStream.listen((m) {
        print("ndefFormatable scanned : "+m);
      });
    } on PlatformException {
      response = 'Failed to scan ndefFormatable.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = response;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
}

class _ndefMessage{
  List<int> payload = List();
  List<int> id = List();
  List<int> type = List();
  int tnf;
}