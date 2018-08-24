import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class DatabaseClient  {

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.dn in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test11.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE coins (name TEXT PRIMARY KEY, nameb TEXT NOT NULL, tickerCap TEXT NOT NULL, roi REAL NOT NULL, usdvalue REAL NOT NULL, changep REAL NOT NULL, mnCost INTEGER NOT NULL,mncount INTEGER  NOT NULL, mnpriceusd REAL NOT NULL, usdvol REAL NOT NULL, dailyUSD REAL NOT NULL, dailyBTC REAL NOT NULL, monthlyUSD REAL NOT NULL, monthlyBTC REAL NOT NULL, yearlyUSD REAL NOT NULL, yearlyBTC REAL NOT NULL, btcval REAL NOT NULL, usdMarketCap REAL NOT NULL, btcMarketCap REAL NOT NULL, btcvol REAL NOT NULL, hold NUM NOT NULL, holdvalue NUM NOT NULL)");
    await db.execute("CREATE TABLE value (name TEXT PRIMARY KEY, value NUM NOT NULL)");
    print("Created tables");
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO coins(name, nameb, tickerCap, roi, usdvalue, changep, mnCost, mncount, mnpriceusd, usdvol, dailyUSD, dailyBTC, monthlyUSD, monthlyBTC, yearlyUSD, yearlyBTC, btcval, usdMarketCap, btcMarketCap, btcvol, hold, holdvalue) VALUES("curium", "refresh", "refresh", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0)');
      print("insertedcoin: $id1");
      int id2 = await txn.rawInsert(
          'INSERT INTO coins(name, nameb, tickerCap, roi, usdvalue, changep, mnCost, mncount, mnpriceusd, usdvol, dailyUSD, dailyBTC, monthlyUSD, monthlyBTC, yearlyUSD, yearlyBTC, btcval, usdMarketCap, btcMarketCap, btcvol, hold, holdvalue) VALUES("phore", "refresh", "refresh", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0)');
      print("insertedcoin: $id2");
    });
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO value(name, value) VALUES("portval", 0)');
      print("insertedcoin: $id1");
    });
  }
  addCoin (String name) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM coins');
    print(list);
        await dbClient.transaction((txn) async {
          int id3 = await txn.rawInsert(
              'INSERT INTO coins(name, nameb, tickerCap, roi, usdvalue, changep, mnCost, mncount, mnpriceusd, usdvol, dailyUSD, dailyBTC, monthlyUSD, monthlyBTC, yearlyUSD, yearlyBTC, btcval, usdMarketCap, btcMarketCap, btcvol, hold, holdvalue) VALUES("${name}", "refresh", "refresh", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0)');
          print("insertedcoin: $id3");
        });
  }
  updateCoin (name, roi, usdvalue, changep, mnCost, mncount, mnpriceusd, usdvol, dailyUSD, dailyBTC, monthlyUSD, monthlyBTC, yearlyUSD, yearlyBTC, btcval, usdMarketCap, btcMarketCap, btcvol) async {
    var dbClient = await db;
    int update = await dbClient.rawUpdate(
        'UPDATE coins SET roi = ?, usdvalue = ?, changep = ?, mnCost = ?, mncount = ?, mnpriceusd = ?, usdvol = ?, dailyUSD = ?, dailyBTC = ?, monthlyUSD = ?, monthlyBTC = ?, yearlyUSD = ?, yearlyBTC = ?, btcval = ?, usdMarketCap = ?, btcMarketCap = ?, btcvol = ?  WHERE name = ?',
        [roi, usdvalue, changep, mnCost, mncount, mnpriceusd, usdvol, dailyUSD, dailyBTC, monthlyUSD, monthlyBTC, yearlyUSD, yearlyBTC, btcval, usdMarketCap, btcMarketCap, btcvol, name]);
    print("updated: $update");
  }
  updateCoinPrice (name, usdvalue, tickerCap, nameb) async {
    var dbClient = await db;
    int update = await dbClient.rawUpdate(
        'UPDATE coins SET usdvalue = ?, tickerCap = ?, nameb = ? WHERE name = ?',
        [usdvalue, tickerCap, nameb, name]);
    print("updated: $update");
  }
  updateHoldPrice2 (name, hold, holdvalue) async {
    var dbClient = await db;
    int update = await dbClient.rawUpdate(
        'UPDATE coins SET hold = ?, holdvalue = ? WHERE name = ?',
        [hold, holdvalue, name]);
    print("updated: $update");
  }
  manageValue (value) async {
    var dbClient = await db;
      int update = await dbClient.rawUpdate(
          'UPDATE value SET value = ? WHERE name = ?',
          [value, 'portval']);
      print("updated: $update");

  }
  manageValue2view () async {
    var dbClient = await db;
    return jsonEncode(await dbClient.rawQuery('SELECT value FROM value'));
  }
  updateHoldPrice (name, holdvalue ) async {
    var dbClient = await db;
    int update = await dbClient.rawUpdate(
        'UPDATE coins SET holdvalue = ? WHERE name = ?',
        [holdvalue, name]);
    print("updated: $update");
  }
  getList () async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM coins');
    print(list);
    return list;
  }
  getListCoin (name) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM coins WHERE name = ?', ["${name}"]);
    print(list);
    return list;
  }
  countRows () async {
    var dbClient = await db;
    int count = Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM coins"));
    return count;
  }
  getCoinList () async {
    var dbClient = await db;
    return jsonEncode(await dbClient.rawQuery('SELECT name FROM coins'));
  }
  getCoinPage (name) async {
    var dbClient = await db;
    return jsonEncode(await dbClient.rawQuery('SELECT roi, usdvalue, changep, mnCost, mncount, mnpriceusd, usdvol, dailyUSD, dailyBTC, monthlyUSD, monthlyBTC, yearlyUSD, yearlyBTC, btcval, usdMarketCap, btcMarketCap, btcvol, hold, holdvalue FROM coins WHERE name = ?', ["${name}"]));
  }
  getCoinListHomePage () async {
    var dbClient = await db;
    return jsonEncode(await dbClient.rawQuery('SELECT name, usdvalue, tickerCap, nameb, hold, holdvalue FROM coins'));
  }
  getCoinListNotJson () async {
    var dbClient = await db;
    var list = await dbClient.rawQuery('SELECT name FROM coins');
    print(list);
    return list.toList();
  }
  removeCoin (name) async {
    var dbClient = await db;
    int count = await dbClient.rawDelete('DELETE FROM coins WHERE name = ?', ["${name}"]);
    print("removeCoin: $count");
  }


}
