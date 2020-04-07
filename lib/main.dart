import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:http/http.dart' as Http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlearning2/TodoListContainer.dart';
import 'MainContainer.dart';
import 'CityContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

import 'TodoThing.dart';

void main() => runApp(new MyStatelessApp());

//Todo: 使用非对称加密传输数据
//Todo: 服务器云储存
//Todo: 推送
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
  final JPush jPush = new JPush();
  var random = Random();
  List<TodoThing> _todoList;
  List<int> finishedList;
  int exp;
  String talk = "完成设定的任务后我的好感会增加，快点去吧";
  String weatherUrl;
  String imageUrl = "assets/images/01.gif";
  List<String> normalTalk = [
    "完成设定的任务后我的好感会增加，快点去吧",
    "等级够高后可以解锁我的新姿势哦(滑稽)",
    "blbtql！blbtql！blbtql！你同意不？",
    "就算不同意也得同意！柏老板天下第一",
    "为什么要迫害柏老板?因为你们都在迫害他",
    "点够1000次会有神秘奖励哦"
  ];
  String userKey;

  @override
  void initState() {
    super.initState();
    _todoList = [TodoThing("防错", DateTime(2077), false, false)];
    exp = 0;
    finishedList = [999];
    weatherUrl =
        'http://47.98.249.99:9092/?source=xw&weather_type=forecast_24h&province=江苏&city=南京&county=栖霞区';
    print("before init");
    imageUrl = "assets/images/01.gif";
    init();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      jPush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print(">>>>>>>>>>>>>>>>>flutter 接收到推送: $message");
      });
    } on Expression catch(e){
      print("发生错误: $e");
    }
    if (!mounted) {
      return;
    }
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("init todoList");
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
    print(_todoListString);
    List<String> _finishedListString = prefs.getStringList("finishedList");
    print("finishedList");
    print(_finishedListString);
    if (_finishedListString != null && _finishedListString.length != 0) {
      setState(() {
        finishedList = _finishedListString.map((String finishedStr) {
          print(finishedStr);
          return int.parse(finishedStr);
        }).toList();
      });
    }

    print("exp");
    setState(() {
      exp = prefs.getInt("exp");
      if (exp == null) exp = 0;
    });

    print("weatherUrl");
    weatherUrl = prefs.getString("weatherUrl");
    if (weatherUrl == null)
      weatherUrl =
          'http://47.98.249.99:9092/?source=xw&weather_type=forecast_24h&province=江苏&city=南京&county=栖霞区';
    TodoThing notDone = _getNotDone(_todoList);
    if (notDone == null) {
      if (_todoList.isNotEmpty) {
        if (_todoList.length <= 5)
          talk = "加油加油！快要全部完成了，再坚持一会儿";
        else if (_todoList.length <= 8)
          talk = "任务量适中，赶紧努力去完成吧";
        else if (_todoList.length > 8) talk = "今天任务量有点艰巨，努力去完成吧";
        imageUrl = "assets/images/study.gif";
      }
      _setWeatherTalk();
    } else {
      if (finishedList.contains(notDone.deadline.day)) {
        finishedList.remove(notDone.deadline.day);
      }
      if (DateTime.now().hour >= 23) {
        talk = "今天有任务没完成哦，无论如何还是准备睡觉吧，明天再肝";
      } else {
        talk = "你这人怎么这样，自己设立的任务都不能完成";
      }
      exp -= 30;
    }
    setState(() {
      imageUrl = imageUrl;
      talk = talk;
      exp = exp;
    });
  }

  TodoThing _getNotDone(List<TodoThing> _todoList) {
    int len = _todoList.length;
    for (int i = 0; i < len; i++)
      if (_todoList[i].deadline.isAfter(DateTime.now())) return _todoList[i];
    return null;
  }

  String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  void _setWeatherTalk() async {
    print("weatherData");
    var response = await Http.get(weatherUrl);
    var weatherData = jsonDecode(response.body);
    print(weatherData["data"]["forecast_24h"]["1"]["day_weather_code"]);
    print("weatherData");
    if (weatherData != null &&
        weatherData["data"] != null &&
        weatherData["data"]["forecast_24h"] != null) {
      int dayWeatherCode = int.parse(
          weatherData["data"]["forecast_24h"]["1"]["day_weather_code"]);
      int nightWeatherCode = int.parse(
          weatherData["data"]["forecast_24h"]["1"]["night_weather_code"]);
      if ((dayWeatherCode >= 3 && dayWeatherCode <= 12) &&
          (nightWeatherCode >= 3 && nightWeatherCode <= 12)) {
        talk = "今天一天都有雨哦，去哪都不能忘了带伞";
      } else if (dayWeatherCode >= 3 && dayWeatherCode <= 12) {
        talk = "今天白天有雨，白天出门记得带上伞哦";
      } else if (nightWeatherCode >= 3 && nightWeatherCode <= 12) {
        talk = "今天晚上有雨，晚上出门记得带上伞哦";
      } else if (_todoList.isNotEmpty) {
        talk = "还有一些事没做完，就现在完成它们吧!";
      } else if (int.parse(
              weatherData["data"]["forecast_24h"]["1"]["max_degree"]) >
          35) {
        talk = "今天天气很热，不宜做太多户外活动哦";
        imageUrl = "assets/images/hot.gif";
      }
    }
  }

  bool _allLong(List<TodoThing> _todoList) {
    int len = _todoList.length;
    for (int i; i < len; i++) if (_todoList[i].isToday) return false;
    return true;
  }

  void _todoListLongCallBack(TodoThing todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoList.remove(todo);
    });
    if ((_todoList.isEmpty || _allLong(_todoList)) &&
        finishedList.indexOf(DateTime.now().day) == -1) {
      finishedList.add(DateTime.now().day);
      exp += 20;
    }
    prefs.setStringList(
        "finishedList",
        finishedList.map((int i) {
          return i.toString();
        }).toList());
    print(finishedList);
    print("finished");
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
    int index = _todoList.indexOf(todo);
    TodoThing temp = _todoList[index];
    if (!temp.isDone) {
      _todoList.removeAt(index);
      temp.isDone = true;
      _todoList.insert(index, temp);
      exp += 5;
      prefs.setStringList(
          "todoList",
          _todoList.map((TodoThing todo) {
            return json.encode(todo);
          }).toList());
      prefs.setInt("exp", exp);
      setState(() {
        _todoList = _todoList;
        exp = exp;
      });
    }
  }

  void undoneCallBack(TodoThing undone) {}

  void _talkChange() {
    setState(() {
      talk = normalTalk[random.nextInt(normalTalk.length)];
    });
  }

  void _imageChange() {
    setState(() {
      imageUrl =
          "assets/images/0" + (random.nextInt(3) + 1).toString() + ".gif";
    });
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
                                  selectedDate = DateTime(
                                      val.year,
                                      val.month,
                                      val.day,
                                      selectedDate.hour,
                                      selectedDate.minute);
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
        if (b.isToday &&
            !a.isToday &&
            a.deadline.isBefore(DateTime.now().add(Duration(days: 2))))
          return -1;
        if (a.isToday &&
            !b.isToday &&
            b.deadline.isBefore(DateTime.now().add(Duration(days: 2))))
          return 1;
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
          }).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Color.fromRGBO(103, 119, 239, 1),
      ),
      child:
      Scaffold(
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
            MainContainer(
                finishedList, exp, talk, _talkChange, _imageChange, imageUrl),
            Container(
              height: 1,
              color: Colors.black12,
            ),
            TodoListContainer(_todoList, _todoListLongCallBack,
                _todoListPressCallBack, undoneCallBack),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(103, 119, 239, 1),
                ),
                child: Text(
                  '菜单栏',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('账号'),
              ),
              ListTile(
                leading: Icon(Icons.my_location),
                title: Text('快递追踪'),
              ),
              ListTile(
                leading: Icon(Icons.cloud_circle),
                title: Text('云同步'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('设置'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addTask();
          },
          child: Icon(Icons.add),
          backgroundColor: Color.fromRGBO(103, 119, 239, 1),
        ),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(
            FloatingActionButtonLocation.endFloat, -30, -70)));
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
