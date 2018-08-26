import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:nodemarketcap/database.dart';

class Fourth extends StatelessWidget {
  final String name;
  final String name2;
  final DatabaseClient databaseClient;
  final updateCoinHold;
  final String usdvalue;
  final String btcval;
  final String hold;
  final String holdvalue;
  const Fourth({
    this.name,
    this.name2,
    @required this.databaseClient,
    this.usdvalue,
    this.btcval,
    this.updateCoinHold,
    this.hold,
    this.holdvalue,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: CoinInfo(name: name, name2: name2, databaseClient: DatabaseClient(), hold: hold, holdvalue: holdvalue, usdvalue: usdvalue,),
    );
  }
}




class CoinInfo extends StatelessWidget {
  final String name;
  final String name2;
  final DatabaseClient databaseClient;
  final String usdvalue;
  final String btcval;
  final String hold;
  final String holdvalue;
   CoinInfo({
    this.name,
    this.name2,
    @required this.databaseClient,

    this.usdvalue,
    this.btcval,
    this.hold,
    this.holdvalue,
    Key key,
  }) : super(key: key);

  TextEditingController nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return  new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(padding: new EdgeInsets.all(20.0),

                child: new Text('$name2' + ' Summary', style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              ),
              new Row(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.all(20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text('Holdings', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                        new Text('$hold')
                      ],
                    ),
                    width: width /2,),
                  new Container(
                    padding: EdgeInsets.all(20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text('Value', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                        new Text('$holdvalue')
                      ],
                    ),
                    width: width /2,),
                ],
              ),
            ],
          ),

        ),
        Divider(),
        new ListTile(
          title: new TextField(
            keyboardType: TextInputType.number,
            controller: nameController,
            decoration: new InputDecoration(
              hintText: "Enter Balance",
            ),
          ),
        ),
        new Center(
          child: new Builder(
            builder: (context) {
              return new Column(
                children: <Widget>[
                  new IconButton(
                      icon: const Icon(Icons.add_circle), onPressed: () => submitHold(context) ),
                  new Text('Add Balance')
                ],
              );
            },
          ),

        ),

      ],
    );

  }

  void submitHold(context) {

    if (nameController.text.isEmpty) {
    } else {
      print(nameController.text);

      var myNum = num.parse(nameController.text);
      assert(myNum is num);
      print(myNum);
      print('$usdvalue');
      var myusdvalue = num.parse('$usdvalue');
      assert(myusdvalue is num);
      print(myusdvalue);
      var value = myNum * myusdvalue;
      print(value);
      databaseClient.updateHoldPrice2('$name', nameController.text.toString(), value.toStringAsFixed(10));
    }
  }

}