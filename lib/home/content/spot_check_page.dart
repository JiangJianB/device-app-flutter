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
  SpotcheckPage({this.fixedAssetsNo,this.name,this.instructions,this.tallyType,this.names});
  @override
  _SpotcheckPageState createState() => _SpotcheckPageState();
}


class _SpotcheckPageState extends State<SpotcheckPage> {
  List pickerChildren = [
    "符合",
    "不符合",
  ];
  int selectedValue = 0;
  int unselectedValue = 1;
  String selectedGender = "符合";
  String unselectedGender = "不符合";
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


  List _list=['清扫','更换','检查','其他'];
  
  @override
  void initState() {
    super.initState();
    if(widget.fixedAssetsNo != null) {
      setState(() {
        _fixedAssetsNo = widget.fixedAssetsNo.toString();
        name=widget.name.toString();
        instructions=widget.instructions.toString();
        tallyType=widget.tallyType.toString();
        _names=widget.names.toString();
        debugPrint(_names);
      });
      _getData(_fixedAssetsNo,tallyType);
    }
  }

  _getData(String fixedAssetsNo,String tallyType) async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    _token=sharedPreferences.getString('_userToken');
    _name = sharedPreferences.getString('_userName');
    name=sharedPreferences.getString('name');
    jobNo=sharedPreferences.getString('jobNo');
    postName=sharedPreferences.getString('postName');
    postNo=sharedPreferences.getString('postNo');

    try{
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token']=_token;
      Response response=await dio.get('http://192.168.2.150:20001/api/tally/judge-over-Time?jobNo=$_name&postNo=$postNo&fixedAssetsNo=$fixedAssetsNo&jobWayId=4&tallyType=$tallyType');
      Map data=response.data;
      print(data);
      print(data['data']);
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

  Widget _buildGenderPicker() {
    return CupertinoPicker(
      itemExtent: 30,
      onSelectedItemChanged: (value) {
        print("选择：${pickerChildren[value]}");
        print("$value");
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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:AppBar (
        title: Text("设备点检",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body:  Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Container(
                width: width,
                height: 50,
                child: Container(
                  padding: const EdgeInsets.only(left: 15),
                  color: Colors.amber,
                  child: Row(
                    children: <Widget>[
                      Container(

                        child: Expanded(
                          child:  name == null ? SizedBox() : Text(name),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: jobNo == null ? SizedBox() :  Text("工号："+jobNo),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child:  postName == null ? SizedBox() : Text("岗位："+postName),
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

            Container(
              height: MediaQuery.of(context).size.height-180,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount:widget.names.length,
                  itemBuilder: (BuildContext context,int index){
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
                                  height:30,
                                  child: Text(_list[widget.names[index]['category']-1]),
                                ),
                                Container(
                                  height: 70,
                                  color: Colors.white,
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(height: 10,),
                                              Container(
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: widget.names[index]['tallyCategoryDetailDTOList'].length,
                                                    itemBuilder: (BuildContext context,int i){
                                                      return Text('${widget.names[index]['tallyCategoryDetailDTOList'][i]['instructions']}');
                                                    }
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
              width: width,
              child: FlatButton(
                color: Colors.amber,
                child: Text("完成点检"),
                onPressed: (){
                  showDialog(context: context,builder: (BuildContext context){
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
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left:30,right: 30),
                                  hintText:("请输入该设备的生产线号"),
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
                                    child: FlatButton(child: Text("取消"),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },),
                                  ),
                                  Expanded(
                                    child: FlatButton(child: Text("提交",style: TextStyle(color: Colors.amber),),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context)=>Continuespotcheck(),
                                        ));
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
