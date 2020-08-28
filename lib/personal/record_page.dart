import 'package:dianjian/personal/record_detail_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  var _token;
  var _name;
  int _pagenum = 1;
  int _pagesize = 10;
  List _list = [];

  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;

  //下拉刷新
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
          opacity: isLoading ? 0.8 : 1.0,
          child: new CircularProgressIndicator(
            backgroundColor: Colors.pink,
          ),
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
          "http://192.168.2.150:20001/api/user/tally-record?pageNum=$_pagenum&pageSize=$_pagesize&jobNo=$_name");
      Map data = response.data;
      print(data);

      if (data['code'] == 200) {
        setState(() {
          _list = data['data']['list'];
        });
        print(_list);
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
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            '点检记录',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.pink,
        ),
        body: Container(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              color: Colors.white,
              child: GestureDetector(
                child: RefreshIndicator(
                  color: Colors.pink,
                  onRefresh: _refresh,
                  child: ListView.builder(
                    itemCount: _list.length + 1,
                    itemExtent: 100,
                    itemBuilder: (BuildContext context, int index) {
                      if(_list.length==0){
                        return SizedBox();
                      }else  if (index == _list.length) {
                        _buildProgressIndicator();
                        _getData();
                        return Padding(
                            padding: EdgeInsets.all(18),
                            child: Center(
                              child: _buildProgressIndicator(),
                            )
                        );
                      } else {
                        return ListTile(
                          title: Text(
                            '${_list[index]['equipmentModel']}' +
                                '${_list[index]['equimentName']}' +
                                '已点检(${_list[index]['equipmentModel']}' +
                                '${_list[index]['fixedAssetsNo']}' +
                                ")",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          subtitle: Text('${_list[index]['tallyName']}' +
                              '       ${_list[index]['tallyEndTime']}'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecorddetailPage(
                                    tallyRecordId:_list[index]['tallyRecordId'],
                                  ),
                                )
                            );
                          },
                        );
                      }
                    },
                    controller: _scrollController,
                  ),
                ),
              ),
            )
        )
    );
  }
}
