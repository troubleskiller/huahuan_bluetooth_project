//import 'package:flutter/material.dart';
import 'package:convert/convert.dart';

const String SET_PACKET = '5A462B4155544F3D310D0A'; //发送参数

class CCTGattPacket {
  int? status; //0:success
  String? errorMsg; //错误提示
  String? head;
  String? type;
  String? content;

  CCTGattPacket(String hexStr) {
    if (!checkIsValid(hexStr)) {
      errorMsg = "无法解析返回值：$hexStr";
      return;
    }
    head = hexStr.substring(0, 4);
    type = hexStr.substring(4, 8);
    status =
        hex.decode(hexStr.substring(hexStr.length - 8, hexStr.length - 4)).last;
    content = hexStr.substring(12, hexStr.length - 8);
  }

  bool checkIsValid(String hexStr) {
    if (hexStr.length < 20) {
      return false;
    }
    //
    return true;
  }
}
