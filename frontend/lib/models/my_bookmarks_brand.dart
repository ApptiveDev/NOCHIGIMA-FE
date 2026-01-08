class Brand {
  final int brandId;
  final String brandName;
  final String imageUrl;
  final int discountedProductCount;
  final int category;

  Brand({
    required this.brandId,
    required this.brandName,
    required this.imageUrl,
    required this.discountedProductCount,
    required this.category,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      brandId: json['brandId'] ?? 0,
      brandName: json['brandName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      discountedProductCount: json['discountedProductCount'] ?? 0,
      category: json['category'] ?? 0,
    );
  }
}