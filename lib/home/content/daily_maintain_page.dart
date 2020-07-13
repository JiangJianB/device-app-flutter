import 'package:dianjian/Instructions/instructions.dart';
import 'package:dianjian/home/content/spot_check_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login.dart';
class DailyMaintainPage extends StatefulWidget {
  final equipmentName;
  final equipmentModel;
  final fixedAssetsNo;
  final equipmentNo;
  final department;
  final postNo;
  final jobWayId;


  DailyMaintainPage({this.equipmentName,this.equipmentModel,this.fixedAssetsNo,this.equipmentNo,this.department,this.postNo,this.jobWayId});
  @override
  _DailyMainPageState createState() => _DailyMainPageState();
}


class _DailyMainPageState extends State<DailyMaintainPage> {
  var _token;
  var _text;
  var _name;
  var name;
  var jobNo;
  var postName;
  var _fixedAssetsNo;
  var tallyType;
  List names=[];
  String equipmentName;
  String equipmentModel;
  String  fixedAssetsNo;
  String equipmentNo;
  String department;
  var postNo;

  @override
  void initState() {
    super.initState();
    if(widget.fixedAssetsNo != null){
      setState(() {
        _fixedAssetsNo=widget.fixedAssetsNo.toString();
        equipmentName=widget.equipmentName.toString();
        equipmentModel=widget.equipmentModel.toString();
        fixedAssetsNo=widget.fixedAssetsNo.toString();
        equipmentNo=widget.equipmentNo.toString();
        department=widget.department.toString();
        postNo=widget.postNo.toString();
      });
      _getData(_fixedAssetsNo);
    }

  }

  _getData(String fixedAssetsNo) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    _token=sharedPreferences.getString('_userToken');
    _name=sharedPreferences.getString("userName");
    name=sharedPreferences.getString('name');
    jobNo=sharedPreferences.getString('jobNo');
    postName=sharedPreferences.getString('postName');
    postNo=sharedPreferences.getString('postNo');

    try{
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token']=_token;
      Response response=await dio.get('http://192.168.2.150:20001/api/tally/eqJobWayTallyCount?fixedAssetsNo=$fixedAssetsNo&jobWayId=51&postNo=$postNo&jobNo=$_name&tips=1');
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

  DateTime now = new DateTime.now();
  @override
  Widget build(BuildContext context) {
    final width= MediaQuery.of(context).size.width;
    if(_text==null)return Container();
    return Scaffold(
        appBar:AppBar (
          title: Text("日保养",style: TextStyle(color: Colors.black),),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 Container(
                   padding: const EdgeInsets.only(left: 15),
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
                           child: jobNo == null ? SizedBox() :  Text("工号："+jobNo),
                         ),
                       ),
                       Container(
                         child: Expanded(
                           child: postName == null ? SizedBox() :  Text("岗位："+postName),
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

                SizedBox(
                  height: MediaQuery.of(context).size.height-180,
                  child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (BuildContext context,int index){
                    return ListTile(
                      title: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(left: 15,right: 20),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 10.0,),
                                      Container(
                                        height: 40,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("设备名称",style: TextStyle(color: Colors.black54),),
                                            widget.equipmentName==null ? SizedBox() : Text(widget.equipmentName)
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("型号",style: TextStyle(color: Colors.black54),),
                                            widget.equipmentModel==null ? SizedBox() : Text(widget.equipmentModel)
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("固定资产编号",style: TextStyle(color: Colors.black54),),
                                            widget.fixedAssetsNo==null ? SizedBox() : Text(widget.fixedAssetsNo)
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("机号",style: TextStyle(color: Colors.black54),),
                                            widget.equipmentNo==null ? SizedBox() : Text(widget.equipmentNo)
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("所属部门",style: TextStyle(color: Colors.black54),),
                                            widget.department==null ? SizedBox() : Text(widget.department)
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
                                        builder: (context)=>InstructionsPage(barcode: _fixedAssetsNo,),
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
                                Container(height: 15,),
                                Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 15,right: 20,top: 30,bottom: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("点检日期"),
                                                  Text(_text['tallyDate']),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: FlatButton(
                                          onPressed: () {

                                          },
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("总点检项目数",style: TextStyle(color: Colors.amber),),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(_text['tallyAllCount'].toString(),style: TextStyle(color: Colors.amber,fontSize: 20),),
                                                  SizedBox(width:10.0),
                                                  Icon(Icons.arrow_forward_ios,color: Colors.amber,),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: FlatButton(
                                          onPressed: () {

                                          },
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("当前点检项目数",style: TextStyle(color: Colors.amber),),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(_text['nowTallyCount'].toString(),style: TextStyle(color: Colors.amber,fontSize: 20),),
                                                  SizedBox(width:10.0),
                                                  Icon(Icons.arrow_forward_ios,color: Colors.amber,),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: FlatButton(
                                          onPressed: () {

                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("已点检项目数",style: TextStyle(color: Colors.amber),),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(_text['alreadyTallyCount'].toString(),style: TextStyle(color: Colors.amber,fontSize: 20),),
                                                  SizedBox(width:10.0),
                                                  Icon(Icons.arrow_forward_ios,color: Colors.amber,),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: FlatButton(
                                          onPressed: () {

                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("待点检项目数",style: TextStyle(color: Colors.amber),),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(_text['needTallyCount'].toString(),style: TextStyle(color: Colors.amber,fontSize: 20),),
                                                  SizedBox(width:10.0),
                                                  Icon(Icons.arrow_forward_ios,color: Colors.amber,),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: FlatButton(
                                          onPressed: () {

                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("异常项目数",style: TextStyle(color: Colors.amber),),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(_text['abnormalTallyCount'].toString(),style: TextStyle(color: Colors.amber,fontSize: 20),),
                                                  SizedBox(width:10.0),
                                                  Icon(Icons.arrow_forward_ios,color: Colors.amber,),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
            ),
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
                color: Colors.amber,
                child: Text("开始点检"),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>SpotcheckPage(

                      fixedAssetsNo: _fixedAssetsNo,
                      tallyType: _text['tallyType'],
                      names: _text['allTallyDTOList']

                    ),
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
