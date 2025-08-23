import 'package:flutter/material.dart';

abstract class ScreenSize {
  static  double? width;
  static  double? height;

  static void init(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }
}
