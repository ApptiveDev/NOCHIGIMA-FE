class BrandProduct {
  final int productId;
  final String name;
  final int price;
  final String imageUrl;
  final bool isDiscountedNow;
  final int? discountValue; // null 가능
  final String discountStartAt;
  final String discountEndAt;
  final int discountedPrice;

  BrandProduct({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.isDiscountedNow,
    required this.discountValue,
    required this.discountStartAt,
    required this.discountEndAt,
    required this.discountedPrice,
  });

  factory BrandProduct.fromJson(Map<String, dynamic> json) {
    return BrandProduct(
      productId: json['productId'],
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      isDiscountedNow: json['isDiscountedNow'],
      discountValue: json['discountValue'],
      discountStartAt: json['discountStartAt'],
      discountEndAt: json['discountEndAt'],
      discountedPrice: json['discountedPrice'],
    );
  }
}
