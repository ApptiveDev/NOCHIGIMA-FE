import 'package:frontend/models/brand_product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class BrandProductService{
  static Future<List<BrandProduct>> fetchProductsByBrand(int brandId) async{
    final response = await http.get(
      Uri.parse('https://api.nochigima.shop/v1/brands/$brandId/products?onlyDiscounted=true')
    );

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return decoded.map((e) => BrandProduct.fromJson(e)).toList();
    } else {
      throw Exception('브랜드 상품 조회 실패');
    }
  }
}