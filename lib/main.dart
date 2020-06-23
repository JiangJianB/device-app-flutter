import 'package:dianjian/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(LoginPage());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      color: Colors.grey,
      home: LoginPage(),
    );
  }
}

