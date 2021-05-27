import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
// import 'package:reorderables2/reorderables2.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineReorderList extends StatefulWidget {
  final List<PlaceLocationModel> listItem;

  final Function onAddMore;
  final Function onUpdate;
  final Function onRemove;
  final Function onSubmited;
  final Function onReorder;

  TimelineReorderList(
      {Key key,
      this.listItem,
      this.onAddMore,
      this.onUpdate,
      this.onRemove,
      this.onSubmited,
      this.onReorder})
      : super(key: key);

  @override
  _TimelineReorderListState createState() => _TimelineReorderListState();
}

class _TimelineReorderListState extends State<TimelineReorderList> {
  List<String> alphabetList = [
    '#',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    '*'
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        PlaceLocationModel row1 = widget.listItem.removeAt(oldIndex);
        widget.listItem.insert(newIndex, row1);
        widget.onSubmited(widget.listItem);
      });
    }

    Widget reorderableColumn = IntrinsicWidth(
        child: ReorderableColumn(
      children: renderListInput(),
      onReorder: _onReorder,
    ));

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 30.0),
      child: Transform(
        transform: Matrix4.rotationZ(0),
        alignment: FractionalOffset.topLeft,
        child: Material(
          child: reorderableColumn,
          color: Colors.transparent,
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }

  Widget nodeDecorator(String val) {
    if (val == "#") {
      return TimelineTile(
        alignment: TimelineAlign.start,
        isFirst: (val == "#") ? true : false,
        isLast: (val == "*") ? true : false,
        afterLineStyle: LineStyle(thickness: 2.0),
        beforeLineStyle: LineStyle(thickness: 2.0),
        indicatorStyle: IndicatorStyle(
          width: 30,
          indicatorXY: 0.5,
          height: 25.0,
          drawGap: true,
          indicator: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                height: 15.0,
                width: 15.0,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    border:
                        Border.all(color: Colors.deepOrangeAccent, width: 3.0),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ),
      );
    } else if (val == "*") {
      return TimelineTile(
        alignment: TimelineAlign.start,
        isFirst: (val == "#") ? true : false,
        isLast: (val == "*") ? true : false,
        afterLineStyle: LineStyle(thickness: 2.0),
        beforeLineStyle: LineStyle(thickness: 2.0),
        indicatorStyle: IndicatorStyle(
          width: 30,
          height: 25.0,
          indicatorXY: 0.5,
          drawGap: true,
          indicator: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                height: 20.0,
                width: 20.0,
                child: Align(
                  child: Icon(
                    Icons.place,
                    color: Colors.deepOrangeAccent,
                    size: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: (val == "#") ? true : false,
      isLast: (val == "*") ? true : false,
      afterLineStyle: LineStyle(thickness: 2.0),
      beforeLineStyle: LineStyle(thickness: 2.0),
      indicatorStyle: IndicatorStyle(
        width: 30.0,
        height: 25.0,
        indicatorXY: 0.5,
        drawGap: true,
        indicator: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              height: 18.0,
              width: 18.0,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(20)),
              child: Align(
                alignment: Alignment.center,
                child: Text(val),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> renderListInput() {
    List<Widget> listTemp = [];
    var ind = 0;
    for (var item in widget.listItem) {
      listTemp.add(inputDecorator(ind, item));
      ind++;
    }
    return listTemp;
  }

  void addMorePlace(int ind, int id) {
    if (ind == widget.listItem.length - 1) {
      widget.onAddMore();
    } else if (id == -1) {
      widget.onUpdate(ind, false);
    } else {
      widget.onUpdate(ind, true);
    }
  }

  void onRemoveDirection(int ind) {
    widget.onRemove(ind);
  }

  Widget inputDecorator(int index, PlaceLocationModel item) {
    return Container(
      key: ObjectKey(item.id),
      height: 55.0,
      padding: EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Expanded(
            child: nodeDecorator(index == widget.listItem.length - 1
                ? "*"
                : alphabetList[index]),
          ),
          Expanded(
            flex: 6,
            child: Container(
              height: 40.0,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Colors.grey[350],
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () => addMorePlace(index, item.id),
                      child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            enabled: false,
                            contentPadding:
                                EdgeInsets.only(left: 10.0, top: -10.0),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent))),
                        controller: new TextEditingController(
                          text: UtilsCommon.removeBracketFirstAndLastString(
                              item.name.toString()),
                        ),
                      ),
                    ),
                  ),
                  (index == widget.listItem.length - 1 ||
                          widget.listItem.length == 2)
                      ? Container()
                      : Expanded(
                          child: Icon(
                            Icons.reorder,
                            size: 20,
                          ),
                        ),
                ],
              ),
            ),
          ),
          (index != widget.listItem.length - 1 && widget.listItem.length > 2
              ? Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => onRemoveDirection(index),
                    child: Container(
                      color: Colors.transparent,
                      height: 40.0,
                      child: Icon(
                        Icons.clear,
                        color: LightTheme.colorMain,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  flex: 1,
                  child: Container(
                    child: Icon(
                      Icons.clear,
                      color: Colors.transparent,
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}
