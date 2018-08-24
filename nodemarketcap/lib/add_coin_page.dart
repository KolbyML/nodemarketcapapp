import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:nodemarketcap/database.dart';
import 'package:sqflite/sqflite.dart';
class AddCoinPage extends StatefulWidget {
  final DatabaseClient databaseClient;

  AddCoinPage({Key key, @required this.databaseClient}) : super(key: key);
  @override
  _AddCoinPageState createState() => new _AddCoinPageState();
}



class _AddCoinPageState extends State<AddCoinPage> {
  TextEditingController controller = new TextEditingController();
  String coin;


  addCoin(coinname) async {
    setState(() {
      coin = coinname;
    });
    return widget.databaseClient.addCoin(coin);
  }
  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    final response = await http.get(url);
    final responseJson = json.decode(response.body);
    final coins = await widget.databaseClient.getCoinList();
    final coinsJson = json.decode(coins);
    final coinsamount = widget.databaseClient.countRows();
    setState(() {
      _userDetails.clear();
      for (Map user in responseJson) {

        _userDetails.add(UserDetails.fromJson(user));
        for (Map user2 in coinsJson) {
          if (user.toString() == user2.toString()) {
            _userDetails.removeLast();
          }
          else {
            continue;
          }
        }
      }
    });
  }


  @override
  void initState() {
    super.initState();

    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add Coin'),
        backgroundColor: new Color(0xFF090909),
        elevation: 0.0,
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            color: Colors.white,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },),
                ),
              ),
            ),
          ),
          new Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? new ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, i) {
                return new Card(
                  child: new ListTile(
                      title: new Text(_searchResult[i].name),
                      onTap: () {return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: new Text("Please Read the Following"),
                            content: new Text("If you click the ok button it will Added the requested coin to the app for the coin to appear you must, on the home page pull down the reload the page."),
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
                                  Navigator.of(context).pop();
                                  addCoin((_searchResult[i].name).toString());

                                },

                              ),
                            ],
                          );
                        },
                      );}
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            )
                : new ListView.builder(
              itemCount: _userDetails.length,
              itemBuilder: (context, index) {
                return new Card(
                  child: new ListTile(
                      title: new Text(_userDetails[index].name.toString()),
                      onTap: () {   return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: new Text("Please Read the Following"),
                            content: new Text("If you click the ok button it will Added the requested coin to the app for the coin to appear you must, on the home page pull down the reload the page."),
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
                                  Navigator.of(context).pop();
                                  addCoin((_userDetails[index].name).toString());

                                },

                              ),
                            ],
                          );
                        },
                      );
                      }
                  ),
                  margin: const EdgeInsets.all(0.0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.name.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

List<UserDetails> _searchResult = [];

List<UserDetails> _userDetails = [];

final String url = 'https://nodemarketcap.com/api/api';
class UserDetails {
  final String name;

  UserDetails({this.name});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
      name: json['name'],
    );
  }
  factory UserDetails.fromJson2(Map<String, dynamic> json) {
    return new UserDetails(
      name: json['name'],
    );
  }
}