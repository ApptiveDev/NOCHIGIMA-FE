class Brand {
  final int brandId;
  final String name;
  final String imageUrl;
  final int discountedProductCount;

  Brand({
    required this.brandId,
    required this.name,
    required this.imageUrl,
    required this.discountedProductCount,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      brandId: json['brandId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      discountedProductCount: json['discountedProductCount'],
    );
  }
}
