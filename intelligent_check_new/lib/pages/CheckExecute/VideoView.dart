import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:intelligent_check_new/tools/GetConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideoViewPage extends StatefulWidget{

  final File file;
  VideoViewPage(this.file);

  @override
  State<StatefulWidget> createState() {
    return _VideoViewPageState();
  }

}

class _VideoViewPageState extends State<VideoViewPage>{

  VideoPlayerController _controller;
  VoidCallback listener;
  String theme="blue";


  @override
  Widget build(BuildContext context) {

    if(this.theme.isEmpty){
      return Scaffold(
          body:Text("")
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("视频浏览",style: TextStyle(color: Colors.black,fontSize: 19),),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor:  Colors.white,
        leading:new Container(
          child: GestureDetector(
            onTap: (){Navigator.pop(context);},
            child:Icon(Icons.keyboard_arrow_left, color: GetConfig.getColor(theme), size: 32),
          ),
        ),
      ),
      body: _previewVideo(_controller),
    );
  }

  @override
  void initState() {
    super.initState();
    initConfig();
    listener = () {
      setState(() {});
    };

    _controller = VideoPlayerController.file(this.widget.file)
      ..addListener(listener)
      ..setVolume(1.0)
      ..initialize()
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  initConfig() async{
    SharedPreferences.getInstance().then((preferences){
      setState(() {
        this.theme = preferences.getString("theme")??KColorConstant.DEFAULT_COLOR;
      });
    });
  }

  Widget _previewVideo(VideoPlayerController controller) {
    if (controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    } else if (controller.value.initialized) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: AspectRatioVideo(controller),
      );
    } else {
      return const Text(
        'Error Loading Video',
        textAlign: TextAlign.center,
      );
    }
  }
}

class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);

  final VideoPlayerController controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    listener = () {
      if (!mounted) {
        return;
      }
      if (initialized != controller.value.initialized) {
        initialized = controller.value.initialized;
        setState(() {});
      }
    };
    controller.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller.value?.aspectRatio,
          child: VideoPlayer(controller),
        ),
      );
    } else {
      return Container();
    }
  }
}