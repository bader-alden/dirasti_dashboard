class grade_module{
  String? name;
  String? id;
  grade_module.fromjson(json){
    name = json['name'];
    id = json['id'].toString();
  }
}