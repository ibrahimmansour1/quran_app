import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_tutorial/views/quran_sura_page.dart';
import 'package:quran_tutorial/views/tafsir_page_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var widgejsonData;

  loadJsonAsset() async {
    final String jsonString =
        await rootBundle.loadString('assets/json/surahs.json');
    var data = jsonDecode(jsonString);
    setState(() {
      widgejsonData = data;
    });
  }

  @override
  void initState() {
    loadJsonAsset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFBF0),
              Color(0xFFF5E6D3),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Title
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD4A574).withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.auto_stories_rounded,
                        size: 60.sp,
                        color: const Color(0xFFD4A574),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'القرآن الكريم',
                        style: TextStyle(
                          fontFamily: 'Taha',
                          fontSize: 32.sp,
                          color: const Color(0xFF2C1810),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'اقرأ وتدبر آيات الله',
                        style: TextStyle(
                          fontFamily: 'arial',
                          fontSize: 14.sp,
                          color: const Color(0xFF8B7355),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 50.h),

                // Navigation Cards
                _buildNavigationCard(
                  context,
                  title: 'قراءة المصحف',
                  subtitle: 'القرآن الكريم بالرسم العثماني',
                  icon: Icons.menu_book_rounded,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFD4A574),
                      Color(0xFFB8935E),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => QuranPage(
                          suraJsonData: widgejsonData,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20.h),

                _buildNavigationCard(
                  context,
                  title: 'التفسير الميسر',
                  subtitle: 'تفسير الآيات مع معاني الكلمات',
                  icon: Icons.school_rounded,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF81C784),
                      Color(0xFF66BB6A),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => const TafsirPageView(
                          initialPage: 1,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 40.h),

                // Footer text
                Text(
                  '﴿ وَرَتِّلِ الْقُرْآنَ تَرْتِيلًا ﴾',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Taha',
                    fontSize: 18.sp,
                    color: const Color(0xFF8B7355),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                size: 40.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Taha',
                      fontSize: 22.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'arial',
                      fontSize: 13.sp,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
