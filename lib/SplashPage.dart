
import 'package:dianjian/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
var _token;

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation _animation;

  _get()async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    _token=sharedPreferences.getString('_userToken');
    print(_token);
  }

  void initState() {
    super.initState();
    _controller=AnimationController(vsync: this,duration: Duration(milliseconds: 1500));
    _animation=Tween(begin: 0.0,end: 1.0).animate(_controller);
    _get();
    /*动画事件监听器，
    它可以监听到动画的执行状态，
    我们这里只监听动画是否结束，
    如果结束则执行页面跳转动作,跳转到home界面。 */
    _animation.addStatusListener((status){
      if(status==AnimationStatus.completed){
        if(_token==null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()), (
              route) => route == null);
        }else{
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => App()), (
              route) => route == null);
        }
      }
    });
    //播放动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FadeTransition(//透明度动画组件
      opacity: _animation,  //执行动画
      child: Container(
        color: Colors.white,
        child: Image.asset(  //本地图片
          'images/ic_app_logo.png',
          scale: 3.0,  //进行缩放
          fit:BoxFit.none,  // 充满父容器
        ),
      ),
    );
  }
}