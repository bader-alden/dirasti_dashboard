import 'dart:html';

import 'package:dirasti_dashboard/utils/const.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:dirasti_dashboard/module/user_module.dart';
import 'package:flutter/material.dart';

import '../module/user_module.dart';

List<Map> noti_list = [];
ScrollController noti_list_con = ScrollController();
ScrollController user_elment_con = ScrollController();
int user_type_page = 0;
bool is_loading_update_user = false;

class NotificationPage extends StatefulWidget {
  NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " notices "}).then((value) {
      value?.data.forEach((element) {
        print(element);
        noti_list.add(element);
        if (noti_list.length == value.data.length) {
          setState(() {});
        }
      });
    });


  }

  @override
  void dispose() {
    super.dispose();
    noti_list.clear();
    user_type_page = 0;
  }

  @override
  Widget build(BuildContext context) {
      if (noti_list.isNotEmpty) {
        return Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text("قائمة الأشعارات", style: TextStyle(fontSize: 30)),
                Spacer(),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    onPressed: () {
                      var title_con = TextEditingController();
                      var body_con = TextEditingController();
                      showDialog(context: context, builder: (context)=>AlertDialog(
                        title: Column(
                          children: [
                            Text("إنشاء"),
                            SizedBox(height: 20,),
                            Center(child: Text("العنوان"),),
                            TextFormField(controller: title_con,textDirection: TextDirection.rtl,),
                            SizedBox(height: 20,),
                            Center(child: Text("الموضوع"),),
                            TextFormField(controller: body_con,textDirection: TextDirection.rtl,),
                          ],
                        ),
                        actions: [
                          ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                          ElevatedButton(onPressed: (){
                            dio.post_data(url: "/fcm/all", quary: {"user_id": 'public', "title": title_con.text , "body": body_con.text}).then((value) {
                              print(value?.data);
                              dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " notices "}).then((value) {
                                noti_list.clear();
                                value?.data.forEach((element) {
                                  print(element);
                                  noti_list.add(element);
                                  if (noti_list.length == value.data.length) {
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
                    child: Text("إضافة إشعار للجميع")),
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
                controller: noti_list_con,
                child: ListView.separated(
                    shrinkWrap: true,
                    controller: noti_list_con,
                    itemBuilder: (context, index) {
                      return ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 200), child: noti_list_element(context, noti_list[index], setState));
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        width: double.infinity,
                        height: 2,
                        color: Colors.grey.shade300,
                      );
                    },
                    itemCount: noti_list.length),
              ),
            ),
          ],
        );
      } else {
        return Container(
          color: Colors.white,
          child: const Center(
            child: Text(
              'الاشعارات',
              style: TextStyle(fontSize: 35),
            ),
          ),
        );
      }

  }
}

Widget noti_list_element(BuildContext context, Map model, setstate) {
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
                  Center(child: Text("الرمز التسلسلي: ${model['id']!}")),
                  SizedBox(
                    width: 15,
                  ),
                  Center(child: Text("الى: ${model['user_id'] == "public" ?"الجميع":model['user_id']}")),
                  SizedBox(
                    width: 30,
                  ),
                  //   Text( MediaQuery.of(context).size.width.toString()),
                  Center(child: Text("العنوان: ${model['title']!}")),
                  SizedBox(
                    width: 15,
                  ),
                  Center(child: Text("الموضوع: ${model['body']}",overflow: TextOverflow.ellipsis,)),
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
                          var title_con = TextEditingController(text: model['title']);
                          var body_con = TextEditingController(text: model['body']);
                          showDialog(context: context, builder: (context)=>AlertDialog(
                            title: Column(
                              children: [
                                Text("تعديل"),
                                SizedBox(height: 20,),
                                Center(child: Text("العنوان"),),
                                TextFormField(controller: title_con,textDirection: TextDirection.rtl,),
                                SizedBox(height: 20,),
                                Center(child: Text("الموضوع"),),
                                TextFormField(controller: body_con,textDirection: TextDirection.rtl,),
                              ],
                            ),
                            actions: [
                              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("إلفاء")),
                              ElevatedButton(onPressed: (){
                                dio.post_data(url: "/dash/update_id",quary: {"table":" notices ","id":model['id'],"sql_key":" title = '${title_con.text}' , body = '${body_con.text}' "}).then((value) {
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " notices "}).then((value) {
                                    noti_list.clear();
                                    value?.data.forEach((element) {
                                      print(element);
                                      noti_list.add(element);
                                      if (noti_list.length == value.data.length) {
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
                              dio.post_data(url: "/dash/delet_id",quary: {"table":" notices ","id":model['id']}).then((value) {
                                print(value);
                                setstate(() {
                                  user_type_page = 0;
                                  is_loading_update_user = false;
                                  noti_list.clear();
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " notices "}).then((value) {
                                    value?.data.forEach((element) {
                                      print(element);
                                      noti_list.add(element);
                                      if (noti_list.length == value.data.length) {
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

