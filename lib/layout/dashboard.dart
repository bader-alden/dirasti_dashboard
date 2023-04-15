// import 'package:flutter/material.dart';
//
// class Dashboard extends StatelessWidget {
//   const Dashboard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: const Center(
//         child: Text(
//           'الصفحة الرئيسية',
//           style: TextStyle(fontSize: 35),
//         ),
//       ),
//     );
//   }
// }




/*
 * QR.Flutter
 * Copyright (c) 2019 the QR.Flutter authors.
 * See LICENSE for distribution and usage details.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../utils/QR.dart';

/// This is the screen that you'll see when the app starts
class Dashboard extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}


class _MainScreenState extends State<Dashboard> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final message =
        'https://cdn.glitch.me/e83b95d6-365a-4e9e-a4f5-1fddb25ddcd0/app.apk?v=1681222346769';
    final qrFutureBuilder = FutureBuilder<ui.Image>(
      future: _loadOverlayImage(),
      builder: (ctx, snapshot) {
        final size = 280.0;
        if (!snapshot.hasData) {
          return Container(width: size, height: size);
        }
        return CustomPaint(
          size: Size.square(size),
          painter: QrPainter(
            data: message,
            version: QrVersions.auto,
            eyeStyle:  QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.blue.shade800,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.black,
            ),
            // size: 320.0,
           // embeddedImage: snapshot.data,
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: Size.square(60),
            ),
          ),
        );
      },
    );

    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Container(
                    width: 280,
                    child: qrFutureBuilder,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40)
                    .copyWith(bottom: 40),
                child: Text("لتنزيل التطبيق يرجى مسح رمز الQR"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('assets/a.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }

}