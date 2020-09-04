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

  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;

  //下拉刷新
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2),(){
      _pagesize=10;

      _getData();
    });
  }

  @override
  void initState() {
    super.initState();
    this._refresh();
    this._getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData(_pagesize);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _getMoreData(int pagesize) async {
    if (!isLoading) {
      setState(() => isLoading = true);
      await Future.delayed(Duration(seconds: _pagenum), () {
        setState(() {
          _pagesize += 10;
          isLoading = false;
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
          child: Column(
            children: <Widget>[
               CircularProgressIndicator(
                backgroundColor: Colors.pink,
              ),
            ],
          )
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
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.pink,
        ),
        body: Padding(
          padding: EdgeInsets.only(right: 15),
          child: Container(
            color: Colors.white,
            child: GestureDetector(
              child: RefreshIndicator(
                color: Colors.pink,
                onRefresh: _refresh,
                child: Container(
                  child: ListView.builder(
                    itemCount: _list.length + 1,
                    itemExtent: 90,
                    itemBuilder: (BuildContext context, int index) {
                      if(index==null){
                        return SizedBox();
                      } else if (index == _list.length) {
                        _buildProgressIndicator();
                        _getData();
                        return Padding(
                            padding: EdgeInsets.all(18),
                            child: Center(
                              child:_buildProgressIndicator()
                            )
                        );
                      } else {
                        return ListTile(
                          contentPadding: const EdgeInsets.only(left: 20, top: 13),
                          title: Text(
                            '${_list[index]['messageListContent']}',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          subtitle: Text(
                            '${_list[index]['messageTime']}',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessagedetailPage(id: _list[index]['id'],
                                  ),
                                ));
                          },
                        );
                      }
                    },
                    controller: _scrollController,
                  ),
                )
              ),

            ),
          )
        )
    );
  }
}
