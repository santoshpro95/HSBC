import 'package:flutter/material.dart';

class AppConfig {
  // For Mobile
  //static const suggestionQuestionFont = 14;
  //   static double buttonFont = 12;
  // static double avatarSize(BuildContext context){
  //   return MediaQuery.of(context).size.width / 1.5;
  // }

  // For Kiosk
  static double buttonFont = 25;
  static double ansFont = 25;
  static double suggestionQuestionFont = 25;
  static double avatarSize(BuildContext context){
    return MediaQuery.of(context).size.width / 1.5;
  }

}