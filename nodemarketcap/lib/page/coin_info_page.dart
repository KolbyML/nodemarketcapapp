import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class First extends StatelessWidget {
  final String roi;
  final String usdvalue;
  final String changep;
  final String mnCost;
  final String mncount;
  final String mnpriceusd;
  final String usdvol;
  final String dailyUSD;
  final String dailyBTC;
  final String monthlyUSD;
  final String monthlyBTC;
  final String yearlyUSD;
  final String yearlyBTC;
  final String btcval;
  final String usdMarketCap;
  final String btcMarketCap;
  final String btcvol;
  final String hold;
  final String holdvalue;

  First({
    this.roi,
    this.usdvalue,
    this.changep,
    this.mnCost,
    this.mncount,
    this.mnpriceusd,
    this.usdvol,
    this.dailyUSD,
    this.dailyBTC,
    this.monthlyUSD,
    this.monthlyBTC,
    this.yearlyUSD,
    this.yearlyBTC,
    this.btcval,
    this.usdMarketCap,
    this.btcMarketCap,
    this.btcvol,
    this.hold,
    this.holdvalue,
    Key key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return new Container(
      child: CoinInfo(roi: roi, usdvalue: usdvalue, changep: changep, mnCost: mnCost, mncount: mncount, mnpriceusd: mnpriceusd, usdvol: usdvol, dailyUSD: dailyUSD, dailyBTC: dailyBTC, monthlyUSD: monthlyBTC, yearlyUSD: yearlyUSD, yearlyBTC: yearlyBTC, btcval: btcval, usdMarketCap: usdMarketCap, btcMarketCap: btcMarketCap, btcvol: btcvol, hold: hold, holdvalue: holdvalue,),
    );
  }
}




class CoinInfo extends StatelessWidget {
  final String roi;
  final String usdvalue;
  final String changep;
  final String mnCost;
  final String mncount;
  final String mnpriceusd;
  final String usdvol;
  final String dailyUSD;
  final String dailyBTC;
  final String monthlyUSD;
  final String monthlyBTC;
  final String yearlyUSD;
  final String yearlyBTC;
  final String btcval;
  final String usdMarketCap;
  final String btcMarketCap;
  final String btcvol;
  final String hold;
  final String holdvalue;
  const CoinInfo({
    this.roi,
    this.usdvalue,
    this.changep,
    this.mnCost,
    this.mncount,
    this.mnpriceusd,
    this.usdvol,
    this.dailyUSD,
    this.dailyBTC,
    this.monthlyUSD,
    this.monthlyBTC,
    this.yearlyUSD,
    this.yearlyBTC,
    this.btcval,
    this.usdMarketCap,
    this.btcMarketCap,
    this.btcvol,
    this.hold,
    this.holdvalue,
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new FlatButton.icon(onPressed: null, icon: Icon(Icons.call_made), splashColor:  Color(0xFF090909), highlightColor: Color(0xFF090909), label: Text('Currency: '+ 'USD', style: const TextStyle(fontSize: 18.0) ), ),
                Divider(),
                new ListTile(
                  title: new Text('\$$holdvalue', style: const TextStyle(fontSize: 18.0)),
                  onTap: null,
                ),
                Divider(),
                new Padding(padding: new EdgeInsets.all(8.0),
                  child: new Text('Stats', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                ),
                new Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('Daily', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                          new Text('\$$dailyUSD')
                        ],
                      ),
                        width: width /3,),
                    new Container(
                      padding: EdgeInsets.all(20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('Monthly', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                          new Text('\$$monthlyUSD')
                        ],
                      ),
                      width: width /3,),
                    new Container(
                      padding: EdgeInsets.all(20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('Yearly', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                          new Text('\$$yearlyUSD')
                        ],
                      ),
                      width: width /3,),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('MarketCap', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                          new Text('\$$usdMarketCap')
                        ],
                      ),
                      width: width /3,),
                    new Container(
                      padding: EdgeInsets.all(20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('Price', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                          new Text('\$$usdvalue')
                        ],
                      ),
                      width: width /3,),
                    new Container(
                      padding: EdgeInsets.all(20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('ROI', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                          new Text('$roi %')
                        ],
                      ),
                      width: width /3,),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('MN Cost', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                          new Text('\$$mnpriceusd')
                        ],
                      ),
                      width: width /3,),
                    new Container(
                      padding: EdgeInsets.all(20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('Required', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                          new Text('$mnCost')
                        ],
                      ),
                      width: width /3,),
                    new Container(
                      padding: EdgeInsets.all(20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('MN Count', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                          new Text('$mncount')
                        ],
                      ),
                      width: width /3,),
                  ],
                ),
                Divider(),
                new Padding(padding: new EdgeInsets.all(8.0),
                  child: new Text('Holding', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                ),
                new Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('Value', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                          new Text('\$$usdvalue')
                        ],
                      ),
                      width: width /3,),
                    new Container(
                      padding: EdgeInsets.all(20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('Amount', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                          new Text('$hold')
                        ],
                      ),
                      width: width /3,),
                    new Container(
                      padding: EdgeInsets.all(20.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('Change', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF707070), fontSize: 14.0),),
                          new Text('$changep')
                        ],
                      ),
                      width: width /3,),
                  ],
                ),
              ],
            );
  }
}