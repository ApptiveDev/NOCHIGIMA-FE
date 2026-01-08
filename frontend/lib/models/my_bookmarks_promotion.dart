class Promotion {
  final int productId;
  final String productName;
  final int brandId;
  final String brandName;
  final int price;
  final String imageUrl;
  final bool isDiscountedNow;
  final int discountValue;
  final String discountStartAt;
  final String discountEndAt;
  final int discountedPrice;

  Promotion({
    required this.productId,
    required this.productName,
    required this.brandId,
    required this.brandName,
    required this.price,
    required this.imageUrl,
    required this.isDiscountedNow,
    required this.discountValue,
    required this.discountStartAt,
    required this.discountEndAt,
    required this.discountedPrice,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      brandId: json['brandId'] ?? 0,
      brandName: json['brandName'] ?? '',
      price: json['price'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      isDiscountedNow: json['isDiscountedNow'] ?? true,
      discountValue: json['discountValue'] ?? 0,
      discountStartAt: json['discountStartAt'] ?? '',
      discountEndAt: json['discountEndAt'] ?? '',
      discountedPrice: json['discountedPrice'] ?? 0,
    );
  }
}