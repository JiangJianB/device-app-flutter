import 'package:dianjian/danger/upload_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DangerPage extends StatefulWidget{
  @override
  DangerPageState createState() => new DangerPageState();
}

class DangerPageState extends State<DangerPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
        child:Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text("隐患"),
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(10),
                        height: 40,
                        color: Colors.black87,
                        child: FlatButton(
                          onPressed: (){
                            Navigator.push(context,MaterialPageRoute(
                              builder: (context) => UploadPage(),
                            ));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.add,color: Colors.white,),
                              Text("隐患时间上传",style:TextStyle(color: Colors.white),),
                            ],
                          ),
                        ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.search),
                          hintText: "按标题查找",
                          border: InputBorder.none,
                          filled: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      child: ExpansionTile(
                        title: Text("测试"),
                        leading: Icon(Icons.ac_unit),
                        backgroundColor: Colors.white12,
                        children: <Widget>[
                          ListTile(
                            title: Text("上报时间",style: TextStyle(fontSize: 12),),
                            subtitle: Text("1",style: TextStyle(fontSize: 12),),
                          ),
                          ListTile(
                            title: Text("标题",style: TextStyle(fontSize: 12),),
                            subtitle: Text("2",style: TextStyle(fontSize: 12),),
                          ),
                          ListTile(
                            title: Text("描述",style: TextStyle(fontSize: 12),),
                            subtitle: Text("3",style: TextStyle(fontSize: 12),),
                          ),
                          ListTile(
                            title: Text("上报时间",style: TextStyle(fontSize: 12),),
                            subtitle: Text("4",style: TextStyle(fontSize: 12),),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      child: ExpansionTile(
                        title: Text("测试"),
                        leading: Icon(Icons.ac_unit),
                        backgroundColor: Colors.white12,
                        children: <Widget>[
                          ListTile(
                            title: Text("上报时间",style: TextStyle(fontSize: 12),),
                            subtitle: Text("1",style: TextStyle(fontSize: 12),),
                          ),
                          ListTile(
                            title: Text("标题",style: TextStyle(fontSize: 12),),
                            subtitle: Text("2",style: TextStyle(fontSize: 12),),
                          ),
                          ListTile(
                            title: Text("描述",style: TextStyle(fontSize: 12),),
                            subtitle: Text("3",style: TextStyle(fontSize: 12),),
                          ),
                          ListTile(
                            title: Text("上报时间",style: TextStyle(fontSize: 12),),
                            subtitle: Text("4",style: TextStyle(fontSize: 12),),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        )
    );
  }

  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}
