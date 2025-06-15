import 'dart:html';

import 'package:dirasti_dashboard/module/subject_module.dart';

import 'package:dirasti_dashboard/utils/const.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:dirasti_dashboard/module/user_module.dart';
import 'package:flutter/material.dart';

import '../module/grade_module.dart';
import '../module/user_module.dart';
import 'exam_q.dart';

List<Map> exam_list = [];
List<subject_module> subject_list = [];
List<grade_module> grade_list = [];
ScrollController exam_list_con = ScrollController();
ScrollController user_elment_con = ScrollController();

class Exam extends StatefulWidget {
  Exam({Key? key}) : super(key: key);

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {
  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " exam "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            exam_list.add(element);
            // if (exam_list.length == value.data.length) {
            //   setState(() {});
            // }
          });
        });
        await dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " subject "}).then((value) {
          value?.data.forEach((element) {
            print(element);
            subject_list.add(subject_module.fromjson(element));
            // if (exam_list.length == value.data.length) {
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
        setState(() {});
      }
    });


  }

  @override
  void dispose() {
    super.dispose();
    exam_list.clear();
    subject_list.clear();
    grade_list.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (exam_list.isNotEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text("قائمة الأختبارات", style: TextStyle(fontSize: 30)),
              Spacer(),
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  onPressed: () {
                    var _con = TextEditingController();
                    var time_con = TextEditingController();
                    var order_con = TextEditingController();
                    var is_free_con = TextEditingController();
                    var grade ;
                    var subject ;
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
                                Text("المدة"),
                                TextFormField(controller: time_con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Text("الترتيب"),
                                TextFormField(controller: order_con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Text("هل مجاني  0 للمدفوع  1 للمجاني"),
                                TextFormField(controller: is_free_con,textDirection: TextDirection.rtl,),
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
                              ],
                            ),
                            actions: [
                              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                              ElevatedButton(onPressed: (){
                                dio.post_data(url: "/dash/insert",quary: {"table":" exam " , "sql_key":" name , subject , grade , time , ordero , is_free " , "sql_value":" '${_con.text}', $subject , '$grade' , '${time_con.text}' , '${order_con.text}' , '${is_free_con.text}' " }).then((value) {
                                  print(value?.data);
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " exam "}).then((value) {
                                    exam_list.clear();
                                    value?.data.forEach((element) {
                                      print(element);
                                      exam_list.add(element);
                                      if (exam_list.length == value.data.length) {
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
                  child: Text("إضافة اختبار")),
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
              controller: exam_list_con,
              child: ListView.separated(
                  shrinkWrap: true,
                  controller: exam_list_con,
                  itemBuilder: (context, index) {
                    return ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200), child: exam_list_element(context, exam_list[index], setState));
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey.shade300,
                    );
                  },
                  itemCount: exam_list.length),
            ),
          ),
        ],
      );
    } else {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'الاختبارات',
            style: TextStyle(fontSize: 35),
          ),
        ),
      );
    }

  }
}

Widget exam_list_element(BuildContext context, Map model, setstate) {
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
                  Center(child: Text("الرمز التسلسلي: ${model["id"]!}")),
                  SizedBox(
                    width: 30,
                  ),
                  //   Text( MediaQuery.of(context).size.width.toString()),
                  Center(child: Text("الاسم: ${model['name']!}")),
                  SizedBox(
                    width: 30,
                  ),
                  Center(child: Text("المدة: ${model['time']!}")),
                  SizedBox(
                    width: 30,
                  ),
                  Center(child: Text("الترتيب: ${model['ordero']!}")),
                  SizedBox(
                    width: 30,
                  ),
                  Center(child: Text("هل مجاني: ${model['is_free']=="1"?"نعم":"لا"!}")),
                  SizedBox(
                    width: 30,
                  ),
                  Center(child: Text("السنة:")),
                  SizedBox(
                    width: 10,
                  ),
                  Center(child: Text(grade_list.where((element) => element.id == model['grade']).first.name??"غير متوفر")),
                  SizedBox(
                    width: 30,
                  ),
                  Center(child: Text("المادة:")),
                  SizedBox(
                    width: 10,
                  ),
                  Center(child: Text(subject_list.where((element) => element.id == model["subject"]).first.subject??"غير متوفر")),
                  if (MediaQuery.of(context).size.width > 500)
                    SizedBox(
                      width: MediaQuery.of(context).size.width.toDouble() / 4,
                    ),
                  // Text(model.name!),
                  //Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ExamQ(model:model)));
                    }, child: Text("الاسئلة و الاجوبة")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          var _con = TextEditingController(text: model['name']);
                          var time_con = TextEditingController(text: model['time']);
                          var ordero_con = TextEditingController(text: model['ordero']);
                          var is_free_con = TextEditingController(text: model['is_free']);
                          var grade =model['grade'];
                          var subject =model['subject'];
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
                                      Text("المدة"),
                                      TextFormField(controller: time_con,textDirection: TextDirection.rtl,),
                                      SizedBox(height: 20,),
                                      Text("الترتيب"),
                                      TextFormField(controller: ordero_con,textDirection: TextDirection.rtl,),
                                      SizedBox(height: 20,),
                                      Text("هل مجاني  0 للمدفوع  1 للمجاني"),
                                      TextFormField(controller: is_free_con,textDirection: TextDirection.rtl,),
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
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                                    ElevatedButton(onPressed: (){
                                      dio.post_data(url: "/dash/update_id",data: {
                                        "sql_key":" name = '${_con.text}' , time = '${time_con.text}' , ordero = '${ordero_con.text}' , grade = '$grade' , subject = '$subject' , is_free = '${is_free_con.text}' "

                                      },quary: {"table":" exam ","id":model['id'],
                                      }).then((value) {                                        print(value?.data);
                                      dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " exam "}).then((value) {
                                        exam_list.clear();
                                        value?.data.forEach((element) {
                                          print(element);
                                          exam_list.add(element);
                                          if (exam_list.length == value.data.length) {
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
                              dio.post_data(url: "/dash/delet_id",quary: {"table":" exam ","id":model['id']}).then((value) {
                                print(value);
                                setstate(() {
                                  exam_list.clear();
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " exam "}).then((value) {
                                    value?.data.forEach((element) {
                                      print(element);
                                      exam_list.add(element);
                                      if (exam_list.length == value.data.length) {
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

