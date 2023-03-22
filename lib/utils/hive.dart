import 'package:hive/hive.dart';

class hive {
  static Box<dynamic>? hive_box;
  static init() async {
     hive_box = await Hive.openBox("all");
  }

  static dynamic hive_get(key)  {
    return  hive_box?.get(key);
  }

  static dynamic hive_put(key,value) async {
    return await hive_box?.put(key,value);
  }
  static dynamic hive_delet(key) async {
    return await hive_box?.delete(key);
  }
}