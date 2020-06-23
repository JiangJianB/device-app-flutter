import 'package:dianjian/home/content/daily_maintain_page.dart';
import 'package:dianjian/home/content/monthly_maintain_page.dart';
import 'package:dianjian/home/content/weekly_maintain_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login.dart';
import 'package:dianjian/utils/screen_utils.dart';

class WorkwayPage extends StatefulWidget {
  String list;
  WorkwayPage({Key key,this.list}) : super(key: key);
  @override
  _WorkwayPageState createState() => _WorkwayPageState();
}

class _WorkwayPageState extends State<WorkwayPage> {
  var _token;
  var _text;
  int _radioGroupA = 0;

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
      Response response=await dio.get('http://192.168.2.150:20001/api/tally/eqJobWay?fixedAssetsNo=fixedAssetsNo&postNo=004');
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
  }


  void _handleRadioValueChanged(int value) {
    setState(() {
      _radioGroupA = value;
    });
  }
  @override
  Widget build(BuildContext context) {

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
                              child: Text(''),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Text("工号：J19120267",),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Text("岗位：作业者"),
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
                      itemBuilder: (
                          BuildContext context,int index){
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
                                      Text(_text["equipmentName"]),
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
                                      Text(_text['equipmentModel']),
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
                                      Text(_text['fixedAssetsNo']),
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
                                      Text(_text['equipmentNo'])
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
                                      Text(_text['department'])
                                    ],
                                  ),
                                ),

                              ],
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
                                  groupValue: _radioGroupA,
                                  onChanged: _handleRadioValueChanged,
                                  title: Text('日保养',style: TextStyle(fontSize: 17),),
                                  //利用_radioGroupA值与当前控件value 进行bool判断
                                  selected: _radioGroupA == 0,  //是否跟随主题颜色
                                ),
                                RadioListTile(
                                  value: 1,
                                  groupValue: _radioGroupA,
                                  onChanged: _handleRadioValueChanged,
                                  title: Text('周保养',style: TextStyle(fontSize: 17),),
                                  selected: _radioGroupA == 1,
                                ),
                                RadioListTile(
                                  value: 2,
                                  groupValue: _radioGroupA,
                                  onChanged: _handleRadioValueChanged,
                                  title: Text('月保养',style: TextStyle(fontSize: 17),),
                                  selected: _radioGroupA == 2,
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
                 if(_radioGroupA==0){
                   Navigator.push(context, MaterialPageRoute(
                     builder: (context)=>DailyMaintainPage(),
                   ));
                 }else if(_radioGroupA==1){
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
