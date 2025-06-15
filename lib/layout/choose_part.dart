import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dirasti_dashboard/module/course_module.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../module/copon_module.dart';
import '../module/file_module.dart';
import '../module/grade_module.dart';
import '../module/subject_module.dart';
import '../module/teacher_module.dart';
import '../utils/QR.dart';
import '../utils/const.dart';

class ChoosePart extends StatefulWidget {
  const ChoosePart({super.key});

  @override
  State<ChoosePart> createState() => _ChoosePartState();
}

class _ChoosePartState extends State<ChoosePart> {
  List <course_module> course_list=[];
  List <String> addedItem=[];
  List<file_module> file_list = [];
  List<teacher_module> teacher_list = [];
  List<subject_module> subject_list = [];
  List<grade_module> grade_list = [];
  List<copon_module> copon_list = [];
  var name_con = TextEditingController();
  var price_con = TextEditingController();
  var num_con = TextEditingController();
  var type ;
  var grade ;
  var subject ;
  var tracher ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " course "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            course_list.add(course_module.fromjson(element));
            // if (course_list.length == value.data.length) {
            //   setState(() {});
            // }
          });
        });
        await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " file "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            file_list.add(file_module.fromjson(element));
            // if (course_list.length == value.data.length) {
            //   setState(() {});
            // }
          });
        });
        await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " teatcher "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            teacher_list.add(teacher_module.fromjson(element));
            // if (teacher_list.length == value.data.length) {
            //   setState(() {});
            // }
          });
        });
        await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " subject "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            subject_list.add(subject_module.fromjson(element));
            // if (course_list.length == value.data.length) {
            //   setState(() {});
            // }
          });
        });
        await  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " grade "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            grade_list.add(grade_module.fromjson(element));
            // if (grade_list.length == value.data.length) {
            //   setState(() {});
            // }
          });
        });
      } catch (e) {
        print(e);
      }
      finally {
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaa");
        setState(() {});
      }
    });

  }
  @override
  void dispose() {
    super.dispose();
    course_list.clear();
    file_list.clear();
    teacher_list.clear();
    subject_list.clear();
    copon_list.clear();
    addedItem.clear();
    grade_list.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            actions: [
              ElevatedButton(onPressed: () async {
                  List all_uid=[];
                  var l ='';
                  // addedItem.forEach((element) {
                  //   l="$l,${1}|${element.grade}|${element.subject}|${element.teacher_name}|${element.id}";
                  // });
                  addedItem.forEach((element) {
                    l="$l$element";
                  });
                  print(l);
                  // if(type==0){
                  //   for (var i in file_list){
                  //     l = "$l,$type|$grade|$subject|$tracher|${i.id}";
                  //   }
                  // }else{
                  //   for (var i in course_list){
                  //     l = "$l,$type|$grade|$subject|$tracher|${i.id}";
                  //   }
                  // }
                  print(l);
                  // var l =
                  //     "$type|$grade|$subject|$tracher|${type == 0 ? file : course}";
                  for(var i=0;i<int.parse(num_con.text);i++){
                    Random rng = Random();
                    var s = "";
                    for (var i = 0; i < 9; i++) {
                      if(rng.nextBool()){
                        s = s +rng.nextInt(9).toString();
                      }else{
                        var all = ["q","a","z","w","s","x","e","d","c","r","f","v","t","g","b","y","h","n","u","j","m","i","o","l","p","Q","A","Z","W","S","X","E","D","C","R","F","V","T","G","B","Y","H","N","U","J","M","I","K","O","L","P"];
                        s = s +all[rng.nextInt(all.length-1)].toString();
                      }
                      if(i==2 || i == 5) s = "$s-";
                    }
                    all_uid.add(s);
                  }
                  print(all_uid);
                  if(all_uid.length==1){
                    await dio.post_data(
                        url: "/dash/insert",
                        quary: {
                          "table": " copon ",
                          "sql_key":
                          "  list_cours ,  is_open  , name_copon ,  uid_copon , price , grade ",
                          "sql_value":
                          "  '$l' , '1' , '${name_con.text}' , '${all_uid[0]}' , '${price_con.text}', '$grade' "
                        }).then((value) {
                      Tost_widget(value?.data, "green");
                      print(value?.data);

                      Navigator.pop(context);
                    });
                  }else{
                    await dio.post_data(
                        url: "/dash/list_coponns",
                        quary: {
                          "list_cours":l,
                          "name_copon":name_con.text ,
                          "uid_of_copons":all_uid,
                          "price":price_con.text,
                          "grade":'$grade',
                        }).then((value)
                    {
                      Tost_widget(value?.data, "green");
                      print(value?.data);

                      Navigator.pop(context);
                    });
                  }
                  dio.post_data(
                      url: "/dash/select",
                      quary: {
                        "sql": " * ",
                        "table": " copon "
                      }).then((value) async
                  {
                    for(var i =0 ;i<all_uid.length; i++){
                      ui.Image image = await QrPainter(
                        data: all_uid[i],
                        gapless: true,
                        version: QrVersions.auto,
                        color: Color.fromRGBO(0, 0, 0, 1),
                        emptyColor: Colors.white,
                        //    embeddedImage: AssetImage('assets/images/logo.png'),
                      ).toImage(300);
                      ByteData? data = await CodePainter(qrImage: image)
                          .toImageData(300);
                      var pngBytes = base64Encode(data!.buffer.asUint8List());
                      var download = document.createElement('a') as AnchorElement;
                      download.href = 'data:image/png;base64,'+pngBytes;
                      download.download = all_uid[i]+'.png';
                      download.click();
                      download.remove();
                    }
                    copon_list.clear();
                    value?.data.forEach((element) {
                      print(element);
                      copon_list.add(copon_module
                          .fromjson(element));
                      if (copon_list.length ==
                          value.data.length) {
                        setState(() {});
                      }
                    });
                  });

              },child: Text("موافق")),
            ],
          ),
          body: course_list.isEmpty
      ?CircularProgressIndicator()
      :Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text("إنشاء"),
                SizedBox(height: 10,),
                Center(child: Text("الاسم")),
                TextFormField(controller: name_con,textDirection: TextDirection.rtl,),
                SizedBox(height: 10,),
                Center(child: Text("السعر")),
                TextFormField(controller: price_con,textDirection: TextDirection.rtl,),
                SizedBox(
                  height: 10,
                ),
                // Center(child: Text("رمز الكود ")),
                Row(
                  children: [
                    Expanded(child:  TextFormField(controller: num_con,),),
                    SizedBox(width: 20,),
                    Text("العدد"),
                  ],
                ),
                // Directionality(textDirection: TextDirection.ltr,child: Center(child: Text(model.uid_copon!))),
                SizedBox(
                  height: 30,
                ),
                Center(child: Text("النوع:")),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),

          // Row(
          //   children: [
          //     DropdownButton(
          //         value: type ,
          //         items: ["ملفات","كورسات"].map((e) => DropdownMenuItem(child: Text(e),value: ["ملفات","كورسات"].indexOf(e),)).toList(),
          //         //    value: grade_list[0].name,
          //         onChanged: (value){
          //           type = value;
          //           grade = null;
          //           subject = null;
          //           tracher = null;
          //           print(value);
          //           setState(() {});
          //         }),
          //     Center(child: Text("السنة:")),
          //     SizedBox(
          //       width: 30,
          //     ),
          //     DropdownButton(
          //         value: grade ,
          //         items: grade_list.map((e) => DropdownMenuItem(child: Text(e.name!),value: e.id,)).toList(),
          //         //    value: grade_list[0].name,
          //         onChanged: (value){
          //           grade = value;
          //           subject = null;
          //           tracher = null;
          //
          //           print(value);
          //           setState(() {});
          //         }),
          //     SizedBox(height: 20,),
          //     Text("المادة"),
          //     DropdownButton(
          //         value: subject ,
          //         items: subject_list.where((element) => element.grade==grade).map((e) => DropdownMenuItem(child: Text(e.subject!),value: e.id,)).toList(),
          //         //    value: grade_list[0].name,
          //         onChanged: (value){
          //           subject = value;
          //           tracher = null;
          //
          //           print(value);
          //           setState(() {
          //
          //           });
          //         }),
          //     SizedBox(height: 20,),
          //     Text("الأستاذ"),
          //     DropdownButton(
          //         value: tracher ,
          //         items: teacher_list.where((element) => element.grade==grade && element.subject==subject).map((e) => DropdownMenuItem(child: Text(e.teacher_name!),value: e.id,)).toList(),
          //         //    value: grade_list[0].name,
          //         onChanged: (value){
          //           tracher = value;
          //
          //           print(value);
          //           setState(() {
          //
          //           });
          //         }),
          //   ],
          // ),

          Expanded(
            child: Column(
              children: [
                Text("الكورسات"),
                Expanded(
                  child: ListView.builder(
                      itemCount: course_list.length,
                      itemBuilder: (context,index){
                    var model = course_list[index];
                    var _ =  ",${1.toString()}|${model.grade}|${model.subject}|${model.teacher_name}|${model.id}";
                    var con = ScrollController();
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: (){
                          if(addedItem.contains(_)){
                            addedItem.remove(_);
                          }else{
                            addedItem.add(_);
                          }
                          setState(() {});
                        },
                        child: Container(
                          color: addedItem.contains(_)?Colors.red:Colors.grey.shade100,
                          width: 550,
                          height: 50,
                          child: Scrollbar(
                            controller: con,
                            scrollbarOrientation: ScrollbarOrientation.bottom,
                            child: ListView(
                              controller: con,
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(model.photo! ,width: 50,height: 50,),
                                SizedBox(
                                  width: 30,
                                ),
                                Center(child: Text("الرمز التسلسلي: ${model.id!}")),
                                SizedBox(
                                  width: 30,
                                ),
                                //   Text( MediaQuery.of(context).size.width.toString()),
                                Center(child: Text("الاسم: ${model.name!}")),
                                SizedBox(
                                  width: 30,
                                ),
                                Center(child: Text("الترتيب: ${model.order!}")),
                                SizedBox(
                                  width: 30,
                                ),
                                Center(child: Text("السعر: ${model.price!}")),
                                SizedBox(
                                  width: 30,
                                ),
                                Center(child: Text(model.is_free!?"مجاني":"غير مجاني")),
                                SizedBox(
                                  width: 30,
                                ),
                                Center(child: Text("عدد الدروس: ${model.part!}")),
                                SizedBox(
                                  width: 30,
                                ),
                                Center(child: Text("ساعات الكورس: ${model.number_hours!}")),
                                SizedBox(
                                  width: 30,
                                ),
                                Center(child: Text("السنة:")),
                                SizedBox(
                                  width: 10,
                                ),
                                Center(child: Text(grade_list.where((element) => element.id == model.grade).first.name??"غير متوفر")),
                                SizedBox(
                                  width: 30,
                                ),
                                Center(child: Text("المادة:")),
                                SizedBox(
                                  width: 10,
                                ),
                                Center(child: Text(subject_list.where((element) => element.id == model.subject).first.subject??"غير متوفر")),
                                SizedBox(
                                  width: 30,
                                ),
                                Center(child: Text("اسم الاستاذ:")),
                                SizedBox(
                                  width: 10,
                                ),
                                Center(child: Text(teacher_list.where((element) => element.id == model.teacher_name).first.teacher_name??"غير متوفر")),
                                if (MediaQuery.of(context).size.width > 500)
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width.toDouble() / 6,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                Text("الملفات"),
                Expanded(
                  child: ListView.builder(
                      itemCount: file_list.length,
                      itemBuilder: (context,index){
                        file_module model = file_list[index];
                        var _ =  ",${0.toString()}|${model.grade}|${model.subject}|${model.teacher_name}|${model.id}";
                        var con = ScrollController();
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: InkWell(
                            onTap: (){
                              if(addedItem.contains(_)){
                                addedItem.remove(_);
                              }else{
                                addedItem.add(_);
                              }
                              setState(() {});
                            },
                            child: Container(
                              color: addedItem.contains(_)?Colors.red:Colors.grey.shade100,
                              width: 550,
                              height: 50,
                              child: Scrollbar(
                                controller: con,
                                scrollbarOrientation: ScrollbarOrientation.bottom,
                                child: ListView(
                                  controller: con,
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(model.photo! ,width: 50,height: 50,),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Center(child: Text("الرمز التسلسلي: ${model.id!}")),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    //   Text( MediaQuery.of(context).size.width.toString()),
                                    Center(child: Text("الاسم: ${model.name!}")),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Center(child: Text("الترتيب: ${model.order!}")),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Center(child: Text("السعر: ${model.price!}")),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Center(child: Text(model.is_free!?"مجاني":"غير مجاني")),
                                    SizedBox(
                                      width: 30,
                                    ),

                                    SizedBox(
                                      width: 30,
                                    ),
                                    Center(child: Text("السنة:")),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Center(child: Text(grade_list.where((element) => element.id == model.grade).first.name??"غير متوفر")),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Center(child: Text("المادة:")),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Center(child: Text(subject_list.where((element) => element.id == model.subject).first.subject??"غير متوفر")),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Center(child: Text("اسم الاستاذ:")),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Center(child: Text(teacher_list.where((element) => element.id == model.teacher_name).first.teacher_name??"غير متوفر")),
                                    if (MediaQuery.of(context).size.width > 500)
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width.toDouble() / 6,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
