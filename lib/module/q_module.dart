class q_module{
  String? id;
  String? question;
  String? photo;
  String? exam;
  String? Answer1;
  String? Answer2;
  String? Answer3;
  String? Answer4;
  String? index;
  q_module.fromjson(json){
    question = json['question'];
    exam = json['exam'];
    photo = json['photo'];
    id = json['id'].toString();
    index = json['indexs'].toString();
    Answer1 = json['Answer1'].toString();
    Answer2 = json['Answer2'].toString();
    Answer3 = json['Answer3'].toString();
    Answer4 = json['Answer4'].toString();
  }
}