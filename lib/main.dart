import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlearning2/TodoListContainer.dart';
import 'MainContainer.dart';
import 'CityContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'TodoThing.dart';

void main() => runApp(new MyStatelessApp());

class MyStatelessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Test',
        debugShowMaterialGrid: false,
        theme: new ThemeData(
          primaryColor: Color.fromRGBO(103, 119, 239, 1),
        ),
        home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  List<TodoThing> _todoList;
  List<int> finishedList;
  int exp;
  String talk = "今天会下雨，出门记得带伞哦！";
  String weatherUrl;

  void initState() {
    super.initState();
    _todoList = [TodoThing("防错", DateTime(2077), false, false)];
    exp = 0;
    finishedList = [999];
    weatherUrl =
        'http://47.98.249.99:9092/?source=xw&weather_type=forecast_24h&province=江苏&city=南京&county=栖霞区';
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> _todoListString = prefs.getStringList("todoList");
    if (_todoListString == null)
      _todoList = [
        TodoThing(
            "添加第一个项目吧", DateTime.now().add(Duration(days: 1)), false, false)
      ];
    else {
      setState(() {
        _todoList = _todoListString.map((String todoStr) {
          return TodoThing.fromJson(jsonDecode(todoStr));
        }).toList();
      });
    }

    List<String> _finishedListString = prefs.getStringList("finishedList");
    if (_finishedListString != null) {
      setState(() {
        finishedList = _finishedListString.map((String finishedStr) {
          return int.parse(finishedStr);
        }).toList();
      });
    }

    setState(() {
      exp = prefs.getInt("exp");
      if (exp == null) exp = 0;
    });

    weatherUrl = prefs.getString("weatherUrl");
    if (weatherUrl == null)
      weatherUrl =
          'http://47.98.249.99:9092/?source=xw&weather_type=forecast_24h&province=江苏&city=南京&county=栖霞区';
  }

  bool _allLong(List<TodoThing> _todoList) {
    int len = _todoList.length;
    for (int i; i < len; i++) {
      if (_todoList[i].isToday) return false;
    }
    return true;
  }

  void _todoListLongCallBack(TodoThing todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoList.remove(todo);
    });
    if (_todoList.isEmpty || _allLong(_todoList)) {
      finishedList.add(DateTime.now().day);
      prefs.setStringList(
          "finishedList",
          finishedList.map((int i) {
            i.toString();
          }).toList());
      exp += 20;
    }
    setState(() {
      finishedList = finishedList;
      exp = exp;
    });
    prefs.setStringList(
        "todoList",
        _todoList.map((TodoThing todo) {
          return json.encode(todo);
        }).toList());
  }

  void _todoListPressCallBack(TodoThing todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      int index = _todoList.indexOf(todo);
      TodoThing temp = _todoList[index];
      _todoList.removeAt(index);
      temp.isDone = true;
      _todoList.insert(index, temp);
      exp += 5;
    });
    prefs.setStringList(
        "todoList",
        _todoList.map((TodoThing todo) {
          return json.encode(todo);
        }).toList());
    prefs.setInt("exp", exp);
  }

  void _talkChange() {
    //Todo: 切换说的话
  }

  void _imageChange() {
    //Todo: 切换图片
  }

  void _addTask() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    TodoThing newTodo = await showDialog<TodoThing>(
        context: context,
        builder: (BuildContext context) {
          TextEditingController todoController = TextEditingController();
          bool isToday = true;
          DateTime selectedDate = DateTime.now();
          return AlertDialog(
              title: Text("添加事项"),
              titlePadding: EdgeInsets.only(top: 10, left: 100.0),
              contentPadding: EdgeInsets.all(5),
              content:
                  new StatefulBuilder(builder: (context, StateSetter setState) {
                return Container(
                  height: 250,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 150,
                        child: TextField(
                          controller: todoController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: '事项',
                          ),
                          autofocus: true,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("当天："),
                          Radio(
                            value: true,
                            groupValue: isToday,
                            onChanged: (value) {
                              setState(() {
                                isToday = value;
                              });
                            },
                          ),
                          SizedBox(width: 20),
                          Text("长期："),
                          Radio(
                            value: false,
                            groupValue: isToday,
                            onChanged: (value) {
                              setState(() {
                                isToday = value;
                              });
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(selectedDate.toString().substring(0, 11)),
                          RaisedButton(
                            child: Text('选择日期'),
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: new DateTime.now(),
                                firstDate: new DateTime.now()
                                    .subtract(new Duration(days: 30)),
                                lastDate: new DateTime.now()
                                    .add(new Duration(days: 90)),
                              ).then((DateTime val) {
                                setState(() {
                                  selectedDate = val;
                                });
                                print(selectedDate);
                              }).catchError((err) {
                                print(err);
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("          " +
                              selectedDate.toString().substring(11, 16) +
                              " "),
                          RaisedButton(
                            child: new Text('选择时间'),
                            onPressed: () {
                              showTimePicker(
                                context: context,
                                initialTime: new TimeOfDay.now(),
                              ).then((TimeOfDay val) {
                                setState(() {
                                  selectedDate = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      val.hour,
                                      val.minute);
                                });
                                print(selectedDate);
                              }).catchError((err) {
                                print(err);
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            child: new Text(
                              '提交',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(TodoThing(
                                  todoController.text == null
                                      ? '未命名事项'
                                      : todoController.text,
                                  selectedDate,
                                  isToday,
                                  false));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                );
              }));
        });
    if (newTodo != null) {
      _todoList.add(newTodo);
      _todoList.sort((TodoThing a, TodoThing b) {
        if (b.isToday&&!a.isToday&&a.deadline.isBefore(DateTime.now().add(Duration(days: 2)))) return -1;
        if (a.isToday&&!b.isToday&&b.deadline.isBefore(DateTime.now().add(Duration(days: 2)))) return 1;
        if (a.deadline.isAfter(b.deadline)) return 1;
        if (a.deadline.isBefore(b.deadline)) return -1;
        return 0;
      });
      setState(() {
        _todoList = _todoList;
      });
      prefs.setStringList(
          "todoList",
          _todoList.map((TodoThing todo) {
            return json.encode(todo);
          }).toList()
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(244, 246, 249, 1),
        appBar: AppBar(
          title: Text(
            "标题",
            textAlign: TextAlign.right,
          ),
          centerTitle: true,
          leading: SettingBtn(),
        ),
        body: Column(
          children: <Widget>[
            MainContainer(finishedList, exp, talk, _talkChange, _imageChange),
            Container(
              height: 1,
              color: Colors.black12,
            ),
            TodoListContainer(
                _todoList, _todoListLongCallBack, _todoListPressCallBack),
          ],
        ),
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

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX;
  double offsetY;
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}

class SettingBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: new Icon(Icons.settings),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text("设置"),
                centerTitle: true,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                        height: 170,
                        width: 375,
                        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              style: BorderStyle.solid,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(-2.0, 2.0),
                                blurRadius: 1.0,
                                //spreadRadius: 1.0,
                              )
                            ]),
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Text(
                                "城市设置",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              child: CityContainer(),
                            )
                          ],
                        )),
                  )
                ],
              ),
            );
          }));
        });
  }
}
