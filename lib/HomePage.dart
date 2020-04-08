
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MyDrawer.dart';
import 'TodoThing.dart';
import 'main.dart';
import 'package:flutterlearning2/TodoListContainer.dart';
import 'MainContainer.dart';

class HomePage extends StatelessWidget {
  HomePage(this._todoList, this.finishedList, this.exp, this.talk, this.imageUrl, this._addTask, this._talkChange, this._imageChange, this._todoListLongCallBack, this._todoListPressCallBack, this.undoneCallBack);
  final List<TodoThing> _todoList;
  final List<int> finishedList;
  final int exp;
  final String talk;
  final String imageUrl;
  final Function _addTask;
  final Function _talkChange;
  final Function _imageChange;
  final Function _todoListLongCallBack;
  final Function _todoListPressCallBack;
  final Function undoneCallBack;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromRGBO(244, 246, 249, 1),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "标题",
            textAlign: TextAlign.right,
          ),
          centerTitle: true,
          //leading: SettingBtn(),
        ),
        body: Column(
          children: <Widget>[
            MainContainer(finishedList, exp, talk, _talkChange,
                _imageChange, imageUrl),
            Container(
              height: 1,
              color: Colors.black12,
            ),
            TodoListContainer(_todoList, _todoListLongCallBack,
                _todoListPressCallBack, undoneCallBack),
          ],
        ),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addTask();
          },
          child: Icon(Icons.add),
          backgroundColor: Color.fromRGBO(103, 119, 239, 1),
        ),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(
            FloatingActionButtonLocation.endFloat, -30, -70));
  }
}