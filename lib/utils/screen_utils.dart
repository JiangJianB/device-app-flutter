import 'package:flutter_screenutil/flutter_screenutil.dart';
class ScreenAdaptr{
  static init(context){
    // 按设计稿尺寸设计750*1334
//    ScreenUtil.instance = ScreenUtil(width:375,height:667)..init(context);
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
  }
  static setHeight(double value){
    return ScreenUtil().setHeight(value);
  }
  static setWidth(double value){
    return ScreenUtil().setWidth(value);
  }

  static setFontSize(double value){
    return ScreenUtil().setSp(value);
  }

  static getScreenHeight(){
    return ScreenUtil.screenHeightDp;
  }

  static getScreenWidth(){
    return ScreenUtil.screenWidthDp;
  }

  static getBarHeight(){
    return ScreenUtil.statusBarHeight;
  }
}