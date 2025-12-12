import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TafsirPageView extends StatefulWidget {
  final int initialPage;

  const TafsirPageView({
    Key? key,
    this.initialPage = 1,
  }) : super(key: key);

  @override
  State<TafsirPageView> createState() => _TafsirPageViewState();
}

class _TafsirPageViewState extends State<TafsirPageView> {
  Map<String, dynamic> jsonData = {};
  late PageController _pageController;
  int currentPage = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
    _pageController = PageController(initialPage: currentPage - 1);
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/extracted_ayat.json');
      final data = await json.decode(response);
      setState(() {
        jsonData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading JSON: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final totalPages = jsonData.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF0),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5E6D3),
        title: Text(
          'التفسير الميسر',
          style: TextStyle(
            fontFamily: 'Taha',
            fontSize: 22.sp,
            color: const Color(0xFF2C1810),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2C1810)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFD4A574).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD4A574), width: 1.5),
            ),
            child: Text(
              'صفحة $currentPage',
              style: TextStyle(
                fontFamily: 'aldahabi',
                fontSize: 14.sp,
                color: const Color(0xFF2C1810),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        reverse: true,
        onPageChanged: (index) {
          setState(() {
            currentPage = index + 1;
          });
        },
        itemCount: totalPages,
        itemBuilder: (context, index) {
          final pageNumber = (index + 1).toString();
          final pageData = jsonData[pageNumber];

          if (pageData == null || pageData['ayats'] == null) {
            return const Center(child: Text('لا توجد بيانات'));
          }

          return _buildPageContent(pageData['ayats']);
        },
      ),
    );
  }

  Widget _buildPageContent(List<dynamic> ayats) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFFBF0),
            const Color(0xFFF5E6D3).withOpacity(0.3),
          ],
        ),
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        itemCount: ayats.length,
        itemBuilder: (context, index) {
          final ayatData = ayats[index];
          return _buildAyatCard(ayatData, index);
        },
      ),
    );
  }

  Widget _buildAyatCard(Map<String, dynamic> ayatData, int index) {
    final List<dynamic> ayatList = ayatData['ayat'] ?? [];
    final String tafsir = ayatData['tafsir'] ?? '';

    return Padding(
      padding: EdgeInsets.only(bottom: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (ayatList.isNotEmpty) ..._buildAyatWithMeanings(ayatList),
          if (tafsir.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Text(
              "التفسير",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Taha',
                fontSize: 16.sp,
                color: const Color(0xFFD4A574),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            _buildTafsirText(tafsir),
          ],

          // Simple divider
          SizedBox(height: 20.h),
          Divider(
            color: const Color(0xFFD4A574).withOpacity(0.3),
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildTafsirText(String tafsir) {
    List<TextSpan> textSpans = [];

    List<String> parts = tafsir.split('#');
    String baseFontFamily = tafsir.contains('♠') ? 'maali' : 'amiri';
    String mushafFont = 'QCF_P${(currentPage + 1).toString().padLeft(3, "0")}';

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;

      bool isSpecialSection = i % 2 == 1;

      if (isSpecialSection) {
        textSpans.add(
          TextSpan(
            text: '(',
            style: TextStyle(
              fontFamily: baseFontFamily,
              fontSize: 14.sp,
              height: 1.8,
              color: const Color(0xFF2C1810),
            ),
          ),
        );

        // Add Quranic text with Mushaf font
        textSpans.add(
          TextSpan(
            text: parts[i],
            style: TextStyle(
              fontFamily: mushafFont,
              fontSize: 20.sp,
              height: 1.8,
              color: const Color(0xFF2C1810),
            ),
          ),
        );

        textSpans.add(
          TextSpan(
            text: ')',
            style: TextStyle(
              fontFamily: baseFontFamily,
              fontSize: 14.sp,
              height: 1.8,
              color: const Color(0xFF2C1810),
            ),
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: parts[i],
            style: TextStyle(
              fontFamily: baseFontFamily,
              fontSize: 14.sp,
              height: 1.8,
              color: const Color(0xFF2C1810),
            ),
          ),
        );
      }
    }

    return RichText(
      textAlign: TextAlign.justify,
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }

  List<Widget> _buildAyatWithMeanings(List<dynamic> ayatList) {
    List<TextSpan> textSpans = [];

    for (var item in ayatList) {
      final String aya = item['aya'] ?? '';
      final String meaning = item['meaning'] ?? '';

      if (aya.isEmpty && meaning.isEmpty) continue;

      if (aya.isNotEmpty) {
        textSpans.add(
          TextSpan(
            text: aya,
            style: TextStyle(
              fontFamily:
                  'QCF_P${(currentPage + 1).toString().padLeft(3, "0")}',
              fontSize: 24.sp,
              height: 1.8,
              color: Colors.black,
            ),
          ),
        );
        textSpans.add(
          TextSpan(
            text: ' ',
            style: TextStyle(fontSize: 10.sp),
          ),
        );
      }
      if (meaning.isNotEmpty) {
        textSpans.add(
          TextSpan(
            text: '($meaning) ',
            style: TextStyle(
              fontFamily: 'amiri',
              fontSize: 12.sp,
              height: 1.6,
              color: Colors.green,
            ),
          ),
        );
      }
    }
    return [
      RichText(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.justify,
        text: TextSpan(
          children: textSpans,
        ),
      ),
    ];
  }
}
