import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlearning2/CalendarContainer.dart';

class MainContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: 主容器
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            width: 720,
            height: 258,
            //color: Theme.of(context).primaryColor,
            //child: Image.network("https://b-ssl.duitang.com/uploads/item/201511/16/20151116094944_nSHCc.gif"),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                      padding: EdgeInsets.all(5),
                      width: 175,
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
                          ]
                      ),
                      child: Text(
                        "好久不见，想我了吗？快完成点任务吧hhhhh",
                        style: TextStyle(fontSize: 15),
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      height: 175,
                      //color: Colors.red,
                      child: Image.asset(
                        "assets/images/01.gif",
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
                Container(
                  width: 25,
                ),
                CalendarContainer()
              ],
            )),
      ],
    );
  }
}
