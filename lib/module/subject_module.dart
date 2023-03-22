class subject_module{
  String? id;
  String? photo;
  String? subject;
  String? grade;
  String? banner_1;
  String? banner_2;
  String? banner_3;
  subject_module.fromjson(json){
    id = json['id'].toString();
    photo = json['photo'].toString();
    subject = json['subject'].toString();
    grade = json['grade'].toString();
    banner_1 = json['banner1'].toString();
    banner_2 = json['banner2'].toString();
    banner_3 = json['banner3'].toString();
  }
}