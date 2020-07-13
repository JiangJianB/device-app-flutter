
import 'dart:io';

import 'package:dianjian/danger/danger_page.dart';
import 'package:dianjian/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';


class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();

}

class _UploadPageState extends State<UploadPage> {
  dynamic _picture;
  dynamic _gallery;
  File _imgPath;
  var _token;
  var _text;
  final _title=TextEditingController();//标题
  final _describe=TextEditingController();//内容描述
  List <Widget> list;

  _upLoadImage(File image) async {
    String path = image.path;
    print(path);

    FormData formdata = FormData.fromMap({
      'file':  await MultipartFile.fromFile(path)
    });

    Options options = Options(headers: {
      'X-Distributor-Admin-Token': _token
    });

    try {
      Response response = await Dio().post('http://192.168.2.150:20001/api/hide-danger/add');
      print('res = $response');

      Map data = response.data;

      if (data['data'] == 200) {
        setState(() {
          list.add(data['data']['url']);
        });
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DangerPage()), (route) => route == null);
        Fluttertoast.showToast(msg: "图片上传成功", gravity: ToastGravity.CENTER, textColor: Colors.grey);
      } else {
        Fluttertoast.showToast(msg: '图片上传失败',gravity: ToastGravity.BOTTOM);
      }
    } on DioError catch(error) {
      if(error.response != null) {
        int errcode = error.response.statusCode;
        print(errcode);
        if(errcode == 403) {
          Fluttertoast.showToast(msg: '登陆状态过期，请重新登陆！');
          LoginPage();
        }
      }
    }
  }

  Widget buildAddButton(){
    return GestureDetector(

      onTap: (){
        _optionsDialogBox();
        if(_imgPath != null || list.length<6){
          setState(() {
            list.insert(list.length-1, buildPhoto());
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 60.0,
          height: 60.0,
          color: Colors.grey,
          child: ImageIcon(
            AssetImage("images/ic_add_pic.png"),
          ),
        ),
      ),
    );
  }
  @override
  Widget buildPhoto(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 60.0,
        height: 60.0,
        child: _ImageView(_imgPath),
      ),
    );
  }
  @override
  Widget _ImageView(imgPath) {
    if (imgPath == null) {
    } else {
      return Image.file(
        imgPath,
      );
    }
  }
 @override
  void initState(){
    super.initState();
    list = List<Widget>()..add(buildAddButton());
  }
 @override
  void openCamera() async {
    Navigator.of(context).pop();
    var picture = await ImagePicker.pickImage(source: ImageSource.camera,);
    setState(() {
      _imgPath = picture;
    });
  }
@override
  void openGallery() async {
    Navigator.of(context).pop();
    var gallery = await ImagePicker.pickImage(source: ImageSource.gallery,);
    setState(() {
      _imgPath = gallery;
    });
  }

  @override
  Widget build(BuildContext context) {

    final width= MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 90,
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text("取消"),
                    textColor: Colors.black,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  Text("隐患事件上传",style: TextStyle(fontSize: 20),),
                  FlatButton(
                    child: Text("提交"),
                    textColor: Colors.amber,
                    onPressed: (){
                      _upLoadImage(_imgPath);
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(left: 20),
              height: 20,
              child: Text("标题"),
            ),
            SizedBox(height: 10,),
            Container(
              child: TextField(
                controller: _title,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20,right: 20),
                hintText: "请输入隐患标题",
                hintStyle: TextStyle(fontSize: 14),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
      ),
            Container(
              padding: EdgeInsets.only(left: 20),
              height: 20,
              child: Text("描述"),
            ),
            SizedBox(height: 10,),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 200.0,
                    minHeight: 50.0,
                  ),
                  child: TextField(
                    controller: _describe,
                    obscureText: false,
                    inputFormatters: [LengthLimitingTextInputFormatter(200)],
                    maxLengthEnforced: true,
                    maxLines: null,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20,right: 20),
                      hintText: "请输入隐患描述",
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
            SizedBox(height: 10.0,),
            Container(
              padding: EdgeInsets.only(left: 20),
              height: 20,
              child: Text("添加照片"),
            ),

            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: width,
                  height: height/3,
                  color: Colors.white,
                  child:Wrap(
                    children: list,
                    spacing: 26.0,
                  ),
                ),
              ),
          ],
        ),
      ),
      );
  }

  Future<void> _optionsDialogBox() {
    final width= MediaQuery.of(context).size.width;
    return showModalBottomSheet(context: context,
        builder: (BuildContext context) {
          return Container(
            child: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  RaisedButton(
                    color: Colors.amber,
                    child: Center(
                      child:Text('拍照',style: TextStyle(),),
                    ),
                    onPressed: openCamera,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  RaisedButton(
                    color: Colors.amber,
                    child: Center(
                      child:Text('相册',style: TextStyle(),),
                    ),
                    onPressed: openGallery,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  RaisedButton(
                    color: Colors.amber,
                    child: Center(
                      child:Text('取消',textAlign:TextAlign.center),
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    }
                  ),
                ],
              ),
            ),
          );
        });
  }
}

