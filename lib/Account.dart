import 'package:flutterlearning2/String2DateTime.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _isShowClear = false;
  String userKey = "0";
  TextEditingController _userNameController = new TextEditingController();
  FocusNode _focusNodeUserName = new FocusNode();
  RegExp dateTimeReg =
      new RegExp(r"(\d){2}-(\d){2}-(\d){2} (\d){2}:(\d){2}:(\d){2}.(\d){6}");

  @override
  void initState() {
    _userNameController.addListener(() {
      print(_userNameController.text);
      if (_userNameController.text.length > 0) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }
    });
    _init();
    super.initState();
  }

  void _init() async {
    print("async init");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userKey = prefs.getString("userKey")==null?"0":prefs.getString("userKey");
    if (userKey == null) {
      userKey = "0";
      print(userKey);
      print("in _init()");
    }
    setState(() {
      userKey = userKey;
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userKey", "0");
    setState(() {
      userKey = "0";
    });
  }

  void _login(String _userKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FormData data = FormData.fromMap({
      'userKey': getMd5(_userKey),
    });
    var dio = Dio();
    print("posting data");
    var response = await dio.post('http://'+ prefs.getString("server") +'/login', data: data);
    print(response.data);
    if (dateTimeReg.hasMatch(response.data.toString())) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('成功登录'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('请选择需要使用的数据'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(response.data.toString().substring(0, 19) + "(云端)"),
                onPressed: () {
                  prefs.setString("userKey", _userKey);
                  setState(() {
                    userKey = _userKey;
                  });
                  syncByCloud(_userKey);
                  Navigator.of(context)..pop()..pop();
                },
              ),
              FlatButton(
                child: Text(
                    prefs.getString("lastChange").substring(0, 19) + "(本地)"),
                onPressed: () {
                  prefs.setString("userKey", _userKey);
                  syncByLocal(_userKey);
                  setState(() {
                    userKey = _userKey;
                  });
                  Navigator.of(context)..pop()..pop();
                },
              ),
            ],
          );
        },
      );
    }else if(response.statusCode != 200){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('网络错误'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('请检查服务器设置或稍后再试'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }else{
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('登录错误'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(response.data.toString()),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _register(String _userKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoList = prefs.getStringList("todoList");
    List<String> finishedList = prefs.getStringList("finishedList");
    print(finishedList);
    String weatherUrl = prefs.getString("weatherUrl");
    String regId = prefs.getString("regId");
    int exp = prefs.getInt("exp");
    FormData data = FormData.fromMap({
      'userKey': getMd5(_userKey),
      'weatherUrl': weatherUrl,
      'todoList': todoList.toString(),
      'finishedList': finishedList.toString(),
      'regId': regId,
      'lastChange': prefs.getString("lastChange"),
      'exp': exp,
      'express': "[]",
    });
    var dio = Dio();
    print("posting data");
    var response = await dio.post('http://'+ prefs.getString("server") +'/reg', data: data);
    print("post to" + prefs.getString("server"));
    print(response.data);
    if (response.statusCode != 200) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('网络错误'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('请检查服务器设置或稍后再试'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    if (response.data.toString() == "1")
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('注册成功'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('您已成功注册，请记住您的用户名，这将作为您云账户的唯一凭证'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  setState(() {
                    userKey = _userKey;
                  });
                  prefs.setString("userKey", _userKey);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    else
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('注册失败'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('错误信息:' + response.data.toString()),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    if (userKey == null) {
      userKey = "0";
    }
    print(userKey);
    print("builder userKey");
    return Scaffold(
      appBar: AppBar(
        title: Text("账号"),
        centerTitle: true,
      ),
      body: Center(
          child: Column(children: <Widget>[
          Expanded(
            child: Container(),
            flex: 1,
          ),
          userKey != "0"&& userKey != null
              ? Container(
                  constraints: BoxConstraints.expand(height: 120, width: 350),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(-2.0, 2.0),
                          blurRadius: 1.0,
                        )
                      ]),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "当前账号",
                        style: TextStyle(fontSize: 23),
                      ),
                      Container(
                        color: Colors.black12,
                        height: 1,
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(userKey[0]),
                        ),
                        title: Text(userKey),
                        trailing: GestureDetector(
                          onTap: () {
                            _logout();
                          },
                          child: Text(
                            "退出登录",
                            style:
                                TextStyle(color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ))
              : Container(
                  constraints: BoxConstraints.expand(height: 350, width: 350),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(-2.0, 2.0),
                          blurRadius: 1.0,
                          //spreadRadius: 1.0,
                        )
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "登录/注册",
                        style: TextStyle(fontSize: 25),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        height: 150,
                        child: Image.asset(
                          "assets/images/login.gif",
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Form(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                controller: _userNameController,
                                focusNode: _focusNodeUserName,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "用户名",
                                  hintText: "一个你认为独一无二的用户名",
                                  prefixIcon: Icon(Icons.person),
                                  suffixIcon: (_isShowClear)
                                      ? IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            _userNameController.clear();
                                          },
                                        )
                                      : null,
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  height: 45.0,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: RaisedButton(
                                          color: Theme.of(context).primaryColor,
                                          child: Text(
                                            "登录",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            _login(_userNameController.text);
                                            _focusNodeUserName.unfocus();
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: RaisedButton(
                                          color: Theme.of(context).primaryColor,
                                          child: Text(
                                            "注册",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onPressed: () {
                                            _focusNodeUserName.unfocus();
                                            _register(_userNameController.text);
                                          },
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
          Expanded(
            child: Container(),
            flex: userKey != "0" ? 4 : 2,
          ),
        ])
      ),
    );
  }
}
