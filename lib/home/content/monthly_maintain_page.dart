import 'package:dianjian/home/content/spot_check_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../login.dart';
class MonthlyMaintainPage extends StatefulWidget {
  @override
  _MonthlyMaintainPageState createState() => _MonthlyMaintainPageState();
}

class _MonthlyMaintainPageState extends State<MonthlyMaintainPage> {
  final countnumber=5;
  final numbering=0;
  final numbered=0;
  final nonumber=5;

  DateTime now = new DateTime.now();
  @override
  Widget build(BuildContext context) {
    final width= MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:AppBar (
        title: Text("月保养",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 15),
                color: Colors.amber,
                child: Row(
                  children: <Widget>[
                    Container(

                      child: Expanded(
                        child: Text("蒋建斌"),
                      ),
                    ),
                    Container(
                      child: Expanded(
                        child: Text("工号：J19120267"),
                      ),
                    ),
                    Container(
                      child: Expanded(
                        child: Text("岗位：作业者"),
                      ),
                    ),
                    FlatButton(
                        child: Text("退出登录",style: TextStyle(color: Colors.blue),),
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("退出登录将清空当前操作，确定退出吗？"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("退出登录"),
                                      onPressed: (){
                                        Navigator.push(context,MaterialPageRoute(
                                          builder: (BuildContext context)=>LoginPage(),
                                        ));
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("取消",style: TextStyle(color: Colors.black),),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              }
                          );
                        }
                    )
                  ],
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height-180,
                child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context,int index){
                      return MediaQuery.removePadding(
                        context: context,
                        removeLeft: true,
                        removeTop: true,
                        removeRight: true,
                        child: ListTile(
                          title: Column(
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.only(left: 15,right: 20),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 10.0,),
                                          Container(
                                            height: 40,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text("设备名称",style: TextStyle(color: Colors.black54),),
                                                Text("电池包")
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text("型号",style: TextStyle(color: Colors.black54),),
                                                Text("TD1000")
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text("固定资产编号",style: TextStyle(color: Colors.black54),),
                                                Text("T06APT0037")
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text("机号",style: TextStyle(color: Colors.black54),),
                                                Text("J1E000072")
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text("所属部门",style: TextStyle(color: Colors.black54),),
                                                Text("特康电子")
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      color: Colors.white,
                                      child: FlatButton(
                                        onPressed: (){

                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("说明书/保养手册",style: TextStyle(color: Colors.black54),),
                                            Icon(Icons.arrow_forward_ios,color: Colors.black38,)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(height: 15,),
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(left: 15,right: 20,top: 30,bottom: 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text("点检日期"),
                                                      Text("$now"),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: FlatButton(
                                              onPressed: () {

                                              },
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("总点检项目数",style: TextStyle(color: Colors.amber),),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text("$countnumber",style: TextStyle(color: Colors.amber,fontSize: 20),),
                                                      SizedBox(width:10.0),
                                                      Icon(Icons.arrow_forward_ios,color: Colors.amber,),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: FlatButton(
                                              onPressed: () {

                                              },
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("当前点检项目数",style: TextStyle(color: Colors.amber),),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text("$numbering",style: TextStyle(color: Colors.amber,fontSize: 20),),
                                                      SizedBox(width:10.0),
                                                      Icon(Icons.arrow_forward_ios,color: Colors.amber,),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: FlatButton(
                                              onPressed: () {

                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("已点检项目数",style: TextStyle(color: Colors.amber),),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text("$numbered",style: TextStyle(color: Colors.amber,fontSize: 20),),
                                                      SizedBox(width:10.0),
                                                      Icon(Icons.arrow_forward_ios,color: Colors.amber,),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: FlatButton(
                                              onPressed: () {

                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("待点检项目数",style: TextStyle(color: Colors.amber),),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text("$nonumber",style: TextStyle(color: Colors.amber,fontSize: 20),),
                                                      SizedBox(width:10.0),
                                                      Icon(Icons.arrow_forward_ios,color: Colors.amber,),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: FlatButton(
                                              onPressed: () {

                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("异常项目数",style: TextStyle(color: Colors.amber),),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text("$numbering",style: TextStyle(color: Colors.amber,fontSize: 20),),
                                                      SizedBox(width:10.0),
                                                      Icon(Icons.arrow_forward_ios,color: Colors.amber,),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              height: 50,
              width: width,
              child: FlatButton(
                color: Colors.amber,
                child: Text("开始点检"),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>SpotcheckPage(),
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
