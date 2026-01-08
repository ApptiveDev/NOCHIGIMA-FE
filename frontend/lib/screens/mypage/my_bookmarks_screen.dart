import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Brand {
  final int brandId;
  final String brandName;
  final String imageUrl;
  final int discountedProductCount; // 할인 상품 개수

  Brand({
    required this.brandId,
    required this.brandName,
    required this.imageUrl,
    required this.discountedProductCount,
  });

  // 나중에 백엔드 JSON을 받으면 이 함수가 자동으로 객체로 변환해줍니다.
  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      brandId: json['brandId'] ?? 0,
      brandName: json['brandName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      discountedProductCount: json['discountedProductCount'] ?? 0,
    );
  }
}

class MyBookmarksScreen extends StatefulWidget{
  const MyBookmarksScreen({super.key});

  @override
  State<MyBookmarksScreen> createState() => _MyBookmarksScreenState();
}


class _MyBookmarksScreenState extends State<MyBookmarksScreen>{
  final List<Brand> _brandList = [
    Brand(
      brandId: 1,
      brandName: "버거킹",
      imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Burger_King_logo_%281999%29.svg/2024px-Burger_King_logo_%281999%29.svg.png", // 실제 테스트용 이미지 URL
      discountedProductCount: 12,
    ),
    Brand(
      brandId: 2,
      brandName: "맥도날드",
      imageUrl: "", // 이미지가 없는 경우 테스트
      discountedProductCount: 5,
    ),
    Brand(
      brandId: 3,
      brandName: "신전떡볶이",
      imageUrl: "broken_url", // 이미지가 깨진 경우 테스트
      discountedProductCount: 8,
    ),
  ];

  void _removeBrand(int index){
    setState(() {
      _brandList.removeAt(index);
    });
  }

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
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Color(0xFF323439),
            indicatorWeight: 2.0,
            labelColor: Color(0xFF323439),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            tabs: [
              Tab(text: "나의 브랜드 (${_brandList.length})"),
              Tab(text: "저장한 프로모션 (65)"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _brandList.isEmpty ? const Center(child: Text("즐겨찾기한 브랜드가 없습니다."),)
            : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: _brandList.length,
              itemBuilder: (context, index) {
                final item = _brandList[index];
                return Column(
                  children: [
                    _buildBrandItem(
                      index, _brandList[index]
                    ),
                    const SizedBox(height: 20), // 간격
                  ],
                );
              },
            ),
            const Center(child: Text("저장한 프로모션 화면입니다.")),
          ],
        ),
      ),
    );
  }


  Widget _buildBrandItem(
    int index, Brand brand
  ) {
    return Row(
      children: [
        // 1. 로고 이미지
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              brand.brandName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF323439),
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
                brand.brandName,
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
                    "할인 중인 ${brand.discountedProductCount}개의 상품",
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
            _removeBrand(index);
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
