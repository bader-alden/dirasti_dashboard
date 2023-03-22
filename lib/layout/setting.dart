import 'dart:convert';
import 'dart:typed_data';

import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:uuid/uuid.dart';

import '../utils/const.dart';

int setting_operation = 0;
String? terms;
List faq = [];
List link_list = [];
List point_list = [];

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio.post_data(url: "/dash/select", quary: {"table": "privacy_policy", "sql": " * "}).then((value) => setState(() {
      terms = value?.data[0]['text'].toString();
    }));
    dio.post_data(url: "/dash/select", quary: {"table": "Social_Media", "sql": " * "}).then((value) => setState(() {
      link_list = value?.data;
      print(value?.data);
    }));
    dio.post_data(url: "/dash/select", quary: {"table": "Coupon_points_of_sale", "sql": " * "}).then((value) => setState(() {
      point_list = value?.data;
      print(value?.data);
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (setting_operation == 1) {
      if (terms != null) {
        var con = TextEditingController(text: terms);
        return Scaffold(
          body: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          setting_operation = 0;
                        });
                      },
                      icon: Icon(Icons.arrow_back_ios_new)),
                  Spacer(),
                  Text(
                    "سياسة الخصوصية",
                    style: TextStyle(fontSize: 25),
                  ),
                  Spacer()
                ],
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        color: Colors.grey.shade200,
                        child: TextFormField(
                          maxLines: null,
                          controller: con,
                          decoration: InputDecoration(border: InputBorder.none),
                        )),
                  )),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          setting_operation = 0;
                        });
                      },
                      child: Text("إلغاء")),
                  SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        dio.post_data(url: "/dash/update_id", quary: {"table": "privacy_policy", "sql_key": "text = '" + con.text + "'", "id": "1"}).then(
                                (value) {
                              dio.post_data(url: "/dash/select", quary: {"table": "privacy_policy", "sql": " * "}).then((value) => setState(() {
                                terms = value?.data[0]['text'].toString();
                                setting_operation = 0;
                              }));
                            });
                      },
                      child: Text("حفظ")),
                ],
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        );
      } else {
        return Scaffold(
          body: Text("Terms"),
        );
      }
    }
    if (setting_operation == 2) {
      return Scaffold(
        body: Column(children: [
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      setting_operation = 0;
                    });
                  },
                  icon: Icon(Icons.arrow_back_ios_new)),
              Spacer(),
              Text(
                "أماكن بيع الاكواد",
                style: TextStyle(fontSize: 25),
              ),
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    var name_con = TextEditingController();
                    var address_con = TextEditingController();
                    var lat_con = TextEditingController();
                    var long_con = TextEditingController();
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text('التفاصيل', textDirection: TextDirection.rtl),
                          content: Container(
                            height: 500,
                            width: 500,
                            child: ListView(
                              children: [
                                Text("الاسم:", textDirection: TextDirection.rtl),
                                TextFormField(
                                  controller: name_con,
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("العنوان:", textDirection: TextDirection.rtl),
                                TextFormField(
                                  controller: address_con,
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Latitude :", textDirection: TextDirection.rtl),
                                TextFormField(
                                  controller: lat_con,
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Longitude:", textDirection: TextDirection.rtl),
                                TextFormField(
                                  controller: long_con,
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('إلغاء'),
                              onPressed: () {
                                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                              },
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            TextButton(
                                child: Text('موافق'),
                                onPressed: () {
                                  dio.post_data(url: "/dash/insert", quary: {
                                    "table": "Coupon_points_of_sale",
                                    "sql_key": " name , address , lat , lang ",
                                    "sql_value": "'${name_con.text}' , '${address_con.text}' ,'${lat_con.text}' , '${long_con.text}' "
                                  }).then((value) {
                                    print(value?.data);
                                    dio.post_data(url: "/dash/select", quary: {"table": "Coupon_points_of_sale", "sql": " * "}).then((value) => setState(() {
                                      point_list = value?.data;
                                      Navigator.of(dialogContext).pop();
                                    }));
                                  });
                                })
                          ],
                        );
                      },
                    );
                  },
                  child: Text("إنشاء")),
              SizedBox(
                width: 60,
              ),
            ],
          ),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: point_list.length,
                  itemBuilder: (contex, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(point_list[index]['name']),
                            //Spacer(),
                            SizedBox(
                              width: 50,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('التفاصيل', textDirection: TextDirection.rtl),
                                        content: Container(
                                          height: 500,
                                          width: 500,
                                          child: ListView(
                                            children: [
                                              Text("الاسم:", textDirection: TextDirection.rtl),
                                              Text(point_list[index]['name'], textDirection: TextDirection.rtl),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("العنوان:", textDirection: TextDirection.rtl),
                                              Text(point_list[index]['address'], textDirection: TextDirection.rtl),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("Latitude:", textDirection: TextDirection.rtl),
                                              Text(point_list[index]['lat'], textDirection: TextDirection.rtl),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("Longitude:", textDirection: TextDirection.rtl),
                                              Text(point_list[index]['lang'], textDirection: TextDirection.rtl),

                                            ],
                                          ),
                                        ),
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
                                },
                                child: Text("عرض")),
                            SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  var name_con = TextEditingController(text: point_list[index]['name']);
                                  var addres_con = TextEditingController(text: point_list[index]['address']);
                                  var lat_con = TextEditingController(text: point_list[index]['lat']);
                                  var long_con = TextEditingController(text: point_list[index]['lang']);
                                  var s = point_list[index]['photo'];
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('التفاصيل', textDirection: TextDirection.rtl),
                                        content: Container(
                                          height: 500,
                                          width: 500,
                                          child: ListView(
                                            children: [
                                              Text("الاسم:", textDirection: TextDirection.rtl),
                                              TextFormField(
                                                controller: name_con,
                                                textDirection: TextDirection.rtl,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("العنوان:", textDirection: TextDirection.rtl),
                                              TextFormField(
                                                controller: addres_con,
                                                textDirection: TextDirection.rtl,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("Latitude:", textDirection: TextDirection.rtl),
                                              TextFormField(
                                                controller: lat_con,
                                                textDirection: TextDirection.rtl,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("Longitude:", textDirection: TextDirection.rtl),
                                              TextFormField(
                                                controller: long_con,
                                                textDirection: TextDirection.rtl,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),

                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('إلغاء'),
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                            },
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          TextButton(
                                            child: Text('موافق'),
                                            onPressed: () {
                                              dio.post_data(url: "/dash/update_id", quary: {
                                                "table": "Coupon_points_of_sale",
                                                "sql_key": " name = '${name_con.text}' , address = '${addres_con.text}' ,  lat = '${lat_con.text}' , lang = '${long_con.text}' ",
                                                "id": point_list[index]['id']
                                              }).then((value) {
                                                print(value?.data);
                                                dio.post_data(url: "/dash/select", quary: {"table": "Coupon_points_of_sale", "sql": " * "}).then(
                                                        (value) => setState(() {
                                                      point_list = value?.data;
                                                      Navigator.of(dialogContext).pop();
                                                    }));
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text("تعديل")),
                            SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  dio.post_data(url: "/dash/delet_id", quary: {"table": "Coupon_points_of_sale", "id": point_list[index]['id']}).then((value) {
                                    dio.post_data(url: "/dash/select", quary: {"table": "Coupon_points_of_sale", "sql": " * "}).then((value) => setState(() {
                                      point_list = value?.data;
                                    }));
                                  });
                                },
                                child: Text("حذف")),
                            SizedBox(
                              width: 60,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  }))
        ]),
      );
    }
    if (setting_operation == 3) {
      return Scaffold(
        body: Column(children: [
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      setting_operation = 0;
                    });
                  },
                  icon: Icon(Icons.arrow_back_ios_new)),
              Spacer(),
              Text(
                "التواصل الاجتماعي",
                style: TextStyle(fontSize: 25),
              ),
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    var name_con = TextEditingController();
                    var link_con = TextEditingController();
                    var s ;
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text('التفاصيل', textDirection: TextDirection.rtl),
                          content: Container(
                            height: 500,
                            width: 500,
                            child: ListView(
                              children: [
                                Text("الاسم:", textDirection: TextDirection.rtl),
                                TextFormField(
                                  controller: name_con,
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("الرابط:", textDirection: TextDirection.rtl),
                                TextFormField(
                                  controller: link_con,
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
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
                                          s = value?.data;
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
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('إلغاء'),
                              onPressed: () {
                                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                              },
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            TextButton(
                                child: Text('موافق'),
                                onPressed: () {
                                  dio.post_data(url: "/dash/insert", quary: {
                                    "table": "Social_Media",
                                    "sql_key": " name , link , photo ",
                                    "sql_value": "'${name_con.text}' , '${link_con.text}' , '$s' "
                                  }).then((value) {
                                    print(value?.data);
                                    dio.post_data(url: "/dash/select", quary: {"table": "Social_Media", "sql": " * "}).then((value) => setState(() {
                                      link_list = value?.data;
                                      Navigator.of(dialogContext).pop();
                                    }));
                                  });
                                })
                          ],
                        );
                      },
                    );
                  },
                  child: Text("إنشاء")),
              SizedBox(
                width: 60,
              ),
            ],
          ),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: link_list.length,
                  itemBuilder: (contex, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(link_list[index]['name']),
                            //Spacer(),
                            SizedBox(
                              width: 50,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('التفاصيل', textDirection: TextDirection.rtl),
                                        content: Container(
                                          height: 500,
                                          width: 500,
                                          child: ListView(
                                            children: [
                                              Text("الاسم:", textDirection: TextDirection.rtl),
                                              Text(link_list[index]['name'], textDirection: TextDirection.rtl),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("الرايط:", textDirection: TextDirection.rtl),
                                              Text(link_list[index]['link'], textDirection: TextDirection.rtl),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("الصورة:", textDirection: TextDirection.rtl),
                                              Image.network(link_list[index]['photo'], height: 50),
                                            ],
                                          ),
                                        ),
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
                                },
                                child: Text("عرض")),
                            SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  var name_con = TextEditingController(text: link_list[index]['name']);
                                  var link_con = TextEditingController(text: link_list[index]['link']);
                                  var s = link_list[index]['photo'];
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('التفاصيل', textDirection: TextDirection.rtl),
                                        content: Container(
                                          height: 500,
                                          width: 500,
                                          child: ListView(
                                            children: [
                                              Text("الاسم:", textDirection: TextDirection.rtl),
                                              TextFormField(
                                                controller: name_con,
                                                textDirection: TextDirection.rtl,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text("الرابط:", textDirection: TextDirection.rtl),
                                              TextFormField(
                                                controller: name_con,
                                                textDirection: TextDirection.rtl,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Image.network(s, height: 50),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    // final ImagePicker _picker = ImagePicker();
                                                    // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                                                    // FilePickerResult? image = await FilePicker.platform
                                                    //     .pickFiles(allowedExtensions: ['png'], allowMultiple: false, type: FileType.custom);
                                                    Uint8List? image = await ImagePickerWeb.getImageAsBytes();
                                                    if (image != null) {
                                                      // String dir = image.files[0].name.split(".").last;
                                                      FormData formData = FormData.fromMap(
                                                          {"file": await MultipartFile.fromBytes(image.toList(), filename: name_con.text)});
                                                      dio.post_data(url: "/uplade/uplode", data: formData).then((value) {
                                                        Tost_widget("تم رفع الصورة", "green");
                                                        s = value?.data["message"];
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
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('إلغاء'),
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                            },
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          TextButton(
                                            child: Text('موافق'),
                                            onPressed: () {
                                              dio.post_data(url: "/dash/update_id", quary: {
                                                "table": "Social_Media",
                                                "sql_key": " name = '${name_con.text}' , link = '${link_con.text}' , photo = '${s}'",
                                                "id": link_list[index]['id']
                                              }).then((value) {
                                                print(value?.data);
                                                dio.post_data(url: "/dash/select", quary: {"table": "Social_Media", "sql": " * "}).then(
                                                        (value) => setState(() {
                                                      link_list = value?.data;
                                                      Navigator.of(dialogContext).pop();
                                                    }));
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text("تعديل")),
                            SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  dio.post_data(url: "/dash/delet_id", quary: {"table": "Social_Media", "id": link_list[index]['id']}).then((value) {
                                    dio.post_data(url: "/dash/select", quary: {"table": "Social_Media", "sql": " * "}).then((value) => setState(() {
                                      link_list = value?.data;
                                    }));
                                  });
                                },
                                child: Text("حذف")),
                            SizedBox(
                              width: 60,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  }))
        ]),
      );
    }
    else {
      return Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "الاعدادت العامة",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            setting_operation = 1;
                          });
                        },
                        child: Row(children: [
                          Icon(Icons.circle, size: 20),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "سياسة الخصوصية",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.arrow_back_ios_new),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            setting_operation = 2;
                          });
                        },
                        child: Row(children: [
                          Icon(Icons.circle, size: 20),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            " أماكن تواجد الكورسات",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.arrow_back_ios_new),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            setting_operation = 3;
                          });
                        },
                        child: Row(children: [
                          Icon(Icons.circle, size: 20),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "التواصل الاجتماعي",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.arrow_back_ios_new),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () async {
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
                            FormData.fromMap({"file": await MultipartFile.fromBytes(image.toList(), filename: Uuid().v4() + ".png")});
                            dio.post_data(url: "/uplade/uplode", data: formData,).then((value) {
                              print(value?.data);
                              Tost_widget("تم رفع الصورة", "green");
                              var s = value?.data;
                              dio.post_data(url: "/dash/update_id", quary: {"table": "privacy_policy", "sql_key": "banner = '" + s + "'", "id": "1"}).then(
                                      (value) {});
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: Row(children: [
                          Icon(Icons.circle, size: 20),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "تغيير البانر الرئيسي",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.arrow_back_ios_new),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () {
                          // setState((){
                          //   //setting_operation=5;
                          //
                          // });
                          dio.post_data(url: "/dash/select", quary: {"table": "the_support", "sql": " * "}).then((value) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  var text_con = TextEditingController(text: value?.data[0]['link']);
                                  return AlertDialog(
                                    title: Text("               تغيير رابط الدعم الفني               "),
                                    content: TextFormField(controller: text_con),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            dio.post_data(url: "/dash/update_id", quary: {
                                              "table": "the_support",
                                              "sql_key": " link = '${text_con.text}' ",
                                              "id": 1
                                            }).then((value) => Navigator.pop(context));
                                          },
                                          child: Text("موافق"),
                                          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green))),
                                      ElevatedButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("إلغاء"),
                                          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red))),
                                    ],
                                  );
                                });
                          });
                        },
                        child: Row(children: [
                          Icon(Icons.circle, size: 20),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "رابط الدعم الفني",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.arrow_back_ios_new),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () {
                          // setState((){
                          //   //setting_operation=5;
                          //
                          // });
                          dio.post_data(url: "/dash/select", quary: {"table": "version", "sql": " * "}).then((value) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  var text_con = TextEditingController(text: value?.data[0]['version']);
                                  return AlertDialog(
                                    title: Text("تحذير : تغيير الإصدار بؤدي لطلب تحديث من مستخدمين التطبيق"),
                                    content: TextFormField(controller: text_con),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            dio.post_data(url: "/dash/update_id", quary: {
                                              "table": "version",
                                              "sql_key": " version = '${text_con.text}' ",
                                              "id": 1
                                            }).then((value) => Navigator.pop(context));
                                          },
                                          child: Text("موافق"),
                                          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green))),
                                      ElevatedButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("إلغاء"),
                                          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red))),
                                    ],
                                  );
                                });
                          });
                        },
                        child: Row(children: [
                          Icon(Icons.circle, size: 20),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "الإصدار",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.arrow_back_ios_new),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () {
                          // setState((){
                          //   //setting_operation=5;
                          //
                          // });
                          dio.post_data(url: "/dash/select", quary: {"table": "version", "sql": " * "}).then((value) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  var text_con = TextEditingController(text: value?.data[0]['link']);
                                  return AlertDialog(
                                    title: Text("تحديث رابط تنزيل التطبيق"),
                                    content: TextFormField(controller: text_con),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            dio.post_data(url: "/dash/update_id", quary: {
                                              "table": "version",
                                              "sql_key": " link = '${text_con.text}' ",
                                              "id": 1
                                            }).then((value) => Navigator.pop(context));
                                          },
                                          child: Text("موافق"),
                                          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green))),
                                      ElevatedButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("إلغاء"),
                                          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red))),
                                    ],
                                  );
                                });
                          });
                        },
                        child: Row(children: [
                          Icon(Icons.circle, size: 20),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "رابط التنزيل",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.arrow_back_ios_new),
                        ]),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      );
    }
  }
}
