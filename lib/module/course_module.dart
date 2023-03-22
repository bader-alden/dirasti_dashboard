class course_module{
  String? teacher_name;
  String? name;
  String? des;
  String? banner;
  String? id;
  String? subject;
  String? photo;
  String? grade;
  String? price;
  String? part;
  String? order;
  String? number_hours;
  bool? is_free;
  course_module.fromjson(json){
    teacher_name = json['teacher_name'];
    name = json['name'];
    des = json['des'];
    banner = json['banner'];
    id = json['id'].toString();
    order = json['ordero'].toString();
    subject = json['subject'].toString();
    photo = json['photo'].toString();
    grade = json['grade'].toString();
    price = json['price'].toString();
    part = json['part'].toString();
    number_hours = json['number_hours'].toString();
    is_free = json['is_free'].toString() == "1" ;
  }
}