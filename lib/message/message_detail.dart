import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagedetailPage extends StatefulWidget {
  final id;

  MessagedetailPage({this.id});

  @override
  _MessagedetailPageState createState() => _MessagedetailPageState();
}

class _MessagedetailPageState extends State<MessagedetailPage> {
  var _token;
  var _text;
  String _id;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      setState(() {
        _id = widget.id.toString();
      });
      _getData(_id);
    }
  }

  Future _getData(String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _token = sharedPreferences.getString('_userToken');

    try {
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token'] = _token;
      Response response = await dio
          .get('http://192.168.2.150:20001/api/message/detail?messageId=$id');
      Map data = response.data;

      if (response.statusCode == 200) {
        setState(() {
          _text = data['data'];
        });
        print(_text);
      }
    } catch (e) {
      return print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_text == null) return Container();
    return Scaffold(
      appBar: AppBar(
        title: Text('消息详情'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(_text['messageTime']),
            SizedBox(height: 20.0),
            Text(_text['messageDetailContent']),
          ],
        ),
      ),
    );
  }

}
