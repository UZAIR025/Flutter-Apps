import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:bmi_calculator/pages/main_page.dart';

void main() {
  //developer.log("\x1B[37mIBMI App Starting\x1B[0m");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CupertinoApp(
        title: 'IBMI',
        routes: {
          '/': (BuildContext _context) => MainPage(),
        },
        initialRoute: '/',
      ),
    );
  }
}
