class PromotionData{
  final int productId;
  final int brandId;
  final String name;
  final int price;
  final String imageURL;
  final bool isDiscountedNow;
  final int discountValue;
  final String discountStartAt;
  final String discountEndAt;
  final int discountedPrice;

  bool isBookmarked;


  PromotionData({
    required this.productId,
    required this.brandId,
    required this.name,
    required this.price,
    required this.imageURL,
    required this.isDiscountedNow,
    required this.discountValue,
    required this.discountStartAt,
    required this.discountEndAt,
    required this.discountedPrice,
    this.isBookmarked = false,
  });

  factory PromotionData.fromJson(Map<String, dynamic> json){
    return PromotionData(
        productId: json['productId'] ?? 0,
        brandId: json['brandId'] ?? 0,
        name: json['name'] ?? " ",
        price: json['price'] ?? 0,
        imageURL: json['imageUrl'] as String? ?? "",
        isDiscountedNow: json['isDiscountedNow'] ?? false,
        discountValue: json['discountValue'] ?? 0,
        discountStartAt: json['discountStartAt'] ?? "",
        discountEndAt: json['discountEndAt'] ?? "",
        discountedPrice: json['discountedPrice'] ?? 0,
        isBookmarked: false,
    );
  }
}