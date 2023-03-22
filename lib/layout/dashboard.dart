import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'الصفحة الرئيسية',
          style: TextStyle(fontSize: 35),
        ),
      ),
    );
  }
}
