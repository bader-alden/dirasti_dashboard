import 'dart:html';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dirasti_dashboard/module/subject_module.dart';
import 'package:dirasti_dashboard/module/teacher_module.dart';
import 'package:dirasti_dashboard/module/teacher_module.dart';
import 'package:dirasti_dashboard/utils/const.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:dirasti_dashboard/module/user_module.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:uuid/uuid.dart';

import '../module/grade_module.dart';
import '../module/user_module.dart';

List<teacher_module> teacher_list = [];
List<subject_module> subject_list = [];
List<grade_module> grade_list = [];
ScrollController teacher_list_con = ScrollController();
ScrollController user_elment_con = ScrollController();

class Teacher extends StatefulWidget {
  Teacher({Key? key}) : super(key: key);

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
         teacher_list.clear();
        subject_list.clear();
        grade_list.clear();
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
            // if (teacher_list.length == value.data.length) {
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
    teacher_list.clear();
    subject_list.clear();
    grade_list.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (teacher_list.isNotEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text("قائمة الأساتذة", style: TextStyle(fontSize: 30)),
              Spacer(),
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  onPressed: () {
                    var _con = TextEditingController();
                    var exam_dashboard_id_con = TextEditingController();
                    var grade ;
                    var subject ;
                    var image_link ;
                    showDialog(context: context, builder: (context)=>StatefulBuilder(
                        builder: (context,setst) {
                          return AlertDialog(
                            title: Column(
                              children: [
                                Text("إنشاء"),
                                SizedBox(height: 20,),
                                Text("الاسم"),
                                TextFormField(controller: _con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Text("كلمة سر exam dashboard"),
                                TextFormField(controller: exam_dashboard_id_con,textDirection: TextDirection.rtl,),
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
                              ],
                            ),
                            actions: [
                              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                              ElevatedButton(onPressed: (){
                                dio.post_data(url: "/dash/insert",quary: {"table":" teatcher " , "sql_key":" teacher_name , subject , grade , photo , exam_dashboard_id " , "sql_value":" '${_con.text}', $subject , '$grade' , '$image_link', '${exam_dashboard_id_con.text}' " }).then((value) {
                                  print(value?.data);
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " teatcher "}).then((value) {
                                    teacher_list.clear();
                                    value?.data.forEach((element) {
                                      print(element);
                                      teacher_list.add(teacher_module.fromjson(element));
                                      if (teacher_list.length == value.data.length) {
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
                  child: Text("إضافة أستاذ")),
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
              controller: teacher_list_con,
              child: ListView.separated(
                  shrinkWrap: true,
                  controller: teacher_list_con,
                  itemBuilder: (context, index) {
                    return ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200), child: teacher_list_element(context, teacher_list[index], setState));
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey.shade300,
                    );
                  },
                  itemCount: teacher_list.length),
            ),
          ),
        ],
      );
    } else {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'الاساتذة',
            style: TextStyle(fontSize: 35),
          ),
        ),
      );
    }

  }
}

Widget teacher_list_element(BuildContext context, teacher_module model, setstate) {
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
                  Center(child: Text("الاسم: ${model.teacher_name!}")),
                  SizedBox(
                    width: 30,
                  ),
                  Center(child: Text("exam dashboard : ${model.exam_dashboard_id!}")),
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
                  if (MediaQuery.of(context).size.width > 500)
                    SizedBox(
                      width: MediaQuery.of(context).size.width.toDouble() / 4,
                    ),
                  // Text(model.name!),
                  //Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          var _con = TextEditingController(text: model.teacher_name);
                          var exam_dashboard_id_con = TextEditingController(text: model.exam_dashboard_id);
                          var grade =model.grade;
                          var subject =model.subject;
                          var image_link =model.photo;
                          showDialog(context: context, builder: (context)=>StatefulBuilder(
                              builder: (context,setst) {
                                return AlertDialog(
                                  title: Column(
                                    children: [
                                      Text("إنشاء"),
                                      SizedBox(height: 20,),
                                      Text("الاسم"),
                                      TextFormField(controller: _con,textDirection: TextDirection.rtl,),
                                      SizedBox(height: 20,),
                                      Text("كلمة سر exam dashboard"),
                                      TextFormField(controller: exam_dashboard_id_con,textDirection: TextDirection.rtl,),
                                      SizedBox(height: 20,),
                                      Text("السنة"),
                                      DropdownButton(
                                          value: grade ,
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
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                                    ElevatedButton(onPressed: (){
                                      dio.post_data(url: "/dash/update_id",data: {
                                        "sql_key":" teacher_name = '${_con.text}' , grade = '$grade' , photo = '$image_link' , subject = '$subject' , exam_dashboard_id = '${exam_dashboard_id_con.text}' "
                                      },quary: {"table":" teatcher ","id":model.id,}).then((value) {                                        print(value?.data);
                                      dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " teatcher "}).then((value) {
                                        teacher_list.clear();
                                        value?.data.forEach((element) {
                                          print(element);
                                          teacher_list.add(teacher_module.fromjson(element));
                                          if (teacher_list.length == value.data.length) {
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
                              dio.post_data(url: "/dash/delet_id",quary: {"table":" teatcher ","id":model.id}).then((value) {
                                print(value);
                                setstate(() {
                                  teacher_list.clear();
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " teatcher "}).then((value) {
                                    value?.data.forEach((element) {
                                      print(element);
                                      teacher_list.add(teacher_module.fromjson(element));
                                      if (teacher_list.length == value.data.length) {
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

