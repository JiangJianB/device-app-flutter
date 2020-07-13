

import 'dart:async';
import 'package:dianjian/message/message_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => new _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  var _token;
  var _name;
  int _pagenum = 1;
  int _pagesize = 10;
  List _list = [];

  ScrollController _scrollController= new ScrollController();
  bool isLoading = false;

  @override//下拉刷新
  Future<Null> _refresh() async{
    _list.clear();
    await _list;
    return;
  }

  @override
  void initState() {
    super.initState();
    this._getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData(_pagesize);
      }
    });
  }


  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void _getMoreData(int pagesize) async {
    if(!isLoading){
      setState(() => isLoading=true);
      await Future.delayed(Duration(seconds: _pagenum),(){
        setState(() {
          _pagesize+=10;
          isLoading=false;
          print(_pagesize);
        });
      });
    }
  }
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 0.8 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }



  _getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _token = sharedPreferences.getString('_userToken');
    _name = sharedPreferences.getString('_userName');

    try {
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token'] = _token;
      Response response = await dio.get(
          "http://192.168.2.150:20001/api/message/list?pageNum=$_pagenum&pageSize=$_pagesize&jobNo=$_name");
      Map data = response.data;
      print(response);
      if (data['code'] == 200) {
        setState(() {
          _list = data['data']['list'];
        });
      } else {
        print('错误');
      }
    } catch (e) {
      return print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '消息中心',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amber,
        ),
        body: GestureDetector(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child:ListView.builder(
              controller: _scrollController,
          itemCount: _list.length,
            itemExtent: 90,
            itemBuilder: (BuildContext context, int index) {
              if(index==_list.length){
                return _buildProgressIndicator();
              }else{
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 20,top: 15),
                  title: Text('${_list[index]['messageListContent']}',
                    style: TextStyle(fontSize: 14,color: Colors.black),),
                  subtitle: Text('${_list[index]['messageTime']}',
                    style: TextStyle(fontSize: 12,color: Colors.black),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MessagedetailPage(id: _list[index]['id'],),
                    ));
                  },
                );
              }
            },
          ),
          ),
        )
    );
  }
}