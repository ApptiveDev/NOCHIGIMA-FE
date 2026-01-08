import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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

class Promotion {
  final int productId;
  final String productName;
  final int brandId;
  final String brandName;
  final int price;
  final String imageUrl;
  final bool isDiscountedNow;
  final int discountValue;
  final String discountStartAt;
  final String discountEndAt;
  final int discountedPrice;

  Promotion({
    required this.productId,
    required this.productName,
    required this.brandId,
    required this.brandName,
    required this.price,
    required this.imageUrl,
    required this.isDiscountedNow,
    required this.discountValue,
    required this.discountStartAt,
    required this.discountEndAt,
    required this.discountedPrice,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      brandId: json['brandId'] ?? 0,
      brandName: json['brandName'] ?? '',
      price: json['price'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      isDiscountedNow: json['isDiscountedNow'] ?? true,
      discountValue: json['discountValue'] ?? 0,
      discountStartAt: json['discountStartAt'] ?? '',
      discountEndAt: json['discountEndAt'] ?? '',
      discountedPrice: json['discountedPrice'] ?? 0,
    );
  }
}

class MyBookmarksScreen extends StatefulWidget {
  const MyBookmarksScreen({super.key});

  @override
  State<MyBookmarksScreen> createState() => _MyBookmarksScreenState();
}

class _MyBookmarksScreenState extends State<MyBookmarksScreen> {
  final numberFormat = NumberFormat('###,###,###,###');
  final List<Brand> _brandList = [
    Brand(
      brandId: 1,
      brandName: "버거킹",
      imageUrl:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Burger_King_logo_%281999%29.svg/2024px-Burger_King_logo_%281999%29.svg.png",
      // 실제 테스트용 이미지 URL
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
              Tab(text: "저장한 프로모션 (65)"),
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
                    itemBuilder: (context, index) =>
                        _buildBrandItem(index, _brandList[index]),
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
                    itemBuilder: (context, index) =>
                        _buildPromotionItem(index, _promotionList[index]),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandItem(int index, Brand brand) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {}, // 브랜드 페이지로 넘어가기
      child: Row(
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
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      'assets/images/SearchOutline.svg',
                      width: 16,
                    ),
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
      ),
    );
  }

  Widget _buildPromotionItem(int index, Promotion promotion) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                promotion.imageUrl,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  promotion.brandName,
                  style: const TextStyle(
                    color: Color(0xFF323439),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        promotion.productName,
                        style: const TextStyle(
                          color: Color(0xFF323439),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${numberFormat.format(promotion.discountedPrice)}원",
                      style: const TextStyle(
                        color: Color(0xFF323439),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${promotion.discountStartAt} ~ ${promotion.discountEndAt}",
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      'assets/images/SearchOutline.svg',
                      width: 16,
                      colorFilter: ColorFilter.mode(
                        promotion.isDiscountedNow
                            ? Color(0xFF009345)
                            : Colors.grey[400]!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. 하트
          IconButton(
            onPressed: () {
              _removePromotion(index);
            },
            icon: const Icon(
              Icons.favorite,
              color: Color(0xFFFF3B30),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
