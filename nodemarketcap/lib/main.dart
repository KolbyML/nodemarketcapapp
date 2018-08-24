import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:nodemarketcap/settings.dart';
import 'package:nodemarketcap/add_coin_page.dart';
import 'package:nodemarketcap/coin_page.dart';
import 'package:nodemarketcap/new_listtile_display.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:nodemarketcap/database.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Nodemarketcap',
      home: new MyHomePage(databaseClient: DatabaseClient(),),
    );
  }
}

class MyHomePage extends StatefulWidget {

  final DatabaseClient databaseClient;


  MyHomePage({Key key,  @required this.databaseClient}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Nodemarketcap'),
        backgroundColor: new Color(0xFF090909),

        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: () { _addCoinPage(); },

          ),
          new IconButton(
              icon: new Icon(Icons.settings),
              onPressed: () { _settingsPage(); }
          ),
        ],
      ),
      body:  new ListTable(databaseClient: DatabaseClient(), )
    );
  }
}



