
import 'package:dianjian/home/content/continue_spot_check_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login.dart';

class SpotcheckPage extends StatefulWidget {
  final fixedAssetsNo;
  final name;
  final names;
  final instructions;
  final tallyType;
  final needTallyCount;
  final code;
  final alldata;
  final tallyTotalDetailDTO;
  final tallyCategoryDetailDTOList;
  final benchmarkDTOList;
  final allTallyDTOList;

  SpotcheckPage(
      {this.fixedAssetsNo,
      this.name,
      this.instructions,
      this.tallyCategoryDetailDTOList,
      this.tallyType,
      this.allTallyDTOList,
      this.names,
      this.needTallyCount,
      this.code,
      this.tallyTotalDetailDTO,
      this.benchmarkDTOList,
      this.alldata});

  @override
  _SpotcheckPageState createState() => _SpotcheckPageState();
}

class _SpotcheckPageState extends State<SpotcheckPage> {
  List pickerChildren = [
    "符合",
    "不符",
  ];
  int selectedValue = 0;
  String selectedGender = "请选择";
  TextEditingController _textEditingController = new TextEditingController();
  TextEditingController _textEditingControllers = new TextEditingController();
  ScrollController _controller;

  var _token;
  var _name;
  var _names;
  var _text;
  var name;
  var code;
  var tallyRecordId;
  var jobNo;
  var postName;
  var postNo;
  var jobwayid=4;
  var tallyType;
  var _needTallyCount;
  String _fixedAssetsNo;
  String names;
  String instructions;
  List benchmarkDTOList;
  List allTallyDTOList;
  var tallyTotalDetailDTO;
  var alldata;
  List tallyCategoryDetailDTOList;

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
        _needTallyCount = widget.needTallyCount.toString();
        code = widget.code.toString();
        tallyTotalDetailDTO = widget.tallyTotalDetailDTO.toString();
        alldata = widget.alldata.toString();
        allTallyDTOList = widget.allTallyDTOList;
        benchmarkDTOList = widget.benchmarkDTOList;
        tallyCategoryDetailDTOList = widget.tallyCategoryDetailDTOList;

        debugPrint(_names);
        print(code);
        print(_needTallyCount);
        print(alldata);
        print(tallyType);
        print(benchmarkDTOList);
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

  _postData(int index) async {
    var _token;
//    List<Map<String,Object> > list=[
////    {
////      'id':benchmarkDTOList[index]['id'],
////      'delFlag':benchmarkDTOList[index]['delFlag'],
////      'createdBy':benchmarkDTOList[index]['createdBy'],
////      'createdAt':benchmarkDTOList[index]['createdAt'],
////      'updatedBy':benchmarkDTOList[index]['updatedBy'],
////      'updatedAt':benchmarkDTOList[index]['updatedAt'],
////    'tallyId':benchmarkDTOList[index]['tallyId'],
////    'tallyDetailId':benchmarkDTOList[index]['tallyDetailId'],
////    'category':benchmarkDTOList[index]['category'],
////      'benchmarkName':benchmarkDTOList[index]['benchmarkName'],
////      'ceiling':benchmarkDTOList[index]['ceiling'],
////      'floor':benchmarkDTOList[index]['floor'],
////    },
////    ];
////    List<Map<String,Object> > list1=[
////      {
////        'id':tallyCategoryDetailDTOList[index]['id'],
////        'batchId':tallyCategoryDetailDTOList[index]['batchId'],
////        'order':tallyCategoryDetailDTOList[index]['order'],
////        'name':tallyCategoryDetailDTOList[index]['name'],
////        'isModify':tallyCategoryDetailDTOList[index]['isModify'],
////        'category':tallyCategoryDetailDTOList[index]['category'],
////        'checkType':tallyCategoryDetailDTOList[index]['checkType'],
////        'instructions':tallyCategoryDetailDTOList[index]['instructions'],
////        'tool':tallyCategoryDetailDTOList[index]['tool'],
////        'method':tallyCategoryDetailDTOList[index]['method'],
////        'disposition':tallyCategoryDetailDTOList[index]['disposition'],
////        'cycleType':tallyCategoryDetailDTOList[index]['cycleType'],
////        'bear':tallyCategoryDetailDTOList[index]['bear'],
////        'tallyValue':tallyCategoryDetailDTOList[index]['tallyValue'],
////        'setPointValue':tallyCategoryDetailDTOList[index]['setPointValue'],
////        'tallyBenchmarkId':tallyCategoryDetailDTOList[index]['tallyBenchmarkId'],
////        'benchmarkUnit':tallyCategoryDetailDTOList[index]['benchmarkUnit'],
////        'isAbnormal':tallyCategoryDetailDTOList[index]['isAbnormal'],
////        'benchmarkDTOList':list,
////      }
////    ];
////    List<Map<String,Object> > list2=[
////      {
////        'category':tallyCategoryDetailDTOList[index]['category'],
////        'tallyCategoryDetailDTOList':list1,
////      }
////    ];
    Map<String,dynamic> map = {
      'tallyCategoryDTOList': [], //点检详细总
      'tallyType': tallyType, //点检数据类型 1.通用 2.固定资产编号
      'produceLine': _textEditingController.text, //生产线号
//      'tallyRecordId': tallyCategoryDetailDTOList[index]['id'],
//      'tallyRecordId':'',//点检记录ID
      'jobNo': jobNo, //员工号
//      'checkCode':'',//点检上传code
      'fixedAssetsNo': _fixedAssetsNo, //设备资产编号
      'jobWayId': jobwayid, //作业方式ID
      'needTallyCount': '1', //应该点检项目数
    };
//    String maps = jsonEncode(map);
//    String maps = jsonEncode(map);
////    map['code'] = alldata['code'];
////    map['alldata']=alldata.toString();
////    map['tallyTotalDetailDTO']=tallyTotalDetailDTO;//点检详细总
//    map['tallyTotalDetailDTO']['tallyType']=tallyType;//点检数据类型 1.通用 2.固定资产编号
//    map['tallyTotalDetailDTO']['produceLine']=_textEditingController.text;//生产线号
//    map['tallyTotalDetailDTO']['tallyRecordId']
//    map['tallyTotalDetailDTO']['jobNo']=jobNo;//员工号
//    map['code']=code;//点检上传code
//    map['tallyTotalDetailDTO']['fixedAssetsNo']=_fixedAssetsNo;//设备资产编号
//    map['tallyTotalDetailDTO']['jobWayId']=4;
//    map['tallyTotalDetailDTO']['needTallyCount']=_needTallyCount;//应该点检项目数
//    map['tallyTotalDetailDTO']=_names;
//
    print(map);
    print(tallyType);
    print(_textEditingController.text);
    print(tallyCategoryDetailDTOList[index]['id']);
    print(jobNo);
    print(jobwayid);
//    print(code);
    print(_fixedAssetsNo);
    print(_needTallyCount);
//    print(alldata);

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
      dio.options.method = 'POST';
      dio.options.contentType = 'multipart/form-data';
      Response response = await dio.post('http://192.168.2.150:20001/api/tally/submitEqTally', data: map);
      Map data = response.data;
      print(data);

      if (data['code'] == 200) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Continuespotcheck(),
            ));
      }
    } catch (e) {
      return print(e);
    }
  }


  Widget _buildGenderPicker() {
    return CupertinoPicker(
      itemExtent: 30,
      onSelectedItemChanged: (value) {
        setState(() {
          selectedValue = value;
        });
      },
      children: pickerChildren.map((data) {
        return Text(data);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "设备点检",
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
            Container(
              height: MediaQuery.of(context).size.height - 180,
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
                                GestureDetector(
                                  child: Container(
                                    child: ListView.builder(
                                        controller: _controller,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: widget.names[index]['tallyCategoryDetailDTOList'].length,
                                        itemBuilder: (BuildContext context, int i) {
                                          return Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: ListTile(
                                                  title: Text('${widget.names[index]['tallyCategoryDetailDTOList'][i]['name']}'),
                                                  subtitle: Text('基准：' + '${widget.names[index]['tallyCategoryDetailDTOList'][i]['instructions']}'),
                                                ),
                                              ),
                                              widget.names[index]['tallyCategoryDetailDTOList'][i]['checkType']==1
                                             ? Expanded(
                                                flex: 1,
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
                                                          controller: _textEditingControllers..text='$selectedGender',
                                                          enabled: false, //禁止输入
                                                          decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                          ),
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Colors.black38,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                             : Expanded(
                                                flex: 1,
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
                                                          style: TextStyle(color: Colors.pink),
                                                          cursorColor: Colors.pink,
                                                          controller: _textEditingControllers..text='$selectedGender',
                                                          decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        }),
                                  ),
                                  onTap: () {
                                    showBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: 250,
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    FlatButton(
                                                      child: Text('取消'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text('确定'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        setState( () {
                                                          this.selectedGender=pickerChildren[selectedValue];
                                                        });
                                                      },
                                                    )
                                                  ],
                                                ),
                                                Expanded(
                                                  child: DefaultTextStyle(style: TextStyle(color: Colors.blue,),
                                                    child: _buildGenderPicker(),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                ),
                                Divider(color: Colors.pink,),
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
              width: width,
              child: FlatButton(
                color: Colors.pink,
                child: Text("完成点检"),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 20,),
                                Container(
                                  margin: EdgeInsets.all(30),
                                  child: TextField(
                                    controller: _textEditingController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 30, right: 30),
                                      hintText: ("请输入该设备的生产线号"),
                                      filled: true,
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: FlatButton(
                                          child: Text("取消"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: FlatButton(
                                          child: Text(
                                            "提交",
                                            style: TextStyle(color: Colors.pink),
                                          ),
                                          onPressed: () {
                                            _postData(0);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}


