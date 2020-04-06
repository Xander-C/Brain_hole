import 'package:flutter/material.dart';

import 'TodoThing.dart';

typedef void CartChangedCallback(TodoThing todo);

class TodoListItem extends StatelessWidget {
  TodoListItem(TodoThing todo, this.onTapCallBack, this.pressCallBack)
      : this.todo = todo,
        this._todo = todo.todo,
        this._deadline = todo.deadline,
        this._isToday = todo.isToday,
        this._isDone = todo.isDone,
        super(key: ObjectKey(todo));
  final TodoThing todo;
  final String _todo;
  final DateTime _deadline;
  final bool _isToday;
  final bool _isDone;
  final CartChangedCallback onTapCallBack;
  final CartChangedCallback pressCallBack;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_todo, style: _getTextStyle()),
      subtitle: Text(
        _deadline.toLocal().toString().substring(0,16),
        style: _getTextStyle(),
      ),
      trailing: new Icon(
        Icons.done,
        color: _isDone ? Theme.of(context).primaryColor : Colors.black26,
      ),
      onLongPress: () {
        onTapCallBack(todo);
      },
      onTap: (){
        pressCallBack(todo);
      },
    );
  }

  TextStyle _getTextStyle() {
    if (_isDone)
      return TextStyle(
        color: Colors.black54,
        decoration: TextDecoration.lineThrough,
      );
    if ((_isToday && _deadline.difference(DateTime.now()).inHours <= 2) ||
        (!_isToday && _deadline.difference(DateTime.now()).inDays <= 2))
      return TextStyle(
        color: Colors.red,
      );
    return TextStyle(
      color: Colors.black87,
    );
  }
}
