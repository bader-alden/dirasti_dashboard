class noti_module{
  String? title;
  String? body;
  String? id;
  noti_module.fromjson(json){
    title = json['title'];
    id = json['id'].toString();
    body = json['body'];
  }
}