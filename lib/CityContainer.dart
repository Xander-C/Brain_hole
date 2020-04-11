import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';
import 'package:dio/dio.dart';

import 'String2DateTime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CityContainerState();
}

class _CityContainerState extends State<CityContainer> {
  TextEditingController provinceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Wrap(
          spacing: 10,
          children: <Widget>[
            Container(
              width: 150,
              child: TextField(
                controller: provinceController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '省/自治区/直辖市',
                ),
                autofocus: false,
              ),
            ),
            Container(
              width: 150,
              child: TextField(
                controller: cityController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '市',
                ),
                autofocus: false,
              ),
            ),
            Container(
              width: 150,
              child: TextField(
                controller: countyController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '区/县',
                ),
                autofocus: false,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              width: 150,
              child: RaisedButton(
                onPressed: _submit,
                child: Text(
                  '提交',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  handleFailure(error){
    showDialog(
        context: context,
        builder: (ctx){return _showDialog(false, error.message);}
    );
  }

  void _submit() async {
    String url =
        'http://47.98.249.99:9092/?source=xw&weather_type=forecast_24h&province=';
    url = url +
        provinceController.text +
        '&city=' +
        cityController.text +
        '&county=' +
        countyController.text;
    var response = await Http.get(url).catchError(handleFailure);
    if(response.statusCode == 200) {
      String jsonString = response.body;
      var weatherData = jsonDecode(jsonString);
      print(weatherData["data"]);
      if(weatherData != null && weatherData["data"] != null && weatherData["data"]["forecast_24h"] != null){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("lastChange", DateTime.now().toLocal().toString());
        FormData data = FormData.fromMap({
          'userKey': getMd5(prefs.getString("userKey")),
          'weatherUrl': url,
          'lastChange': prefs.getString("lastChange"),
        });
        var dio = Dio();
        print("posting data");
        var response = await dio.post('http://'+ prefs.getString("server") +'/update', data: data);
        print("post to" + prefs.getString("server"));
        prefs.setString("weatherUrl", url);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('设置成功'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('地址已保存'),
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
              title: Text('设置失败'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('城市不存在'),
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
    }else{
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('网络问题'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('请坚持服务器或稍后再试'),
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

  Widget _showDialog(bool suc, String dialog){
    return Center(
        child: Container(
          height: 100,
          width: 250,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
              style: BorderStyle.solid,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  suc?"提交成功":"提交错误",
                  style: TextStyle(fontSize: 28, color: Colors.black),
                ),
              ),
              Text(dialog, style: TextStyle(fontSize: 20),)
            ],
          ),
        ));
  }
}

