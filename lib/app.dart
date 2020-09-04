import 'package:dianjian/danger/danger_page.dart';
import 'package:dianjian/message/message_page.dart';
import 'package:dianjian/personal/personal_page.dart';
import 'package:flutter/material.dart';
import 'home/home_page.dart';

enum ItemType { GroupChat, AddFriends, QrCode, Payments, Help }

class App extends StatefulWidget {
  final name;
  final jobNo;
  final postName;
  App({this.name,this.jobNo,this.postName});
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  var _currentIndex = 0;
  List<Widget> pages = List();

//  currentPage() {
//    switch (_currentIndex) {
//      case 0:
//        if (home == null) {
//          home = new HomePage();
//        }
//        return home;
//      case 1:
//        if (message == null) {
//          message = new MessagePage();
//        }
//        return message;
//      case 2:
//        if (danger == null) {
//          danger = new DangerPage();
//        }
//        return danger;
//      case 3:
//        if (me == null) {
//          me = new PersonalPage();
//        }
//        return me;
//      default:
//    }
//  }
  void initState() {
    // TODO: implement initState
    super.initState();
    pages
      ..add(HomePage())
      ..add(MessagePage())
      ..add(DangerPage())
      ..add(PersonalPage());

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: ((index) {
          setState(() {
            _currentIndex = index;
          });
        }),
        items: [
          new BottomNavigationBarItem(
              title: new Text(
                '首页',
                style: TextStyle(
                    color:
                        _currentIndex == 0 ? Colors.black : Color(0xff999999)),
              ),
              icon: _currentIndex == 0
                  ? Image.asset(
                      'images/ic_home_select.png',
                      width: 32.0,
                      height: 28.0,
                    )
                  : Image.asset(
                      'images/ic_home_unselect.png',
                      width: 32.0,
                      height: 28.0,
                    )),
          new BottomNavigationBarItem(
              title: new Text(
                '消息',
                style: TextStyle(
                    color:
                        _currentIndex == 1 ? Colors.black : Color(0xff999999)),
              ),
              icon: _currentIndex == 1
                  ? Image.asset(
                      'images/ic_message_select.png',
                      width: 32.0,
                      height: 28.0,
                    )
                  : Image.asset(
                      'images/ic_message_unselect.png',
                      width: 32.0,
                      height: 28.0,
                    )),
          new BottomNavigationBarItem(
              title: new Text(
                '隐患',
                style: TextStyle(
                    color:
                        _currentIndex == 2 ? Colors.black : Color(0xff999999)),
              ),
              icon: _currentIndex == 2
                  ? Image.asset(
                      'images/ic_danger_select.png',
                      width: 32.0,
                      height: 28.0,
                    )
                  : Image.asset(
                      'images/ic_danger_unselect.png',
                      width: 32.0,
                      height: 28.0,
                    )),
          new BottomNavigationBarItem(
              title: new Text(
                '我的',
                style: TextStyle(
                    color:
                        _currentIndex == 3 ? Colors.black : Color(0xff999999)),
              ),
              icon: _currentIndex == 3
                  ? Image.asset(
                      'images/ic_mine_select.png',
                      width: 32.0,
                      height: 28.0,
                    )
                  : Image.asset(
                      'images/ic_mine_unselect.png',
                      width: 32.0,
                      height: 28.0,
                    )),
        ],
      ),
    );
  }
}
