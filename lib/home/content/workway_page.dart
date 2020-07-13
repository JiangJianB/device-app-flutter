import 'package:dianjian/Instructions/Instructions.dart';
import 'package:dianjian/app.dart';
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
  WorkwayPage({this.barcode,this.postNo});
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
  int _radioGroup= 0;
  String _fixedAssetsNo;
  var jobwayid;

  @override
  void initState() {
    super.initState();
    if(widget.barcode != null) {
      setState(() {
        _fixedAssetsNo = widget.barcode.toString();
        print(_fixedAssetsNo);
      });
      _getData(_fixedAssetsNo);
    }
  }

  _getData(String fixedAssetsNo) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    name=sharedPreferences.getString('name');
    jobNo=sharedPreferences.getString('jobNo');
    postName=sharedPreferences.getString('postName');
    _token=sharedPreferences.getString('_userToken');
    postNo=sharedPreferences.getString('postNo');


    try{
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token']=_token;
      Response response=await dio.get('http://192.168.2.150:20001/api/tally/eqJobWay?fixedAssetsNo=$fixedAssetsNo&postNo=$postNo');
      Map data=response.data;
      print(data);
      if(data['code']==200){
        setState(() {
          _text=data['data'];
        });
        jobWayId=_text['jobWayList'][{'id'} ]as int;
        print(jobWayId);
      }else{
        Fluttertoast.showToast(msg: '设备已停用',gravity: ToastGravity.BOTTOM,);
        return App();
      }

    }catch(e){
      return print(e);
    }
  }

  void _handleRadioValueChanged(int value) {
    setState(() {
      _radioGroup = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_text==null)return Container();
    ScreenAdaptr.init(context);
    final width= MediaQuery.of(context).size.width;
    return Scaffold(
        appBar:AppBar (
          title: Text("选择作业方式",style: TextStyle(color: Colors.black),),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
          ),
        ),
        body:  Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                    width: width,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.amber,
                      child: Row(
                        children: <Widget>[
                          Container(

                            child: Expanded(
                              child: name == null ? SizedBox() : Text(name),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: jobNo == null ? SizedBox() : Text("工号："+jobNo),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: postName == null ? SizedBox() : Text("岗位："+postName),
                            ),
                          ),
                          FlatButton(
                              child: Text("退出登录",style: TextStyle(color: Colors.blue),),
                              onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text("退出登录将清空当前操作，确定退出吗？"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("退出登录"),
                                            onPressed: (){
                                              Navigator.push(context,MaterialPageRoute(
                                                builder: (BuildContext context)=>LoginPage(),
                                              ));
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("取消",style: TextStyle(color: Colors.black),),
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                );
                              }
                          )
                        ],
                      ),
                    ),
                  ),

                SizedBox(
                  height: MediaQuery.of(context).size.height-190,
                  child: ListView.builder(
                    itemCount: 1,
                      itemBuilder: (BuildContext context,int index){
                    return ListTile(
                      title: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child:Column(
                              children: <Widget>[
                                SizedBox(height: 10.0,),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.only(left: 10,right: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("设备名称",style: TextStyle(color: Colors.black54),),
                                      _text['equipmentName']==null ? SizedBox() : Text(_text["equipmentName"]),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(left: 10,right: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("型号",style: TextStyle(color: Colors.black54),),
                                      _text['equipmentModel']==null ? SizedBox() : Text(_text['equipmentModel']),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.only(left: 10,right: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("固定资产编号",style: TextStyle(color: Colors.black54),),
                                      _text['fixedAssetsNo']==null ? SizedBox() : Text(_text['fixedAssetsNo']),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.only(left: 10,right: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("机号",style: TextStyle(color: Colors.black54),),
                                      _text['equipmentNo']==null ? SizedBox() : Text(_text['equipmentNo'])
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.only(left: 10,right: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("所属部门",style: TextStyle(color: Colors.black54),),
                                      _text['department']==null ? SizedBox() : Text(_text['department'])
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
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context)=>InstructionsPage(barcode:_fixedAssetsNo),

                                ));
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("说明书/保养手册",style: TextStyle(color: Colors.black54),),
                                  Icon(Icons.arrow_forward_ios,color: Colors.black38,)
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("请选择该设备将要进行的作业方式："),
                                RadioListTile(
                                  value: 0,
                                  groupValue: _radioGroup,
                                  onChanged: _handleRadioValueChanged,
                                  title: Text('日保养',style: TextStyle(fontSize: 17),),
                                  //利用_radioGroupA值与当前控件value 进行bool判断
                                  selected: _radioGroup == 0,  //是否跟随主题颜色
                                ),
                                RadioListTile(
                                  value: 1,
                                  groupValue: _radioGroup,
                                  onChanged: _handleRadioValueChanged,
                                  title: Text('周保养',style: TextStyle(fontSize: 17),),
                                  selected: _radioGroup == 1,
                                ),
                                RadioListTile(
                                  value: 2,
                                  groupValue: _radioGroup,
                                  onChanged: _handleRadioValueChanged,
                                  title: Text('月保养',style: TextStyle(fontSize: 17),),
                                  selected: _radioGroup == 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),

              ],
            ) ,
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
                color: Colors.amber,
                child: Text("下一步"),
                onPressed: (){
                 if(_radioGroup==0){
                   Navigator.push(context, MaterialPageRoute(
                     builder: (context)=>DailyMaintainPage(
                       equipmentName: _text['equipmentName'],
                       equipmentModel: _text['equipmentModel'],
                       fixedAssetsNo: _text['fixedAssetsNo'],
                       equipmentNo: _text['equipmentNo'],
                       department: _text['department'],
                     ),
                   ));
                 }else if(_radioGroup==1){
                   Navigator.push(context, MaterialPageRoute(
                     builder: (context)=>WeeklyMaintainPage(),
                   ));
                 }else{
                   Navigator.push(context, MaterialPageRoute(
                     builder: (context)=>MonthlyMaintainPage(),
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
