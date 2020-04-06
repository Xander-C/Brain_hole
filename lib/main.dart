import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlearning2/TodoListContainer.dart';
import 'MainContainer.dart';
import 'TodoListItem.dart';
import 'CityContainer.dart';

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

  final List<int> finishedList = [1,3,5,6];

  void _todoListLongCallBack(TodoThing todo){ //Todo: 发送请求删除服务器上的信息
    setState(() {
      _todoList.remove(todo);
    });
  }

  void _todoListPressCallBack(TodoThing todo){ //Todo: 发送请求更新服务器上的信息
    setState(() {
      int index = _todoList.indexOf(todo);
      TodoThing temp = _todoList[index];
      _todoList.removeAt(index);
      temp.set_isDone(true);
      _todoList.insert(index, temp);
    });
  }

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
              MainContainer(finishedList),
              Container(
                height: 1,
                width: 400,
                color: Colors.black12,
              ),
              TodoListContainer(_todoList, _todoListLongCallBack, _todoListPressCallBack),
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
                            Container(child: CityContainer(),)
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
