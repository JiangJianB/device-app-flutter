import 'dart:convert';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:dianjian/app.dart';
import 'package:dianjian/danger/danger_page.dart';
import 'package:dianjian/home/home_page.dart';
import 'package:dianjian/main.dart';
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
  String _imageUrl;
  var _token;
  var _userid;
  final _title = TextEditingController(); //标题
  final _describe = TextEditingController(); //内容描述
  List list = [];


  _postdata() async {
    print(_title.text);
    print(_describe.text);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _token = sharedPreferences.getString('_userToken');
    _userid = sharedPreferences.getString('userid');
    print(_userid);

    Map <String,dynamic> map={
      'title':_title.text,
      'describe':_describe.text,
      'enclosureNum':0,
      'reportUserId':_userid,
      'enclosureUrl':[],
    };

    print(map);



    try {
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token'] = _token;
      Response response = await dio.post('http://192.168.2.150:20001/api/hide-danger/add', data: map);
      Map data = response.data;
      print(data);

      if (response.statusCode == 200) {
        print(map);
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "隐患上传成功",
            gravity: ToastGravity.CENTER,
            textColor: Colors.grey);
      } else {
        Fluttertoast.showToast(msg: '隐患上传失败', gravity: ToastGravity.BOTTOM);
      }
    } on DioError catch (error) {
      print(error);
      Fluttertoast.showToast(msg: '网络未连接', gravity: ToastGravity.BOTTOM);
    }
  }

//  _upLoadImage(File image) async {
//    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    _token = sharedPreferences.getString('_userToken');
//    print(_token);
//
//    String path = image.path;
//    print(path);
//    FormData formdata =
//        FormData.fromMap({'file': await MultipartFile.fromFile(path)});
//
//    try {
//      Dio dio = Dio();
//      dio.options.headers['X-Auth-Token'] = _token;
//      dio.options.method = 'POST';
//      dio.options.contentType = 'multipart/form-data';
////      Options options = Options(headers: {
////        'X-Distributor-Admin-Token': _token
////      });
//
//      Response response =
//          await dio.post('http://192.168.2.150:20001/files/', data: formdata);
////      Response response = await dio.post('https://api.distributor.yat.com/admin/storage/create',data: formdata, options: options);
//      print(response);
//      Map data = response.data;
//      if (response.statusCode == 200) {
//        print(image);
//        print('上传成功');
//        print(response.data);
//        return response.data;
//      } else {
//        print('图片上传失败');
//      }
//    } on DioError catch (error) {
//      print(error);
//    }
//  }

  Widget buildAddButton() {
    return GestureDetector(
      onTap: () {
//        _optionsDialogBox();
        if (_imageUrl == null) {
          setState(() {});
        } else {
          setState(() {
            list.insert(list.length - 1, buildPhoto());
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

  Widget buildPhoto() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 60.0,
        height: 60.0,
        child: _ImageView(_imageUrl),
      ),
    );
  }

  Widget _ImageView(imgPath) {
    if (_imageUrl == null) {
    } else {
      return Image.network(
        imgPath,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    list = List<Widget>()..add(buildAddButton());
  }

//  @override
//  void openCamera() async {
//    Navigator.of(context).pop();
//    final picture = await ImagePicker()
//        .getImage(source: ImageSource.camera, imageQuality: 50);
//    File _image = File(picture.path);
//    _upLoadImage(_image);
//  }
//
//  @override
//  void openGallery() async {
//    Navigator.of(context).pop();
//    final gallery = await ImagePicker()
//        .getImage(source: ImageSource.gallery, imageQuality: 50);
//    File _image = File(gallery.path);
//    _upLoadImage(_image);
//  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "隐患事件上传",
                    style: TextStyle(fontSize: 20),
                  ),
                  FlatButton(
                    child: Text("提交"),
                    textColor: Colors.pink,
                    onPressed: () {
                      _postdata();
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
              child: TextFormField(
                controller: _title,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20, right: 20),
                  hintText: "请输入隐患标题",
                  hintStyle: TextStyle(fontSize: 14),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '100',
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
              child: TextFormField(
                controller: _describe,
                obscureText: false,
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
                maxLengthEnforced: true,
                maxLines: null,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20, right: 20),
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
                height: height / 3,
                color: Colors.white,
                child: Wrap(
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

//  Future<void> _optionsDialogBox() {
//    final width = MediaQuery.of(context).size.width;
//    return showModalBottomSheet(
//        context: context,
//        builder: (BuildContext context) {
//          return Container(
//            child: new SingleChildScrollView(
//              child: new ListBody(
//                children: <Widget>[
//                  RaisedButton(
//                    color: Colors.pink,
//                    child: Center(
//                      child: Text(
//                        '拍照',
//                        style: TextStyle(),
//                      ),
//                    ),
//                    onPressed: openCamera,
//                  ),
//                  Padding(
//                    padding: EdgeInsets.all(8.0),
//                  ),
//                  RaisedButton(
//                    color: Colors.pink,
//                    child: Center(
//                      child: Text(
//                        '相册',
//                        style: TextStyle(),
//                      ),
//                    ),
//                    onPressed: openGallery,
//                  ),
//                  Padding(
//                    padding: EdgeInsets.all(8.0),
//                  ),
//                  RaisedButton(
//                      color: Colors.pink,
//                      child: Center(
//                        child: Text('取消', textAlign: TextAlign.center),
//                      ),
//                      onPressed: () {
//                        Navigator.pop(context);
//                      }),
//                ],
//              ),
//            ),
//          );
//        });
//  }
}
