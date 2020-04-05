import 'package:flutter/material.dart';
import 'MainContainer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Test',
      //color: Color.fromRGBO(244, 246, 249, 1),
      debugShowMaterialGrid: false,
      theme: new ThemeData(primaryColor: Color.fromRGBO(103,119,239, 1),),
      home: Scaffold(
        backgroundColor: Color.fromRGBO(244,246,249, 1),
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