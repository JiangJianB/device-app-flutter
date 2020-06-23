import 'package:barcode_scan/barcode_scan.dart';
import 'package:date_format/date_format.dart';
import 'package:dianjian/home/content/workway_page.dart';
import 'package:dianjian/utils/screen_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime time=DateTime.now();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaptr.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child:Column(
            children: <Widget>[
              Container(
                height: 115,
                color: Colors.amber,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              scan();
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context)=>WorkwayPage(),
                              ));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/ic_home_scan.png",width: 30,height: 30,),
                                SizedBox(height:8.0),
                                Text("扫一扫",style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              Fluttertoast.showToast(msg: "设备不支持NFC！",gravity: ToastGravity.CENTER);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/ic_home_nfc.png",width: 30,height: 30,),
                                SizedBox(height:8.0),
                                Text("读取NFC",style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Container(
                width: ScreenAdaptr.setWidth(400),
                height: ScreenAdaptr.setHeight(60),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                          side: BorderSide(
                            color: Colors.amber,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        color: Colors.white,
                        child: Text("近1天",style: TextStyle(fontSize: ScreenAdaptr.setFontSize(24)),),
                        textColor: Colors.amber,
                        highlightColor: Colors.amber,
                        onPressed: (){
                          setState(() {
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.amber,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Text("近2天",style: TextStyle(fontSize: ScreenAdaptr.setFontSize(25)),),
                        textColor: Colors.amber,
                        color: Colors.white,
                        onPressed: (){
                          setState(() {
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5)
                          ),
                          side: BorderSide(
                            color: Colors.amber,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        color: Colors.white,
                        child: Text("近1周", style: TextStyle(fontSize: ScreenAdaptr.setFontSize(25)),),
                        textColor: Colors.amber,
                        onPressed: (){
                          setState(() {
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Container(
                padding: EdgeInsets.only(left: 10),
                height: 35,
                color: Colors.amber,
                alignment: Alignment.centerLeft,
                child: Text("截止到：",semanticsLabel: formatDate(time,[yyyy,'年',mm,'月',dd,'日']).toString(),style: TextStyle(color: Colors.white,fontSize: ScreenAdaptr.setFontSize(25)),),
              )
            ],
          ),
        ),
      ),
    );
  }

  //  扫描二维码
  Future scan() async {
    try {
      // 此处为扫码结果，barcode为二维码的内容
      String barcode = await BarcodeScanner.scan();
      print('扫码结果: '+barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        // 未授予APP相机权限
        print('未授予APP相机权限');
      } else {
        // 扫码错误
        print('扫码错误: $e');
      }
    } on FormatException{
      // 进入扫码页面后未扫码就返回
      print('进入扫码页面后未扫码就返回');
    } catch (e) {
      // 扫码错误
      print('扫码错误: $e');
    }
  }

}