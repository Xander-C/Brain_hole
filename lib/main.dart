import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlearning2/TodoListContainer.dart';
import 'MainContainer.dart';
import 'TodoListItem.dart';

void main() => runApp(new MyStatelessApp());

class MyStatelessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}

class MyApp extends StatefulWidget {
  @override
  createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  List<TodoThing> _todoList = [
    TodoThing("wdnmd", DateTime(2020, 4, 6), false, true),
    TodoThing("wdnmd", DateTime(2020, 4, 6), false, false),
    TodoThing("wdnmd", DateTime(2020, 5, 5), false, false),
    TodoThing("wdnmd", DateTime(2020, 5, 5), false, false),
    TodoThing("wdnmd", DateTime(2020, 5, 5), false, false),
    TodoThing("wdnmd", DateTime(2020, 5, 5), false, false),
    TodoThing("wdnmd", DateTime(2020, 5, 5), false, false),
    TodoThing("wdnmd", DateTime(2020, 5, 5), false, false),
    TodoThing("wdnmd", DateTime(2020, 5, 5), false, false),
    TodoThing("wdnmd", DateTime(2020, 5, 5), false, false),
    TodoThing("wdnmd", DateTime(2020, 5, 5), false, false),
  ];
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Test',
      //color: Color.fromRGBO(244, 246, 249, 1),
      debugShowMaterialGrid: false,
      theme: new ThemeData(
        primaryColor: Color.fromRGBO(103, 119, 239, 1),
      ),
      home: Scaffold(
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
              MainContainer(),
              Container(
                height: 1,
                width: 400,
                color: Colors.black12,
              ),
              TodoListContainer(_todoList, (TodoThing todo, bool isDone) {}),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
            backgroundColor: Color.fromRGBO(103, 119, 239, 1),
          ),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(
              FloatingActionButtonLocation.endFloat, -30, -70)),
    );
  }

  void _pressSetting() {
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              "设置",
              textAlign: TextAlign.right,
            ),
            centerTitle: true,
            leading:
                IconButton(icon: new Icon(Icons.settings), onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          body: Container());
    }));
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

class SettingBtn extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: new Icon(Icons.settings), onPressed: (){Navigator.of(context).push(MaterialPageRoute(
      builder: (context){
        return Scaffold(
          appBar: AppBar(
            title: Text("设置"),
            centerTitle: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

          ],),
        );
      }
    ));});
  }
}