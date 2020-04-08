import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlearning2/Account.dart';

import 'Setting.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(103, 119, 239, 1),
            ),
            child: Text(
              '菜单栏',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('首页'),
              onTap: () {
                Navigator.of(context)
                  ..pop();
              }
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('账号'),
              onTap: () {
                Navigator.of(context)
                  ..pop()
                  ..push(MaterialPageRoute(builder: (context) {
                    return Account();
                  }));
              }
          ),
          ListTile(
            leading: Icon(Icons.my_location),
            title: Text('快递追踪'),
          ),
          ListTile(
            leading: Icon(Icons.cloud_circle),
            title: Text('云同步'),
          ),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('设置'),
              onTap: () {
                Navigator.of(context)
                  ..pop()
                  ..push(MaterialPageRoute(builder: (context) {
                    return Setting();
                  }));
              }),
        ],
      ),
    );
  }
}
