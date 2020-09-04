import 'package:dianjian/Instructions/Instructions.dart';
import 'package:dianjian/home/content/daily_maintain_page.dart';
import 'package:dianjian/home/content/monthly_maintain_page.dart';
import 'package:dianjian/home/content/weekly_maintain_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login.dart';
import 'package:dianjian/utils/screen_utils.dart';

class WorkwayPage extends StatefulWidget {
  final barcode;
  final postNo;

  WorkwayPage({this.barcode, this.postNo});

  @override
  _WorkwayPageState createState() => _WorkwayPageState();
}

class _WorkwayPageState extends State<WorkwayPage> {
  var _token;
  var _text;
  var name;
  var postName;
  var jobNo;
  var postNo;
  var jobWayId;
  int groupValue = 0;

  String _fixedAssetsNo;
  List jobwayid = [];

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
    name = sharedPreferences.getString('name');
    jobNo = sharedPreferences.getString('jobNo');
    postName = sharedPreferences.getString('postName');
    _token = sharedPreferences.getString('_userToken');
    postNo = sharedPreferences.getString('postNo');

    try {
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token'] = _token;
      Response response = await dio.get(
          'http://192.168.2.150:20001/api/tally/eqJobWay?fixedAssetsNo=$fixedAssetsNo&postNo=$postNo');
      Map data = response.data;
      print(data);
      if (data['code'] == 200) {
        setState(() {
          _text = data['data'];
        });
        jobWayId = _text['jobWayList'];
        print(jobWayId);
      } else {
        Fluttertoast.showToast(
          msg: '设备已停用',
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      return print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_text == null) return Container();
    ScreenAdaptr.init(context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "选择作业方式",
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
          children: <Widget>[
            SizedBox(
              width: width,
              child: Container(
                height: 50,
                padding: const EdgeInsets.only(left: 10),
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
                                          Navigator.push(context,
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
            SizedBox(
              height: MediaQuery.of(context).size.height - 190,
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10.0,),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.only(left: 10, right: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "设备名称",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      _text['equipmentName'] == null
                                          ? SizedBox()
                                          : Text(_text["equipmentName"]),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(left: 10, right: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "型号",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      _text['equipmentModel'] == null
                                          ? SizedBox()
                                          : Text(_text['equipmentModel']),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.only(left: 10, right: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "固定资产编号",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      _text['fixedAssetsNo'] == null
                                          ? SizedBox()
                                          : Text(_text['fixedAssetsNo']),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.only(left: 10, right: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "机号",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      _text['equipmentNo'] == null
                                          ? SizedBox()
                                          : Text(_text['equipmentNo'])
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.only(left: 10, right: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "所属部门",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      _text['department'] == null
                                          ? SizedBox()
                                          : Text(_text['department'])
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: FlatButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => InstructionsPage(barcode: _fixedAssetsNo),
                                    ));
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "说明书/保养手册",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black38,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(16.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: jobWayId.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: RadioListTile(
                                        activeColor: Colors.pink,
                                        value: index + 1,
                                        groupValue: groupValue,
                                        onChanged: (int value) {
                                          setState(() {
                                            groupValue = value;
                                          });
                                        },
                                        title: _text['jobWayList'][index]['name'] == null
                                            ? SizedBox()
                                            : Text(_text['jobWayList'][index]['name']),
                                      ),
                                    ),
                                  ],
                                );
                              },
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              height: 50,
              width: width,
              child: FlatButton(
                color: Colors.pink,
                child: Text("下一步"),
                onPressed: () {
                  if (groupValue == 0) {
                    Fluttertoast.showToast(msg: '请选择作业方式', gravity: ToastGravity.BOTTOM);
                  } else if (groupValue == 1) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DailyMaintainPage(
                            equipmentName: _text['equipmentName'],
                            equipmentModel: _text['equipmentModel'],
                            fixedAssetsNo: _text['fixedAssetsNo'],
                            equipmentNo: _text['equipmentNo'],
                            department: _text['department'],
                          ),
                        ));
                  } else if (groupValue == 2) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MonthlyMaintainPage(
                            equipmentName: _text['equipmentName'],
                            equipmentModel: _text['equipmentModel'],
                            fixedAssetsNo: _text['fixedAssetsNo'],
                            equipmentNo: _text['equipmentNo'],
                            department: _text['department'],
                          ),
                        ));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WeeklyMaintainPage(
                            equipmentName: _text['equipmentName'],
                            equipmentModel: _text['equipmentModel'],
                            fixedAssetsNo: _text['fixedAssetsNo'],
                            equipmentNo: _text['equipmentNo'],
                            department: _text['department'],
                          ),
                        ));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
