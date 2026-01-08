import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/models/my_bookmarks_brand.dart';
import 'package:frontend/widgets/home/bookmarks_card.dart';
import 'package:frontend/screens/mypage/my_bookmarks_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyBookmarks extends StatefulWidget {
  const MyBookmarks({super.key});

  @override
  State<MyBookmarks> createState() => _MyBookmarksState();
}

class _MyBookmarksState extends State<MyBookmarks> {
  List<Brand> bookmarkBrands = [];
  bool _isLoading = true;

  final storage = const FlutterSecureStorage();
  final String baseUrl = "api.nochigima.shop";

  @override
  void initState() {
    super.initState();
    _fetchRecentBookmarks();
  }

  Future<void> _fetchRecentBookmarks() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      final uri = Uri.https(baseUrl, '/v1/favorites/brands');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        setState(() {
          bookmarkBrands = jsonList
              .map((json) => Brand.fromJson(json))
              .toList();
          _isLoading = false;
        });
      } else {
        print("홈 즐겨찾기 로드 실패: ${response.statusCode}");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("홈 즐겨찾기 네트워크 에러: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '나의 즐겨찾기',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w700,
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyBookmarksScreen(),
                    ),
                  ).then((_) {
                    _fetchRecentBookmarks();
                  });
                },
                child: Row(
                  children: [
                    const Text(
                      '전체보기 >',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Pretendard",
                        fontWeight: FontWeight.w400,
                        color: AppColors.nochigimaColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF333F)),
                )
              : bookmarkBrands.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  shrinkWrap: false,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  itemBuilder: (context, index) {
                    return BookmarksCard(brand: bookmarkBrands[index]);
                  },
                  separatorBuilder: (_, _) => const SizedBox(width: 18.0),
                  itemCount: bookmarkBrands.length,
                ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.bookmark_border, color: Colors.grey, size: 30),
          SizedBox(height: 8),
          Text(
            "즐겨찾기한 브랜드가 없어요",
            style: TextStyle(
              fontFamily: "Pretendard",
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
