import 'dart:convert';
import 'dart:js_util';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dirasti_dashboard/module/course_module.dart';
import 'package:dirasti_dashboard/module/part_module.dart';
import 'package:dirasti_dashboard/module/subject_module.dart';
import 'package:flutter/material.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:uuid/uuid.dart';

import '../utils/const.dart';
double persent = 0;
int loading_type = 0;
List<part_module> part_list = [];
var loading_index = null;
Map res_new = {
  "دقة منخفضة":"",
  "دقة متوسطة":"",
  "دقة مرتفعة":"",
};
class Part extends StatefulWidget {
  const Part({Key? key, required this.course}) : super(key: key);
  final course_module course;
  @override
  _PartState createState() => _PartState(course);
}

class _PartState extends State<Part> {
  final course_module course;

  _PartState(this.course);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " part "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            part_list.add(part_module.fromjson(element));
            // if (course_list.length == value.data.length) {
            //   setState(() {});
            // }
          });
        });
      } catch (e) {
        print(e);
      } finally {
        part_list.removeWhere((element) => element.course != course.id);
        part_list.sort((a, b) => a.order!.compareTo(b.order!),);
        part_list.forEach((element) { element.part?.sort((a, b) => a.order!.compareTo(b.order!));});
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaa");
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    part_list.clear();
    loading_index = null;
    persent = 0;
    loading_type = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
        actions: [
          ElevatedButton(onPressed: () {
            var name_con = TextEditingController();
            var order_con = TextEditingController();
            showDialog<void>(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Column(
                    children: [
                      SizedBox(height: 20,),
                      Text("الاسم"),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: name_con,
                      ),
                      Text("الترتيب"),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: order_con,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('موافق'),
                      onPressed: () {
                        dio.post_data(url: "/dash/insert",quary: {"table":" part " , "sql_key":" name , ordero , teacher_name , subject , part  , grade  , course " , "sql_value":" '${name_con.text}' , '${order_con.text}' , '${course.teacher_name}', ${course.subject} , '[]' , '${course.grade}', '${course.id}' " }).then((value) async {
                          await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " part "}).then((value) {
                            part_list.clear();
                            value?.data.forEach((element) {
                              print(element);
                              part_list.add(part_module.fromjson(element));
                              if (part_list.length == value.data.length) {
                                part_list.removeWhere((element) => element.course != course.id);
                                part_list.sort((a, b) => a.order!.compareTo(b.order!),);
                                part_list.forEach((element) { element.part?.sort((a, b) => a.order!.compareTo(b.order!));});
                                setState(() {});
                              }
                            });
                          });
                        });
                        Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                      },
                    ),
                    TextButton(
                      child: Text('إلغاء'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                      },
                    ),
                  ],
                );
              },
            );
          }, child: Text(" إنشاء جزء")),
        ],
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: part_list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Center(child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 50,),
                            ElevatedButton( onPressed: () {
                              showDialog(context: context, builder: (context)=>AlertDialog(
                                title:Text("هل انت متأكد")
                                ,actions: [
                                ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                                ElevatedButton(onPressed: (){
                                  dio.post_data(url: "/dash/delet_id",quary: {"table":" part ","id":part_list[index].id}).then((value) {
                                    print(value);
                                    setState(() {
                                      part_list.clear();
                                      dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " part "}).then((value) {
                                        value?.data.forEach((element) {
                                          print(element);
                                          part_list.add(part_module.fromjson(element));
                                          if (part_list.length == value.data.length) {
                                            part_list.removeWhere((element) => element.course != course.id);
                                            part_list.sort((a, b) => a.order!.compareTo(b.order!),);
                                            part_list.forEach((element) { element.part?.sort((a, b) => a.order!.compareTo(b.order!));});
                                            setState(() {});
                                          }
                                        });
                                      });
                                    });
                                    Navigator.pop(context);
                                  });
                                }, child: Text("موافق")),
                              ],));
                            }, child: Text(" حذف")),
                            SizedBox(width: 50,),
                            ElevatedButton(onPressed: () {
                              var name_con = TextEditingController(text: part_list[index].name!);
                              var order_con = TextEditingController(text: part_list[index].order!);
                              showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Column(
                                          children: [
                                            SizedBox(height: 20,),
                                            Text("الاسم"),
                                            SizedBox(height: 20,),
                                            TextFormField(
                                              controller: name_con,
                                            ),
                                            Text("الترتيب"),
                                            SizedBox(height: 20,),
                                            TextFormField(
                                              controller: order_con,
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('موافق'),
                                            onPressed: () {
                                              dio.post_data(url: "/dash/update_id",quary: {"table":" part ","id":part_list[index].id,"sql_key":" name = '${name_con.text}' , ordero = '${order_con.text}' "}).then((value) async {
                                                await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " part "}).then((value) {
                                                  part_list.clear();
                                                  value?.data.forEach((element) {
                                                    print(element);
                                                    part_list.add(part_module.fromjson(element));
                                                    if (part_list.length == value.data.length) {
                                                      part_list.removeWhere((element) => element.course != course.id);
                                                      part_list.sort((a, b) => a.order!.compareTo(b.order!),);
                                                      part_list.forEach((element) { element.part?.sort((a, b) => a.order!.compareTo(b.order!));});
                                                      setState(() {});
                                                    }
                                                  });
                                                });
                                              });
                                              Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                            },
                                          ),
                                          TextButton(
                                            child: Text('إلغاء'),
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }, child: Text(" تعديل الاسم و الترتيب")),
                            SizedBox(width: 50,),
                            ElevatedButton(onPressed: () {
                              var name_con = TextEditingController();
                              var time_con = TextEditingController();
                              var order_con = TextEditingController();
                              showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('إنشاء'),
                                        content: Column(
                                          children: [
                                            Text('الاسم'),
                                            SizedBox(height: 10,),
                                            TextFormField(controller: name_con,textDirection: TextDirection.rtl,),
                                            SizedBox(height: 20,),
                                            Text('الوقت'),
                                            SizedBox(height: 10,),
                                            TextFormField(controller: time_con,textDirection: TextDirection.rtl,),
                                            SizedBox(height: 20,),
                                            Text('الترتيب'),
                                            SizedBox(height: 10,),
                                            TextFormField(controller: order_con,textDirection: TextDirection.rtl,),

                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('موافق'),
                                            onPressed: () {
                                             List<part_detail_module> ad = [];
                                             List<String> part_new = [];
                                             ad.addAll(part_list[index].part!);
                                             print("="*50);
                                             print(ad);
                                              ad.add(part_detail_module(name: name_con.text,time: time_con.text,res: res_new,order: order_con.text));
                                             ad.forEach((element) {part_new.add(json.encode(element.toJson()));});
                                            dio.post_data(url: "/dash/update_id",quary: {"table":" part ","id":part_list[index].id,"sql_key":" part = '${part_new}' "}).then((value) async {
                                              await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " part "}).then((value) {
                                                part_list.clear();
                                                value?.data.forEach((element) {
                                                  print(element);
                                                  part_list.add(part_module.fromjson(element));
                                                  if (part_list.length == value.data.length) {
                                                    part_list.removeWhere((element) => element.course != course.id);
                                                    part_list.sort((a, b) => a.order!.compareTo(b.order!),);
                                                    part_list.forEach((element) { element.part?.sort((a, b) => a.order!.compareTo(b.order!));});
                                                    setState(() {});
                                                  }
                                                });
                                              });
                                            });
                                            Navigator.of(dialogContext).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('إلغاء'),
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }, child: Text("إضافة")),
                            SizedBox(width: 50,),
                            Text("الترتيب"+part_list[index].order!,style: TextStyle(fontSize: 25),),
                            SizedBox(width: 20,),
                            Text(part_list[index].name!,style: TextStyle(fontSize: 25),),


                          ],
                        )),
                        ListView.builder(
                            itemCount: part_list[index].part!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, indexd) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //Spacer(),
                                      SizedBox(width: 50,),
                                      ElevatedButton(onPressed: () {
                                        List<part_detail_module> ad = [];
                                        List<String> part_new = [];
                                        ad.addAll(part_list[index].part!);
                                        print("="*50);
                                        print(ad);
                                        ad.remove(part_list[index].part![indexd]);
                                        ad.forEach((element) {part_new.add(json.encode(element.toJson()));});
                                        dio.post_data(url: "/dash/update_id",quary: {"table":" part ","id":part_list[index].id,"sql_key":" part = '${part_new}' "}).then((value) async {
                                          await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " part "}).then((value) {
                                            part_list.clear();
                                            value?.data.forEach((element) {
                                              print(element);
                                              part_list.add(part_module.fromjson(element));
                                              if (part_list.length == value.data.length) {
                                                part_list.removeWhere((element) => element.course != course.id);
                                                part_list.sort((a, b) => a.order!.compareTo(b.order!),);
                                                part_list.forEach((element) { element.part?.sort((a, b) => a.order!.compareTo(b.order!));});
                                                setState(() {});
                                              }
                                            });
                                          });
                                        });
                                      }, child: Text("حذف")),
                                      SizedBox(width: 50,),
                                      ElevatedButton(onPressed: () async {
                                        Uint8List? image = await ImagePickerWeb.getVideoAsBytes();
                                        if (image != null) {
                                          loading_index = part_list[index].part![indexd];
                                          loading_type = 3;
                                          FormData formData =
                                          FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: Uuid().v4()+".mp4")});
                                          dio.post_data(url: "/uplade/uplode", data: formData,onsend: (start,end){
                                            persent = start / end;
                                            setState(() {});
                                          }).then((value) {
                                            print(value?.data);
                                            Tost_widget("تم رفع الصورة", "green");
                                            var new_res= part_list[index].part![indexd].res;
                                            new_res!["دقة مرتفعة"] = value?.data;
                                            change_part(part_list , index , indexd, part_list[index].part![indexd] ,  null , null , new_res , null);
                                            loading_index = null;
                                            persent=0;
                                            setState(() {});
                                          });
                                        }
                                      }, child:  persent==0 || !equal(loading_index, part_list[index].part![indexd]) || loading_type != 3  ?Text(" تعديل دقة مرتفعة"):CircularProgressIndicator(color: Colors.white,value: persent,)),
                                      SizedBox(width: 50,),
                                      ElevatedButton(onPressed: () async {
                                        Uint8List? image = await ImagePickerWeb.getVideoAsBytes();
                                        if (image != null) {
                                          loading_index = part_list[index].part![indexd];
                                          loading_type = 2;
                                          FormData formData =
                                          FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: Uuid().v4()+".mp4")});
                                          dio.post_data(url: "/uplade/uplode", data: formData,onsend: (start,end){
                                            persent = start / end;
                                            setState(() {});
                                          }).then((value) {
                                            print(value?.data);
                                            Tost_widget("تم رفع الصورة", "green");
                                            var new_res= part_list[index].part![indexd].res;
                                            new_res!["دقة متوسطة"] = value?.data;
                                            change_part(part_list , index , indexd, part_list[index].part![indexd] ,  null , null , new_res , null );
                                            loading_index = null;
                                            persent=0;
                                            setState(() {});
                                          });
                                        }
                                      }, child:  persent==0 || !equal(loading_index, part_list[index].part![indexd]) || loading_type != 2  ?Text("تعديل دقة متوسطة"):CircularProgressIndicator(color: Colors.white,value: persent,)),
                                      SizedBox(width: 50,),
                                      ElevatedButton(onPressed: () async {
                                        Uint8List? image = await ImagePickerWeb.getVideoAsBytes();
                                        if (image != null) {
                                          loading_index = part_list[index].part![indexd];
                                          loading_type = 1;
                                          FormData formData =
                                          FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: Uuid().v4()+".mp4")});
                                          dio.post_data(url: "/uplade/uplode", data: formData,onsend: (start,end){
                                            persent = start / end;
                                            setState(() {});
                                          }).then((value) {
                                            print(value?.data);
                                            Tost_widget("تم رفع الصورة", "green");
                                            var new_res= part_list[index].part![indexd].res;
                                            new_res!["دقة منخفضة"] = value?.data;
                                            change_part(part_list , index , indexd, part_list[index].part![indexd] ,  null , null , new_res , null );
                                            loading_index = null;
                                            persent=0;
                                            setState(() {});
                                          });
                                        }
                                      }, child:  persent==0 || !equal(loading_index, part_list[index].part![indexd]) || loading_type != 1  ?Text("تعديل دقة منخفضة"):CircularProgressIndicator(color: Colors.white,value: persent,)),
                                      SizedBox(width: 50,),
                                      ElevatedButton(onPressed: () {
                                        var name_con = TextEditingController(text: part_list[index].part![indexd].name);
                                        var time_con = TextEditingController(text: part_list[index].part![indexd].time);
                                        var order_con = TextEditingController(text: part_list[index].part![indexd].order);
                                        showDialog<void>(
                                          context: context,
                                          builder: (BuildContext dialogContext) {
                                            return AlertDialog(
                                              title: Text('إنشاء'),
                                              content: Column(
                                                children: [
                                                  Text('الاسم'),
                                                  SizedBox(height: 10,),
                                                  TextFormField(controller: name_con,textDirection: TextDirection.rtl,),
                                                  SizedBox(height: 20,),
                                                  Text('الوقت'),
                                                  SizedBox(height: 10,),
                                                  TextFormField(controller: time_con,textDirection: TextDirection.rtl,),
                                                  SizedBox(height: 20,),
                                                  Text('الترتيب'),
                                                  SizedBox(height: 10,),
                                                  TextFormField(controller: order_con,textDirection: TextDirection.rtl,),
                                                ],
                                              ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('موافق'),
                                                      onPressed: () {
                                                        change_part(part_list , index , indexd, part_list[index].part![indexd] , name_con.text ,  time_con.text , null , order_con.text);
                                                        Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('إلغاء'),
                                                      onPressed: () {
                                                        Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                      }, child: Text(" تعديل الاسم و الوقت و الترتيب")),
                                      SizedBox(width: 50,),
                                      Column(
                                        children: [
                                          Text("الاسم: "+part_list[index].part![indexd].name!),
                                          Text("المدة: "+part_list[index].part![indexd].time!),
                                          Text("الترتيب: "+part_list[index].part![indexd].order!),
                                        ],
                                      ),
                                    ],
                                  ),
                                ))
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
   change_part(List<part_module> part_list , index , indexd,part_detail_module changed , String? name , String? time ,Map? res , String? order ){
    List<part_detail_module> ad = [];
    List<String> part_new = [];
    var new_name = name ?? changed.name;
    var new_time = time ?? changed.time;
    var new_order = order ?? changed.order;
    Map? new_res = res ?? changed.res;
    ad.addAll(part_list[index].part!);
    ad.remove(part_list[index].part![indexd]);
    ad.add(part_detail_module(name: new_name,time: new_time,res: new_res,order:new_order ));
    ad.forEach((element) {part_new.add(json.encode(element.toJson()));});
    dio.post_data(url: "/dash/update_id",quary: {"table":" part ","id":part_list[index].id,"sql_key":" part = '${part_new}' "}).then((value) async {
      await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " part "}).then((value) {
        part_list.clear();
        value?.data.forEach((element) {
          print(element);
          part_list.add(part_module.fromjson(element));
          if (part_list.length == value.data.length) {
            part_list.removeWhere((element) => element.course != course.id);
            part_list.sort((a, b) => a.order!.compareTo(b.order!),);
            part_list.forEach((element) { element.part?.sort((a, b) => a.order!.compareTo(b.order!));});
            setState(() {});
          }
        });
      });
    });
  }
}

