import 'package:flutter/material.dart';

class AppColors {
  static final Color colorFFFFFF = HexColor("#FFFFFF");
  static final Color colorFF671B = HexColor("#FF671B");
  static final Color colorFFF5F0 = HexColor("#FFF5F0");
  static final Color color0294A5 = HexColor("#0294A5");
  static final Color color9B9B9B = HexColor("#9B9B9B");
  static final Color color4A4A4A = HexColor("#4A4A4A");
  static final Color colorD8D8D8 = HexColor("#D8D8D8");
  static final Color color151C26 = HexColor("#151C26");
  static final Color color8899A6 = HexColor("#8899A6");
  static final Color color000000 = HexColor("#000000");
  static final Color color8E8E93 = HexColor("#8E8E93");
  static final Color colorEEEEEE = HexColor("#EEEEEE");
  static final Color colorFEB900 = HexColor("#FEB900");
  
}
class HexColor extends Color{
  static int _getColorFromHex(String hexColor){
    hexColor = hexColor.toLowerCase().replaceAll("#", "");
    if(hexColor.length == 6){
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}