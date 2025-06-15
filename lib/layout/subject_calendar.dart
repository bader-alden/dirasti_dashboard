import 'dart:html';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dirasti_dashboard/module/calendar_module.dart';
import 'package:dirasti_dashboard/module/calendar_subject_module.dart';
import 'package:dirasti_dashboard/utils/const.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:dirasti_dashboard/module/user_module.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:uuid/uuid.dart';

import '../module/grade_module.dart';
import '../module/user_module.dart';

List<calendar_subject_module> calendar_subject_list = [];
List<grade_module> grade_list = [];
ScrollController calendar_subject_list_con = ScrollController();
ScrollController user_elment_con = ScrollController();
calendar_subject_module? user_model_type;

class CalendarSubject extends StatefulWidget {
  CalendarSubject({Key? key}) : super(key: key);

  @override
  State<CalendarSubject> createState() => _CalendarSubjectState();
}

class _CalendarSubjectState extends State<CalendarSubject> {
  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " calendar "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            calendar_subject_list.add(calendar_subject_module.fromjson(element));
            // if (calendar_subject_list.length == value.data.length) {
            //   setState(() {});
            // }
          });
        });
        await  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " grade "}).then((value) {
          grade_list.clear();
          value?.data.forEach((element) {
            print(element);
            grade_list.add(grade_module.fromjson(element));
            // if (grade_list.length == value.data.length) {
            //   setState(() {});
            // }
          });
        });
      } catch (e) {

      }
      finally {
        print( grade_list.map((e) => e.name).toList().map((e) => DropdownMenuItem(child: Text(e!))).toList().length);
        print( grade_list.length);
        setState(() {});
      }
    });


  }

  @override
  void dispose() {
    super.dispose();
    calendar_subject_list.clear();
    user_model_type = null;
  }

  @override
  Widget build(BuildContext context) {
    if (calendar_subject_list.isNotEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(" قائمة المواد الدراسية في التقويم", style: TextStyle(fontSize: 30)),
              Spacer(),
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  onPressed: () {
                    var _con = TextEditingController();
                    var grade ;
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
                              Text("السنة"),
                              DropdownButton(
                                  value: grade,
                                  items: grade_list.map((e) => DropdownMenuItem(child: Text(e.name!),value: e.id,)).toList(),
                                  //    value: grade_list[0].name,
                                  onChanged: (value){
                                    grade = value;
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
                              dio.post_data(url: "/dash/insert",quary: {"table":" calendar " , "sql_key":" subject , grade , photo " , "sql_value":" '${_con.text}' , '$grade' , '$image_link'  " }).then((value) {
                                print(value?.data);
                                dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " calendar "}).then((value) {
                                  calendar_subject_list.clear();
                                  value?.data.forEach((element) {
                                    print(element);
                                    calendar_subject_list.add(calendar_subject_module.fromjson(element));
                                    if (calendar_subject_list.length == value.data.length) {
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
                  child: Text("إضافة مادة")),
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
              controller: calendar_subject_list_con,
              child: ListView.separated(
                  shrinkWrap: true,
                  controller: calendar_subject_list_con,
                  itemBuilder: (context, index) {
                    return ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200), child: calendar_subject_list_element(context, calendar_subject_list[index], setState));
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey.shade300,
                    );
                  },
                  itemCount: calendar_subject_list.length),
            ),
          ),
        ],
      );
    } else {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            ' المواد التقويم',
            style: TextStyle(fontSize: 35),
          ),
        ),
      );
    }

  }
}

Widget calendar_subject_list_element(BuildContext context, calendar_subject_module model, setstate) {
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
                  Center(child: Text("الاسم: ${model.subject!}")),
                  SizedBox(
                    width: 30,
                  ),
                  Center(child: Text("السنة:")),
                  SizedBox(
                    width: 10,
                  ),
                  Center(child: Text(grade_list.where((element) => element.id == model.grade).first.name??"غير متوفر")),
                  // SizedBox(
                  //   width: 30,
                  // ),
                  //   Text( MediaQuery.of(context).size.width.toString()),
                  // Center(child: Text("الرقم: ${model.mobile_id!}")),
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
                          var _con = TextEditingController(text: model.subject);
                          var grade =model.grade;
                          var image_link = model.photo;
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
                                      SizedBox(height: 30,),
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
                                        "sql_key":" subject = '${_con.text}' , grade = '$grade' , photo = '$image_link' "
                                      },quary: {"table":" calendar ","id":model.id,}).then((value) {
                                        print(value?.data);
                                        dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " calendar "}).then((value) {
                                          calendar_subject_list.clear();
                                          value?.data.forEach((element) {
                                            print(element);
                                            calendar_subject_list.add(calendar_subject_module.fromjson(element));
                                            if (calendar_subject_list.length == value.data.length) {
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
                              dio.post_data(url: "/dash/delet_id",quary: {"table":" calendar ","id":model.id}).then((value) {
                                print(value);
                                setstate(() {
                                  user_model_type = null;
                                  calendar_subject_list.clear();
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " calendar "}).then((value) {
                                    value?.data.forEach((element) {
                                      print(element);
                                      calendar_subject_list.add(calendar_subject_module.fromjson(element));
                                      if (calendar_subject_list.length == value.data.length) {
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

