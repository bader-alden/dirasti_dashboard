import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dirasti_dashboard/module/q_module.dart';
import 'package:flutter/material.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:uuid/uuid.dart';

import '../utils/const.dart';

List<q_module> q_list = [];

class ExamQ extends StatefulWidget {
  const ExamQ({Key? key, this.model}) : super(key: key);
  final model;
  @override
  _ExamQState createState() => _ExamQState(model);
}

class _ExamQState extends State<ExamQ> {
  final model;

  _ExamQState(this.model);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " all_tests "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            q_list.add(q_module.fromjson(element));
            // if (exam_list.length == value.data.length) {
            //   setState(() {});
            // }
          });
        });
      } catch (e) {
        print(e);
      } finally {
        q_list.removeWhere((element) => element.exam != model['id'].toString());
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    q_list.clear();
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
            ElevatedButton(
                onPressed: () {
                  var q_con = TextEditingController();
                  var a1_con = TextEditingController();
                  var a2_con = TextEditingController();
                  var a3_con = TextEditingController();
                  var a4_con = TextEditingController();
                  var ans = TextEditingController();
                  var image_link ="" ;
                  showDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(builder: (context, setst) {
                            return AlertDialog(
                              title: Column(
                                children: [
                                  Text("إنشاء"),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("السؤال"),
                                  TextFormField(
                                    controller: q_con,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("الجواب 1"),
                                  TextFormField(
                                    controller: a1_con,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("الجواب 2"),
                                  TextFormField(
                                    controller: a2_con,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("الجواب 3"),
                                  TextFormField(
                                    controller: a3_con,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("الجواب 4"),
                                  TextFormField(
                                    controller: a4_con,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("رقم الجواب"),
                                  TextFormField(
                                    controller: ans,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("صورة   يمكن تركه فارغ"),
                                  SizedBox(
                                    height: 30,
                                  ),
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
                                          FormData formData = FormData.fromMap(
                                              {"file": await MultipartFile.fromBytes(image.toList(), filename: Uuid().v4() + ".png")});
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
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("إلفاء")),
                                ElevatedButton(onPressed: (){
                                  dio.post_data(url: "/dash/insert",quary: {"table":" all_tests " , "sql_key":" grade, subject , exam , indexs , question , photo , Answer1 , Answer2 , Answer3 , Answer4 " , "sql_value":" '${model['grade']}' , '${model['subject']}' , '${model['id']}' ,'${ans.text}' , '${q_con.text}' , '$image_link' , '${a1_con.text}' , '${a2_con.text}' , '${a3_con.text}' , '${a4_con.text}' " }).then((value) {
                                    print(value?.data);
                                    dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " all_tests "}).then((value) {
                                      q_list.clear();
                                      value?.data.forEach((element) {
                                        print(element);
                                        q_list.add(q_module.fromjson(element));
                                        if (q_list.length == value.data.length) {
                                          q_list.removeWhere((element) => element.exam != model['id'].toString());
                                          setState(() {});
                                        }
                                      });
                                    });
                                    Navigator.pop(context);
                                  });
                                },child: Text("موافق")),
                              ],
                            );
                          }));
                },
                child: Text("إضافة"))
          ]),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: q_list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey.shade200,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("هل انت متأكد"),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("إلفاء")),
                                        ElevatedButton(
                                            onPressed: () {
                                              dio.post_data(url: "/dash/delet_id", quary: {"table": " all_tests ", "id": q_list[index].id}).then(
                                                  (value) {
                                                print(value);
                                                setState(() {
                                                  q_list.clear();
                                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " all_tests "}).then((value) {
                                                    value?.data.forEach((element) {
                                                      print(element);
                                                      q_list.add(q_module.fromjson(element));
                                                      if (q_list.length == value.data.length) {
                                                        q_list.removeWhere((element) => element.exam != model['id'].toString());
                                                        setState(() {});
                                                      }
                                                    });
                                                  });
                                                });
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text("موافق")),
                                      ],
                                    ));
                          },
                          child: Text("حذف")),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            var q_con = TextEditingController(text: q_list[index].question);
                            var a1_con = TextEditingController(text: q_list[index].Answer1);
                            var a2_con = TextEditingController(text: q_list[index].Answer2);
                            var a3_con = TextEditingController(text: q_list[index].Answer3);
                            var a4_con = TextEditingController(text: q_list[index].Answer4);
                            var ans = TextEditingController(text: q_list[index].index);
                            var image_link = q_list[index].photo;
                            showDialog(
                                context: context,
                                builder: (context) => StatefulBuilder(builder: (context, setst) {
                                      return AlertDialog(
                                        title: Column(
                                          children: [
                                            Text("إنشاء"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("السؤال"),
                                            TextFormField(
                                              controller: q_con,
                                              textDirection: TextDirection.rtl,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("الجواب 1"),
                                            TextFormField(
                                              controller: a1_con,
                                              textDirection: TextDirection.rtl,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("الجواب 2"),
                                            TextFormField(
                                              controller: a2_con,
                                              textDirection: TextDirection.rtl,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("الجواب 3"),
                                            TextFormField(
                                              controller: a3_con,
                                              textDirection: TextDirection.rtl,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("الجواب 4"),
                                            TextFormField(
                                              controller: a4_con,
                                              textDirection: TextDirection.rtl,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("رقم الجواب"),
                                            TextFormField(
                                              controller: ans,
                                              textDirection: TextDirection.rtl,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("صورة   يمكن تركه فارغ"),
                                            SizedBox(
                                              height: 30,
                                            ),
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
                                                    FormData formData = FormData.fromMap(
                                                        {"file": await MultipartFile.fromBytes(image.toList(), filename: Uuid().v4() + ".png")});
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
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("إلفاء")),
                                          ElevatedButton(
                                              onPressed: () {
                                                dio.post_data(url: "/dash/update_id",data: {
                                                  "sql_key":
                                                  " question = '${q_con.text}' , indexs = '${ans.text}' , photo = '$image_link' , Answer1 = '${a1_con.text}' , Answer2 = '${a2_con.text}' , Answer3 = '${a3_con.text}' , Answer4 = '${a4_con.text}' "

                                                }, quary: {
                                                  "table": " all_tests ",
                                                  "id": q_list[index].id.toString(),
                                                }).then((value) {
                                                  print(value?.data);
                                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " all_tests "}).then((value) {
                                                    q_list.clear();
                                                    value?.data.forEach((element) {
                                                      print(element);
                                                      q_list.add(q_module.fromjson(element));
                                                      if (q_list.length == value.data.length) {
                                                        q_list.removeWhere((element) => element.exam != model['id'].toString());
                                                        setState(() {});
                                                      }
                                                    });
                                                  });
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Text("موافق")),
                                        ],
                                      );
                                    }));
                          },
                          child: Text("تعديل ")),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    if (q_list[index].photo != null)
                      Image.network(
                        q_list[index].photo!,
                        width: 200,
                        height: 200,
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("السؤال"),
                          Text(q_list[index].question!),
                          Text("الاجوبة"),
                          Text(q_list[index].Answer1!),
                          Text(q_list[index].Answer2!),
                          Text(q_list[index].Answer3!),
                          Text(q_list[index].Answer4!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
