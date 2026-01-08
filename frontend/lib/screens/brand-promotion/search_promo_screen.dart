import 'package:flutter/material.dart';
import 'package:frontend/screens/brand-promotion/brand_detail_screen.dart';
import 'package:frontend/widgets/brand-promotion/popular_search_section.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/category_brand_data.dart';

class SearchPromotion extends StatefulWidget {
  const SearchPromotion({super.key});

  @override
  State<SearchPromotion> createState() => _SearchPromotionState();
}

class _SearchPromotionState extends State<SearchPromotion> {
  final TextEditingController _textController = TextEditingController();
  final storage = const FlutterSecureStorage();
  final String baseUrl = "api.nochigima.shop";

  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  bool _isSearchActive = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _searchBrands(String keyword) async {
    if (keyword.trim().isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _isLoading = true;
      _isSearchActive = true;
    });

    try {
      String? accessToken = await storage.read(key: 'accessToken');

      final uri = Uri.https(baseUrl, '/v1/brands/search', {'keyword': keyword});

      final response = await http.get(
        uri,
        headers: {
          'accept': '*/*',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
      );

      print("검색 요청 URL: $uri");
      print("응답 코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));

        setState(() {
          _searchResults = list;
          _isLoading = false;
        });
      } else {
        print("검색 실패: ${response.body}");
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print("에러 발생: $e");
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFAFB8C1)),
        title: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: SearchBar(
            controller: _textController,
            hintText: "브랜드명 검색",
            hintStyle: WidgetStateProperty.all(
              TextStyle(
                color: Colors.grey[400],
                fontFamily: "Pretendard",
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: WidgetStateProperty.all<Color>(Colors.grey[050]!),
            elevation: WidgetStateProperty.all<double>(0.0),
            onSubmitted: (value) {
              _searchBrands(value);
            },
            trailing: [
              IconButton(
                onPressed: () {
                  _textController.clear();
                  setState(() {
                    _isSearchActive = false;
                    _searchResults.clear();
                  });
                },
                icon: Icon(Icons.cancel),
              ),
              IconButton(
                onPressed: () {
                  _searchBrands(_textController.text);
                },
                icon: Icon(Icons.search),
              ),
            ],
            shape: WidgetStateProperty.all(
              ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            constraints: BoxConstraints(maxHeight: 60),
          ),
        ),
      ),
      // 인기 검색어
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_isSearchActive
          ? Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20.0, 20.0, 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PopularSearchSection(
                    onKeywordTap: (keyword) {
                      setState(() {
                        _textController.text = keyword;
                        _searchBrands(keyword);
                      });
                    },
                  ),
                ],
              ),
            )
          : _searchResults.isEmpty
          ? const Center(
              child: Text(
                "검색된 브랜드가 없습니다.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontFamily: "Pretendard",
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _searchResults.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final brand = _searchResults[index];
                final String name = brand['name'] ?? '이름 없음';
                final String imageUrl = brand['imageUrl'] ?? '';
                final int brandId = brand['brandId'] ?? 0;
                final int discountedProductCount = brand['discountedProductCount'] ?? 0;

                return InkWell(
                  onTap: () {
                    final brandObject = CategoryBrandData(brandId: brandId, name: name, imageUrl: imageUrl, discountedProductCount: discountedProductCount);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BrandDetail(brandData: brandObject),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                )
                              : const Icon(Icons.store, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 브랜드 이름
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF323439),
                          fontFamily: "Pretendard",
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
