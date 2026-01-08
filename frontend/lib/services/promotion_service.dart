import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/promotion_data.dart';

class PromotionService {
  static const String baseUrl = 'https://api.nochigima.shop/v1';

  // 특정 브랜드의 프로모션 목록을 가져오는 함수
  static Future<List<PromotionData>> fetchPromotionsByBrand(int brandId) async {
    print("요청하는 브랜드 ID: $brandId");
    final url = Uri.parse('$baseUrl/brands/$brandId/products?onlyDiscounted=true');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));

        return body.map((item) => PromotionData.fromJson(item)).toList();
      } else {
        throw Exception('서버 응답 에러: ${response.statusCode}');
      }
    } catch (e) {
      print('프로모션 로딩 실패: $e');
      return [];
    }
  }

  // 전체 프로모션 목록 가져오기
  static Future<List<PromotionData>> fetchAllPromotions() async {
    final url = Uri.parse('$baseUrl/promotions');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        return body.map((item) => PromotionData.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}