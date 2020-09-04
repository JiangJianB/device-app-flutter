import 'package:flutter/material.dart';
import 'SplashPage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SplashScreen(), // 闪屏页
    );
  }
}