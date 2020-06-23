
import 'package:dianjian/personal/record_detail_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordPage extends StatefulWidget {
  RecordPage({Key key}) : super(key: key);

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  var _token;
  var _name;
  List _list = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    _token =sharedPreferences.getString('_userToken');
    _name = sharedPreferences.getString('_userName');
    print(_name);
    print(_token);

    try{
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token'] = _token;
      Response response = await dio.get("http://192.168.2.150:20001/api/user/tally-record?pageNum=1&pageSize=10&jobNo=$_name");
      Map data=response.data;
      print(data);

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
            '点检记录',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 10),
          child: GestureDetector(
            child: ListView.builder(
                itemCount: _list.length,
                itemExtent: 100,
                itemBuilder: (BuildContext context,int index){
                  return ListTile(
                    title: Text('${_list[index]['equipmentModel']}'+'${_list[index]['equimentName']}'+'已点检(${_list[index]['equipmentModel']}'+'${_list[index]['fixedAssetsNo']}'+")",style: TextStyle(fontSize: 15.0),),

                    subtitle: Text('${_list[index]['tallyName']}'+'       ${_list[index]['tallyEndTime']}'),
                  );
                }),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context)=>RecorddetailPage(),
              ));
            },
          )

        )
    );
  }
}
