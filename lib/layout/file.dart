import 'dart:html' as html;
import 'dart:html';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dirasti_dashboard/module/file_module.dart';
import 'package:dirasti_dashboard/module/subject_module.dart';

import 'package:dirasti_dashboard/module/teacher_module.dart';
import 'package:dirasti_dashboard/utils/const.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:dirasti_dashboard/module/user_module.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:uuid/uuid.dart';

import '../module/grade_module.dart';
import '../module/user_module.dart';

List<file_module> file_list = [];
List<teacher_module> teacher_list = [];
List<subject_module> subject_list = [];
List<grade_module> grade_list = [];
ScrollController file_list_con = ScrollController();
ScrollController user_elment_con = ScrollController();
double presint =0;
class File_layout extends StatefulWidget {
  File_layout({Key? key}) : super(key: key);

  @override
  State<File_layout> createState() => _File_layoutState();
}

class _File_layoutState extends State<File_layout> {
  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " file "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            file_list.add(file_module.fromjson(element));
            // if (file_list.length == value.data.length) {
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
            // if (file_list.length == value.data.length) {
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
    file_list.clear();
    subject_list.clear();
    grade_list.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (file_list.isNotEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text("قائمة الملفات", style: TextStyle(fontSize: 30)),
              Spacer(),
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  onPressed: () {
                    var name_con = TextEditingController();
                    var price_con = TextEditingController();
                    var des_con = TextEditingController();
                    var hour_con = TextEditingController();
                    var is_free_con = TextEditingController();
                    var order = TextEditingController();
                    var grade ;
                    var subject ;
                    var tracher ;
                    var file_link ;
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
                                Text("السعر"),
                                TextFormField(controller: price_con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Text("الوصف"),
                                TextFormField(controller: des_con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Text("عدد الصفحات"),
                                TextFormField(controller: hour_con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Text("هل مجاني  0 للمدفوع  1 للمجاني"),
                                TextFormField(controller: is_free_con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Text("الترتيب"),
                                TextFormField(controller: order,textDirection: TextDirection.rtl,),
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
                                    Uint8List? image = await ImagePickerWeb.getFileAsBytes();
                                    if (image != null) {
                                      // showDialog<void>(
                                      //   context: context,
                                      //   barrierDismissible: false,
                                      //   builder: (BuildContext context) {
                                      //     return AlertDialog(
                                      //       title: Container(height: 50, width: 50, child: CircularProgressIndicator()),
                                      //     );
                                      //   },
                                      // );
                                      // String dir = image.files[0].name.split(".").last;
                                      FormData formData =
                                      FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: Uuid().v4()+".pdf")});
                                      dio.post_data(url: "/uplade/uplode", data: formData,onsend: (int start, int end) {
                                        presint = start / end;
                                        setst(() {});
                                      }).then((value) {
                                        presint=0;
                                        setst(() {});
                                        print(value?.data);
                                        Tost_widget("تم رفع الملف", "green");
                                        file_link = value?.data;
                                      });

                                    }
                                  },
                                  child: presint==0?Text("تغيير الملف"):CircularProgressIndicator(color: Colors.white,value: presint,),),
                              ],
                            ),
                            actions: [
                              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                              ElevatedButton(onPressed: (){
                                dio.post_data(url: "/dash/insert",quary: {"table":" file " , "sql_key":" name , teacher_name , subject , price , photo , grade  , des , number_of_pages , is_free , link , ordero " , "sql_value":" ' ${name_con.text}' , '$tracher', $subject , '${price_con.text}' , 'https://www.fing.edu.uy/inco/grupos/gsi/img/placeholder.png' , '$grade', '${des_con.text}' , '${hour_con.text}' , '${is_free_con.text}' , '$file_link' , '${order.text}' " }).then((value) {
                                  print(value?.data);
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " file "}).then((value) {
                                    file_list.clear();
                                    value?.data.forEach((element) {
                                      print(element);
                                      file_list.add(file_module.fromjson(element));
                                      if (file_list.length == value.data.length) {
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
                  child: Text("إضافة ملف")),
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
              controller: file_list_con,
              child: ListView.separated(
                  shrinkWrap: true,
                  controller: file_list_con,
                  itemBuilder: (context, index) {
                    return ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200), child: file_list_element(context, file_list[index], setState));
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey.shade300,
                    );
                  },
                  itemCount: file_list.length),
            ),
          ),
        ],
      );
    } else {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'الملفات',
            style: TextStyle(fontSize: 35),
          ),
        ),
      );
    }
  }
}

Widget file_list_element(BuildContext context, file_module model, setstate) {
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
                  // Image.network(model.photo! ,width: 50,height: 50,),
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
                  Center(child: Text("عدد الصفحات: ${model.number_page!}")),
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
                  Center(child: Text(teacher_list.firstWhere((element) => element.id == model.teacher_name).teacher_name??"غير متوفر")),
                  if (MediaQuery.of(context).size.width > 500)
                    SizedBox(
                      width: MediaQuery.of(context).size.width.toDouble() / 8,
                    ),
                  // Text(model.name!),
                  //Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: (){
                      showDialog<void>(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: Text('الوصف'),
                                content: Text(model.des!),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('موافق'),
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }, child: Text("عرض الوصف")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: (){
                      html.window.open(model.link!,"_blank");
                    }, child: Text("عرض الملف")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          var name_con = TextEditingController(text: model.name);
                          var price_con = TextEditingController(text: model.price);
                          var des_con = TextEditingController(text: model.des);
                          var hour_con = TextEditingController(text: model.number_page);
                          var is_free_con = TextEditingController(text: model.is_free! ?"1":"0");
                          var order_con = TextEditingController(text: model.order);
                          var grade = model.grade;
                          var subject = model.subject;
                          var tracher =model.teacher_name;
                          var file_link =model.link;
                          showDialog(
                              context: context, builder: (context)=>StatefulBuilder(
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
                                      Text("السعر"),
                                      TextFormField(controller: price_con,textDirection: TextDirection.rtl,),
                                      SizedBox(height: 20,),
                                      Text("الوصف"),
                                      TextFormField(controller: des_con,textDirection: TextDirection.rtl,),
                                      SizedBox(height: 20,),
                                      Text("عدد الصفحات"),
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
                                            Uint8List? image = await ImagePickerWeb.getFileAsBytes();
                                            if (image != null) {
                                              // showDialog<void>(
                                              //   context: context,
                                              //   barrierDismissible: false,
                                              //   builder: (BuildContext context) {
                                              //     return AlertDialog(
                                              //       title: Container(height: 50, width: 50, child: CircularProgressIndicator()),
                                              //     );
                                              //   },
                                              // );
                                              // String dir = image.files[0].name.split(".").last;
                                              FormData formData =
                                              FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: Uuid().v4()+".pdf")});
                                              dio.post_data(url: "/uplade/uplode", data: formData,onsend: (start, end) {
                                                presint = start / end;
                                                setst(() {});
                                              }).then((value) {
                                                presint=0;
                                                setst(() {});
                                                print(value?.data);
                                                Tost_widget("تم رفع الملف", "green");
                                                file_link = value?.data;
                                              });

                                            }
                                          },
                                          child: presint==0?Text("تغيير الملف"):CircularProgressIndicator(color: Colors.white,value: presint.toDouble(),),),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                                    ElevatedButton(onPressed: (){
                                      dio.post_data(url: "/dash/update_id",data: {
                                        "sql_key":" teacher_name = '${tracher}' , grade = '$grade' , link = '$file_link' , photo = '${model.photo}' , subject = '$subject' , name = '${name_con.text}' , price = '${price_con.text}' , des = '${des_con.text}' , ordero = '${order_con.text}' , number_of_pages = '${hour_con.text}' , is_free = '${is_free_con.text}' "

                                      },quary: {"table":" file ","id":model.id,
                                      }).then((value) {
                                        print(value?.data);
                                        dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " file "}).then((value) {
                                          file_list.clear();
                                          value?.data.forEach((element) {
                                            print(element);
                                            file_list.add(file_module.fromjson(element));
                                            if (file_list.length == value.data.length) {
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
                              dio.post_data(url: "/dash/delet_id",quary: {"table":" file ","id":model.id}).then((value) {
                                print(value);
                                setstate(() {
                                  file_list.clear();
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " file "}).then((value) {
                                    value?.data.forEach((element) {
                                      print(element);
                                      file_list.add(file_module.fromjson(element));
                                      if (file_list.length == value.data.length) {
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

