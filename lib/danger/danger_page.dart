import 'package:dianjian/danger/upload_name.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DangerPage extends StatefulWidget {
  @override
  DangerPageState createState() => new DangerPageState();
}

class DangerPageState extends State<DangerPage> {
  var _token;
  var _name;
  int _pagenum = 1;
  int _pagesize = 10;
  String _title;
  List _list = [];
  dynamic _total;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    this._refresh();
    this._getData();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  //下拉刷新
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2),(){
      _pagesize=10;
      _getData();
    });
  }

  _getData() async {
    _title = _controller.text;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _token = sharedPreferences.getString('_userToken');
    _name = sharedPreferences.getString('_userName');

    try {
      Dio dio = Dio();
      dio.options.headers['X-Auth-Token'] = _token;
      Response response = await dio.post(
          "http://192.168.2.150:20001/api/hide-danger/list?pageNum=$_pagenum&pageSize=$_pagesize&jobNo=$_name&key=$_title");

      Map data = response.data;
      print(response);

      if (data['code'] == 200) {
        setState(() {
          _list = data['data']['list'];
          _total = data['data'];
          print(_total);
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
    final height = MediaQuery.of(context).size.width;
    print(height);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.pink,
          centerTitle: true,
          title: Text("隐患"),
        ),
        body: Container(
            color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 40,
                          color: Colors.black87,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => UploadPage(),
                                  ));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                Text(
                                  "隐患时间上传",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          height: 40,
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            cursorColor: Colors.pink,
                            controller: _controller,
                            onEditingComplete: () {
                              _getData();
                              print(_controller.text);
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.search,color: Colors.pink,),
                              hintText: "按标题查找",
                              border: InputBorder.none,
                              filled: true,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0,),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                        height: height,
                        child: RefreshIndicator(
                          color: Colors.pink,
                          onRefresh:_refresh ,
                          child: ListView.builder(
                              itemCount: _list.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: ExpansionTile(
                                          title: _list[index]['hideDangerTitle'] == null
                                              ? Text('')
                                              : Text(_list[index]['hideDangerTitle']),
                                          backgroundColor: Colors.white12,
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Text('上报时间:',),
                                                  SizedBox(width: 50,),
                                                  _list[index]['createdAt'] == null
                                                      ? SizedBox
                                                      : Text(_list[index]['createdAt']),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Text('标题:',),
                                                  SizedBox(width: 50,),
                                                  _list[index]['hideDangerTitle'] == null
                                                      ? SizedBox
                                                      : Text(_list[index]['hideDangerTitle']),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('描述:',),
                                                  SizedBox(width: 50,),
                                                  _list[index]['hideDangerDescribe'] == null
                                                      ? SizedBox
                                                      : Text(_list[index]['hideDangerDescribe']),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Text('附件:',),
                                                  SizedBox(width: 50,),
                                                  Text(''),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Text('最后更新:',),
                                                  SizedBox(width: 50,),
                                                  _list[index]['updatedAt'] == null
                                                      ? SizedBox()
                                                      : Text(_list[index]['updatedAt']),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        )
                    ),
                  )
                ],
              )),
      ),
    );
  }
}
