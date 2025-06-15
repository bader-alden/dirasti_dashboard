import 'dart:html';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dirasti_dashboard/module/subject_module.dart';
import 'package:dirasti_dashboard/utils/const.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:dirasti_dashboard/module/user_module.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:uuid/uuid.dart';

import '../module/grade_module.dart';
import '../module/user_module.dart';

List<subject_module> subject_list = [];
List<grade_module> grade_list = [];
ScrollController subject_list_con = ScrollController();
ScrollController user_elment_con = ScrollController();
subject_module? user_model_type;

class Subject extends StatefulWidget {
  Subject({Key? key}) : super(key: key);

  @override
  State<Subject> createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      subject_list.clear();
      grade_list.clear();
      try {
        await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " subject "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            subject_list.add(subject_module.fromjson(element));
            // if (subject_list.length == value.data.length) {
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
    subject_list.clear();
    grade_list.clear();
    user_model_type = null;
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
              Text("قائمة المواد الدراسية", style: TextStyle(fontSize: 30)),
              Spacer(),
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  onPressed: () {
                    var _con = TextEditingController();
                    var grade ;
                    var image_link ;
                    var banner1_link ;
                    var banner2_link ;
                    var banner3_link ;
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
                                  value: grade ?? grade_list[0].id,
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
                                      // String dir = image.files[0].namer.split(".").last;
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
                                        banner1_link = value?.data;
                                        Navigator.pop(context);
                                      });

                                    }
                                  },
                                  child: Text("تغيير البانر الاساسي")),
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
                                        banner2_link = value?.data;
                                        Navigator.pop(context);
                                      });

                                    }
                                  },
                                  child: Text("تغيير بانر الملفات")),
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
                                        banner3_link = value?.data;
                                        Navigator.pop(context);
                                      });

                                    }
                                  },
                                  child: Text("تغيير بانر الاختبارات")),
                            ],
                          ),
                          actions: [
                            ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                            ElevatedButton(onPressed: (){
                              dio.post_data(url: "/dash/insert",quary: {"table":" subject " , "sql_key":" subject , grade , photo , banner1 , banner2 , banner3 " , "sql_value":" '${_con.text}' , '$grade' , '$image_link' , '$banner1_link' , '$banner2_link' , '$banner3_link' " }).then((value) {
                                print(value?.data);
                                dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " subject "}).then((value) {
                                  subject_list.clear();
                                  value?.data.forEach((element) {
                                    print(element);
                                    subject_list.add(subject_module.fromjson(element));
                                    if (subject_list.length == value.data.length) {
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
              controller: subject_list_con,
              child: ListView.separated(
                  shrinkWrap: true,
                  controller: subject_list_con,
                  itemBuilder: (context, index) {
                    return ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200), child: subject_list_element(context, subject_list[index], setState));
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey.shade300,
                    );
                  },
                  itemCount: subject_list.length),
            ),
          ),
        ],
      );
    } else {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'المواد',
            style: TextStyle(fontSize: 35),
          ),
        ),
      );
    }

  }
}

Widget subject_list_element(BuildContext context, subject_module model, setstate) {
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
                          var banner1_link = model.banner_1;
                          var banner2_link = model.banner_2;
                          var banner3_link = model.banner_3;
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
                                                banner1_link = value?.data;
                                                Navigator.pop(context);
                                              });

                                            }
                                          },
                                          child: Text("تغيير البانر الاساسي")),
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
                                                banner2_link = value?.data;
                                                Navigator.pop(context);
                                              });

                                            }
                                          },
                                          child: Text("تغيير بانر الملفات")),
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
                                                banner3_link = value?.data;
                                                Navigator.pop(context);
                                              });
                                            }
                                          },
                                          child: Text("تغيير بانر الاختبارات")),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                                    ElevatedButton(onPressed: (){
                                      dio.post_data(url: "/dash/update_id",data: {
                                        "sql_key":" subject = '${_con.text}' , grade = '$grade' , photo = '$image_link' , banner1 = '$banner1_link' , banner2 = '$banner2_link'  , banner3 = '$banner3_link'"
                                      },quary: {"table":" subject ","id":model.id,}).then((value) {
                                        print(value?.data);
                                        dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " subject "}).then((value) {
                                          subject_list.clear();
                                          value?.data.forEach((element) {
                                            print(element);
                                            subject_list.add(subject_module.fromjson(element));
                                            if (subject_list.length == value.data.length) {
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
                              dio.post_data(url: "/dash/delet_id",quary: {"table":" subject ","id":model.id}).then((value) {
                                print(value);
                                setstate(() {
                                  user_model_type = null;
                                  subject_list.clear();
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " subject "}).then((value) {
                                    value?.data.forEach((element) {
                                      print(element);
                                      subject_list.add(subject_module.fromjson(element));
                                      if (subject_list.length == value.data.length) {
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

