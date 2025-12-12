import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_tutorial/views/my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392.72727272727275, 800.7272727272727),
      builder: (context, child) => const MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

// 1- separate design in UI (background)
// 2- put (lotus) font in all program
// 3- make meaning in dark red and increase font by 2 degrees u'll find it in word office
// 4- التفسير = اللطائف
// 5- make quranic text in tafsir in purple (like word file if it's not colored don't color it)
// 6- save last page on read sth like (anchor)
