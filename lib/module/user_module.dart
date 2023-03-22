class user_module{
  String? name;
  String? id;
  String? email;
  bool? is_male;
  String? course_file;
  String? grade;
  String? mobile_id;
  user_module.fromjson(json){
    name = json['name'].toString();
    email = json['email'].toString();
    is_male = json['is_male'].toString()=="1";
    course_file = json['course_file'].toString();
    grade = json['grade'].toString();
    mobile_id = json['mobile_id'].toString();
    id = json['user_id'].toString();
  }
}