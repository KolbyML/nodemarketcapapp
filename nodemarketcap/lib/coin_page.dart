import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nodemarketcap/settings.dart';
import 'package:nodemarketcap/page/coin_hold_page.dart' as fourth;
import 'package:nodemarketcap/page/coin_info_page.dart' as first;
import 'package:nodemarketcap/page/coin_alerts_page.dart' as third;
import 'package:nodemarketcap/database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:nodemarketcap/new_listtile_display.dart';

class CoinPage extends StatefulWidget {
  final String coin;
  final String coinb;
  final ListTableState listTableState;
  final DatabaseClient databaseClient;
  const CoinPage({
    @required this.databaseClient,
    this. listTableState,
    this.coin,
    this.coinb,
    Key key,
  }) : super(key: key);
  @override
  _CoinPageState createState() => new _CoinPageState();
}
class _CoinPageState extends State<CoinPage>  with SingleTickerProviderStateMixin {

  Future<Null> getCoins() async {
    await updateCoinStats();
    final coinsb = await widget.databaseClient.getCoinPage(widget.coin.toString());
    final coinsJson = json.decode(coinsb);
    final coinsamount = widget.databaseClient.countRows();
    setState(() {
      _coinDetails.clear();
      for (Map user2 in coinsJson) {
        _coinDetails.add(CoinDetails.fromJson(user2));
        print(CoinDetails.fromJson(user2));
      }
    });
  }
  Future<Null> updateCoinStats() async {
    try {
      var cleg = _coinDetails.length - 1;
      for (var i = 0; i <=  cleg; i++) {
        var name = widget.coin.toString();
        var url = 'https://nodemarketcap.com/api/' + name;
        var stats = await fetchJSON(url);
        print('${stats['nameb'].toString()}');
        widget.databaseClient.updateCoin(name, '${stats['roi'].toString()}', '${stats['usdvalue'].toString()}', '${stats['changep'].toString()}', '${stats['mnCost'].toString()}', '${stats['mncount'].toString()}',
            '${stats['mnpriceusd'].toString()}', '${stats['usdvol'].toString()}', '${stats['dailyUSD'].toString()}', '${stats['dailyBTC'].toString()}', '${stats['monthlyUSD'].toString()}', '${stats['monthlyBTC'].toString()}',
          '${stats['yearlyUSD'].toString()}', '${stats['yearlyBTC'].toString()}', '${stats['btcval'].toString()}', '${stats['usdMarketCap'].toString()}', '${stats['btcMarketCap'].toString()}', '${stats['btcvol'].toString()}',);
      }
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
  TabController controller;

  @override
  void initState() {
    super.initState();
    updateCoinStats();
    getCoins();
    controller = new TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _settingsPage() {
    // 1
    Navigator.of(context).push(new PageRouteBuilder(
      opaque: true,
      pageBuilder: (BuildContext context, _, __) {
        return new SettingsPage();
      },
      //
    ));
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.coinb),
        backgroundColor: new Color(0xFF090909),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.autorenew),
              onPressed: getCoins,
            ),
            new IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () { return showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: new Text("Please Read the Following"),
                    content: new Text("If you click the ok button it will Remove the requested coin to the app for the coin to appear you must, on the home page pull down the reload the page."),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      new FlatButton(
                        child: new Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      new FlatButton(
                        child: new Text("Ok"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          widget.databaseClient.removeCoin(widget.coin.toString());
                          widget.listTableState.getCoins();

                        },

                      ),
                    ],
                  );
                },
              );
              },
            ),
            new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () { },
            ),
            new IconButton(
              icon: new Icon(Icons.settings),
              onPressed: () { _settingsPage(); }
            ),
      ],
        bottom: new TabBar(
          controller: controller,
          indicatorColor: new Color(0xFF090909),
          unselectedLabelColor: new Color(0xFF808080),
          tabs: <Widget>[
            new Tab(child: Text('Info', style: new TextStyle(),),),
            new Tab(child: Text('Alerts', style: new TextStyle(),),),
            new Tab(child: Text('Holdings', style: new TextStyle(),),),
          ],
        ),
    ),
      body: new TabBarView(
          controller: controller,
          children: <Widget>[
            new first.First(roi: _coinDetails[0].roi.toString(), usdvalue: _coinDetails[0].usdvalue.toString(), changep: _coinDetails[0].changep.toString(), mnCost: _coinDetails[0].mnCost.toString(),
              mncount: _coinDetails[0].mncount.toString(), mnpriceusd: _coinDetails[0].mnpriceusd.toString(), usdvol: _coinDetails[0].usdvol.toString(), dailyUSD: _coinDetails[0].dailyUSD.toString(),
              dailyBTC: _coinDetails[0].dailyBTC.toString(), monthlyUSD: _coinDetails[0].monthlyUSD.toString(), monthlyBTC: _coinDetails[0].monthlyBTC.toString(), yearlyUSD: _coinDetails[0].yearlyUSD.toString(),
              yearlyBTC: _coinDetails[0].yearlyBTC.toString(), btcval: _coinDetails[0].btcval.toString(), usdMarketCap: _coinDetails[0].usdMarketCap.toString(), btcMarketCap: _coinDetails[0].btcMarketCap.toString(),
              btcvol: _coinDetails[0].btcvol.toString(),hold: _coinDetails[0].hold.toString(), holdvalue: _coinDetails[0].holdvalue.toString(), ),
            new third.Third(),
            new fourth.Fourth(name: widget.coin, name2: widget.coinb,  databaseClient: DatabaseClient(),  hold: _coinDetails[0].hold.toString(), holdvalue: _coinDetails[0].holdvalue.toString(), usdvalue: _coinDetails[0].usdvalue.toString(),),
          ]
      ),

    );
  }

}
List<CoinDetails> _coinDetails = [];

class CoinDetails {
  final num roi;
  final num usdvalue;
  final num changep;
  final num mnCost;
  final num mncount;
  final num mnpriceusd;
  final num usdvol;
  final num dailyUSD;
  final num dailyBTC;
  final num monthlyUSD;
  final num monthlyBTC;
  final num yearlyUSD;
  final num yearlyBTC;
  final num btcval;
  final num usdMarketCap;
  final num btcMarketCap;
  final num btcvol;
  final num hold;
  final num holdvalue;

  CoinDetails({this.roi, this.usdvalue, this.changep, this.mnCost, this.mncount, this.mnpriceusd, this.usdvol, this.dailyUSD, this.dailyBTC, this.monthlyUSD, this.monthlyBTC,
    this.yearlyUSD, this.yearlyBTC, this.btcval, this.usdMarketCap, this.btcMarketCap, this.btcvol, this.hold, this.holdvalue});

  factory CoinDetails.fromJson(Map<String, dynamic> json) {
    return new CoinDetails(
      roi: json['roi'],
      usdvalue: json['usdvalue'],
      changep: json['changep'],
      mnCost: json['mnCost'],
      mncount: json['mncount'],
      mnpriceusd: json['mnpriceusd'],
      usdvol: json['usdvol'],
      dailyUSD: json['dailyUSD'],
      dailyBTC: json['dailyBTC'],
      monthlyUSD: json['monthlyUSD'],
      monthlyBTC: json['monthlyBTC'],
      yearlyUSD: json['yearlyUSD'],
      yearlyBTC: json['yearlyBTC'],
      btcval: json['btcval'],
      usdMarketCap: json['usdMarketCap'],
      btcMarketCap: json['btcMarketCap'],
      btcvol: json['btcvol'],
      hold: json['hold'],
      holdvalue: json['holdvalue'],
    );
  }

}