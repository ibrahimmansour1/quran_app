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

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4A574).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with verse number
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFD4A574),
                    Color(0xFFB8935E),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_stories_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'الآية ${index + 1}',
                    style: TextStyle(
                      fontFamily: 'Taha',
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Ayat with meanings
            if (ayatList.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Build aya text with word meanings
                    ..._buildAyatWithMeanings(ayatList),

                    SizedBox(height: 20.h),

                    // Divider
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            const Color(0xFFD4A574).withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Tafsir section
            if (tafsir.isNotEmpty)
              Container(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'التفسير',
                          style: TextStyle(
                            fontFamily: 'Taha',
                            fontSize: 18.sp,
                            color: const Color(0xFFD4A574),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4A574).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.menu_book_rounded,
                            color: const Color(0xFFD4A574),
                            size: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      tafsir,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'arial',
                        fontSize: 15.sp,
                        height: 1.8,
                        color: const Color(0xFF2C1810),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAyatWithMeanings(List<dynamic> ayatList) {
    List<Widget> widgets = [];

    for (var item in ayatList) {
      final String aya = item['aya'] ?? '';
      final String meaning = item['meaning'] ?? '';

      if (aya.isEmpty && meaning.isEmpty) continue;

      // If there's only meaning (like a section header)
      if (aya.isEmpty && meaning.isNotEmpty) {
        widgets.add(
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFD4A574).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              meaning,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'arial',
                fontSize: 13.sp,
                color: const Color(0xFFB8935E),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        );
        continue;
      }

      // Aya text with optional meaning
      widgets.add(
        Container(
          margin: EdgeInsets.only(bottom: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Arabic text
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDF8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFD4A574).withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  aya,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily:
                        'QCF_P${currentPage.toString().padLeft(3, "0")}',
                    fontSize: 26.sp,
                    height: 2.0,
                    color: const Color(0xFF1A1A1A),
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              // Meaning if exists
              if (meaning.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF81C784).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          meaning,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily:
                                'QCF_P${currentPage.toString().padLeft(3, "0")}',
                            fontSize: 16.sp,
                            color: const Color(0xFF2E7D32),
                            height: 1.8,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.lightbulb_outline,
                        size: 16.sp,
                        color: const Color(0xFF66BB6A),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return widgets;
  }
}
