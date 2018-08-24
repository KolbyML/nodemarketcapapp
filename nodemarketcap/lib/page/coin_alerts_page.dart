import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Third extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: CoinInfo(),
    );
  }
}




class CoinInfo extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return  new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text('Currently Not Enabled',style:  new TextStyle(fontSize: 20.0,)),
        new Container(
            color: Colors.grey,
            child: new ButtonBar(
              children: <Widget>[
                FlatButton.icon(onPressed: null, icon: Icon(Icons.call_made), splashColor:  Color(0xFF090909), highlightColor: Color(0xFF090909), label: Text('Turn on Alerts', style: const TextStyle(fontSize: 18.0, color: Colors.black) ), ),
              ],)
        ),
        new Center(
            child: new Column(
              children: <Widget>[
                new IconButton(
                    icon: const Icon(Icons.add_circle), onPressed: () {}),
                new Text('Add Coin')
              ],
            ),

        ),



      ],
    );

  }

}