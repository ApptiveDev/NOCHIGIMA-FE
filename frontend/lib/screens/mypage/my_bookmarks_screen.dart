import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/screens/brand-promotion/brand_detail_screen.dart';
import 'package:frontend/screens/brand-promotion/detail_promo_screen.dart';
import 'package:frontend/widgets/mypage/brand_item.dart';
import '../../widgets/mypage/mypage_widgets.dart';
import '../../models/my_bookmarks_promotion.dart';
import '../../models/my_bookmarks_brand.dart';
import '../../models/category_brand_data.dart';
import '../../models/promotion_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyBookmarksScreen extends StatefulWidget {
  final int initialIndex;

  const MyBookmarksScreen({super.key, this.initialIndex = 0});

  @override
  State<MyBookmarksScreen> createState() => _MyBookmarksScreenState();
}

class _MyBookmarksScreenState extends State<MyBookmarksScreen> {
  List<Brand> _brandList = [];
  List<Promotion> _promotionList = [];

  bool _isLoading = true;
  final storage = const FlutterSecureStorage();
  final String baseUrl = "api.nochigima.shop";

  @override
  void initState() {
    super.initState();
    _fetchAllBookmarks();
  }

  Future<void> _fetchAllBookmarks() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        return;
      }
      final brandUri = Uri.https(baseUrl, '/v1/favorites/brands');
      final promotionUri = Uri.https(baseUrl, '/v1/favorites/discounts');

      final results = await Future.wait([
        http.get(brandUri, headers: {'Authorization': 'Bearer $accessToken'}),
        http.get(
          promotionUri,
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      ]);

      final brandResponse = results[0];
      final promotionResponse = results[1];

      if (brandResponse.statusCode == 200 &&
          promotionResponse.statusCode == 200) {
        final List<dynamic> brandJson = jsonDecode(
          utf8.decode(brandResponse.bodyBytes),
        );
        final List<dynamic> promotionJson = jsonDecode(
          utf8.decode(promotionResponse.bodyBytes),
        );
        setState(() {
          _brandList = brandJson.map((json) => Brand.fromJson(json)).toList();
          _promotionList = promotionJson
              .map((json) => Promotion.fromJson(json))
              .toList();
          _isLoading = false;
        });
      } else {
        print(
          "데이터 로드 실패 : ${brandResponse.statusCode} / ${promotionResponse.statusCode}",
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("네트워크 에러: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeBrand(int index) async {
    final brandToRemove = _brandList[index];
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      final uri = Uri.https(
        baseUrl,
        '/v1/favorites/brands/${brandToRemove.brandId}',
      );
      final response = await http.delete(
        uri,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          _brandList.removeAt(index);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("즐겨찾기가 해제되었습니다. ")));
      } else {
        print("삭제 실패: ${response.statusCode}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("삭제에 실패했습니다. ")));
      }
    } catch (e) {
      print("삭제 에러 : $e");
    }
  }

  Future<void> _removePromotion(int index) async {
    final promotionToRemove = _promotionList[index];
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      final uri = Uri.https(
        baseUrl,
        '/v1/favorites/discounts/${promotionToRemove.productId}',
      );
      final response = await http.delete(
        uri,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          _promotionList.removeAt(index);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('즐겨찾기가 해제되었습니다. ')));
      } else {
        print("삭제 실패 : ${response.statusCode}");
      }
    } catch (e) {
      print("삭제 에러 : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.grey))
            : TabBarView(
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
                            final brand = _brandList[index];
                            return BrandItem(brand: brand, onRemove: () => _removeBrand(index),
                            onTap: (){
                              try{
                                final categoryBrandData = CategoryBrandData(
                                  brandId: brand.brandId,
                                  name: brand.brandName ?? "이름 없음",
                                  imageUrl: brand.imageUrl ?? "",
                                  discountedProductCount: brand.discountedProductCount ?? 0,
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BrandDetail(
                                      brandData: categoryBrandData,
                                    ),
                                  ),
                                ).then((_) {
                                  _fetchAllBookmarks();
                                });
                              }catch (e) {
                                print("페이지 이동 중 에러 발생: $e"); // 에러가 나면 콘솔에 출력
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("페이지 이동 오류: $e")),
                                );
                              }
                            },);
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
                            final promotion = _promotionList[index]; // Promotion 모델

                            return GestureDetector(
                              onTap: () {
                                final promotionData = PromotionData(
                                  productId: promotion.productId,
                                  brandId: promotion.brandId,
                                  name: promotion.productName ?? "",
                                  discountValue: promotion.discountValue ?? 0,
                                  price: promotion.price,
                                  discountedPrice: 0,
                                  discountStartAt: promotion.discountStartAt ?? "",
                                  discountEndAt: promotion.discountEndAt ?? "",
                                  imageURL: promotion.imageUrl ?? "",
                                  isBookmarked: true,
                                  isDiscountedNow: promotion.isDiscountedNow,
                                );

                                // 2. 상세 페이지 이동
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPromotion(promotionData: promotionData),
                                  ),
                                ).then((_) {
                                  _fetchAllBookmarks();
                                });
                              },
                              child: PromotionItem(
                                promotion: _promotionList[index],
                                onRemove: () => _removePromotion(index),
                              ),
                            );
                          },
                        ),
                ],
              ),
      ),
    );
  }
}
