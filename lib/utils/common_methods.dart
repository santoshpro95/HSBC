import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CommonMethods {
  //#region Region - Route Right to Left
  static Route createRouteRTL(var screen) {
    return CupertinoPageRoute(builder: (_) => screen);
  }

  //#endregion

  // region containsOnlyWhitespace
  static bool containsOnlyWhitespace(String input) {
    return RegExp(r'^\s*$').hasMatch(input);
  }

  // endregion

}
