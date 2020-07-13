import 'package:dianjian/home/home_page.dart';
import 'package:dianjian/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(LoginPage());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _token;
  dynamic entrance;


  @override
  void initState(){
    super.initState();
    _getData();
    if(_token !=null){
      entrance=HomePage();
    }else{
      entrance=LoginPage();
    }
  }
  _getData()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    _token=sharedPreferences.getString('_userToken');
    print(_token);
  }
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




