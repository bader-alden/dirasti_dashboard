class teacher_module{
  String? teacher_name;
  String?  exam_dashboard_id;
  String? id;
  String? subject;
  String? photo;
  String? grade;
  teacher_module.fromjson(json){
    teacher_name = json['teacher_name'];
    id = json['id'].toString();
    subject = json['subject'].toString();
    photo = json['photo'].toString();
    exam_dashboard_id = json['exam_dashboard_id'].toString();
    grade = json['grade'].toString();
  }
}