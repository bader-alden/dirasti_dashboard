class copon_module{
  String? id;
  String? grade;
  String? add_by;
  List<String>? list_cours;
  String? uid_copon;
  String? name_copon;
  bool? is_open;
  String? price;
  copon_module.fromjson(json){
    id = json['id'].toString();
    grade = json['grade'].toString();
    add_by = json['add_by'].toString();
    list_cours = json['list_cours'].toString().split("|");
    uid_copon = json['uid_copon'];
    name_copon = json['name_copon'];
    is_open = json['is_open']==1;
    price = json['price'].toString();
  }
}