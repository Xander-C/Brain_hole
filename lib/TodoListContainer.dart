import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'TodoListItem.dart';

class TodoListContainer extends StatelessWidget {
  TodoListContainer(this._todoList, this.onTapCallBack);
  final List<TodoThing> _todoList;
  final CartChangedCallback onTapCallBack;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(0),
        width: 400,
        height: 505,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: _todoList.map((TodoThing todoThing) {
            return TodoListItem(
                todoThing,
                onTapCallBack);
          }).toList(),
        ));
  }
}
