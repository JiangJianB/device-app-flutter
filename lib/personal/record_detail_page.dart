

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecorddetailPage extends StatefulWidget {

  @override
  _RecorddetailPageState createState() => _RecorddetailPageState();
}

class _RecorddetailPageState extends State<RecorddetailPage> {
  var _token;
  var _name;
  List _list = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    _token =sharedPreferences.getString('_userToken');
    _name = sharedPreferences.getString('_userName');
    print(_name);
    print(_token);

    try{
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token'] = _token;
      Response response = await dio.get("http://192.168.2.150:20001/api/user/tally-record_detail?tallyRecordId=110786");
      Map data=response.data;
      print(data);

      if(data['code']==200){
        setState(() {
          _list=data['data']['list'];
        });
        print(_list);
      }else{
        print('错误');
      }
    }catch(e){
      return print(e);
    }
  }
  List list=new List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("点检详情",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: ListView.builder(
          itemBuilder: (BuildContext context,int index){
            return ListTile();
          }
      ),
    );
  }
}
