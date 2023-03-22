class file_module{
  String? teacher_name;
  String? name;
  String? id;
  String? subject;
  String? photo;
  String? grade;
  String? price;
  String? link;
  String? des;
  String? order;
  String? number_page;
  bool? is_free;
  file_module.fromjson(json){
    teacher_name = json['teacher_name'];
    name = json['name'];
    id = json['id'].toString();
    order = json['ordero'].toString();
    subject = json['subject'].toString();
    photo = json['photo'].toString();
    grade = json['grade'].toString();
    price = json['price'].toString();
    link = json['link'].toString();
    des = json['des'].toString();
    number_page = json['number_of_pages'].toString();
    is_free = json['is_free'].toString() == "1" ;
  }
}