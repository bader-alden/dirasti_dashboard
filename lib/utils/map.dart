import 'dart:html';
import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import 'dart:ui' as ui;

class Map_screen extends StatelessWidget {
  const Map_screen({Key? key, this.lat, this.lan, this.title}) : super(key: key);
final lat;
final lan;
final title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(" موقع " + title,style: TextStyle(color: Colors.black),),
      centerTitle: true,
      leading: null,
        actions: [
          SizedBox(width: 20,),
          BackButton(color: Colors.black,)
        ],
      ),
      body: Center(
        child: Container(
            height: 1000,
            width: 1000,
            child: getMap(lat,lan)),
      ),
    );
  }
}

Widget getMap(lat,lan) {
  String htmlId = "7";

  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
    final myLatlng = LatLng(double.parse(lat),double.parse(lan));

    final mapOptions = MapOptions()
      ..zoom = 17
      ..center =LatLng(double.parse(lat),double.parse(lan));

    final elem = DivElement()
      ..id = htmlId
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.border = 'none';

    final map = GMap(elem, mapOptions);

    Marker(MarkerOptions()
      ..position = myLatlng
      ..map = map
      ..title = ' '
    );

    return elem;
  });

  return HtmlElementView(viewType: htmlId);
}