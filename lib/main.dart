import 'dart:html';
import 'dart:html' as html;

import 'package:dirasti_dashboard/layout/Users.dart';
import 'package:dirasti_dashboard/layout/exam.dart';
import 'package:dirasti_dashboard/layout/login.dart';
import 'package:dirasti_dashboard/layout/subject.dart';
import 'package:dirasti_dashboard/utils/dio.dart';
import 'package:dirasti_dashboard/utils/hive.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'layout/change_pass.dart';
import 'layout/copon.dart';
import 'layout/course.dart';
import 'layout/dashboard.dart';
import 'layout/file.dart';
import 'layout/grade.dart';
import 'layout/notification.dart';
import 'layout/setting.dart';
import 'layout/subject_calendar.dart';
import 'layout/teacher.dart';
String getOSInsideWeb() {
  final userAgent = window.navigator.userAgent.toString().toLowerCase();
  if( userAgent.contains("iphone"))  return "ios";
  if( userAgent.contains("ipad")) return "ios";
  if( userAgent.contains("android"))  return "Android";
  return "Web";
}
main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  String platform = "";
  if (kIsWeb) {
    platform = getOSInsideWeb();
  }
  if(platform == "Android" ||platform =="ios" ){
    is_open = false;
  }else{
    is_open = true;
  }

  dio.init();
  await hive.init();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'دراستي',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home:  Login(),
      // home: const MyHomePage(title: 'easy_sidemenu Demo'),
      debugShowCheckedModeBanner: false,
    );
  }
}

SideMenuController page = SideMenuController();
var page_con = PageController();
bool is_open = true;
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SideMenu(
                controller: page,
                style: SideMenuStyle(
                  showTooltip: false,
                  displayMode: is_open?SideMenuDisplayMode.open:SideMenuDisplayMode.compact,
                  hoverColor: Colors.blue[100],
                  selectedColor: Colors.lightBlue,
                  selectedTitleTextStyle: const TextStyle(color: Colors.white),
                  selectedIconColor: Colors.white,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.all(Radius.circular(10)),
                  // ),
                  // backgroundColor: Colors.blueGrey[700]
                ),
                title: Column(
                  children: [
                    SizedBox(height: 10,),
                    ElevatedButton(onPressed: (){
                      setState(() {
                        is_open=!is_open;
                      });
                    }, child: Container(width: double.infinity,child: Icon(Icons.menu_open))),
                    SizedBox(height: 20,),
                    ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 200,
                          maxWidth: 300,
                        ),
                        child: Image.asset("assets/logo.png")
                    ),
                    SizedBox(height: 20,),
                    const Divider(
                      indent: 8.0,
                      endIndent: 8.0,
                    ),
                  ],
                ),
                footer: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'تم الإعداد بواسطة تطبيقي',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                items: [
                  SideMenuItem(
                    priority: 0,
                    title: 'الصفحة الرئيسية',
                    onTap: (index,con) {
                      page.changePage(0);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.home),
                  ),

                    SideMenuItem(
                      priority: 1,
                      title: 'المستخدمين',
                      onTap: (index,con) {
                        page.changePage(1);
                        page_con.jumpToPage(index);
                      },
                      icon: const Icon(Icons.supervisor_account),
                    ),

                    SideMenuItem(
                      priority: 2,
                      title: 'السنوات الدراسية',
                      onTap: (index,con) {
                        page.changePage(2);
                        page_con.jumpToPage(index);
                      },
                      icon: const Icon(Icons.school),
                    ),

                    SideMenuItem(
                      priority: 3,
                      title: 'المواد',
                      onTap: (index,con) {
                        page.changePage(3);
                        page_con.jumpToPage(index);
                      },
                      icon: const Icon(Icons.subject),
                    ),

                    SideMenuItem(
                      priority: 4,
                      title: 'الاساتذة',
                      onTap: (index,con) {
                        page.changePage(4);
                        page_con.jumpToPage(index);
                      },
                      icon: const Icon(Icons.co_present_outlined),
                    ),

                    SideMenuItem(
                      priority: 5,
                      title: 'الكورسات',
                      onTap: (index,con) {
                        page.changePage(5);
                        page_con.jumpToPage(index);
                      },
                      icon: const Icon(Icons.video_collection),
                    ),
                    SideMenuItem(
                      priority: 6,
                      title: 'الملفات',
                      onTap: (index,con) {
                        page.changePage(6);
                        page_con.jumpToPage(index);
                      },
                      icon: const Icon(Icons.list_alt_sharp),
                    ),
                  SideMenuItem(
                    priority: 7,
                    title: 'الاختبارات',
                    onTap: (index,con) {
                      page.changePage(7);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.question_answer_outlined),
                  ),
                  SideMenuItem(
                    priority: 8,
                    title: 'الاشعارات',
                    onTap: (index,con) {
                      page.changePage(8);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.notifications),
                  ),
                  SideMenuItem(
                    priority: 9,
                    title: 'أكواد التفعيل',
                    onTap: (index,con) {

                      page.changePage(9);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.credit_card),
                  ),
                  SideMenuItem(
                    priority: 10,
                    title: 'مواد التقويم',
                    onTap: (index,con) {
                      page.changePage(10);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.calendar_month),
                  ),
                  SideMenuItem(
                      priority: 11,
                      title: 'الإعدادات العامة',
                      onTap: (index,con) {
                        page.changePage(11);
                        page_con.jumpToPage(index);
                      },
                      icon: const Icon(Icons.settings),
                    ), SideMenuItem(
                    priority: 12,
                    title: 'تغيير كلمة السر',
                    onTap: (index,con) {
                      page.changePage(12);
                      page_con.jumpToPage(index);
                    },
                    icon: const Icon(Icons.password),
                  ),

                  SideMenuItem(
                    priority: 13,
                    title: 'تسجيل الخروج',
                    icon: Icon(Icons.exit_to_app),
                    onTap: (index,con) async {
                      await hive.hive_delet("id");
                      await hive.hive_delet("password");
                      html.window.location.reload();
                      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false);
                    },
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: page_con,
                  physics: NeverScrollableScrollPhysics(),
                  children:  [
                    Dashboard(),
                    Users(),
                    Grade(),
                    Subject(),
                    Teacher(),
                    Course(),
                    File_layout(),
                    Exam(),
                    NotificationPage(),
                    Copon(),
                    CalendarSubject(),
                    Settings(),
                    ChangePass(),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}