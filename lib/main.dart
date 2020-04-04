import 'package:flutter/material.dart';
import 'MainContainer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Test',
      theme: new ThemeData(primaryColor: Colors.green[300],),
      home: Scaffold(
        appBar: AppBar(
          title: Text("标题",
            textAlign: TextAlign.right,
          ),
          centerTitle: true,
          leading: IconButton(icon: new Icon(Icons.list), onPressed: (){print("leading ontap");}),
        ),
        body: Column(
          children: <Widget>[
            MainContainer(),
          ],
        ),
      ),
    );
  }
}