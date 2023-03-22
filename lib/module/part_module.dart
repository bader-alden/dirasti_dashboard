import 'dart:convert';

class part_module{
  String? teacher_name;
  String? name;
  String? id;
  String? subject;
  String? grade;
  List<part_detail_module>? part=[];
  String? number_hours;
  String? order;
  String? is_course;
  String? course;
  part_module.fromjson(jsond){
    teacher_name = jsond['teacher_name'];
    name = jsond['name'];
    id = jsond['id'].toString();
    order = jsond['ordero'].toString();
    course = jsond['course'].toString();
    subject = jsond['subject'].toString();
    grade = jsond['grade'].toString();
      print(jsond['part']);
      json.decode(jsond['part'].toString()).forEach((e){
     part?.add( part_detail_module.fromjson(e));
    });

  }

}
class part_detail_module{

  String? name;
  String? time;
  String? order;
  Map? res;
  part_detail_module({this.name, this.time, this.res, this.order});

  part_detail_module.fromjson(json){
    name = json['name'].toString();
    time = json['time'].toString();
    order = json['order'].toString();
    res = json['res'].map((key, value) => MapEntry(key, value?.toString()));
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['time'] = this.time;
    data['order'] = this.order;
    data['res'] = this.res;
    return data;
  }
}