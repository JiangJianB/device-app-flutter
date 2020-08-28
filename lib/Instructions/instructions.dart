import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'instructions_detail.dart';

class InstructionsPage extends StatefulWidget {
  final barcode;

  InstructionsPage({this.barcode});

  @override
  _InstructionsPageState createState() => _InstructionsPageState();
}

class _InstructionsPageState extends State<InstructionsPage> {
  var _token;
  List _list = [];
  String _fixedAssetsNo;

  @override
  void initState() {
    super.initState();
    if (widget.barcode != null) {
      setState(() {
        _fixedAssetsNo = widget.barcode.toString();
        print(_fixedAssetsNo);
      });
      _getData(_fixedAssetsNo);
    }
  }

  _getData(String fixedAssetsNo) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _token = sharedPreferences.getString('_userToken');

    try {
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token'] = _token;
      Response response = await dio.get(
          'http://192.168.2.150:20001/api/instructions/fixedAssetsNo?fixedAssetsNo=$fixedAssetsNo');
      Map data = response.data;
      print(data);
      if (data['code'] == 200) {
        setState(() {
          _list = data['data'];
        });
      }
      else{
        Navigator.pop(context);
        Fluttertoast.showToast(msg: '所查询的说明书不存在',gravity: ToastGravity.BOTTOM);
      }
    } catch (e) {
      return print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('说明书/保养手册'),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: GestureDetector(
          child: Container(
            child: ListView.builder(
              itemExtent: 50,
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              margin: const EdgeInsets.only(left: 10, top: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: AssetImage('images/ic_pdf.png'),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              width: 160,
                              height: 30,
                              margin: const EdgeInsets.only(left: 10, top: 25),
                              child: Text(_list[index]['name']),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 20, top: 20),
                        child: Row(
                          children: <Widget>[
                            Text('查看'),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InstructionsDetailPage(
                            title: _list[index]['name'],
                            id: _list[index]['id'],
                          ),
                        ));
                  },
                );
              },
            ),
          ),
        ));
  }
}
