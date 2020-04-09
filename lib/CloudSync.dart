import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'String2DateTime.dart';

class CloudSync extends StatefulWidget {
  @override
  _CloudSyncState createState() => _CloudSyncState();
}

class _CloudSyncState extends State<CloudSync> {
  bool isSync = true;
  var response;
  String userKey;
  String localTimeString;

  void check()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userKey = prefs.getString("userKey");
    localTimeString = prefs.getString("lastChange");
    DateTime localTime = toDateTime(localTimeString);
    FormData data = FormData.fromMap({
      'userKey': getMd5(prefs.getString("userKey")),
    });
    var dio = Dio();
    print("posting data");
    response = await dio.post('http://'+ prefs.getString("server") +'/login', data: data);
    if(response.statusCode == 200){
      DateTime cloudTime = toDateTime(response.data);
      isSync = cloudTime == localTime;
    }
    setState(() {
      isSync=isSync;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("云同步"),
          centerTitle: true,
        ),
        body: Center(
            child: Column(children: <Widget>[
          Expanded(
            child: Container(),
            flex: 1,
          ),
          Container(
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
                    "同步状态",
                    style: TextStyle(fontSize: 23),
                  ),
                  Container(
                    color: Colors.black12,
                    height: 1,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  ),
                  Text(
                    isSync?"当前已经是最新状态":"未同步，请选择要保留的数据",
                    style: TextStyle(fontSize: 20),
                  ),
                  isSync?Container(width: 1,height: 1,):Container(
                    child: Column(children: <Widget>[
                      FlatButton(
                        child: Text(response.data.toString().substring(0, 19) + "(云端)"),
                        onPressed: () {
                          syncByCloud(userKey);
                          Navigator.of(context)..pop()..pop();
                        },
                      ),
                      FlatButton(
                        child: Text(
                            localTimeString.substring(0, 19) + "(本地)"),
                        onPressed: () {
                          syncByLocal(userKey);
                          Navigator.of(context)..pop()..pop();
                        },
                      ),
                    ],),
                  )
                ],
              )),
          Expanded(
            child: Container(),
            flex: 2,
          ),
        ])));
  }
}
