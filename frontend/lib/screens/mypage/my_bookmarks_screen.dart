import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyBookmarksScreen extends StatefulWidget{
  const MyBookmarksScreen({super.key});

  @override
  State<MyBookmarksScreen> createState() => _MyBookmarksScreenState();
}


class _MyBookmarksScreenState extends State<MyBookmarksScreen>{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "나의 즐겨찾기",
            style: TextStyle(
              color: Color(0xFF323439),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          // 탭바 구현
          bottom: const TabBar(
            indicatorColor: Color(0xFF323439),
            indicatorWeight: 2.0,
            labelColor: Color(0xFF323439),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            tabs: [
              Tab(text: "나의 브랜드 (7)"),
              Tab(text: "저장한 프로모션 (65)"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMyBrandsList(),
            const Center(child: Text("저장한 프로모션 화면입니다.")),
          ],
        ),
      ),
    );
  }

  // 브랜드 리스트 위젯
  Widget _buildMyBrandsList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        _buildBrandItem(
          logoColor: const Color(0xFFF5EBDC), // 베이지색 배경
          logoText: "BURGER\nKING",
          logoTextColor: Colors.red,
          category: "햄버거",
          brandName: "버거킹",
          storeCount: 6,
        ),
        const SizedBox(height: 20),
        _buildBrandItem(
          logoColor: const Color(0xFFDA0015), // 빨간색 배경
          logoText: "M",
          logoTextColor: Colors.yellow,
          category: "햄버거",
          brandName: "맥도날드",
          storeCount: 4,
        ),
        const SizedBox(height: 20),
        _buildBrandItem(
          logoColor: const Color(0xFF009345), // 초록색 배경
          logoText: "신전",
          logoTextColor: Colors.white,
          category: "떡볶이",
          brandName: "신전떡볶이",
          storeCount: 2,
        ),
      ],
    );
  }

  Widget _buildBrandItem({
    required Color logoColor,
    required String logoText,
    required Color logoTextColor,
    required String category,
    required String brandName,
    required int storeCount,
  }) {
    return Row(
      children: [
        // 1. 로고 이미지
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: logoColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              logoText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: logoTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // 2. 텍스트
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(
                  color: Color(0xFF858C9A),
                  fontSize: 13,
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 4),
              Text(
                brandName,
                style: const TextStyle(
                  color: Color(0xFF323439),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "근처 ${storeCount}개의 매장",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset('assets/images/SearchOutline.svg',width: 16,),
                ],
              ),
            ],
          ),
        ),

        // 3. 하트
        IconButton(
          onPressed: () {
          },
          icon: const Icon(
            Icons.favorite,
            color: Color(0xFFFF3B30),
            size: 28,
          ),
        ),
      ],
    );
  }
}
