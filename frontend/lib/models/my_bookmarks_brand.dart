class Brand {
  final int brandId;
  final String brandName;
  final String imageUrl;
  final int discountedProductCount;
  final int categoryId;

  Brand({
    required this.brandId,
    required this.brandName,
    required this.imageUrl,
    required this.discountedProductCount,
    required this.categoryId,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      brandId: json['brandId'] ?? 0,
      brandName: json['brandName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      discountedProductCount: json['discountedProductCount'] ?? 0,
      categoryId: json['category'] ?? 0,
    );
  }
}