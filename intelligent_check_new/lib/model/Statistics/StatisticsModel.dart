import 'dart:convert' show json;

class StatisticsItemModel {

  int actualNum;
  int totalNum;
  String name;


  num persentNum;


  StatisticsItemModel.fromParams({this.actualNum, this.totalNum, this.name,this.persentNum});

  StatisticsItemModel.fromJson(jsonRes) {
    actualNum = jsonRes['actualNum'];
    totalNum = jsonRes['totalNum'];
    name = jsonRes['name'];
    //计算所占百分比   如果出现错误数据 总量=0   为0   否则如果相等  则为100   否则  百分比
    persentNum=totalNum==0?0:(actualNum==totalNum?100: num.parse((100/totalNum).toStringAsFixed(3))*actualNum );///根据比例设置实际数  四舍五入

  }

  @override
  String toString() {
    return '{"actualNum": $actualNum,"totalNum": $totalNum,"name": ${name != null?'${json.encode(name)}':'null'}}';
  }
}