class teacher_module{
  String? teacher_name;
  String? id;
  String? subject;
  String? photo;
  String? grade;
  teacher_module.fromjson(json){
    teacher_name = json['teacher_name'];
    id = json['id'].toString();
    subject = json['subject'].toString();
    photo = json['photo'].toString();
    grade = json['grade'].toString();
  }
}