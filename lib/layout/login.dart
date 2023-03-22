import 'package:dirasti_dashboard/utils/const.dart';
import 'package:dirasti_dashboard/utils/hive.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dirasti_dashboard/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'dart:html' as html;

import '../utils/const.dart';
var login_name_con =TextEditingController();
var login_pass_con =TextEditingController();
class Login extends StatelessWidget {
  const Login({super.key, this.title});
  final title;
  @override
  Widget build(BuildContext context) {
    // hive.hive_get("id").then((value) => print(value));
    if(hive.hive_get("id")!=null){
      dio.post_data(url: "/dash/signid",quary: {"id":  hive.hive_get("id")}).then((value) {
        if(value?.data.length > 0) {
          print(value?.data);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyHomePage()), (route) => false);
        }else{
          hive.hive_delet("id");
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyApp()), (route) => false);
        }
      });
      return Scaffold(body:  Center(child: Text(" ...جار تسجيل الدخول")));
    }
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
              padding: EdgeInsets.all(30),
              color: Colors.grey.shade200,
              width: 400,
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/logo.png",height: 125),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: login_name_con,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(hintText: "اسم المستخدم",hintTextDirection: TextDirection.rtl),
                  ),
                  TextFormField(
                    controller: login_pass_con,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(hintText: "كلمة السر",hintTextDirection: TextDirection.rtl),
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(onPressed: (){
                    dio.post_data(url: "/dash/signin",quary: {
                      "name":login_name_con.text,
                      "password":login_pass_con.text
                    }).then((value) async {
                      print(value?.data);
                      if(value?.data.length > 0){
                        await  hive.hive_put('id',value?.data[0]["id"].toString() );
                        await hive.hive_put('password',value?.data[0]["password"].toString() );
                        Tost_widget("تم تسجيل الدخول بنجاح", "green");

                         html.window.location.reload();
                        //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false);
                      }else{
                        Tost_widget("أسم المستخدم أو كلمة السر خاطئة", "red");
                      }
                    });
                    //  Navigator.pushAndRemoveUntil(context,    MaterialPageRoute(builder: (context)=>MyHomePage(title: "title")), (route) => false);
                  }, child: Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),child: Text("تسجيل الدخول"),))
                ],
              )
          ),
        ));
  }
}
