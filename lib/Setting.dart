import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CityContainer.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          )
        ],
      ),
    );
  }
}
