import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelligent_check_new/widget/touch_callback.dart';

class SelectImage extends StatefulWidget {
  final List<String> ilist;
  SelectImage({Key key, @required this.ilist}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  List imgList = new List();

  StateSetter _actionState;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() {
    imgList = widget.ilist;
  }

  final Map<int, Function> map = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "现场照片",
          style: TextStyle(color: Colors.black, fontSize: 19),
        ),
        centerTitle: true,
        elevation: 0.2,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: new Container(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.keyboard_arrow_left, color: Colors.red, size: 32),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Text(
              '提交',
              style: new TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            onPressed: () {
              //提交后的处理
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: DraggableGridViewDemo(
        mylist: imgList,
      ),
    );
  }
}

typedef bool CanAccept(int oldIndex, int newIndex);

typedef Widget DataWidgetBuilder<T>(BuildContext context, T data);

class SortableGridView<T> extends StatefulWidget {
  final DataWidgetBuilder<T>
      itemBuilder; //用于生成GridView的Item Widget的函数，接收一个context参数和一个数据源参数，返回一个Widget
  final CanAccept canAccept; //是否接受拖拽过来的数据的回调函数
  final List<T> dataList; //数据源List
  final Axis scrollDirection; //GridView的滚动方向
  final int
      crossAxisCount; //非主轴方向的item数量，即 如果GridView的滚动方向是垂直方向，那么这个字段的意思就是有多少列；如果为水平方向，则此字段代表有多少行。
  final double
      childAspectRatio; //每个Item的宽高比，由于GridView的Item默认是正方形的，可以通过这个比例稍作调整。可能会有我不知道的别的办法。

  SortableGridView(
    this.dataList, {
    Key key,
    this.scrollDirection = Axis.vertical,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.0,
    @required this.itemBuilder,
    @required this.canAccept,
  })  : assert(itemBuilder != null),
        assert(canAccept != null),
        assert(dataList != null && dataList.length >= 0),
        super(key: key);
  @override
  State<StatefulWidget> createState() => _SortableGridViewState<T>();
}

class _SortableGridViewState<T> extends State<SortableGridView> {
  List<T> _dataList; //数据源
  List<T> _dataListBackup; //数据源备份，在拖动时 会直接在数据源上修改 来影响UI变化，当拖动取消等情况，需要通过备份还原
  bool _showItemWhenCovered = false; //手指覆盖的地方，即item被拖动时 底部的那个widget是否可见；
  int _willAcceptIndex = -1; //当拖动覆盖到某个item上的时候，记录这个item的坐标
//  int _draggingItemIndex = -1; //当前被拖动的item坐标
//  ScrollController _scrollController;//当item数量超出屏幕 拖动Item到底部或顶部 可使用ScrollController滚动GridView 实现自动滚动的效果。

  @override
  void initState() {
    super.initState();
    _dataList = widget.dataList;
    _dataListBackup = _dataList.sublist(0);
//    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    _scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
//      controller: _scrollController,
      //childAspectRatio: widget.childAspectRatio, //item宽高比
      scrollDirection: widget.scrollDirection, //默认vertical
      crossAxisCount: widget.crossAxisCount, //列数
      children: _buildGridChildren(context),
    );
  }

  //生成widget列表
  List<Widget> _buildGridChildren(BuildContext context) {
    final List list = List<Widget>();
    for (int x = 0; x < _dataList.length; x++) {
      list.add(_buildDraggable(context, x));
    }
    list.add(TouchCallBack(
      child: Container(
        color: Colors.grey[200],
        child: Icon(Icons.add_a_photo),
      ),
      onPressed: () =>
          showDialog(context: context, builder: (_) => _showSimpleDialog()),
    ));
    return list;
  }

  _showSimpleDialog() {
    return SimpleDialog(
      backgroundColor: Colors.white,
      children: <Widget>[
        FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.photo_camera,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text('拍摄'),
              ),
            ],
          ),
          onPressed: () {
            getImagebyCamera();
            Navigator.of(context).pop();
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(
            height: 0.5,
            color: Color(0XFFd9d9d9),
          ),
        ),
        FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.photo,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text('从相册选择'),
              ),
            ],
          ),
          onPressed: () {
            getImagebyGallery();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future getImagebyGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      //if (image != null) _dataList.add(image);
    });
  }

  Future getImagebyCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      //if (image != null) _dataList.add(image);
    });
  }

  //绘制一个可拖拽的控件。
  Widget _buildDraggable(BuildContext context, int index) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return LongPressDraggable(
          data: index,
          child: DragTarget<int>(
            //松手时 如果onWillAccept返回true 那么久会调用，本案例不使用。
            onAccept: (int data) {},
            //绘制widget
            builder: (context, data, rejects) {
              return _willAcceptIndex >= 0 && _willAcceptIndex == index
                  ? null
                  : widget.itemBuilder(context, _dataList[index]);
            },
            //手指拖着一个widget从另一个widget头上滑走时会调用
            onLeave: (int data) {
              //TODO 这里应该还可以优化，当用户滑出而又没有滑入某个item的时候 可以重新排列  让当前被拖走的item的空白被填满
              print('$data is Leaving item $index');
              _willAcceptIndex = -1;
              setState(() {
                _showItemWhenCovered = false;
                _dataList = _dataListBackup.sublist(0);
              });
            },
            //接下来松手 是否需要将数据给这个widget？  因为需要在拖动时改变UI，所以在这里直接修改数据源
            onWillAccept: (int fromIndex) {
              print('$index will accept item $fromIndex');
              final accept = fromIndex != index;
              if (accept) {
                _willAcceptIndex = index;
                _showItemWhenCovered = true;
                _dataList = _dataListBackup.sublist(0);
                final fromData = _dataList[fromIndex];
                setState(() {
                  _dataList.removeAt(fromIndex);
                  _dataList.insert(index, fromData);
                });
              }
              return accept;
            },
          ),
          onDragStarted: () {
            //开始拖动，备份数据源
//            _draggingItemIndex = index;
            _dataListBackup = _dataList.sublist(0);
            print('item $index ---------------------------onDragStarted');
            Scaffold.of(context)
                .showSnackBar(new SnackBar(content: new MyDragTarget()));
          },
          onDraggableCanceled: (Velocity velocity, Offset offset) {
            print(
                'item $index ---------------------------onDraggableCanceled,velocity = $velocity,offset = $offset');
            //拖动取消，还原数据源

            setState(() {
              _willAcceptIndex = -1;
              _showItemWhenCovered = false;
              _dataList = _dataListBackup.sublist(0);
            });
          },
          onDragCompleted: () {
            //拖动完成，刷新状态，重置willAcceptIndex
            print("item $index ---------------------------onDragCompleted");
            setState(() {
              _showItemWhenCovered = false;
              _willAcceptIndex = -1;
              _dataList.removeAt(index);
            });
            Scaffold.of(context).removeCurrentSnackBar();
          },
          //用户拖动item时，那个给用户看起来被拖动的widget，（就是会跟着用户走的那个widget）
          feedback: SizedBox(
            width: constraint.maxWidth,
            height: constraint.maxHeight,
            child: widget.itemBuilder(context, _dataList[index]),
          ),
          //这个是当item被拖动时，item原来位置用来占位的widget，（用户把item拖走后原来的地方该显示啥？就是这个）
          childWhenDragging: Container(
            child: SizedBox(
              child: _showItemWhenCovered
                  ? widget.itemBuilder(context, _dataList[index])
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class DraggableGridViewDemo extends StatefulWidget {
  final List mylist;
  DraggableGridViewDemo({Key key, @required this.mylist}) : super(key: key);
  @override
  _DraggableGridViewDemoState createState() => _DraggableGridViewDemoState();
}

class _DraggableGridViewDemoState extends State<DraggableGridViewDemo> {
  List<String> channelItems = new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    channelItems = widget.mylist;
  }

  @override
  Widget build(BuildContext context) {
    /*for (int x = 0; x < 20; x++) {
     channelItems.add("x = $x");
    }*/
    return SortableGridView(
      channelItems,
      //childAspectRatio: 3.0, //宽高3比1
      crossAxisCount: 4, //3列
      scrollDirection: Axis.vertical, //竖向滑动
      canAccept: (oldIndex, newIndex) {
        return true;
      },
      itemBuilder: (context, data) {
        return Card(
            elevation:0.2,
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Center(
            child: Image.network(data.toString()),
            //child: Text(data),
          ),
        ));
      },
    );
  }
}

class MyDragTarget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyDragTargetState();
}

class _MyDragTargetState extends State<MyDragTarget> {
  var targetText = "拖动至此处删除"; //用于显示的文案
  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onWillAccept: (data) {
        print("data = $data onWillAccept");
        return data != null; //当Draggable传递过来的dada不是null的时候 决定接收该数据。
      },
      onAccept: (data) {
        print("data = $data onAccept");
        setState(() {
          targetText = data.toString(); //接收该数据后修改文案内容。
        });
      },
      onLeave: (data) {
        print("data = $data onLeave"); //我来了 我又走了
      },
      builder: (context, candidateData, rejectedData) {
        //这是DragTarget实际展示给用户看到的样子
        return Container(
          width: 150.0,
          height: 50.0,
          color: Colors.red[500],
          child: Center(
            child: Text(targetText),
          ),
        );
      },
    );
  }
}
