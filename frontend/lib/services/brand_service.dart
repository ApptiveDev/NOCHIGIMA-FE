import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_brand_data.dart';

class BrandService {
  static Future<List<CategoryBrandData>> fetchBrandsByCategory(int categoryId) async {
    final uri = Uri.parse(
      'https://api.nochigima.shop/v1/categories/$categoryId/brands',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List decoded = json.decode(utf8.decode(response.bodyBytes));
      return decoded.map((e) => CategoryBrandData.fromJson(e)).toList();
    } else {
      print("API Error Code: ${response.statusCode}");
      throw Exception('브랜드 목록 조회 실패');
    }
  }

  static Future<CategoryBrandData> fetchBrand(
      int brandId,
      ) async {
    final uri = Uri.parse(
      'https://api.nochigima.shop/v1/brands/$brandId',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decoded = json.decode(utf8.decode(response.bodyBytes));
      return CategoryBrandData.fromJson(decoded);
    } else {
      throw Exception('브랜드 조회 실패');
    }
  }

  static Future<CategoryBrandData> findBrandInAllCategories(int targetBrandId) async {
    final categoryIds = [1, 2, 3, 4, 5, 6];

    final results = await Future.wait(
        categoryIds.map((id) => fetchBrandsByCategory(id).catchError((_) => <CategoryBrandData>[]))
    );

    for (var brandList in results) {
      final found = brandList.where((b) => b.brandId == targetBrandId);
      if (found.isNotEmpty) {
        return found.first;
      }
    }

    throw Exception('어떤 카테고리에서도 해당 브랜드를 찾을 수 없습니다.');
  }
}
