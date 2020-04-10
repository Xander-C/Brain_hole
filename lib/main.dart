import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:http/http.dart' as Http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlearning2/TodoListContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:dio/dio.dart';

import 'MyDrawer.dart';
import 'TodoThing.dart';
import 'MainContainer.dart';
import 'String2DateTime.dart';

void main() => runApp(new MyStatelessApp());

class MyStatelessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: '幸福清单',
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
  DateTime lastChange = DateTime.now();
  String regId;
  String server = "47.98.249.99:9094";

  FocusNode _focusNodeUserName = new FocusNode();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    String userKey = "0";
    print("initState");
    print(userKey);
    _todoList = [TodoThing("添加第一个项目吧", DateTime(2077), false, false)];
    exp = 0;
    finishedList = [999];
    weatherUrl =
        'http://47.98.249.99:9092/?source=xw&weather_type=forecast_24h&province=江苏&city=南京&county=栖霞区';
    imageUrl = "assets/images/01.gif";
    print("before init");
    init();
    print("end of init main 76 inistate");
    print(exp);
    print(finishedList);
  }

  Future<void> initPlatformState() async {
    jPush.setup(appKey: "2f7c9abd2e325f3df5c73a46" ,channel: 'developer-default');
    try {
      jPush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print(">>>>>>>>>>>>>>>>>flutter 接收到推送: $message");
      },
        onOpenNotification: (Map<String, dynamic> message) async{
          setState(() {
            imageUrl = imageUrl;
            _todoList = _todoList;
            finishedList = finishedList;
            exp = exp;
          });
      },);
    } on Expression catch (e) {
      print("发生错误: $e");
    }
    if (!mounted) {
      return;
    }
  }

  void refresh()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      finishedList = prefs.getStringList("finishedList").map((String i){
        return int.parse(i);
      }).toList();
      exp = prefs.getInt("exp");
    });
  }

  void init() async {
    print("async init");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("got prefs main 97 async init");
    userKey = prefs.getString("userKey");
    if (userKey == null) {
      userKey = "0";
      prefs.setString("userKey", "0");
    }
    print("userKey ="+ userKey +"main 103 async");

    String lastChangeString = prefs.getString("lastChange");
    if (lastChangeString == null) {
      lastChange = DateTime.now();
      prefs.setString("lastChange", lastChange.toLocal().toString());
    } else
      lastChange = toDateTime(lastChangeString);
    print("lastChange ="+ lastChangeString +"main 111 async");

    server = await prefs.get("server");
    if(server == null){
      prefs.setString("server", "47.98.249.99:9094");
    }
    print("server = "+ server +"main 117 async init");


//    List<String> finishedListString = prefs.getStringList("finishedList");
//    if (finishedListString == null) {
//      finishedList = [999];
//      prefs.setStringList(
//          "finishedList",
//    finishedList.map((int i) {
//            return i.toString();
//          }).toList());
//      setState(() {
//    finishedList = finishedList;
//      });
//    } else {
//      setState(() {
//        finishedList = finishedListString.map((String todoStr) {
//          return int.parse(todoStr);
//        }).toList();
//      });
//    }


    List<String> _todoListString = prefs.getStringList("todoList");
    if (_todoListString == null) {
      _todoList = [
        TodoThing(
            "添加第一个项目吧", DateTime.now().add(Duration(days: 3)), false, false)
      ];
      prefs.setStringList(
          "todoList",
          _todoList.map((TodoThing todo) {
            return json.encode(todo);
          }).toList());
      setState(() {
        _todoList = _todoList;
      });
    } else {
      setState(() {
        _todoList = _todoListString.map((String todoStr) {
          return TodoThing.fromJson(json.decode(todoStr));
        }).toList();
      });
    }
    print(jsonEncode (TodoThing(
        "添加第一个项目吧", DateTime.now().add(Duration(days: 3)), false, false)
    ));
    print(_todoListString);


    List<String> _finishedListString = prefs.getStringList("finishedList");
    print("finishedList");
    print(_finishedListString);
    if (_finishedListString != null) {
      setState(() {
        finishedList = _finishedListString.map((String finishedStr) {
          return int.parse(finishedStr);
        }).toList();
      });
    } else
      prefs.setStringList("finishedList", ["999"]);
    print(finishedList);

    setState(() {
      exp = prefs.getInt("exp");
      print(exp);
      print("main init async 198");
      finishedList = finishedList;
      if (exp == null) {
        prefs.setInt("exp", 0);
        exp = 0;
      }
    });
    print("init exp = " + exp.toString() + " main 178 async init");

    print("init weatherUrl main 166 async init");
    weatherUrl = prefs.getString("weatherUrl");
    if (weatherUrl == null) {
      weatherUrl =
          'http://47.98.249.99:9092/?source=xw&weather_type=forecast_24h&province=江苏&city=南京&county=栖霞区';
      prefs.setString("weatherUrl", weatherUrl);
    }
    print(weatherUrl);
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
    regId = prefs.getString("regId");
    if (regId == null) {
      regId = await jPush.getRegistrationID();
      prefs.setString("regId", regId);
    }
    print("regId = "+ regId +"main 250 async init");
  }

  TodoThing _getNotDone(List<TodoThing> _todoList) {
    int len = _todoList.length;
    for (int i = 0; i < len; i++)
      if (_todoList[i].deadline.isAfter(DateTime.now())) return _todoList[i];
    return null;
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
        imageUrl = "assets/images/rain.gif";
      } else if (dayWeatherCode >= 3 && dayWeatherCode <= 12) {
        talk = "今天白天有雨，白天出门记得带上伞哦";
        imageUrl = "assets/images/rain.gif";
      } else if (nightWeatherCode >= 3 && nightWeatherCode <= 12) {
        talk = "今天晚上有雨，晚上出门记得带上伞哦";
        imageUrl = "assets/images/rain.gif";
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
    for (int i = 0; i < len; i++) if (_todoList[i].isToday) return false;
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
    print("finished list main:265 longCallBack");
    setState(() {
      finishedList = finishedList;
      exp = exp;
    });
    prefs.setStringList(
        "todoList",
        _todoList.map((TodoThing todo) {
          return json.encode(todo);
        }).toList());
    lastChange = DateTime.now();
    prefs.setString("lastChange", lastChange.toLocal().toString());
    FormData data = FormData.fromMap({
      'userKey': getMd5(userKey),
      'todoList': _todoList
        .map((TodoThing todo) {
    return json.encode(todo);
    })
        .toList()
        .toString(),
      'lastChange': lastChange.toLocal().toString(),
      'finishedList': finishedList.map((int i) {
        return i.toString();
      }).toList().toString(),
      'exp': exp,
    });
    var dio = Dio();
    print("posting data");
    if(userKey != "0")
      var response =
          await dio.post('http://'+ prefs.getString("server") +'/update', data: data);
  }

  void _todoListPressCallBack(TodoThing todo) async {
    print("exp"+exp.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = _todoList.indexOf(todo);
    TodoThing temp = _todoList[index];
    if (!temp.isDone) {
      _todoList.removeAt(index);
      temp.isDone = true;
      _todoList.insert(index, temp);
      prefs.setStringList(
          "todoList",
          _todoList.map((TodoThing todo) {
            return json.encode(todo);
          }).toList());
      setState(() {
        _todoList = _todoList;
        exp += 5;
      });
      prefs.setInt("exp", exp);
      lastChange = DateTime.now();
      prefs.setString("lastChange", lastChange.toLocal().toString());
      FormData data = FormData.fromMap({
        'userKey': getMd5(userKey),
        'todoList':_todoList
          .map((TodoThing todo) {
      return json.encode(todo);
      })
          .toList()
          .toString(),
        'lastChange': lastChange.toLocal().toString(),
        'exp': exp,
      });
      var dio = Dio();
      print("posting data");
      if(userKey!="0")
      var response =
          await dio.post('http://'+ prefs.getString("server") +'/update', data: data);
    }
  }

  void undoneCallBack(TodoThing undone) {}

  void _talkChange() {
    setState(() {
      talk = normalTalk[random.nextInt(normalTalk.length)];
    });
  }

  void _imageChange(){
    setState(() {
      imageUrl =
          "assets/images/0" + (random.nextInt(4) + 1).toString() + ".gif";
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
                          focusNode: _focusNodeUserName,
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
                              _focusNodeUserName.unfocus();
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
                              _focusNodeUserName.unfocus();
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
      lastChange = DateTime.now();
      FormData data = FormData.fromMap({
        'userKey': getMd5(userKey),
        'todoList': _todoList
            .map((TodoThing todo) {
              return json.encode(todo);
            })
            .toList()
            .toString(),
        'lastChange': lastChange.toLocal().toString(),
      });
      var dio = Dio();
      print("adding data");
      if(userKey!="0")
      var response =
          await dio.post('http://'+ prefs.getString("server") +'/update', data: data);
      print("added data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          primaryColor: Color.fromRGBO(103, 119, 239, 1),
        ),
        child: Scaffold(
            //backgroundColor: Color.fromRGBO(244, 246, 249, 1),
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                "主页",
                textAlign: TextAlign.right,
              ),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                    icon:Icon(Icons.refresh),
                    onPressed: () {
                     refresh();
                    }),
              ],
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
