import 'dart:html';

import 'package:dirasti_dashboard/module/grade_module.dart';
import 'package:dirasti_dashboard/utils/const.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:dirasti_dashboard/module/user_module.dart';
import 'package:flutter/material.dart';

import '../module/user_module.dart';

List<grade_module> grade_list = [];
ScrollController grade_list_con = ScrollController();
ScrollController user_elment_con = ScrollController();
int user_type_page = 0;
bool is_loading_update_user = false;
grade_module? user_model_type;

class Grade extends StatefulWidget {
  Grade({Key? key}) : super(key: key);

  @override
  State<Grade> createState() => _GradeState();
}

class _GradeState extends State<Grade> {
  @override
  void initState() {
    dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " grade "}).then((value) {
      grade_list.clear();
      value?.data.forEach((element) {
        print(element);
        grade_list.add(grade_module.fromjson(element));
        if (grade_list.length == value.data.length) {
          setState(() {});
        }
      });
    });


  }

  @override
  void dispose() {
    super.dispose();
    grade_list.clear();
    user_type_page = 0;
    user_model_type = null;
  }

  @override
  Widget build(BuildContext context) {
      if (grade_list.isNotEmpty) {
        return Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text("قائمة السنوات الدراسية", style: TextStyle(fontSize: 30)),
                Spacer(),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    onPressed: () {
                      var _con = TextEditingController();
                      showDialog(context: context, builder: (context)=>AlertDialog(
                        title: Column(
                          children: [
                            Text("إنشاء"),
                            SizedBox(height: 20,),
                            TextFormField(controller: _con,textDirection: TextDirection.rtl,),
                          ],
                        ),
                        actions: [
                          ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                          ElevatedButton(onPressed: (){
                            dio.post_data(url: "/dash/insert",quary: {"table":" grade " , "sql_key":" name " , "sql_value":" '${_con.text}' " }).then((value) {
                              print(value?.data);
                              dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " grade "}).then((value) {
                                grade_list.clear();
                                value?.data.forEach((element) {
                                  print(element);
                                  grade_list.add(grade_module.fromjson(element));
                                  if (grade_list.length == value.data.length) {
                                    setState(() {});
                                  }
                                });
                              });
                              Navigator.pop(context);
                            });
                          },child: Text("موافق")),
                        ],
                      ));
                    },
                    child: Text("إضافة سنة")),
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
                controller: grade_list_con,
                child: ListView.separated(
                    shrinkWrap: true,
                    controller: grade_list_con,
                    itemBuilder: (context, index) {
                      return ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 200), child: grade_list_element(context, grade_list[index], setState));
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        width: double.infinity,
                        height: 2,
                        color: Colors.grey.shade300,
                      );
                    },
                    itemCount: grade_list.length),
              ),
            ),
          ],
        );
      } else {
        return Container(
          color: Colors.white,
          child: const Center(
            child: Text(
              'الصفوف',
              style: TextStyle(fontSize: 35),
            ),
          ),
        );
      }

  }
}

Widget grade_list_element(BuildContext context, grade_module model, setstate) {
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
                  Center(child: Text("الاسم: ${model.name!}")),
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
                          var _con = TextEditingController(text: model.name);
                          showDialog(context: context, builder: (context)=>AlertDialog(
                            title: Column(
                              children: [
                                Text("تعديل"),
                                SizedBox(height: 20,),
                                TextFormField(controller: _con,textDirection: TextDirection.rtl,),
                              ],
                            ),
                            actions: [
                              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                              ElevatedButton(onPressed: (){
                                dio.post_data(url: "/dash/update_id",data: {
                                "sql_key":" name = '${_con.text}' ",
                                },quary: {"table":" grade ","id":model.id}).then((value) {
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " grade "}).then((value) {
                                    grade_list.clear();
                                    value?.data.forEach((element) {
                                      print(element);
                                      grade_list.add(grade_module.fromjson(element));
                                      if (grade_list.length == value.data.length) {
                                        setstate(() {});
                                      }
                                    });
                                  });
                                  Navigator.pop(context);
                                });
                              },child: Text("موافق")),
                            ],
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
                              dio.post_data(url: "/dash/delet_id",quary: {"table":" grade ","id":model.id}).then((value) {
                                print(value);
                                setstate(() {
                                  user_model_type = null;
                                  user_type_page = 0;
                                  is_loading_update_user = false;
                                  grade_list.clear();
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " grade "}).then((value) {
                                    value?.data.forEach((element) {
                                      print(element);
                                      grade_list.add(grade_module.fromjson(element));
                                      if (grade_list.length == value.data.length) {
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

