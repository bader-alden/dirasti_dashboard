import 'dart:html';

import 'package:dirasti_dashboard/utils/const.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:dirasti_dashboard/module/user_module.dart';
import 'package:flutter/material.dart';

import '../module/user_module.dart';

List<user_module> user_list = [];
ScrollController user_list_con = ScrollController();
ScrollController user_elment_con = ScrollController();
int user_type_page = 0;
bool is_loading_update_user = false;
user_module? user_model_type;

class Users extends StatefulWidget {
  Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  void initState() {
    dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " user "}).then((value) {
      value?.data.forEach((element) {
        print(element);
        user_list.add(user_module.fromjson(element));
        if (user_list.length == value.data.length) {
          setState(() {});
        }
      });
    });


  }

  @override
  void dispose() {
    super.dispose();
    user_list.clear();
    user_type_page = 0;
    user_model_type = null;
  }

  @override
  Widget build(BuildContext context) {
    if (user_type_page == 1 && user_model_type != null) {
      return user_detail_widget(context, user_model_type, setState);
    } else if (user_type_page == 2 && user_model_type != null) {
      return user_update_widget(context, user_model_type, setState);
    } else if (user_type_page == 4) {
      return user_update_widget(context, null, setState);
    } else {
      if (user_list.isNotEmpty) {
        return Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text("قائمة بالمستخدمين", style: TextStyle(fontSize: 30)),
                Spacer(),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    onPressed: () {
                      setState(() {
                        user_type_page = 4;
                      });
                    },
                    child: Text("إضافة مستخدم")),
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
                controller: user_list_con,
                child: ListView.separated(
                    shrinkWrap: true,
                    controller: user_list_con,
                    itemBuilder: (context, index) {
                      return ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 200), child: user_list_element(context, user_list[index], setState));
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        width: double.infinity,
                        height: 2,
                        color: Colors.grey.shade300,
                      );
                    },
                    itemCount: user_list.length),
              ),
            ),
          ],
        );
      } else {
        return Container(
          color: Colors.white,
          child: const Center(
            child: Text(
              'المستخدمين',
              style: TextStyle(fontSize: 35),
            ),
          ),
        );
      }
    }
  }
}

Widget user_list_element(BuildContext context, user_module model, setstate) {
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
                  Icon(Icons.account_circle, size: 40),
                  SizedBox(
                    width: 10,
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
                  //   Text( MediaQuery.of(context).size.width.toString()),
                  Center(child: Text("الرقم: ${model.mobile_id!}")),
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
                          setstate(() {
                            user_model_type = model;
                            user_type_page = 1;
                          });
                        },
                        child: Text("عرض جميع المعلومات")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          setstate(() {
                            user_model_type = model;
                            user_type_page = 2;
                          });
                        },
                        child: Text("تعديل المستخدم")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              var title_con = TextEditingController();
                              var body_con = TextEditingController();
                              return AlertDialog(
                                title: Text('إرسال إشعار الى ' + model.name!),
                                content: Column(
                                  children: [
                                    Center(child: Text("العنوان"),),
                                    SizedBox(height: 20,),
                                    TextFormField(
                                      controller: title_con,
                                    ),
                                    SizedBox(height: 30,),
                                    Center(child: Text("المضمون"),),
                                    SizedBox(height: 20,),
                                    TextFormField(
                                      controller: body_con,
                                    ),
                                    SizedBox(height: 30,)
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('إلغاء'),
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                                    },
                                  ),
                                  TextButton(
                                    child: Text('إرسال'),
                                    onPressed: () {
                                      dio.post_data(url: "/fcm/res_one", quary: {"user_id": model.id, "title": title_con.text , "body": body_con.text}).then((value) {
                                        print(value?.data);
                                        print(value?.data);
                                        Tost_widget("تم الارسال بنجاج", "green");
                                        Navigator.of(dialogContext).pop();
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("إرسال إشعار")),
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
                              dio.post_data(url: "/dash/update_id_user",quary: {"table":" user ","id":model.id,"sql_key":"secret_code = 'restart' "}).then((value) {
                                print(value);
                                setstate(() {
                                  user_model_type = null;
                                  user_type_page = 0;
                                  is_loading_update_user = false;
                                  user_list.clear();
                                  dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " user "}).then((value) {
                                    value?.data.forEach((element) {
                                      print(element);
                                      user_list.add(user_module.fromjson(element));
                                      if (user_list.length == value.data.length) {
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
                        child: Text("اعادة فتح الحساب")),
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
                             dio.post_data(url: "/dash/delet_id_user",quary: {"table":" user ","id":model.id}).then((value) {
                               print(value);
                               setstate(() {
                                 user_model_type = null;
                                 user_type_page = 0;
                                 is_loading_update_user = false;
                                 user_list.clear();
                                 dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " user "}).then((value) {
                                   value?.data.forEach((element) {
                                     print(element);
                                     user_list.add(user_module.fromjson(element));
                                     if (user_list.length == value.data.length) {
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
                        child: Text("حذف المستخدم")),
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

Widget user_detail_widget(BuildContext context, user_module? model, setstate) {
  print(MediaQuery.of(context).size.width);
  return ListView(
    shrinkWrap: true,
    children: [
      SizedBox(
        height: 30,
      ),
      Row(
        children: [
          IconButton(
              onPressed: () {
                setstate(() {
                  user_type_page = 0;
                  user_model_type = null;
                });
              },
              icon: Icon(Icons.arrow_back_ios)),
          Spacer(),
          Text(
            "عرض بيانات المستخدم",
            style: TextStyle(fontSize: 30),
          ),
          Spacer(),
        ],
      ),
      SizedBox(
        height: 30,
      ),
      Container(
        height: 30,
        width: double.infinity,
      //  color: Colors.grey.shade200,
      ),
      Container(
        height: 350,
       // color: Colors.grey.shade200,
        child: GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width < 700 ? 1 : 2, childAspectRatio: 8),
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                  child: Text(
                "الاسم ${model?.name ?? "غيرمتوفر"}",
                style: TextStyle(fontSize: 24),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                  child: Text(
                "الرقم التسلسلي ${model?.id ?? "غيرمتوفر"}",
                style: TextStyle(fontSize: 24),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                  child: Text(
                    "رقم الجوال ${model?.mobile_id ?? "غيرمتوفر"}",
                    style: TextStyle(fontSize: 24),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                  child: Text(
                    "الجنس ${model!.is_male!?"ذكر":"انثى" }",
                    style: TextStyle(fontSize: 24),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                  child: Text(
                    "الصف ${model.grade}",
                    style: TextStyle(fontSize: 24),
                  )),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Center(
            //       child: Text(
            //     "العنوان ${model?.address ?? "غيرمتوفر"}",
            //     style: TextStyle(fontSize: 24),
            //   )),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Center(
            //       child: Text(
            //     "رقم الهوية ${model?.id_number ?? "غيرمتوفر"}",
            //     style: TextStyle(fontSize: 24),
            //   )),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Center(
            //       child: Text(
            //     "المفضلة ${model?.fav ?? "غيرمتوفر"}",
            //     style: TextStyle(fontSize: 24),
            //   )),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Center(child: Text("المزادات المشارك بها ${model?.auctions??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Center(child: Text("المزادات التي أنشأها ${ model?.my_auction??"غيرمتوفر"}",style: TextStyle(fontSize: 24),)),
            // ),
          ],
        ),
      ),
      SizedBox(
        height: 15,
      ),
      Container(
        height: 3,
        color: Colors.grey,
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        "الكورسات",
        style: TextStyle(fontSize: 24),
      ),
      SizedBox(
        height: 10,
      ),
      ListView.builder(
          itemCount: model?.course_file?.split(",").length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (model!.course_file!.split(",")[index] != "" && model!.course_file!.split(",")[index] != " "&&model!.course_file!.split(",")[index][0] == "1" ) {
              return Row(
                children: [
                  Text(model!.course_file!.split(",")[index]),
                  SizedBox(width: 20,),
                  ElevatedButton(onPressed: () {
                //    Navigator.push(context, MaterialPageRoute(builder: (context)=>auction_details_screen(is_redy: false,type: model!.fav![index].split("|")[1],id:model!.fav![index].split("|")[0] ,)));
                  }, child: Text("عرض")),
                ],
              );
            } else {
              return Container();
            }
          }),
      Container(
        height: 3,
        color: Colors.grey,
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        "الملفات",
        style: TextStyle(fontSize: 24),
      ),
      SizedBox(
        height: 10,
      ),
      ListView.builder(
          itemCount: model?.course_file?.split(",").length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (model!.course_file!.split(",")[index] != "" && model!.course_file!.split(",")[index] != " "&&model!.course_file!.split(",")[index][0] == "0" ) {
              return Row(
                children: [
                  Text(model!.course_file!.split(",")[index]),
                  SizedBox(width: 20,),
                  ElevatedButton(onPressed: () {
                    //    Navigator.push(context, MaterialPageRoute(builder: (context)=>auction_details_screen(is_redy: false,type: model!.fav![index].split("|")[1],id:model!.fav![index].split("|")[0] ,)));
                  }, child: Text("عرض")),
                ],
              );
            } else {
              return Container();
            }
          }),

      // ListView.builder(
      //     itemCount: model?.auctions?.length,
      //     shrinkWrap: true,
      //     itemBuilder: (context, index) {
      //       if (model!.auctions![index] != "") {
      //         return Row(
      //           children: [
      //             Text(model!.auctions![index]),
      //             ElevatedButton(onPressed: () {
      //               Navigator.push(context, MaterialPageRoute(builder: (context)=>auction_details_screen(is_redy: false,type: model!.auctions![index].split("|")[1],id:model!.auctions![index].split("|")[0] ,)));
      //             }, child: Text("عرض")),
      //           ],
      //         );
      //       } else {
      //         return Container();
      //       }
      //     }),
      SizedBox(
        height: 75,
      ),
    ],
  );
}

Widget user_update_widget(BuildContext context, user_module? model, setstate) {
  var name_con = TextEditingController(text: model?.name);
  var grade_con = TextEditingController(text: model?.grade);
  var mobile_num_con = TextEditingController(text: model?.mobile_id);
   var male_con = TextEditingController(text: (model?.is_male??true) ?"1":"0");
  return Column(
    children: [
      SizedBox(
        height: 30,
      ),
      Row(
        children: [
          IconButton(
              onPressed: () {
                setstate(() {
                  user_type_page = 0;
                  user_model_type = null;
                });
              },
              icon: Icon(Icons.arrow_back_ios)),
          Spacer(),
          Text(
            "تعديل بيانات المستخدم",
            style: TextStyle(fontSize: 30),
          ),
          Spacer(),
        ],
      ),
      SizedBox(
        height: 30,
      ),
      Container(
        height: 30,
        width: double.infinity,
        color: Colors.grey.shade200,
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.all(8),
          color: Colors.grey.shade200,
          child: ListView(
            // gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width<500 ?1:2,childAspectRatio: 10),
            children: [
              Text(
                "الاسم: ",
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 3),
                  child: TextFormField(
                    controller: name_con,
                  )),
              SizedBox(
                height: 40,
              ),
              Text(
                "الصف: ",
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 3),
                  child: TextFormField(
                    controller: grade_con,
                  )),
              SizedBox(
                height: 40,
              ),
              Text(
                "الحنس 0 للانثى 1 للذكر: ",
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 3),
                  child: TextFormField(
                    controller: male_con,
                  )),
              SizedBox(
                height: 40,
              ),
              Text(
                "رقم الجوال: ",
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 3),
                  child: TextFormField(
                    controller: mobile_num_con,
                  )),
              // SizedBox(
              //   height: 40,
              // ),
              // Text(
              //   "رقم الهوية: ",
              //   style: TextStyle(fontSize: 24),
              // ),
              // Padding(
              //     padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 3),
              //     child: TextFormField(
              //       controller: id_num_con,
              //     )),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setstate(() {
                          user_model_type = null;
                          user_type_page = 0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("إلغاء"),
                      )),
                  SizedBox(
                    width: 100,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setstate(() {
                          is_loading_update_user = true;
                        });

                        dio.post_data(url: "/dash/" + (model == null ? "insert" : "update_id_user"), quary: {
                          "table": "user",
                          "id": model == null ? "" : model?.id,
                          "sql_key": model != null
                              ? " grade = '" +
                                  grade_con.text +
                                  "', is_male = '" +
                                  male_con.text +
                                  "' , name = '" +
                                  name_con.text +
                                  "' , mobile_id = '" +
                                  mobile_num_con.text +
                                  "'"
                              : " grade , is_male  , name , mobile_id   ,gsm_token ,gsm_token2 , secret_code , course_file ",
                          "sql_value": " '" +
                              grade_con.text +
                              "', '" +
                              male_con.text +
                              "' , '" +
                              name_con.text +
                              "' , '" +
                              mobile_num_con.text +
                              "' , ' ' , ' ' , 'restart' , ' ' ",
                        }).then((value) {
                          print(value);
                          setstate(() {
                            user_model_type = null;
                            user_type_page = 0;
                            is_loading_update_user = false;
                            user_list.clear();
                            dio.post_data(url: "/dash/select", quary: {"sql": " * ", "table": " user "}).then((value) {
                              value?.data.forEach((element) {
                                print(element);
                                user_list.add(user_module.fromjson(element));
                                if (user_list.length == value.data.length) {
                                  setstate(() {});
                                }
                              });
                            });
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: is_loading_update_user
                            ? Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              )
                            : Text("موافق"),
                      ),
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey.shade400))),
                ],
              )
            ],
          ),
        ),
      )
    ],
  );
}
