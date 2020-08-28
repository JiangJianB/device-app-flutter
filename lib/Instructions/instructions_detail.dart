import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructionsDetailPage extends StatefulWidget {
  final title;
  final id;

  InstructionsDetailPage({this.title, this.id});

  @override
  _InstructionsDetailPageState createState() => _InstructionsDetailPageState();
}

class _InstructionsDetailPageState extends State<InstructionsDetailPage> {
  var _title;
  var _id;

  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      setState(() {
        _title = widget.title.toString();
        _id = widget.id.toString();
        print(_title);
      });
      _getData(_title, _id);
    }
  }

  _getData(String title, String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _title = sharedPreferences.getString('title');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.white,
        ),
        body: Container(
          height: height,
          width: width,
          child: Center(
            child: GestureDetector(
              child: Text('点击下载查看说明书',style: TextStyle(color: Colors.pink,fontSize: 30),),
              onTap: (){
                launch('http://192.168.2.150:20001/files/$_id');
                print(_id);
              },
            ),
          ),

        ));
  }
}
