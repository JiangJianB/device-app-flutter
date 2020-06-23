import 'package:dianjian/home/content/continue_spot_check_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login.dart';

const double kPickerHeight = 216.0;
const double kItemHeight = 30.0;
const Color kBtnColor = Color(0xFF323232);//50
const Color kTitleColor = Color(0xFF787878);//120
const double kTextFontSize = 17.0;

typedef StringClickCallback = void Function(int selectIndex,Object selectStr);


class SpotcheckPage extends StatefulWidget {
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
  var _text;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    _token=sharedPreferences.getString('_userToken');
    _name = sharedPreferences.getString('_userName');
    try{
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token']=_token;
      Response response=await dio.get('http://192.168.2.150:20001/api/tally/judge-over-Time?jobNo=$_name&postNo=004&fixedAssetsNo=Y02APF219&jobWayId=4&tallyType=1');
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
                          child: Text("蒋建斌"),
                        ),
                      ),
                      Container(
                        child: Expanded(
                          child: Text("工号：J19120267"),
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
              height: MediaQuery.of(context).size.height-180,
              child: ListView.builder(
                  itemCount:1,
                  itemBuilder: (BuildContext context,int index){
                    return ListTile(
                      title: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height:30,
                                  child: Text("清扫"),
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
                                              Text("机器周围无灰尘"),
                                              SizedBox(height: 10,),
                                              Text("基准：无灰尘无杂物",style: TextStyle(color: Colors.black38),)
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text("$selectedGender"),
                                              IconButton(
                                                icon: Icon(Icons.arrow_forward_ios),
                                                onPressed: (){
                                                  showModalBottomSheet(context: context, builder: (BuildContext contest){
                                                    return Container(
                                                      height: height/3,
                                                      width: width,
                                                      child:  Column(
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              FlatButton(
                                                                color: Colors.white,
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text("取消"),
                                                              ),
                                                              FlatButton(
                                                                color: Colors.white,
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                  setState(() {
                                                                    selectedGender = pickerChildren[selectedValue];
                                                                  });
                                                                },
                                                                child: Text("确认"),
                                                              ),
                                                            ],
                                                          ),
                                                          Expanded(
                                                            child: DefaultTextStyle(
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 22,
                                                              ),
                                                              child: _buildGenderPicker(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top:15),
                                  height: 35,
                                  child: Text("检查"),
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
                                              Text("开关按钮"),
                                              SizedBox(height: 10,),
                                              Text("基准：无松动",style: TextStyle(color: Colors.black38),)
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text('$selectedGender'),
                                              IconButton(
                                                icon: Icon(Icons.arrow_forward_ios),
                                                onPressed: (){
                                                  showModalBottomSheet(context: context, builder: (BuildContext contest){
                                                    return Container(
                                                      height: height/3,
                                                      width: width,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: <Widget>[
                                                                FlatButton(
                                                                  color: Colors.white,
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Text("取消"),
                                                                ),
                                                                FlatButton(
                                                                  color: Colors.white,
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                    setState(() {
                                                                      selectedGender = pickerChildren[selectedValue];
                                                                    });
                                                                  },
                                                                  child: Text("确认"),
                                                                ),
                                                              ],
                                                            ),
                                                            Expanded(
                                                              child: DefaultTextStyle(
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 22,
                                                                ),
                                                                child: _buildGenderPicker(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    );
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(),
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
                                              Text("操作面板"),
                                              SizedBox(height: 10,),
                                              Text("基准：无污渍",style: TextStyle(color: Colors.black38),)
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text("$selectedGender"),
                                              IconButton(
                                                icon: Icon(Icons.arrow_forward_ios),
                                                onPressed: (){
                                                  showModalBottomSheet(context: context, builder: (BuildContext contest){
                                                    return Container(
                                                      height: height/3,
                                                      width: width,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: <Widget>[
                                                                FlatButton(
                                                                  color: Colors.white,
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Text("取消"),
                                                                ),
                                                                FlatButton(
                                                                  color: Colors.white,
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                    setState(() {
                                                                      selectedGender = pickerChildren[selectedValue];
                                                                    });
                                                                  },
                                                                  child: Text("确认"),
                                                                ),
                                                              ],
                                                            ),
                                                            Expanded(
                                                              child: DefaultTextStyle(
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 22,
                                                                ),
                                                                child: _buildGenderPicker(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    );
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(),
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
                                              Text("各线路、螺丝"),
                                              SizedBox(height: 10,),
                                              Text("基准：无漏铜",style: TextStyle(color: Colors.black38),)
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text("$selectedGender"),
                                              IconButton(
                                                icon: Icon(Icons.arrow_forward_ios),
                                                onPressed: (){
                                                  showModalBottomSheet(context: context, builder: (BuildContext contest){
                                                    return Container(
                                                      height: height/3,
                                                      width: width,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: <Widget>[
                                                                FlatButton(
                                                                  color: Colors.white,
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Text("取消"),
                                                                ),
                                                                FlatButton(
                                                                  color: Colors.white,
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                    setState(() {
                                                                      selectedGender = pickerChildren[selectedValue];
                                                                    });
                                                                  },
                                                                  child: Text("确认"),
                                                                ),
                                                              ],
                                                            ),
                                                            Expanded(
                                                              child: DefaultTextStyle(
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 22,
                                                                ),
                                                                child: _buildGenderPicker(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    );
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(),
                                Container(
                                  height: 70,
                                  color: Colors.white,
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text("各部件、螺丝"),
                                              SizedBox(height: 10,),
                                              Text("基准：无松动",style: TextStyle(color: Colors.black38),)
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text("$selectedGender"),
                                              IconButton(
                                                icon: Icon(Icons.arrow_forward_ios),
                                                onPressed: (){
                                                  showModalBottomSheet(context: context, builder: (BuildContext contest){
                                                    return Container(
                                                      height: height/3,
                                                      width: width,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: <Widget>[
                                                                FlatButton(
                                                                  color: Colors.white,
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Text("取消"),
                                                                ),
                                                                FlatButton(
                                                                  color: Colors.white,
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                    setState(() {
                                                                      selectedGender = pickerChildren[selectedValue];
                                                                    });
                                                                  },
                                                                  child: Text("确认"),
                                                                ),
                                                              ],
                                                            ),
                                                            Expanded(
                                                              child: DefaultTextStyle(
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 22,
                                                                ),
                                                                child: _buildGenderPicker(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    );
                                                  });
                                                },
                                              )
                                            ],
                                          ),
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
