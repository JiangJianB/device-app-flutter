

import 'package:dianjian/message/message_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagePage extends StatefulWidget {

  MessagePage({Key key}) : super(key: key);
  @override
  _MessagePageState createState() => new _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  var _token;
  var _name;
  int _pagenum=1;
  int _pagesize=10;
  int id;
  List _list = [];


  ScrollController _scrollController=ScrollController();
  bool isLoading=false;

  @override
  void initState() {
    super.initState();
    _getData();
    _list;

    _scrollController.addListener((){
      if(_scrollController.position.pixels==
      _scrollController.position.maxScrollExtent){
        print('到底了');
        _getMore();
      }
    });
  }

  void didChangeDependencies() {
    ///在initState之后调 Called when a dependency of this [State] object changes.
    super.didChangeDependencies();
  }


  _getData() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
     _token =sharedPreferences.getString('_userToken');
     _name = sharedPreferences.getString('_userName');

    try{
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token'] = _token;
      Response response = await dio.get("http://192.168.2.150:20001/api/message/list?pageNum=$_pagenum&pageSize=$_pagesize&jobNo=$_name");
      Map data=response.data;
      print(response);
      if(data['code']==200){
        setState(() {
          _list=data['data']['list'];
        });
        print(_list);
      }else{
        print('错误');
      }
    }catch(e){
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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: GestureDetector(
          child: ListView.builder(
            controller: _scrollController,
              itemCount: _pagesize,
              itemExtent: 100,
              itemBuilder: (BuildContext context,int index){
                return ListTile(
                  title: Text('${_list[index]["messageListContent"]}',style: TextStyle(fontSize: 15),),

                  subtitle: Text('${_list[index]['messageTime']}',style: TextStyle(fontSize: 15),),


                );
              },

          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context)=>MessagedetailPage(),
            ));
          },
        ),
      )
    );
  }
  /// 下拉刷新方法,为list重新赋值
  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _list=_list;
      });
    });
  }
  /// 上拉加载更多
  _getMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _list.addAll(_list.getRange(_list.length, _list.length+10));
          _pagenum++;
          isLoading = false;
        });
      });
    }
  }
  /// 加载更多时显示的组件,给用户提示

  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '加载中...     ',
              style: TextStyle(fontSize: 16.0),
            ),
            CircularProgressIndicator(strokeWidth: 1.0,)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
}

