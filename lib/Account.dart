import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _isShowClear = false;

  TextEditingController _userNameController = new TextEditingController();
  FocusNode _focusNodeUserName = new FocusNode();

  @override
  void initState() {
    _userNameController.addListener(() {
      print(_userNameController.text);

      if (_userNameController.text.length > 0) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        Container(
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
                        keyboardType: TextInputType.number,
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
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  onPressed: () {
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
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  onPressed: () {
                                    _focusNodeUserName.unfocus();
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
          flex: 2,
        ),
      ])),
    );
  }
}
