import 'package:flutter/material.dart';

class AppConfig {
  // For Mobile
  //static const suggestionQuestionFont = 14;
  //   static double buttonFont = 12;
  // static double avatarSize(BuildContext context){
  //   return MediaQuery.of(context).size.width / 1.5;
  // }

  // For Kiosk
  static double buttonFont = 20;
  static double suggestionQuestionFont = 20;
  static double avatarSize(BuildContext context){
    return MediaQuery.of(context).size.width / 1.4;
  }

}