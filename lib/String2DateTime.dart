import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime toDateTime(String str) {
  return DateTime(
      int.parse(str.substring(0, 4)),
      int.parse(str.substring(5, 7)),
      int.parse(str.substring(8, 10)),
      int.parse(str.substring(11, 13)),
      int.parse(str.substring(14, 16)),
      int.parse(str.substring(17, 19)));
}

String getMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

void syncByCloud(String str) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  FormData formData = FormData.fromMap({
    'userKey': getMd5(str),
  });
  var dio = Dio();
  print("posting data");
  var response =
      await dio.post('http://'+ prefs.getString("server") +'/getUser', data: formData);
  var responseData = response.data;
  String _weatherUrl = responseData["weatherUrl"];
  String _todoListString = responseData["todoList"];
  String _finishedListString = responseData["finishedList"];
  List<dynamic> _todoList = jsonDecode(_todoListString);
  List<dynamic> _finishedList = jsonDecode(_finishedListString);
  _todoList = _todoList.map((dynamic obj) {
    return jsonEncode(obj);
  }).toList();
  _finishedList = _finishedList.map((dynamic obj) {
    return obj.toString();
  }).toList();
  int _exp = responseData["exp"];
  print("exp=" + _exp.toString());
  String _lastChange = responseData["lastChange"];
  _lastChange = _lastChange.substring(0, 4) +
      "-" +
      _lastChange.substring(4, 6) +
      "-" +
      _lastChange.substring(6, 8) +
      " " +
      _lastChange.substring(8, 10) +
      ":" +
      _lastChange.substring(10, 12) +
      ":" +
      _lastChange.substring(12, 14) +
      "." +
      _lastChange.substring(14);
  print(_lastChange);
  prefs.setString("weatherUrl", _weatherUrl);
  prefs.setString("lastChange", _lastChange);
  prefs.setInt("exp", _exp);
  prefs.setStringList("todoList", _todoList);
  prefs.setStringList("finishedList", _finishedList);
  print(prefs.getStringList("finishedList"));
}

void syncByLocal(String str) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> todoList = prefs.getStringList("todoList");
  List<String> finishedList = prefs.getStringList("finishedList");
  print(finishedList);
  String weatherUrl = prefs.getString("weatherUrl");
  String regId = prefs.getString("regId");
  int exp = prefs.getInt("exp");
  FormData data = FormData.fromMap({
    'userKey': getMd5(str),
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
  var response = await dio.post('http://'+ prefs.getString("server") +'/update', data: data);
}
