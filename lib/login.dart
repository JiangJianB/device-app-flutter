import 'package:dianjian/utils/screen_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title,}) : super(key: key);

  final String title;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  var name;
  var jobNo;
  var postName;
  var postNo;
  var userid;
  var _token;
  int radioValue = 0;
  String text2='http://';

  final _userName = TextEditingController(); //用户名
  final _userPwd = TextEditingController(); //密码
  var myController = TextEditingController(); //配置地址
  final mysController = TextEditingController(); //用户名
  GlobalKey _globalKey = new GlobalKey<FormState>(); //用于检查输入框是否为空

  Future getHttp() async {
    Map<String, String> map = {};
    map['jobNo'] = _userName.text;
    map['password'] = _userPwd.text;
    print(map);
    try {
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token'] = _token;
      dio.options.method = 'POST';
      Response response = await dio.post("http://192.168.2.150:20001/pub/api/login?jobNo=" + map['jobNo'] + "&password=" + map['password'], data: map);
//      response = await Dio().post("https://api.distributor.yat.com/admin/auth/login",data: map);
      print(response);
      Map data = response.data;
      if (data['code'] == 200) {
        _saveLoginMsg(data['data']);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => App()), (route) => route == null);
        print('登录成功');
      } else {
        print('登录失败');
      }
      return response.data;
    } catch (e) {
      return print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getLoginMsg();
    myController.text = 'http://';
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  // 保存本地账号密码
  void _saveLoginMsg(Map map) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("jobNo", _userName.text);
    await preferences.setString("pwd", _userPwd.text);

    await preferences.setString("_userName", map['jobNo']);
    await preferences.setString("_userPwd", map['password']);
    await preferences.setString('name', map['name']);
    await preferences.setString('postName', map['post']['postName']);
    await preferences.setString("_userToken", map['token']);
    await preferences.setString('postNo', map['postNo']);
    await preferences.setString('userid', map['id'].toString());
    map['jobNo'] = _userName.text;
    map['password'] = _userPwd.text;

    print(map['token']);
    print(map['name']);
    print(map['post']['postName']);
    print(map['postNo']);
    print(map['id']);
//    print(map['jobNo']);
//    data['token'] =_userToken.toString();
//    print(map['token']);
  }

  // 读取账号密码，并将值直接赋给账号框和密码框
  void _getLoginMsg() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _userName.text = preferences.get("jobNo");
    _userPwd.text = preferences.get("pwd");
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    ScreenAdaptr.init(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("登录"),
          backgroundColor: Colors.pink,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                          child: Container(
                            height: 290,//Dialog的高
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                              Text("配置接口地址", style: TextStyle(fontSize: ScreenUtil().setSp(35)),),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: RadioListTile(
                                        activeColor: Colors.pink,
                                        value: 0,
                                        groupValue: radioValue,
                                        onChanged: (int value) {
                                          setState(() {
                                            radioValue = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(child: Text('http://',style: TextStyle(fontSize: ScreenUtil().setSp(35)),)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: new EdgeInsets.only(left: 20.0, right: 20.0),
                                    child: TextField(
                                      controller: myController,
                                      cursorColor: Colors.pink,
                                      style: TextStyle(fontSize:20),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(left: 10.0, right: 20.0),
                                        hintText: "请输入服务器地址",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: TextField(
                                      controller: mysController,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(left: 30.0, right: 20.0),
                                        border: InputBorder.none,
                                        enabled: false,
                                        hintText:'http://www.baidu.com',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 290,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      color: Colors.pink,
                                      child: Text(
                                        "确认",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        mysController.text=myController.text;
                                        myController.clear();
                                        if(mysController.text=='http://192.168.2.150:20001' || mysController.text=='http://pds.yat.com:20001'){
                                          Navigator.pop(context);
                                        }else{
                                          Fluttertoast.showToast(msg: '接口地址错误，请重新输入');
                                          setState(() {
                                            myController.text=text2;
                                          });
                                        }
                                      }
                                    ),
                                  )
                                ],
                              ),
                            ]),
                      ));
                    });
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: Form(
                key: _globalKey,
                autovalidate: true, //自动校验
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: TextDirection.ltr,
                      children: <Widget>[
                        Container(
                          //装图片的盒子
                          child: Image.asset(
                            "images/ic_login_logo.png",
                            height: 100,
                            width: 50,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      cursorColor: Colors.pink,
                      controller: _userName,
                      decoration: InputDecoration(
                          hintText: "输入你的账号",
                          filled: true,
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.pink,
                          )),
                      validator: (v) {
                        return v.trim().length > 0 ? null : "用户名不能为空";
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      cursorColor: Colors.pink,
                      controller: _userPwd,
                      decoration: InputDecoration(
                          hintText: "输入你的密码",
                          filled: true,
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.pink,
                          )),
                      validator: (v) {
                        return v.trim().length > 5 ? null : "密码不低于6位";
                      },
                      obscureText: true,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    SizedBox(
                      width: width,
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: () {
                          if ((_globalKey.currentState as FormState)
                              .validate()) {
                            getHttp();
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text(
                          "登录",
                          style: TextStyle(color: Colors.white), //字体白色
                        ),
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
