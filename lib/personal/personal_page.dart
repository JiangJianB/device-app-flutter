import 'package:dianjian/login.dart';
import 'package:dianjian/personal/record_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'modify_page.dart';
import 'package:dianjian/utils/screen_utils.dart';

class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  var _token;
  var _text;
  var _name;
  var name;
  var jobNo;
  var postName;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    _token=sharedPreferences.getString('_userToken');
    _name=sharedPreferences.getString("userName");
    name=sharedPreferences.getString('name');
    jobNo=sharedPreferences.getString('jobNo');
    postName=sharedPreferences.getString('postName');
    try{
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token']=_token;
      Response response=await dio.get('http://192.168.2.150:20001/api/tally/eqJobWayTallyCount?fixedAssetsNo=Y02APF219&jobWayId=51&postNo=004&jobNo=$_name&tips=1');
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
  @override
  Widget build(BuildContext context) {
    ScreenAdaptr.init(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("个人中心"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: ImageIcon(AssetImage("images/ic_login_out.png")),
                onPressed: (){
                  showDialog(
                    context: context,
                  builder: (BuildContext context){
                      return AlertDialog(

                        title: Text("是否退出当前账号"),
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
            ),
          ],
        ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Container(
                          height: 120,
                          child: Image.asset("images/ic_default_header.png", width: 70, height: 70,),
                        ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textDirection: TextDirection.ltr,
                          children: <Widget>[
                            name == null ? SizedBox() : Text(name,style: TextStyle(fontSize: ScreenAdaptr.setFontSize(25)),),
                            jobNo == null ? SizedBox() :Text("工号："+jobNo,style: TextStyle(fontSize: 14.0,color: Colors.black54),),
                            postName == null ? SizedBox() :Text("岗位："+postName,style: TextStyle(fontSize: 14.0,color: Colors.black54),),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  color:  Colors.white,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ModifyPage()
                      ));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.lock,color: Colors.black38,),
                        Text("修改密码",style: TextStyle(fontSize: ScreenAdaptr.setFontSize(27)),),
                        Icon(Icons.arrow_forward_ios,color: Colors.black38,)
                      ],
                    ),
                  ),
                ),
                Divider(),
                Container(
                  height: 60,
                  color:  Colors.white,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => RecordPage(),
                      ));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.border_color,color: Colors.black38,),
                        Text("点检记录",style: TextStyle(fontSize: ScreenAdaptr.setFontSize(27)),),
                        Icon(Icons.arrow_forward_ios,color: Colors.black38,)
                      ],
                    ),
                  ),
                ),

              ],
            ),
      ),
    );

  }
}
