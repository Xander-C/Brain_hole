import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'CityContainer.dart';


class Setting extends StatelessWidget {
  TextEditingController _userNameController = new TextEditingController();
  FocusNode _focusNodeUserName = new FocusNode();

  void submit(String string)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("server", string);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
        centerTitle: true,
      ),
      body: ListView(children: <Widget>[ Column(
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
          ),
          Center(
            child: Container(
                height: 200,
                width: 375,
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                padding: EdgeInsets.all(8),
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
                  children: <Widget>[
                    Center(
                      child: Text(
                        "服务器设置",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: TextFormField(
                        controller: _userNameController,
                        focusNode: _focusNodeUserName,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "服务器",
                          hintText: "ip:端口号",
                          prefixIcon: Icon(Icons.person),
                          suffixIcon: IconButton(
                            icon: Text("默认", style: TextStyle(color: Colors.black26),),
                            onPressed: () {
                              _userNameController.text="47.98.249.99:9094";
                            },
                          )
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: (){
                        submit(_userNameController.text);
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('设置成功'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('服务器地址已保存'),
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
                      },
                      child: Text(
                        '提交',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                )),
          )
        ],
      ),],)
    );
  }
}
