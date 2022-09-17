import 'package:flutter/material.dart';
import 'package:oem_huahuan220824_flutter/view/screen/main_screen.dart';

void main() {
  runApp(const Project20220824());
}

class Project20220824 extends StatelessWidget {
  const Project20220824({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}
