import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/brand_data.dart';

class BrandService {
  static Future<List<Brand>> fetchBrandsByCategory(int categoryId) async {
    final uri = Uri.parse(
      'https://your-domain.com/v1/categories/$categoryId/brands',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List decoded = json.decode(utf8.decode(response.bodyBytes));
      return decoded.map((e) => Brand.fromJson(e)).toList();
    } else {
      throw Exception('브랜드 목록 조회 실패');
    }
  }
}
