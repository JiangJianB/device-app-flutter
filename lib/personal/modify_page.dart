import 'package:dianjian/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModifyPage extends StatefulWidget {

  @override
  _ModifyPageState createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  TextEditingController _oddpwd = new TextEditingController();
  TextEditingController _newpwd = new TextEditingController();
  TextEditingController _newspwd = new TextEditingController();
  GlobalKey _formKey= new GlobalKey<FormState>();


  Future _getHttp() async {
    Map<String,String> map = {};
    map['password'] = _oddpwd.text;
    print(map);
    try {
      SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
      Response response;
      response = await Dio().post(
          "http://192.168.2.150:20001/pub/api/user/reset-password",data: map);
      Map data = response.data;
//      data['data']=_userToken.text;
      if(data['code'] == 200) {
        print('数据已连接');
      } else {
        print('连接失败');
      }
      return response.data;
    }catch(e){
      return print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getHttp();
  }

  void _modify(){
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          if (_newpwd.text  == _oddpwd.text || _newspwd.text==_newspwd.text ) {
            return AlertDialog(
                content:Text('请联系管理员修改密码')
            );
          } else if(_oddpwd.text!=_newpwd.text || _oddpwd.text==null){
            return AlertDialog(
              content: Text("原始密码错误，请联系管理员"),
            );
          }return AlertDialog(
            content: Text("两次密码输入不一致"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final width= MediaQuery.of(context).size.width;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text("修改密码",style: TextStyle(color: Colors.black),),
        ),
        body: SingleChildScrollView(
          child:Container(
            padding: EdgeInsets.all(20),
            child:Form(
                key: _formKey,
                autovalidate: true,
                child: Column(
                    children: <Widget>[
                      SizedBox(height: 30,),
                      TextFormField(
                        autofocus: true,
                        controller: _oddpwd,
                        decoration: InputDecoration(
                          hintText: "请输入原密码",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10,right: 10),
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _newpwd,
                        decoration: InputDecoration(
                          hintText: "请输入新密码",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10,right: 10),
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _newspwd,
                        decoration: InputDecoration(
                          hintText: "请再次出入新密码",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10,right: 10),
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 20,),
                      SizedBox(
                        height: 40,
                        width: width,
                        child: RaisedButton(
                          child: Text("完成",style: TextStyle(color: Colors.white),),
                          color: Colors.amber,
                          onPressed: (){
                            if ((_formKey.currentState as FormState).validate()) {
                              _modify();
                            }
                          },
                        ),
                      ),
                    ]
                )
            ),
          ),
        ),
      ),
    );
  }
}
