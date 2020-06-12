import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intelligent_check_new/constants/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideoViewSmallPage extends StatefulWidget{

  final File file;
  VideoViewSmallPage(this.file);

  @override
  State<StatefulWidget> createState() {
    return _VideoViewSmallPageState();
  }

}

class _VideoViewSmallPageState extends State<VideoViewSmallPage>{

  VideoPlayerController _controller;
  VoidCallback listener;
  String theme="";


  @override
  Widget build(BuildContext context) {

    if(this.theme.isEmpty){
      return Scaffold(
          body:Text("")
      );
    }

    return Scaffold(
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
        '没有视频被选择',
        textAlign: TextAlign.center,
      );
    } else if (controller.value.initialized) {
      return AspectRatioVideo(controller);
    } else {
      return const Text(
        '视频加载失败',
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