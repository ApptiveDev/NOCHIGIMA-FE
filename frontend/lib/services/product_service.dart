import 'package:frontend/models/product_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ProductService{
    static Future<List<ProductData>> fetchProductByBrand(
        int brandId,
        ) async {;
    final response = await http.get(
      Uri.parse('https://api.nochigima.shop/v1/brands/$brandId/products?onlyDiscounted=true')
    );

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return decoded.map((e) => ProductData.fromJson(e)).toList();
    } else {
      throw Exception('브랜드 상품 조회 실패');
    }
  }

  static Future<ProductData> fetchProductDetail(
        int productId,
        )async {
      final response = await http.get(
        Uri.parse('https://api.nochigima.shop/v1/products/$productId'),
      );

      if (response == 200){
        final decoded = json.decode(response.body);
        return ProductData.fromJson(decoded);
      }else{
        throw Exception('상품 상제 조회 실패');
      }
    }
}