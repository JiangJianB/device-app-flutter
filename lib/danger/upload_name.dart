import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';


class UploadPage extends StatefulWidget {

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  dynamic _picture;
  dynamic _gallery;

  List <Widget> list;
  void initState(){
    super.initState();
    list = List<Widget>()..add(buildAddButton());
  }

  void openCamera() async {
    Navigator.of(context).pop();
    var picture = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      _picture = picture;
    });
  }
  void openGallery() async {
    Navigator.of(context).pop();
    var gallery = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _gallery = gallery;
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
                    obscureText: false,
                    inputFormatters: [LengthLimitingTextInputFormatter(100)],
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

            GestureDetector(
              onTap: (){
                _optionsDialogBox();
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: width,
                  height: height/4,
                  color: Colors.white,
                  child:Wrap(
                    children: list,
                    spacing: 26.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      );
  }
  Widget buildAddButton(){
    return GestureDetector(
      onTap: (){
        if(list.length<6){
          setState(() {
            list.insert(list.length-1, buildPhoto());
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 60.0,
          height: 50.0,
          color: Colors.grey,
          child: ImageIcon(
            AssetImage("images/ic_add_pic.png"),

          ),
        ),
      ),
    );
  }
  Widget buildPhoto(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 60.0,
        height: 60.0,
        color: Colors.grey,
        child: Center(child: Text('照片'),),
      ),
    );
  }
  Future<void> _optionsDialogBox() {
    return showModalBottomSheet(context: context,
        builder: (BuildContext context) {
          return Container(
            child: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('拍照'),
                    onTap: openCamera,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('相册'),
                    onTap: openGallery,
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    child: new Text('取消'),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

