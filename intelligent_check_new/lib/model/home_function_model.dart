import 'package:flutter/widgets.dart';

class HomeFunctionModel{
  Text functionName;
  Icon functionIcon;
  Image functionImage;
  Widget navPage;
  bool isBadgeIcon;
  num itemCount;
  bool disabled;


  HomeFunctionModel();

  HomeFunctionModel.fromParams({this.functionName,this.functionIcon,this.functionImage,this.navPage,this.isBadgeIcon,this.itemCount,this.disabled});
}