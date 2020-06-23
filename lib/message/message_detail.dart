
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagedetailPage extends StatefulWidget {
  @override
  _MessagedetailPageState createState() => _MessagedetailPageState();
}

class _MessagedetailPageState extends State<MessagedetailPage> {
  var _token;
 var _text;

@override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    _token=sharedPreferences.getString('_userToken');

    try{
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token']=_token;
      Response response=await dio.get('http://192.168.2.150:20001/api/message/detail?messageId=1');
      Map data=response.data;
      print(data);
      if(data['code']==200){
        setState(() {
          _text=data['data'];
        });
      }

    }catch(e){
      return print(e);
    }

    // print(json.decode(result.data)["result"]);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('消息详情'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_text['messageTime']),
            SizedBox(height:30.0),
            Text(_text['messageDetailContent']),
          ],
        ),
      ),
    );
  }
}
