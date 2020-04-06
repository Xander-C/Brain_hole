import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';

class CityContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CityContainerState();
}

class _CityContainerState extends State<CityContainer> {
  TextEditingController provinceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Wrap(
          spacing: 10,
          children: <Widget>[
            Container(
              width: 150,
              child: TextField(
                controller: provinceController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '省/自治区/直辖市',
                ),
                autofocus: false,
              ),
            ),
            Container(
              width: 150,
              child: TextField(
                controller: cityController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '市',
                ),
                autofocus: false,
              ),
            ),
            Container(
              width: 150,
              child: TextField(
                controller: countyController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '区/县',
                ),
                autofocus: false,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              width: 150,
              child: RaisedButton(
                onPressed: _submit,
                child: Text(
                  '提交',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  handleFailure(error){
    showDialog(
        context: context,
        builder: (ctx){return _showDialog(false, error.message);}
    );
  }

  void _submit() async {
    String url =
        'http://47.98.249.99:9092/?source=xw&weather_type=forecast_24h&province=';
    url = url +
        provinceController.text +
        '&city=' +
        cityController.text +
        '&county=' +
        countyController.text;
    var response = await Http.get(url).catchError(handleFailure);
    if(response.statusCode == 200) {
      String jsonString = response.body;
      var weatherData = jsonDecode(jsonString);
      print(weatherData["data"]);
      if(weatherData != null && weatherData["data"] != null && weatherData["data"]["forecast_24h"] != null){
        //Todo :储存天气链接
        showDialog(
            context: context,
            builder: (ctx){return _showDialog(true, "设置成功");}
        );
      }else{
        showDialog(
            context: context,
            builder: (ctx){return _showDialog(false, "城市不正确");}
        );
      }
    }else{
      showDialog(
          context: context,
          builder: (ctx){return _showDialog(false, "请求有问题");}
      );
    }
  }

  Widget _showDialog(bool suc, String dialog){
    return Center(
        child: Container(
          height: 100,
          width: 250,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
              style: BorderStyle.solid,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  suc?"提交成功":"提交错误",
                  style: TextStyle(fontSize: 28),
                ),
              ),
              Text(dialog, style: TextStyle(fontSize: 20),)
            ],
          ),
        ));
  }
}

