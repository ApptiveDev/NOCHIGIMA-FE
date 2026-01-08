import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/category_data.dart';

class CategoryService{
  static const String baseUrl = 'https://api.nochigima.shop';

  static Future<List<CategoryData>> fetchCategories() async{
    final response = await http.get(
      Uri.parse('$baseUrl/v1/categories'),
    );

    if(response == 200){
      final List decoded = json.decode(response.body);
      return decoded
          .map((e) => CategoryData.fromJson(e))
          .toList();
    }else{
      throw Exception('카테고리 조회 실패');
    }
  }
}