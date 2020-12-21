import 'package:flutter/material.dart';
import 'package:flutter_torico_id_login/flutter_torico_id_login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FlatButton(
            child: Text('login'),
            onPressed: () {
              final toricoIdLogin = ToricoIdLogin(
                url: 'XXXXX',
                redirectURI: 'example://',
              );
              toricoIdLogin.login();
            },
          ),
        ),
      ),
    );
  }
}
