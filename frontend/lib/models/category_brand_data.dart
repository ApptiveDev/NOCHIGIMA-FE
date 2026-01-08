class CategoryBrandData {
  final int brandId;
  final String name;
  final String imageUrl;
  final int discountedProductCount;

  CategoryBrandData({
    required this.brandId,
    required this.name,
    required this.imageUrl,
    required this.discountedProductCount,
  });

  factory CategoryBrandData.fromJson(Map<String, dynamic> json) {
    return CategoryBrandData(
      brandId: json['brandId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      discountedProductCount: json['discountedProductCount'],
    );
  }

  String get koreanName {
    switch (name.toLowerCase().replaceAll(' ', '')) {
      case 'burgerking': return '버거킹';
      case 'mcdonalds': return '맥도날드';
      default: return name;
    }
  }

}
