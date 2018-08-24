import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nodemarketcap/coin_page.dart';
import 'dart:async';
import 'package:nodemarketcap/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nodemarketcap/add_coin_page.dart';


import 'package:nodemarketcap/main.dart';

class ListTable extends StatefulWidget {
  final DatabaseClient databaseClient;

  ListTable({Key key,  @required this.databaseClient}) : super(key: key);
  @override
  ListTableState createState() => new ListTableState();
}



class ListTableState extends State<ListTable> {
  Future<Null> getCoins() async {
    await updateCoinStats2();
    await updateCoinStats();
    final coinsb = await widget.databaseClient.getCoinListHomePage();
    final coinsJson = json.decode(coinsb);
    final coinsc = await widget.databaseClient.manageValue2view();
    final coinsJsonc = json.decode(coinsc);
    setState(() {
      _coinDetails.clear();
      for (Map user2 in coinsJson) {
        _coinDetails.add(CoinDetails.fromJson(user2));
        print(CoinDetails.fromJson(user2));
      }
      _coinDetails2.clear();
      for (Map user3 in coinsJsonc) {
        _coinDetails2.add(CoinDetails2.fromJson2(user3));
        print(CoinDetails2.fromJson2(user3));
      }
    });
  }
  Future<Null> updateCoinStats() async {
    try {
      var cleg = _coinDetails.length - 1;
      for (var i = 0; i <=  cleg; i++) {
        var name = _coinDetails[i].name.toString();
        var url = 'https://nodemarketcap.com/api/' + name;
        var stats = await fetchJSON(url);
        print('${stats['nameb'].toString()}');
        widget.databaseClient.updateCoinPrice(name, '${stats['usdvalue'].toString()}', '${stats['tickerCap'].toString()}', '${stats['nameb'].toString()}');
      }
    }
    catch (e) {
      return;
    }

}
  Future<Null> updateCoinStats2() async {
    try {
      final value = _coinDetails.fold(0, (sum, coin) => sum + coin.holdvalue);
      widget.databaseClient.manageValue(value);
    }
    catch (e) {
      return;
    }

  }
  dynamic fetchJSON(url) async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body)[0];
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
      throw Error();
    }
  }
  @override
  void initState() {
    super.initState();
    updateCoinStats2();
    updateCoinStats();
    getCoins();
  }

  List<Widget> generateTiles(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var ListTiles = <Widget>[];
    ListTiles.add(Container(
      padding: EdgeInsets.all(20.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  'Portfolio Value',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      fontSize: 14.0),
                ),
                new Text(
                  "\$${_coinDetails2.isEmpty ? '0' : _coinDetails2[0].value.toStringAsFixed(2)}",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 22.0),
                ),
              ],
            ),
            flex: 3,
          ),
          new Expanded(
            child: new Container(),
            flex: 2,
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Text(
                  'Change',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      fontSize: 14.0),
                ),
                new Text(
                  '00.00%',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 22.0),
                ),
              ],
            ),
            flex: 2,
          ),
        ],
      ),
    ));
    ListTiles.add(Container(
      color: new Color(0xFF090909),
      child: new Row(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(left: 37.0, right: 0.0),
            child: new Text('Coin',
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.white)),
            width: width /4,),
          new Container(
            padding: EdgeInsets.only(left: 0.0, right: 30.0),
            child: new Text('Holdings',
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.white)),
            width: width /4,),
          new Container(
            padding: EdgeInsets.only(left: 20.0, right: 0.0),
            child: new Text('Price',
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.white)),
            width: width /4,),
          new Container(
            padding: EdgeInsets.only(left: 25.0, right: 0.0),
            child: new Text('Alert',
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.white)),
            width: width /4,),
        ],
      ),
    ));
    var cleg = _coinDetails.length - 1;
    for (var i = 0; i <=  cleg; i++) {
      var name = _coinDetails[i].name.toString();
      var nameb = _coinDetails[i].nameb.toString();
      var ticker = _coinDetails[i].tickerCap.toString();
      var price = _coinDetails[i].usdvalue.toString();
      var hold = _coinDetails[i].hold.toString();
      var holdvalue = _coinDetails[i].holdvalue.toStringAsFixed(3);

      var url = 'https://nodemarketcap.com/api/' + name;
      var url2 = 'https://nodemarketcap.com/api/getlogo/' + name;
      ListTiles.add(
        CoinTile(url: url, url2: url2, ticker: ticker, price: price, name: name, nameb: nameb, hold: hold, holdvalue: holdvalue, ),
      );
      ListTiles.add(
        Divider(),
      );
    }
    ListTiles.add(
      Center(
        child: new IconButton(
            icon: const Icon(Icons.add_circle), onPressed: () {_addCoinPage();}),
      ),
    );
    return ListTiles;
  }

  _addCoinPage() {
    // 1
    Navigator.of(context).push(new PageRouteBuilder(
      opaque: true,
      pageBuilder: (BuildContext context, _, __) {
        return new AddCoinPage(databaseClient: DatabaseClient(),);
      },
      //
    ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO(ianh): This whole build function doesn't handle RTL yet.
    double width = MediaQuery.of(context).size.width;
    // CARD
    return new RefreshIndicator(
      child:     new ListView(
        children: generateTiles(context),
      ),
      onRefresh: getCoins,
    );
  }
}

class CoinTile extends StatelessWidget {
  final String url;
  final String url2;
  final String price;
  final String ticker;
  final String name;
  final String nameb;
  final String hold;
  final String holdvalue;


  const CoinTile({
    this.url,
    this.url2,
    this.price,
    this.ticker,
    this.name,
    this.nameb,
    this.hold,
    this.holdvalue,
    Key key,
  }) : super(key: key);

  _CoinPage(BuildContext context, coin, coinb) {
    // 1
    Navigator.of(context).push(new PageRouteBuilder(
      opaque: true,
      pageBuilder: (BuildContext context, _, __) {
        return new CoinPage(databaseClient: DatabaseClient(), coin: coin, coinb: coinb);
      },
      //
    ));
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListTile(
              leading: new Container(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                new  Image.network(url2, width: 32.0, height: 32.0,),
                      new Text('$ticker', style: new TextStyle(fontWeight: FontWeight.bold,),)
                    ]),
                width: width /5.7,),
              title: new Row(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(top:  14.0, bottom: 14.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text('\$$holdvalue'),
                        new Text('$hold')
                      ],
                    ),
                    width: width /3.36,),
                  new Container(
                    padding: EdgeInsets.only(top:  14.0, bottom: 14.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text('\$$price'),
                      ],
                    ),
                    width: width /5.4,),
                  new Container(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0),
                    child: new IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {}),width: width /4.5,),
                ],
              ),
              onTap: () {_CoinPage(context, '$name', '$nameb');},
            );
  }

}



List<CoinDetails> _coinDetails = [];

class CoinDetails {
  final String name;
  final num usdvalue;
  final String tickerCap;
  final String nameb;
  final num hold;
  final num holdvalue;
  final num value;

  CoinDetails({this.name, this.usdvalue, this.tickerCap, this.nameb, this.hold, this.holdvalue, this.value});

  factory CoinDetails.fromJson(Map<String, dynamic> json) {
    return new CoinDetails(
      name: json['name'],
      usdvalue: json['usdvalue'],
        tickerCap: json['tickerCap'],
      nameb: json['nameb'],
      hold: json['hold'],
      holdvalue: json['holdvalue'],

    );
  }
  factory CoinDetails.fromJson2(Map<String, dynamic> json) {
    return new CoinDetails(
      value: json['value'],
    );
  }
}

List<CoinDetails2> _coinDetails2 = [];

class CoinDetails2 {
  final num value;

  CoinDetails2({this.value});

  factory CoinDetails2.fromJson2(Map<String, dynamic> json) {
    return new CoinDetails2(
      value: json['value'],
    );
  }
}