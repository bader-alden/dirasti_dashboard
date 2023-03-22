import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:dirasti_dashboard/module/copon_module.dart';
import 'package:dirasti_dashboard/module/course_module.dart';
import 'package:dirasti_dashboard/module/file_module.dart';
import 'package:dirasti_dashboard/module/subject_module.dart';
import 'package:dirasti_dashboard/module/copon_module.dart';
import 'package:dirasti_dashboard/module/copon_module.dart';
import 'package:dirasti_dashboard/module/teacher_module.dart';
import 'package:dirasti_dashboard/utils/const.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:dirasti_dashboard/module/user_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../module/grade_module.dart';
import '../module/user_module.dart';

List<copon_module> copon_list = [];
List<copon_module> sec_copon_list = [];
List<course_module> course_list = [];
List<file_module> file_list = [];
List<teacher_module> teacher_list = [];
List<subject_module> subject_list = [];
List<grade_module> grade_list = [];
ScrollController copon_list_con = ScrollController();
ScrollController user_elment_con = ScrollController();
var filter_type;
var filter_grade;
var filter_tracher;
var filter_file;
var filter_is_open;
var filter_course;
var filter_subject;
class Copon extends StatefulWidget {
  Copon({Key? key}) : super(key: key);

  @override
  State<Copon> createState() => _CoponState();
}

class _CoponState extends State<Copon> {
  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " copon "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            copon_list.add(copon_module.fromjson(element));
            sec_copon_list.add(copon_module.fromjson(element));
            // if (copon_list.length == value.data.length) {
            //   setState(() {});
            // }
          });
        });
        await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " file "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            file_list.add(file_module.fromjson(element));
            // if (copon_list.length == value.data.length) {
            //   setState(() {});
            // }
          });
        });
        await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " course "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            course_list.add(course_module.fromjson(element));
            // if (copon_list.length == value.data.length) {
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
            // if (copon_list.length == value.data.length) {
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
    copon_list.clear();
     course_list.clear();
     file_list.clear();
     teacher_list.clear();
    subject_list.clear();
     grade_list.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (subject_list.isNotEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text("قائمة أكواد التفعيل", style: TextStyle(fontSize: 30)),
              Spacer(),
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  onPressed: () {
                    var name_con = TextEditingController();
                    var price_con = TextEditingController();
                    var uid_con = TextEditingController();
                    var type ;
                    var grade ;
                    var subject ;
                    var tracher ;
                    var course ;
                    var file ;
                    showDialog(context: context, builder: (context)=>StatefulBuilder(
                        builder: (context,setst) {
                          return AlertDialog(
                            content: Column(
                              children: [
                                Text("إنشاء"),
                                SizedBox(height: 20,),
                                Center(child: Text("الاسم")),
                                TextFormField(controller: name_con,textDirection: TextDirection.rtl,),
                                SizedBox(
                                  height: 30,
                                ),
                                Center(child: Text("السعر")),
                                TextFormField(controller: price_con,textDirection: TextDirection.rtl,),
                                SizedBox(
                                  height: 30,
                                ),
                                Center(child: Text("رمز الكود ")),
                               Row(
                                 children: [
                                   ElevatedButton(onPressed: (){
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
                                     uid_con.text=s;
                                   }, child: Text("إنشاء")),
                                   SizedBox(width: 20,),
                                   Expanded(child:  TextFormField(controller: uid_con,),)
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
                                DropdownButton(
                                    value: type ,
                                    items: ["ملفات","كورسات"].map((e) => DropdownMenuItem(child: Text(e),value: ["ملفات","كورسات"].indexOf(e),)).toList(),
                                    //    value: grade_list[0].name,
                                    onChanged: (value){
                                     type = value;
                                     grade = null;
                                     subject = null;
                                     tracher = null;
                                     course=null;
                                      print(value);
                                      setst(() {});
                                    }),
                                Center(child: Text("السنة:")),
                                SizedBox(
                                  width: 30,
                                ),
                                DropdownButton(
                                    value: grade ,
                                    items: grade_list.map((e) => DropdownMenuItem(child: Text(e.name!),value: e.id,)).toList(),
                                    //    value: grade_list[0].name,
                                    onChanged: (value){
                                      grade = value;
                                      subject = null;
                                      tracher = null;
                                      course=null;
                                      print(value);
                                      setst(() {});
                                    }),
                                SizedBox(height: 20,),
                                Text("المادة"),
                                DropdownButton(
                                    value: subject ,
                                    items: subject_list.where((element) => element.grade==grade).map((e) => DropdownMenuItem(child: Text(e.subject!),value: e.id,)).toList(),
                                    //    value: grade_list[0].name,
                                    onChanged: (value){
                                      subject = value;
                                      tracher = null;
                                      course=null;
                                      print(value);
                                      setst(() {});
                                    }),
                                SizedBox(height: 20,),
                                Text("الأستاذ"),
                                DropdownButton(
                                    value: tracher ,
                                    items: teacher_list.where((element) => element.grade==grade && element.subject==subject).map((e) => DropdownMenuItem(child: Text(e.teacher_name!),value: e.id,)).toList(),
                                    //    value: grade_list[0].name,
                                    onChanged: (value){
                                      tracher = value;
                                      course=null;
                                      print(value);
                                      setst(() {});
                                    }),
                                SizedBox(height: 20,),
                                if(type == 1)
                                Text("كورسات"),
                                if(type == 1)
                                DropdownButton(
                                    value: course ,
                                    items: course_list.where((element) => element.grade==grade && element.subject==subject).map((e) => DropdownMenuItem(child: Text(e.name!),value: e.id,)).toList(),
                                    //    value: grade_list[0].name,
                                    onChanged: (value){
                                      course = value;
                                      print(value);
                                      setst(() {});
                                    }),
                                if(type == 0)
                                  Text("ملفات"),
                                if(type == 0)
                                  DropdownButton(
                                      value: file ,
                                      items: file_list.where((element) => element.grade==grade && element.subject==subject).map((e) => DropdownMenuItem(child: Text(e.name!),value: e.id,)).toList(),
                                      //    value: grade_list[0].name,
                                      onChanged: (value){
                                        file = value;
                                        print(value);
                                        setst(() {});
                                      }),

                              ],
                            ),
                            actions: [
                              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                              ElevatedButton(onPressed: (){
                                var l = "$type|$grade|$subject|$tracher|${type==0?file:course}";
                                dio.post_data(url: "/dash/insert",quary: {"table":" copon " , "sql_key":"  list_cours ,  is_open  , name_copon ,  uid_copon , price , grade " , "sql_value":"  '$l' , '1' , '${name_con.text}' , '${uid_con.text}' , '${price_con.text}', '$grade' " }).then((value) {
                                  print(value?.data);
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " copon "}).then((value) {
                                    copon_list.clear();
                                    value?.data.forEach((element) {
                                      print(element);
                                      copon_list.add(copon_module.fromjson(element));
                                      if (copon_list.length == value.data.length) {
                                        setState(() {});
                                      }
                                    });
                                  });
                                  Navigator.pop(context);
                                });
                              },child: Text("موافق")),
                            ],
                          );
                        }
                    ));
                  },
                  child: Text("إضافة كود")),
              SizedBox(
                width: 30,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(width: 20,),
              Text("النوع"),
              SizedBox(width: 10,),
              DropdownButton(
                  value: filter_type ,
                  items: ["ملفات","كورسات"].map((e) => DropdownMenuItem(child: Text(e),value: ["ملفات","كورسات"].indexOf(e),)).toList(),
                  //    value: grade_list[0].name,
                  onChanged: (value){
                    filter_type = value;
                    filter_grade = null;
                    filter_subject = null;
                    filter_tracher = null;
                    filter_course=null;
                    print(value);
                    setState(() {
                      copon_list.clear();
                      copon_list.addAll(sec_copon_list);
                      copon_list.removeWhere((element) => value.toString() != element.list_cours![0].toString());
                      });
                  }),
              SizedBox(width: 20,),
              Center(child: Text("السنة:")),
              SizedBox(
                width: 30,
              ),
              DropdownButton(
                  value: filter_grade ,
                  items: grade_list.map((e) => DropdownMenuItem(child: Text(e.name!),value: e.id,)).toList(),
                  //    value: grade_list[0].name,
                  onChanged: (value){
                    filter_grade = value;
                    filter_subject = null;
                    filter_tracher = null;
                    filter_course=null;
                    print(value);
                    setState(() {
                      copon_list.clear();
                      copon_list.addAll(sec_copon_list);
                      copon_list.removeWhere((element) => filter_type.toString() != element.list_cours![0].toString() || element.grade !=filter_grade.toString());
                      });
                  }),
              SizedBox(width: 20,),
              Text("المادة"),
              DropdownButton(
                  value: filter_subject ,
                  items: subject_list.where((element) => element.grade==filter_grade).map((e) => DropdownMenuItem(child: Text(e.subject!),value: e.id,)).toList(),
                  //    value: grade_list[0].name,
                  onChanged: (value){
                    filter_subject = value;
                    filter_tracher = null;
                    filter_course=null;
                    print(value);
                    setState(() {
                      copon_list.clear();
                      copon_list.addAll(sec_copon_list);
                      copon_list.removeWhere((element) => filter_type.toString() != element.list_cours![0].toString() || element.grade !=filter_grade.toString() ||filter_subject.toString()!=element.list_cours![2] );
                      });
                  }),
              SizedBox(width: 20,),
              Text("الأستاذ"),
              DropdownButton(
                  value: filter_tracher ,
                  items: teacher_list.where((element) => element.grade==filter_grade && element.subject==filter_subject).map((e) => DropdownMenuItem(child: Text(e.teacher_name!),value: e.id,)).toList(),
                  //    value: grade_list[0].name,
                  onChanged: (value){
                    filter_tracher = value;
                    filter_course=null;
                    print(value);
                    setState(() {
                      copon_list.clear();
                      copon_list.addAll(sec_copon_list);
                      copon_list.removeWhere((element) => filter_type.toString() != element.list_cours![0].toString() || element.grade !=filter_grade.toString() ||filter_subject.toString()!=element.list_cours![2] ||filter_tracher.toString()!=element.list_cours![3] );
                    });
                  }),
              SizedBox(width: 20,),
              if(filter_type == 1)
                Text("كورسات"),
              if(filter_type == 1)
                DropdownButton(
                    value: filter_course ,
                    items: course_list.where((element) => element.grade==filter_grade && element.subject==filter_subject).map((e) => DropdownMenuItem(child: Text(e.name!),value: e.id,)).toList(),
                    //    value: grade_list[0].name,
                    onChanged: (value){
                      filter_course = value;
                      print(value);
                      setState(() {
                        copon_list.clear();
                        copon_list.addAll(sec_copon_list);
                        copon_list.removeWhere((element) => filter_type.toString() != element.list_cours![0].toString() || element.grade !=filter_grade.toString() ||filter_subject.toString()!=element.list_cours![2] ||filter_tracher.toString()!=element.list_cours![3] ||filter_course.toString()!=element.list_cours![4] );

                      });
                    }),
              if(filter_type == 0)
                Text("ملفات"),
              if(filter_type == 0)
                DropdownButton(
                    value: filter_file ,
                    items: file_list.where((element) => element.grade==filter_grade && element.subject==filter_subject).map((e) => DropdownMenuItem(child: Text(e.name!),value: e.id,)).toList(),
                    //    value: grade_list[0].name,
                    onChanged: (value){
                      filter_file = value;
                      print(value);
                      setState(() {
                        copon_list.clear();
                        copon_list.addAll(sec_copon_list);
                        copon_list.removeWhere((element) => filter_type.toString() != element.list_cours![0].toString() || element.grade !=filter_grade.toString() ||filter_subject.toString()!=element.list_cours![2] ||filter_tracher.toString()!=element.list_cours![3] ||filter_file.toString()!=element.list_cours![4] );

                      });
                    }),
              DropdownButton(
                  value: filter_is_open ,
                  items: ["مستعمل","غير مستعمل"].map((e) => DropdownMenuItem(child: Text(e),value: ["مستعمل","غير مستعمل"].indexOf(e),)).toList(),
                  //    value: grade_list[0].name,
                  onChanged: (value){
                    filter_is_open = value;
                    print(value);
                    setState(() {
                      copon_list.clear();
                      copon_list.addAll(sec_copon_list);
                      copon_list.removeWhere((element) => filter_type.toString() != element.list_cours![0].toString() || element.grade !=filter_grade.toString() ||filter_subject.toString()!=element.list_cours![2] ||filter_tracher.toString()!=element.list_cours![3] ||filter_file.toString()!=element.list_cours![4] || filter_is_open != element.is_open );

                    });
                  }),
              SizedBox(width: 40,),
              ElevatedButton(onPressed: (){
                filter_type = null;
                filter_grade = null;
                filter_subject = null;
                filter_tracher = null;
                filter_course=null;
                setState(() {
                  copon_list.clear();
                  copon_list.addAll(sec_copon_list);
                });
              }, child: Text("إعادة الفلتر"))
            ],
          ),
          SizedBox(height: 20,),
          Expanded(
            child: Scrollbar(
              controller: copon_list_con,
              child: ListView.separated(
                  shrinkWrap: true,
                  controller: copon_list_con,
                  itemBuilder: (context, index) {
                    return ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200), child: copon_list_element(context, copon_list[index], setState));
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey.shade300,
                    );
                  },
                  itemCount: copon_list.length),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            color: Colors.white,
            child: const Center(
              child: Text(
                'الأكواد',
                style: TextStyle(fontSize: 35),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: ElevatedButton(onPressed: (){
          //
          //   }, child: Text("إعادة الفلتر")),
          // )
        ],
      );
    }
  }
}

Widget copon_list_element(BuildContext context, copon_module model, setstate) {
  var con = ScrollController();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.grey.shade100,
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
                  SizedBox(
                    width: 30,
                  ),
                  Center(child: Text("الرمز التسلسلي: ${model.id!}")),
                  SizedBox(
                    width: 30,
                  ),
                  //   Text( MediaQuery.of(context).size.width.toString()),
                  Center(child: Text("الاسم: ${model.name_copon!}")),
                  SizedBox(
                    width: 30,
                  ),
                  Center(child: Text("السعر: ${model.price!}")),
                  SizedBox(
                    width: 30,
                  ),
                  Center(child: Text(model.is_open!?"غير مستخدم":"مستحدم")),
                  SizedBox(
                    width: 30,
                  ),
                  Center(child: Text("رمز الكود: ")),
                  Directionality(textDirection: TextDirection.ltr,child: Center(child: Text(model.uid_copon!))),
                  SizedBox(
                    width: 30,
                  ), Center(child: Text(model.list_cours![0]=="0"?"ملف":"كورس")),
                  SizedBox(
                    width: 30,
                  ),
                  Center(child: Text("السنة:")),
                  SizedBox(
                    width: 10,
                  ),
                  Center(child: Text(grade_list.where((element) => element.id == model.list_cours![1]).first.name??"غير متوفر")),
                  SizedBox(
                    width: 30,
                  ),
                  Center(child: Text("المادة:")),
                  SizedBox(
                    width: 10,
                  ),
                  Center(child: Text(subject_list.where((element) => element.id == model.list_cours![2]).first.subject??"غير متوفر")),
                  SizedBox(
                    width: 30,
                  ),
                  Center(child: Text("اسم الاستاذ:")),
                  SizedBox(
                    width: 10,
                  ),
                  Center(child: Text(teacher_list.where((element) => element.id == model.list_cours![3]).first.teacher_name??"غير متوفر")),
                  SizedBox(
                    width: 30,
                  ),
                  if(model.add_by!=null)
                  Center(child: Text("تم التفعيل من قبل:" + model.add_by!)),
                  if(model.add_by!=null)
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  if(model.list_cours![0].toString() == "0")
                    Center(child: Text("اسم الملف:")),
                  if(model.list_cours![0].toString() == "0")
                  SizedBox(
                    width: 10,
                  ),
                  if(model.list_cours![0].toString() == "0")
                  Center(child: Text(file_list.where((element) => element.id == model.list_cours![4]).first.name??"غير متوفر")),
                  if(model.list_cours![0].toString() == "1")
                  Center(child: Text("اسم الكورس:")),
                  if(model.list_cours![0].toString() == "1")
                  SizedBox(
                    width: 10,
                  ),
                  if(model.list_cours![0].toString() == "1")
                  Center(child: Text(course_list.where((element) => element.id == model.list_cours![4]).first.name??"غير متوفر")),
                  if (MediaQuery.of(context).size.width > 500)
                    SizedBox(
                      width: MediaQuery.of(context).size.width.toDouble() / 8,
                    ),
                  // Text(model.name!),
                  //Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: () async {
                      Future<ui.Image> _loadOverlayImage() async {
                        final completer = Completer<ui.Image>();
                        final byteData = await rootBundle.load('assets/logo.png');
                        ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
                        return completer.future;
                      }
                       await _loadOverlayImage().then((value) async {
                         final image = await QrPainter(
                             data:model.uid_copon!,
                             version: QrVersions.auto,
                             errorCorrectionLevel: QrErrorCorrectLevel.Q,
                          //      embeddedImage: value,
                            gapless: true,
                             color: Colors.black,
                             emptyColor: Colors.white,
                         ).toImageData(400);

                         var pngBytes = base64Encode(image!.buffer.asUint8List());

                         var download = document.createElement('a') as AnchorElement;

                         download.href = 'data:image/png;base64,'+pngBytes;
                         download.download = model.uid_copon!+'.png';
                         download.click();
                         download.remove();
                       });



                    }, child: Text("أستخراج qr")),
                  ),
                  // SizedBox(width: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          var name_con = TextEditingController(text:model.name_copon);
                          var price_con = TextEditingController(text: model.price);
                          var uid_con = TextEditingController(text: model.uid_copon);
                          var type =model.list_cours?[0];
                          var grade=model.list_cours?[1];
                          var subject=model.list_cours?[2];
                          var tracher=model.list_cours?[3];
                          var course=model.list_cours?[4];
                          var file=model.list_cours?[4];
                          var is_open=model.is_open;
                          showDialog(context: context, builder: (context)=>StatefulBuilder(
                              builder: (context,setst) {
                                return AlertDialog(
                                  content: Column(
                                    children: [
                                      Text("تعديل"),
                                      SizedBox(height: 20,),
                                      Center(child: Text("الاسم")),
                                      TextFormField(controller: name_con,textDirection: TextDirection.rtl,),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Center(child: Text("السعر")),
                                      TextFormField(controller: price_con,textDirection: TextDirection.rtl,),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Center(child: Text("رمز الكود ")),
                                      Row(
                                        children: [
                                          ElevatedButton(onPressed: (){
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
                                            uid_con.text=s;
                                          }, child: Text("إنشاء")),
                                          SizedBox(width: 20,),
                                          Expanded(child:  TextFormField(controller: uid_con,),)
                                        ],
                                      ),
                                      SizedBox(width: 20,),
                                      Text("يعمل؟"),
                                      Switch(value: is_open!, onChanged: (value){
                                        setst((){
                                          is_open=value;
                                        });
                                      }),
                                      // Directionality(textDirection: TextDirection.ltr,child: Center(child: Text(model.uid_copon!))),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Center(child: Text("النوع:")),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      DropdownButton(
                                          value: type ,
                                          items: ["ملفات","كورسات"].map((e) => DropdownMenuItem(child: Text(e),value: ["ملفات","كورسات"].indexOf(e).toString(),)).toList(),
                                          //    value: grade_list[0].name,
                                          onChanged: (value){
                                            type = value.toString();
                                            grade = null;
                                            subject = null;
                                            tracher = null;
                                            course=null;
                                            print(value);
                                            setst(() {});
                                          }),
                                      Center(child: Text("السنة:")),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      DropdownButton(
                                          value: grade ,
                                          items: grade_list.map((e) => DropdownMenuItem(child: Text(e.name!),value: e.id,)).toList(),
                                          //    value: grade_list[0].name,
                                          onChanged: (value){
                                            grade = value;
                                            subject = null;
                                            tracher = null;
                                            course=null;
                                            print(value);
                                            setst(() {});
                                          }),
                                      SizedBox(height: 20,),
                                      Text("المادة"),
                                      DropdownButton(
                                          value: subject ,
                                          items: subject_list.where((element) => element.grade==grade).map((e) => DropdownMenuItem(child: Text(e.subject!),value: e.id,)).toList(),
                                          //    value: grade_list[0].name,
                                          onChanged: (value){
                                            subject = value;
                                            tracher = null;
                                            course=null;
                                            print(value);
                                            setst(() {});
                                          }),
                                      SizedBox(height: 20,),
                                      Text("الأستاذ"),
                                      DropdownButton(
                                          value: tracher ,
                                          items: teacher_list.where((element) => element.grade==grade && element.subject==subject).map((e) => DropdownMenuItem(child: Text(e.teacher_name!),value: e.id,)).toList(),
                                          //    value: grade_list[0].name,
                                          onChanged: (value){
                                            tracher = value;
                                            course=null;
                                            print(value);
                                            setst(() {});
                                          }),
                                      SizedBox(height: 20,),
                                      if(type == 1)
                                        Text("كورسات"),
                                      if(type == 1)
                                        DropdownButton(
                                            value: course ,
                                            items: course_list.where((element) => element.grade==grade && element.subject==subject).map((e) => DropdownMenuItem(child: Text(e.name!),value: e.id,)).toList(),
                                            //    value: grade_list[0].name,
                                            onChanged: (value){
                                              course = value;
                                              print(value);
                                              setst(() {});
                                            }),
                                      if(type == 0)
                                        Text("ملفات"),
                                      if(type == 0)
                                        DropdownButton(
                                            value: file ,
                                            items: file_list.where((element) => element.grade==grade && element.subject==subject).map((e) => DropdownMenuItem(child: Text(e.name!),value: e.id,)).toList(),
                                            //    value: grade_list[0].name,
                                            onChanged: (value){
                                              file = value;
                                              print(value);
                                              setst(() {});
                                            }),

                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                                    ElevatedButton(onPressed: (){
                                      var l = "$type|$grade|$subject|$tracher|${type=='0'?file:course}";
                                      dio.post_data(url: "/dash/update_id", quary: {
                                        "table": "copon",
                                        "sql_key": " is_open = '${is_open! ? "1":"0"}' , list_cours = '$l' , name_copon = '${name_con.text}' , uid_copon = '${uid_con.text}' , price = '${price_con.text}' , grade = '${grade}'  ",
                                        "id": model.id
                                      })                                        .then((value) {
                                        print(value?.data);
                                        dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " copon "}).then((value) {
                                          copon_list.clear();
                                          value?.data.forEach((element) {
                                            print(element);
                                            copon_list.add(copon_module.fromjson(element));
                                            if (copon_list.length == value.data.length) {
                                              setstate(() {});
                                            }
                                          });
                                        });
                                        Navigator.pop(context);
                                      });
                                    },child: Text("موافق")),
                                  ],
                                );
                              }
                          ));
                        },
                        child: Text("تعديل كود")),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: ElevatedButton(
                  //       onPressed: () {
                  //         // var name_con = TextEditingController(text: model.name);
                  //         // var price_con = TextEditingController(text: model.price);
                  //         // var part_con = TextEditingController(text: model.part);
                  //         // var hour_con = TextEditingController(text: model.number_hours);
                  //         // var is_free_con = TextEditingController(text: model.is_free! ?"1":"0");
                  //         // var grade = model.grade;
                  //         // var subject = model.subject;
                  //         // var tracher =model.teacher_name;
                  //         // showDialog(context: context, builder: (context)=>StatefulBuilder(
                  //         //     builder: (context,setst) {
                  //         //       return AlertDialog(
                  //         //         content: Column(
                  //         //           children: [
                  //         //             Text("إنشاء"),
                  //         //             SizedBox(height: 20,),
                  //         //             Text("الاسم"),
                  //         //             TextFormField(controller: name_con,textDirection: TextDirection.rtl,),
                  //         //             SizedBox(height: 20,),
                  //         //             Text("السعر"),
                  //         //             TextFormField(controller: price_con,textDirection: TextDirection.rtl,),
                  //         //             SizedBox(height: 20,),
                  //         //             Text("عدد الأجزاء"),
                  //         //             TextFormField(controller: part_con,textDirection: TextDirection.rtl,),
                  //         //             SizedBox(height: 20,),
                  //         //             Text("عدد الساعات"),
                  //         //             TextFormField(controller: hour_con,textDirection: TextDirection.rtl,),
                  //         //             SizedBox(height: 20,),
                  //         //             Text("هل مجاني  0 للمدفوع  1 للمجاني"),
                  //         //             TextFormField(controller: is_free_con,textDirection: TextDirection.rtl,),
                  //         //             SizedBox(height: 20,),
                  //         //             Text("السنة"),
                  //         //             DropdownButton(
                  //         //                 value: grade ?? grade_list[0].id,
                  //         //                 items: grade_list.map((e) => DropdownMenuItem(child: Text(e.name!),value: e.id,)).toList(),
                  //         //                 //    value: grade_list[0].name,
                  //         //                 onChanged: (value){
                  //         //                   grade = value;
                  //         //                   print(value);
                  //         //                   setst(() {});
                  //         //                 }),
                  //         //             SizedBox(height: 20,),
                  //         //             Text("المادة"),
                  //         //             DropdownButton(
                  //         //                 value: subject ,
                  //         //                 items: subject_list.where((element) => element.grade==grade).map((e) => DropdownMenuItem(child: Text(e.subject!),value: e.id,)).toList(),
                  //         //                 //    value: grade_list[0].name,
                  //         //                 onChanged: (value){
                  //         //                   subject = value;
                  //         //                   print(value);
                  //         //                   setst(() {});
                  //         //                 }),
                  //         //             SizedBox(height: 20,),
                  //         //             Text("الأستاذ"),
                  //         //             DropdownButton(
                  //         //                 value: tracher ,
                  //         //                 items: teacher_list.where((element) => element.grade==grade && element.subject==subject).map((e) => DropdownMenuItem(child: Text(e.teacher_name!),value: e.id,)).toList(),
                  //         //                 //    value: grade_list[0].name,
                  //         //                 onChanged: (value){
                  //         //                   tracher = value;
                  //         //                   print(value);
                  //         //                   setst(() {});
                  //         //                 }),
                  //         //           ],
                  //         //         ),
                  //         //         actions: [
                  //         //           ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                  //         //           ElevatedButton(onPressed: (){
                  //         //             dio.post_data(url: "/dash/update_id",quary: {"table":" copon ","id":model.id,"sql_key":" teacher_name = '${tracher}' , grade = '$grade' , photo = '${model.photo}' , subject = '$subject' , name = '${name_con.text}' , price = '${price_con.text}' , part = '${part_con.text}' , number_hours = '${hour_con.text}' , is_free = '${is_free_con.text}' "}).then((value) {
                  //         //               print(value?.data);
                  //         //               dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " copon "}).then((value) {
                  //         //                 copon_list.clear();
                  //         //                 value?.data.forEach((element) {
                  //         //                   print(element);
                  //         //                   copon_list.add(copon_module.fromjson(element));
                  //         //                   if (copon_list.length == value.data.length) {
                  //         //                     setstate(() {});
                  //         //                   }
                  //         //                 });
                  //         //               });
                  //         //               Navigator.pop(context);
                  //         //             });
                  //         //           },child: Text("موافق")),
                  //         //         ],
                  //         //       );
                  //         //     }
                  //         // ));
                  //       },
                  //       child: Text("تعديل ")),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog(context: context, builder: (context)=>AlertDialog(
                            title:Text("هل انت متأكد")
                            ,actions: [
                            ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                            ElevatedButton(onPressed: (){
                              dio.post_data(url: "/dash/delet_id",quary: {"table":" copon ","id":model.id}).then((value) {
                                print(value);
                                setstate(() {
                                  copon_list.clear();
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " copon "}).then((value) {
                                    value?.data.forEach((element) {
                                      print(element);
                                      copon_list.add(copon_module.fromjson(element));
                                      if (copon_list.length == value.data.length) {
                                        setstate(() {});
                                      }
                                    });
                                  });
                                });
                                Navigator.pop(context);
                              });
                            }, child: Text("موافق")),
                          ],));
                        },
                        child: Text("حذف")),
                  ),
                ],
              ),
            ),
          ),
        ),
        //  Spacer(),
      ],
    ),
  );
}

