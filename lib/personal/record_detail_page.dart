import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecorddetailPage extends StatefulWidget {
  final tallyRecordId;
  RecorddetailPage({this.tallyRecordId});
  @override
  _RecorddetailPageState createState() => _RecorddetailPageState();
}

class _RecorddetailPageState extends State<RecorddetailPage> {
  var _token;
  var _name;
  var _text;
  String _tallyRecordId;
  ScrollController _controller;
  List _list = ['清扫', '更换', '检查', '其他'];

  @override
  void initState() {
    super.initState();
    if (widget.tallyRecordId != null) {
      setState(() {
        _tallyRecordId = widget.tallyRecordId.toString();
        print(_tallyRecordId);
      });
      _getData(_tallyRecordId);
    }

  }

  _getData( String tallyRecordId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _token = sharedPreferences.getString('_userToken');
    _name = sharedPreferences.getString('_userName');
    print(_name);
    print(_token);

    try {
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token'] = _token;
      Response response = await dio.get(
//          "http://192.168.2.150:20001/api/user/tally-record_detail?tallyRecordId=$tallyRecordId");
           "http://192.168.2.150:20001/api/user/tally-record-detail?tallyRecordId=$tallyRecordId");
      Map data = response.data;
      print(data);

      if (data['code'] == 200) {
        setState(() {
          _text = data['data'];
        });
        print(_text);
      } else {
        print('错误');
      }
    } catch (e) {
      return print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "点检详情",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body:  Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _text?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 30,
                            child: Text(_list[_text[index]['tallyCategory'] -1 ]),
                          ),
                          Container(
                            child: Container(
                              color: Colors.white,
                              child: ListView.builder(
                                  controller: _controller,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _text[index]['tallyRecordDetailDTOList'].length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return GestureDetector(
                                      onTap: (){
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context){
                                              return AlertDialog(
                                                title: Text('${_text[index]['tallyRecordDetailDTOList'][i]['tallyName']}'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text('方法：'+'${_text[index]['tallyRecordDetailDTOList'][i]['method']}',style: TextStyle(color: Colors.black54),),
                                                      Text('工具：'+'${_text[index]['tallyRecordDetailDTOList'][i]['tool']}',style: TextStyle(color: Colors.black54),),
                                                      Text('基准：'+'${_text[index]['tallyRecordDetailDTOList'][i]['instructions']}',style: TextStyle(color: Colors.black54),),
                                                      Text('处置：'+'${_text[index]['tallyRecordDetailDTOList'][i]['disposition']}',style: TextStyle(color: Colors.black54),),
                                                      Center(
                                                        child: FlatButton(
                                                          child: Text('确认',style: TextStyle(color: Colors.pink,fontSize: 20),),
                                                          onPressed: (){
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                        );
                                      },
                                      child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: ListTile(
                                            title: Text(
                                                '${_text[index]['tallyRecordDetailDTOList'][i]['tallyName']}'),
                                            subtitle: Text('基准：' +
                                                '${_text[index]['tallyRecordDetailDTOList'][i]['instructions']}'),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              child: Container(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 30,
                                                      width: 50,
                                                      child: TextField(
                                                        controller: TextEditingController()..text = _text[index]['tallyRecordDetailDTOList'][i]['tallyValue'],
                                                        enabled: false, //禁止输入
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                    );
                                  }),
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
