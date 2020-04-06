import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'TodoListItem.dart';
import 'TodoThing.dart';

class TodoListContainer extends StatelessWidget {
  TodoListContainer(this._todoList, this.onTapCallBack, this.pressCallBack);
  final List<TodoThing> _todoList;
  final CartChangedCallback onTapCallBack;
  final CartChangedCallback pressCallBack;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      width: 400,
      height: 505,
      child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: ListTile.divideTiles(
            context: context,
            tiles: _todoList.map((TodoThing todoThing) {
              return TodoListItem(todoThing, onTapCallBack, pressCallBack);
            }).toList(),
          ).toList()),
    );
  }
}
