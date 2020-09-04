import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../login.dart';

class AbnormaltallycountPage extends StatefulWidget {
  final fixedAssetsNo;
  final name;
  final names;
  final datas;
  final instructions;
  final tallyType;

  AbnormaltallycountPage(
      {this.fixedAssetsNo,
      this.name,
      this.instructions,
      this.tallyType,
      this.names,
      this.datas});

  @override
  _AbnormaltallycountPageState createState() => _AbnormaltallycountPageState();
}

class _AbnormaltallycountPageState extends State<AbnormaltallycountPage> {
  var _token;
  var _name;
  var _names;
  var _text;

  var name;

  var jobNo;
  var postName;
  var postNo;
  var tallyType;
  String _fixedAssetsNo;
  String names;
  String instructions;

  List _list = ['清扫', '更换', '检查', '其他'];

  @override
  void initState() {
    super.initState();
    if (widget.fixedAssetsNo != null) {
      setState(() {
        _fixedAssetsNo = widget.fixedAssetsNo.toString();
        name = widget.name.toString();
        instructions = widget.instructions.toString();
        tallyType = widget.tallyType.toString();
        _names = widget.names.toString();
        debugPrint(_names);
      });
      _getData(_fixedAssetsNo, tallyType);
    }
  }

  _getData(String fixedAssetsNo, String tallyType) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _token = sharedPreferences.getString('_userToken');
    _name = sharedPreferences.getString('_userName');
    name = sharedPreferences.getString('name');
    jobNo = sharedPreferences.getString('jobNo');
    postName = sharedPreferences.getString('postName');
    postNo = sharedPreferences.getString('postNo');

    try {
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token'] = _token;
      Response response = await dio.get(
          'http://192.168.2.150:20001/api/tally/judge-over-Time?jobNo=$_name&postNo=$postNo&fixedAssetsNo=$fixedAssetsNo&jobWayId=4&tallyType=$tallyType');
      Map data = response.data;
      print(data);
      print(data['data']);
      if (data['code'] == 200) {
        setState(() {
          _text = data['data'];
        });
      }
    } catch (e) {
      return print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "异常项目数",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: width,
              height: 50,
              child: Container(
                padding: const EdgeInsets.only(left: 15),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Expanded(
                        child: name == null ? SizedBox() : Text(name),
                      ),
                    ),
                    Container(
                      child: Expanded(
                        child: jobNo == null ? SizedBox() : Text("工号：" + jobNo),
                      ),
                    ),
                    Container(
                      child: Expanded(
                        child: postName == null
                            ? SizedBox()
                            : Text("岗位：" + postName),
                      ),
                    ),
                    FlatButton(
                        child: Text(
                          "退出登录",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("退出登录将清空当前操作，确定退出吗？"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("退出登录"),
                                      onPressed: () async{
                                        final prefs = await SharedPreferences.getInstance();
                                        final result = await prefs.clear();
                                        if(result)
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (BuildContext context) => LoginPage(),
                                            ));
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "取消",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        })
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 125,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget.names.length,
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
                                  child: Text(_list[widget.names[index]['category'] - 1]),
                                ),
                                Container(
                                  child: Container(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: widget.names[index]['tallyCategoryDetailDTOList'].length -
                                            (widget.names[index]['tallyCategoryDetailDTOList'].length),
                                        itemBuilder: (BuildContext context, int i) {
                                          return Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: ListTile(
                                                  title: Text(
                                                      '${widget.names[index]['tallyCategoryDetailDTOList'][i]['name']}'),
                                                  subtitle: Text('基准：' +
                                                      '${widget.names[index]['tallyCategoryDetailDTOList'][i]['instructions']}'),
                                                ),
                                              ),
                                            ],
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
          ],
        ),
      ),
    );
  }
}
