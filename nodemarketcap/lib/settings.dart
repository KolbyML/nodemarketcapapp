import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:get_version/get_version.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  bool switchValue = true;

  String _projectVersion = '';

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String projectVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _projectVersion = projectVersion;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Settings'),
        backgroundColor: new Color(0xFF090909),
      ),
      body:
      new ListView(
        children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(padding: new EdgeInsets.all(8.0),
                    child: new Text('App', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF484848), fontSize: 14.0),),
                  ),
                new ListTile(
                  title: const Text('Notifications', style: const TextStyle(fontSize: 18.0)),
                  trailing: Switch(
                      value: true,
                      onChanged: (bool value) {setState(() {switchValue = value;});},
                      activeColor: new Color(0xFFffffff),
                      activeTrackColor: new Color(0xFF11e7ff)
                  ),
                ),
                Divider(),
                new Padding(padding: new EdgeInsets.all(8.0),
                  child: new Text('Feedback', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF484848), fontSize: 14.0),),
                ),
                new ListTile(
                  title: const Text('Share App', style: const TextStyle(fontSize: 18.0)),
                  onTap: () {Share.share('Checkout out the Nodemarketcap App it helps you monitor the value, earnings and price of your Masternode Investments. https://nodemarketcap.com/');},

                ),
                new ListTile(
                  title: const Text('Contact Us', style: const TextStyle(fontSize: 18.0)),
                  onTap: _launchEmail,

                ),
                Divider(),
                new Padding(padding: new EdgeInsets.all(8.0),
                  child: new Text('Social', style: new TextStyle(fontWeight: FontWeight.bold, color: new Color(0xFF484848), fontSize: 14.0),),
                ),
                new ListTile(
                  title: const Text('Website', style: const TextStyle(fontSize: 18.0)),
                    onTap: _launchWebsite,

                ),
                new ListTile(
                  title: const Text('Twitter', style: const TextStyle(fontSize: 18.0)),
                  onTap: _launchTwitter,

                ),
                new ListTile(
                  title: const Text('Discord', style: const TextStyle(fontSize: 18.0)),
                  onTap: _launchDiscord,

                ),
                Divider(),
                new ListTile(
                  title: const Text('App Version'),
                  subtitle: new Text(_projectVersion),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
_launchWebsite() async {
  const url = 'https://nodemarketcap.com/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchTwitter() async {
  const url = 'https://twitter.com/nodemarketcap';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
_launchDiscord() async {
  const url = 'https://discord.gg/3HvzZjA';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
_launchEmail() async {
  const url = 'mailto:info@nodemarketcap.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}