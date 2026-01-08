import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/widgets/mypage/brand_item.dart';
import '../../widgets/mypage/mypage_widgets.dart';
import '../../models/my_bookmarks_promotion.dart';
import '../../models/my_bookmarks_brand.dart';

class MyBookmarksScreen extends StatefulWidget {
  const MyBookmarksScreen({super.key});

  @override
  State<MyBookmarksScreen> createState() => _MyBookmarksScreenState();
}

class _MyBookmarksScreenState extends State<MyBookmarksScreen> {
  final List<Brand> _brandList = [
    Brand(
      brandId: 1,
      brandName: "버거킹",
      imageUrl:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Burger_King_logo_%281999%29.svg/2024px-Burger_King_logo_%281999%29.svg.png",
      // 실제 테스트용 이미지 URL
      discountedProductCount: 12,
      categoryId: 0
    ),
    Brand(
      brandId: 2,
      brandName: "맥도날드",
      imageUrl: "", // 이미지가 없는 경우 테스트
      discountedProductCount: 5,
      categoryId: 0
    ),
    Brand(
      brandId: 3,
      brandName: "신전떡볶이",
      imageUrl: "broken_url", // 이미지가 깨진 경우 테스트
      discountedProductCount: 8,
      categoryId: 1
    ),
  ];

  final List<Promotion> _promotionList = [
    Promotion(
      productId: 101,
      productName: "와퍼 주니어 세트",
      brandId: 1,
      brandName: "버거킹",
      price: 8000,
      imageUrl:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Burger_King_logo_%281999%29.svg/2024px-Burger_King_logo_%281999%29.svg.png",
      isDiscountedNow: true,
      // 할인 중 (초록색 아이콘)
      discountValue: 0,
      discountStartAt: "2026-01-08",
      discountEndAt: "2026-01-15",
      discountedPrice: 4500,
    ),
    Promotion(
      productId: 102,
      productName: "빅맥 런치 세트",
      brandId: 2,
      brandName: "맥도날드",
      price: 7200,
      imageUrl: "",
      isDiscountedNow: false,
      // 할인 종료 (회색 아이콘)
      discountValue: 0,
      discountStartAt: "2025-12-01",
      discountEndAt: "2025-12-31",
      discountedPrice: 5900,
    ),
  ];

  void _removeBrand(int index) {
    setState(() {
      _brandList.removeAt(index);
    });
  }

  void _removePromotion(int index) {
    setState(() {
      _promotionList.removeAt(index);
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
              Tab(text: "저장한 프로모션 (${_promotionList.length})"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _brandList.isEmpty
                ? const Center(child: Text("즐겨찾기한 브랜드가 없습니다."))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    itemCount: _brandList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      return BrandItem(
                        brand: _brandList[index],
                        onRemove: () => _removeBrand(index),
                      );
                    },
                  ),
            _promotionList.isEmpty
                ? const Center(child: Text("저장한 프로모션이 없습니다."))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    itemCount: _promotionList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      return PromotionItem(
                        promotion: _promotionList[index],
                        onRemove: () => _removePromotion(index),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
