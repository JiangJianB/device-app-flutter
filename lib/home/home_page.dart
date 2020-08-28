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
  var _barcode;
  var i = 1;
  DateTime time = DateTime.now();
  Map<String, Text> map = {
    '近1天': Text('近1天'),
    '近2天': Text('近2天'),
    '近一周': Text('近一周'),
  };
  String _day = '近1天';

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
          child: Column(
            children: <Widget>[
              Container(
                height: 115,
                color: Colors.pink,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              scan();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/ic_home_scan.png",
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  "扫一扫",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: "设备不支持NFC！",
                                  gravity: ToastGravity.CENTER);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/ic_home_nfc.png",
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  "读取NFC",
                                  style: TextStyle(color: Colors.white),
                                )
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
                width: ScreenAdaptr.setWidth(1000),
                height: ScreenAdaptr.setHeight(60),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CupertinoSegmentedControl(
                      children: map, // 数据
                      groupValue: _day, // 选中的数据
                      onValueChanged: (index) {
                        setState(() {// 数据改变时通过setState改变选中状态
                          _day = index;
                        });
                      },
                      unselectedColor: CupertinoColors.white, // 未选中颜色
                      selectedColor: CupertinoColors.systemPink, // 选中颜色
                      borderColor: CupertinoColors.systemPink, // 边框颜色
                      pressedColor: const Color(0x33007AFF), // 点击时候的颜色
                    )
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Container(
                padding: EdgeInsets.only(left: 10),
                height: 35,
                color: Colors.pink,
                alignment: Alignment.centerLeft,
                child: Text(
                  "截止到：${formatDate(DateTime.now(), [
                    yyyy, '-', mm, '-', dd, ' 00:00:00 , 点检任务列表如下：'
                  ])}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenAdaptr.setFontSize(25)),
                ),
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
      _barcode = barcode;
      if (_barcode == barcode) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkwayPage(barcode: _barcode),
            ));
      } else {
        Fluttertoast.showToast(msg: '扫码失败', gravity: ToastGravity.CENTER);
      }
      print('扫码结果:' + barcode);
      print(_barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        // 未授予APP相机权限
        print('未授予APP相机权限');
      } else {
        // 扫码错误
        print('扫码错误: $e');
      }
    } on FormatException {
      // 进入扫码页面后未扫码就返回
      print('进入扫码页面后未扫码就返回');
    } catch (e) {
      // 扫码错误
      print('扫码错误: $e');
    }
  }
}
