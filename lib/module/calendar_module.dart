class calendar_module{
  String? body;
  String? date;
  String? time;
  String? subject;
  calendar_module.fromjson(json){
    body = json['body'];
    date = json['date'];
    time = json['time'];
    subject = json['subject'];
  }
}