import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
String? col;
String base_url = "https://workable-forest-quotation.glitch.me/";
 Tost_widget (msg,String color){
  if(color == "green") col = "#02e637";
  if(color == "red") col = "#fc031c";
  return Fluttertoast.showToast(
      msg: msg.toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      webPosition: "left",
      //webBgColor: "linear-gradient(to right, #00b09b, #96c93d)",
      webBgColor:col,
      textColor: Colors.white,
      fontSize: 16.0
  );
}