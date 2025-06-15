import 'dart:html';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dirasti_dashboard/layout/part.dart';
import 'package:dirasti_dashboard/module/course_module.dart';
import 'package:dirasti_dashboard/module/subject_module.dart';
import 'package:dirasti_dashboard/module/course_module.dart';
import 'package:dirasti_dashboard/module/course_module.dart';
import 'package:dirasti_dashboard/module/teacher_module.dart';
import 'package:dirasti_dashboard/utils/const.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:dirasti_dashboard/module/user_module.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:uuid/uuid.dart';

import '../module/grade_module.dart';
import '../module/user_module.dart';

List<course_module> course_list = [];
List<teacher_module> teacher_list = [];
List<subject_module> subject_list = [];
List<grade_module> grade_list = [];
ScrollController course_list_con = ScrollController();
ScrollController user_elment_con = ScrollController();

class Course extends StatefulWidget {
  Course({Key? key}) : super(key: key);

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  @override
  void initState()  {
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
    subject_list.clear();
    grade_list.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (course_list.isNotEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text("قائمة الكورسات", style: TextStyle(fontSize: 30)),
              Spacer(),
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  onPressed: () {
                    var name_con = TextEditingController();
                    var des_con = TextEditingController();
                    var price_con = TextEditingController();
                    var part_con = TextEditingController();
                    var hour_con = TextEditingController();
                    var is_free_con = TextEditingController();
                    var order_con = TextEditingController();
                    var grade ;
                    var subject ;
                    var tracher ;
                    var image_link ;
                    var banner_link ;
                    showDialog(context: context, builder: (context)=>StatefulBuilder(
                        builder: (context,setst) {
                          return AlertDialog(
                            scrollable: true,
                            content: Column(
                              children: [
                                Text("إنشاء"),
                                SizedBox(height: 20,),
                                Text("الاسم"),
                                TextFormField(controller: name_con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Text("الوصف"),
                                TextFormField(controller: des_con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Text("السعر"),
                                TextFormField(controller: price_con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Text("عدد الأجزاء"),
                                TextFormField(controller: part_con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Text("عدد الساعات"),
                                TextFormField(controller: hour_con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Text("هل مجاني  0 للمدفوع  1 للمجاني"),
                                TextFormField(controller: is_free_con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Text("الترتيب"),
                                TextFormField(controller: order_con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Text("السنة"),
                                DropdownButton(
                                    value: grade ?? grade_list[0].id,
                                    items: grade_list.map((e) => DropdownMenuItem(child: Text(e.name!),value: e.id,)).toList(),
                                    //    value: grade_list[0].name,
                                    onChanged: (value){
                                      grade = value;
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
                                      print(value);
                                      setst(() {});
                                    }),
                                SizedBox(height: 20,),
                                ElevatedButton(
                                    onPressed: () async {
                                      // final ImagePicker _picker = ImagePicker();
                                      // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                                      // FilePickerResult? image = await FilePicker.platform
                                      //     .pickFiles(allowedExtensions: ['png'], allowMultiple: false, type: FileType.custom);
                                      Uint8List? image = await ImagePickerWeb.getImageAsBytes();
                                      if (image != null) {
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Container(height: 50, width: 50, child: CircularProgressIndicator()),
                                            );
                                          },
                                        );
                                        // String dir = image.files[0].name.split(".").last;
                                        FormData formData =
                                        FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: Uuid().v4()+".png")});
                                        dio.post_data(url: "/uplade/uplode", data: formData).then((value) {
                                          print(value?.data);
                                          Tost_widget("تم رفع الصورة", "green");
                                          image_link = value?.data;
                                          Navigator.pop(context);
                                        });

                                      }
                                    },
                                    child: Text("تغيير الصورة")),
                                SizedBox(height: 20,),
                                ElevatedButton(
                                    onPressed: () async {
                                      // final ImagePicker _picker = ImagePicker();
                                      // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                                      // FilePickerResult? image = await FilePicker.platform
                                      //     .pickFiles(allowedExtensions: ['png'], allowMultiple: false, type: FileType.custom);
                                      Uint8List? image = await ImagePickerWeb.getImageAsBytes();
                                      if (image != null) {
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Container(height: 50, width: 50, child: CircularProgressIndicator()),
                                            );
                                          },
                                        );
                                        // String dir = image.files[0].name.split(".").last;
                                        FormData formData =
                                        FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: Uuid().v4()+".png")});
                                        dio.post_data(url: "/uplade/uplode", data: formData).then((value) {
                                          print(value?.data);
                                          Tost_widget("تم رفع الصورة", "green");
                                          banner_link = value?.data;
                                          Navigator.pop(context);
                                        });

                                      }
                                    },
                                    child: Text("تغيير البانر")),
                              ],
                            ),
                            actions: [
                              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                              ElevatedButton(onPressed: (){
                                dio.post_data(url: "/dash/insert",quary: {"table":" course " , "sql_key":" name , teacher_name , subject , price , photo , grade  , part , number_hours , is_free ,des , banner , ordero " , "sql_value":" ' ${name_con.text}' , '$tracher', $subject , '${price_con.text}' , '$image_link' , '$grade', '${part_con.text}' , '${hour_con.text}' , '${is_free_con.text}' , '${des_con.text}' , '$banner_link' , '${order_con.text}' " }).then((value) {
                                  print(value?.data);
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " course "}).then((value) {
                                    course_list.clear();
                                    value?.data.forEach((element) {
                                      print(element);
                                      course_list.add(course_module.fromjson(element));
                                      if (course_list.length == value.data.length) {
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
                  child: Text("إضافة كورس")),
              SizedBox(
                width: 30,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Scrollbar(
              controller: course_list_con,
              child: ListView.separated(
                  shrinkWrap: true,
                  controller: course_list_con,
                  itemBuilder: (context, index) {
                    return ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200), child: course_list_element(context, course_list[index], setState));
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey.shade300,
                    );
                  },
                  itemCount: course_list.length),
            ),
          ),
        ],
      );
    } else {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'الكورسات',
            style: TextStyle(fontSize: 35),
          ),
        ),
      );
    }
  }
}

Widget course_list_element(BuildContext context, course_module model, setstate) {
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
                  // Text(model.name!),
                  //Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Part(course: model,)));
                    }  , child: Text("الأجزاء")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          var name_con = TextEditingController(text: model.name);
                          var des_con = TextEditingController(text: model.des);
                          var price_con = TextEditingController(text: model.price);
                          var part_con = TextEditingController(text: model.part);
                          var hour_con = TextEditingController(text: model.number_hours);
                          var order_con = TextEditingController(text: model.order);
                          var is_free_con = TextEditingController(text: model.is_free! ?"1":"0");
                          var grade = model.grade;
                          var subject = model.subject;
                          var tracher =model.teacher_name;
                          var banner =model.banner;
                          var image_link =model.photo;
                          showDialog(context: context, builder: (context)=>StatefulBuilder(
                              builder: (context,setst) {
                                return AlertDialog(
                                  scrollable: true,
                                  content: Column(
                                    children: [
                                      Text("إنشاء"),
                                      SizedBox(height: 20,),
                                      Text("الاسم"),
                                      TextFormField(controller: name_con,textDirection: TextDirection.rtl,),
                                      SizedBox(height: 20,),
                                      Text("الوصف"),
                                      TextFormField(controller: des_con,textDirection: TextDirection.rtl,),
                                      SizedBox(height: 20,),
                                      Text("السعر"),
                                      TextFormField(controller: price_con,textDirection: TextDirection.rtl,),
                                      SizedBox(height: 20,),
                                      Text("عدد الأجزاء"),
                                      TextFormField(controller: part_con,textDirection: TextDirection.rtl,),
                                      SizedBox(height: 20,),
                                      Text("عدد الساعات"),
                                      TextFormField(controller: hour_con,textDirection: TextDirection.rtl,),
                                      SizedBox(height: 20,),
                                      Text("هل مجاني  0 للمدفوع  1 للمجاني"),
                                      TextFormField(controller: is_free_con,textDirection: TextDirection.rtl,),
                                      SizedBox(height: 20,),
                                      Text("الترتيب"),
                                      TextFormField(controller: order_con,textDirection: TextDirection.rtl,),
                                      SizedBox(height: 20,),
                                      Text("السنة"),
                                      DropdownButton(
                                          value: grade ?? grade_list[0].id,
                                          items: grade_list.map((e) => DropdownMenuItem(child: Text(e.name!),value: e.id,)).toList(),
                                          //    value: grade_list[0].name,
                                          onChanged: (value){
                                            grade = value;
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
                                            print(value);
                                            setst(() {});
                                          }),
                                      SizedBox(height: 20,),
                                      ElevatedButton(
                                          onPressed: () async {
                                            // final ImagePicker _picker = ImagePicker();
                                            // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                                            // FilePickerResult? image = await FilePicker.platform
                                            //     .pickFiles(allowedExtensions: ['png'], allowMultiple: false, type: FileType.custom);
                                            Uint8List? image = await ImagePickerWeb.getImageAsBytes();
                                            if (image != null) {
                                              // String dir = image.files[0].name.split(".").last;
                                              FormData formData =
                                              FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: name_con.text)});
                                              dio.post_data(url: "/uplade/uplode", data: formData).then((value) {
                                                Tost_widget("تم رفع الصورة", "green");
                                                image_link = value?.data;
                                                Navigator.pop(context);
                                              });
                                              showDialog<void>(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Container(height: 50, width: 50, child: CircularProgressIndicator()),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: Text("تغيير الصورة")),
                                      SizedBox(height: 20,),
                                      ElevatedButton(
                                          onPressed: () async {
                                            // final ImagePicker _picker = ImagePicker();
                                            // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                                            // FilePickerResult? image = await FilePicker.platform
                                            //     .pickFiles(allowedExtensions: ['png'], allowMultiple: false, type: FileType.custom);
                                            Uint8List? image = await ImagePickerWeb.getImageAsBytes();
                                            if (image != null) {
                                              // String dir = image.files[0].name.split(".").last;
                                              FormData formData =
                                              FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: name_con.text)});
                                              dio.post_data(url: "/uplade/uplode", data: formData).then((value) {
                                                Tost_widget("تم رفع الصورة", "green");
                                                banner = value?.data;
                                                Navigator.pop(context);
                                              });
                                              showDialog<void>(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Container(height: 50, width: 50, child: CircularProgressIndicator()),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: Text("تغيير البانر")),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                                    ElevatedButton(onPressed: (){
                                      dio.post_data(url: "/dash/update_id",
                                          data: {
                                            "sql_key":" teacher_name = '${tracher}' , grade = '$grade' , photo = '$image_link' , banner = '$banner' , subject = '$subject' , name = '${name_con.text}'  , ordero = '${order_con.text}'  , des = '${des_con.text}' , price = '${price_con.text}' , part = '${part_con.text}' , number_hours = '${hour_con.text}' , is_free = '${is_free_con.text}' "

                                          }
                                          ,quary: {
                                        "table":" course ",
                                        "id":model.id,
                                      }).then((value) {
                                        print(value?.data);
                                        dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " course "}).then((value) {
                                          course_list.clear();
                                          value?.data.forEach((element) {
                                            print(element);
                                            course_list.add(course_module.fromjson(element));
                                            if (course_list.length == value.data.length) {
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
                        child: Text("تعديل ")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog(context: context, builder: (context)=>AlertDialog(
                            title:Text("هل انت متأكد")
                            ,actions: [
                            ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                            ElevatedButton(onPressed: (){
                              dio.post_data(url: "/dash/delet_id",quary: {"table":" course ","id":model.id}).then((value) {
                                print(value);
                                setstate(() {
                                  course_list.clear();
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " course "}).then((value) {
                                    value?.data.forEach((element) {
                                      print(element);
                                      course_list.add(course_module.fromjson(element));
                                      if (course_list.length == value.data.length) {
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

