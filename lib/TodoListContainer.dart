import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'TodoListItem.dart';
import 'TodoThing.dart';

class TodoListContainer extends StatelessWidget {
  TodoListContainer(this._todoList, this.onTapCallBack, this.pressCallBack,
      this.undoneCallBack);
  final List<TodoThing> _todoList;
  final CartChangedCallback onTapCallBack;
  final CartChangedCallback pressCallBack;
  final CartChangedCallback undoneCallBack;
  @override
  Widget build(BuildContext context) {
//    return Container(
//      margin: EdgeInsets.all(0),
//      width: 400,
//      height: 505,
    return Expanded(
      child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: ListTile.divideTiles(
            context: context,
            tiles: _todoList.map((TodoThing todoThing) {
              return TodoListItem(
                  todoThing, onTapCallBack, pressCallBack, undoneCallBack);
            }).toList(),
          ).toList()),
    );
  }
}
