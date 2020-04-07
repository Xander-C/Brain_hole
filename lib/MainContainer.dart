import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterlearning2/CalendarContainer.dart';

typedef void ChangeCallBack();

class MainContainer extends StatelessWidget {
  MainContainer(this.finishedList, this.exp, this.talk, this.imageChange,
      this.talkChange, this.imageUrl);
  final List<int> finishedList;
  final int exp;
  final String talk;
  final ChangeCallBack imageChange;
  final ChangeCallBack talkChange;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            width: 720,
            height: 258,
            decoration: BoxDecoration(
              color: Color.fromRGBO(244, 246, 249, 1),
            ),
            //color: Theme.of(context).primaryColor,
            //child: Image.network("https://b-ssl.duitang.com/uploads/item/201511/16/20151116094944_nSHCc.gif"),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        talkChange();
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                        padding: EdgeInsets.all(5),
                        width: 175,
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
                        child: Text(
                          talk,
                          style: TextStyle(fontSize: 15),
                          maxLines: 2,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        imageChange();
                      },
                      child: Container(
                        height: 175,
                        //color: Colors.red,
                        child: Image.asset(
                          imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  width: 25,
                ),
                CalendarContainer(finishedList, exp)
              ],
            )),
      ],
    );
  }
}
