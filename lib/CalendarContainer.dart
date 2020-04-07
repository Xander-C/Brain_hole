import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Day {
  Day(this.date, this.currentMouth);
  int date;
  bool currentMouth;
}

class CalendarContainer extends StatelessWidget {
  CalendarContainer(this.finishedList, this.exp);
  final List<int> finishedList;
  final int exp;

  static const List<int> _daysInMonth = <int>[
    31,
    -1,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ];
  int _getDaysInMouth(int mouth, int year) {
    if (_daysInMonth[mouth] != -1)
      return _daysInMonth[mouth];
    else if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) return 29;
    return 28;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          height: 202,
          width: 175,
          padding: EdgeInsets.all(5),
          child: _buildCalendar(context),
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
        ),
        _buildFavorRow(exp, context)
      ],
    );
  }

  Column _buildCalendar(BuildContext context) {
    List<Day> _initDays(BuildContext context) {
      List<Day> _days = [];
      DateTime now = new DateTime.now();
      int mouth = now.month;
      int day = now.day;
      int weekday = now.weekday;
      int firstDayWeekday = (weekday - (day % 7) + 1 + 7) % 7;
      int dayMax = _getDaysInMouth(mouth - 1, now.year);
      print(mouth);
      print(dayMax);
      int lastMax =
          _getDaysInMouth((mouth + 10) % 12, now.year - (mouth + 11) ~/ 12);
      int n = lastMax - firstDayWeekday + 1;
      for (int i = 0; i < firstDayWeekday; i++) {
        _days.add(Day(n++, false));
      }
      n = 1;
      for (int i = firstDayWeekday; i < dayMax + firstDayWeekday; i++) {
        _days.add(Day(n++, true));
      }
      n = 1;
      for (int i = dayMax + firstDayWeekday; i < 42; i++) {
        _days.add(Day(n++, false));
      }
      return _days;
    }
    List<Day> _days = _initDays(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Center(child: Text(
            "打卡日历",
            style: TextStyle(fontSize: 18),
          ),)
        ),
        _buildTitle(),
        Wrap(
          spacing: 2,
          runSpacing: 2,
          children: _days.map((Day day) {
            return _buildDay(day, context);
          }).toList(),
        )
      ],
    );
  }

  Row _buildTitle() {
    final List<String> dayTitles = ["日", "一", "二", "三", "四", "五", "六"];
    Container _buildTitleDay(String day) {
      return Container(
        width: 23.25,
        height: 23.25,
        child: Center(
            child: Text(
          day,
          style: TextStyle(color: Colors.black54),
        )),
      );
    }

    return Row(
        children: dayTitles.map((String day) {
      return _buildTitleDay(day);
    }).toList());
  }

  Container _buildDay(Day day, BuildContext context) {
    print(day);
    return Container(
      width: 21.5,
      height: 21.5,
      decoration: BoxDecoration(
        color: _getDayColor(day, context),
        shape: BoxShape.circle,
        border: _getBorder(day, context),
      ),
      child: Center(
          child: Text(
        day.date.toString(),
        style: _getDayTextStyle(day),
      )),
    );
  }

  Container _buildFavorRow(int exp, BuildContext context) {

    int _getLevel(int exp, int level){
      if(exp<pow(5,level)) return level;
      return _getLevel(exp, level + 1);
    }

    int level = _getLevel(exp, 1);
    double percent = exp/pow(5, level);

    return Container(
        height: 20,
        width: 175,
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 3,
                child: Text(
                  "好感:"+ level.toString() +"级",
                  textAlign: TextAlign.right,
                )),
            SizedBox(width: 10.0),
            Expanded(
              flex: 5,
              child: Container(
                  width: 175,
                  height: 15,
                  child: LinearProgressIndicator(
                    value: percent,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                    backgroundColor: Color(0xFFc5cae9),
                  )),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ));
  }

  Color _getDayColor(Day day, BuildContext context) {
    int i = DateTime.now().day;
    if (!day.currentMouth) return Colors.white;
    if (i < day.date) return Colors.white;
    if (finishedList.indexOf(day.date) != -1)
      return Theme.of(context).primaryColor;
    if(day.date == i) return Colors.white;
    return Colors.black12;
  }

  Border _getBorder(Day day, BuildContext context) {
    if (day.currentMouth && day.date == DateTime.now().day)
      return Border.all(
        color: Theme.of(context).primaryColor,
        style: BorderStyle.solid,
      );
    else return null;
  }

  TextStyle _getDayTextStyle(Day day) {
    int i = DateTime.now().day;
    if (!day.currentMouth) return TextStyle(color: Colors.black26);
    if (i < day.date) return TextStyle(color: Colors.black54);
    if (finishedList.indexOf(day.date) != -1)
      return TextStyle(color: Colors.white, fontSize: 11);
    if(day.date == i) return TextStyle(color: Colors.black54);
    return TextStyle(color: Colors.black54);
  }
}
