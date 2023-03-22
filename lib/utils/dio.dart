import 'package:dirasti_dashboard/utils/const.dart';
import 'package:dirasti_dashboard/utils/hive.dart';
import 'package:dio/dio.dart';

class dio {
  static Dio? dios;
  static init() {
    dios = Dio(BaseOptions(
        baseUrl: base_url,
       // baseUrl: "https://faceted-dull-evening.glitch.me/",
        receiveDataWhenStatusError: true,
        followRedirects: true,
        validateStatus: (status) { return status! < 500;},
        headers: {'Content-Type': 'application/json','Accept':'application/json'}));
  }

  static Future<Response?> get_data({url, quary}) async {
    dios?.options.headers = { 'Accept':'application/json',"Access-Control-Allow-Origin": "*"};
    return await dios?.get(url,queryParameters: quary ??{});
  }

  static Future<Response?> post_data(
      {url,Map<String,dynamic>? quary, data,onsend}) async {
    dios?.options.headers = {'Accept':'application/json',"Access-Control-Allow-Origin": "*"};
    Map<String,dynamic> a = {"user_id_check":hive.hive_get("id")??"","pass_check":hive.hive_get("password")??""};
    a.addAll(quary??{});
    return dios?.post(url, queryParameters: a!, data: data,onSendProgress: onsend);
  }

  static Future<Response?> put_data(
      {url, quary, data,}) async {

    return dios?.put(url, queryParameters: quary, data: data);
  }
  // static Future<Response?> download(
  //     {url, quary, data, lang = "ar", token}) async {
  //   dios?.options.headers = {'lang': lang, 'Authorization': token};
  //
  //   return dios?.download(url, savePath);
  //}
}
