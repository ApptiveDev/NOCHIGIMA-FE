class PromotionData{
  final int productId;
  final String name;
  final int price;
  final String imageURL;
  final bool isDiscountedNow;
  final int discountValue;
  final String discountStartAt;
  final String discountEndAt;
  final int discountedPrice;

  PromotionData({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageURL,
    required this.isDiscountedNow,
    required this.discountValue,
    required this.discountStartAt,
    required this.discountEndAt,
    required this.discountedPrice,
  });

  factory PromotionData.fromJson(Map<String, dynamic> json){
    return PromotionData(
        productId: json['productId'] ?? 0,
        name: json['name'] ?? " ",
        price: json['price'] ?? 0,
        imageURL: json['imageUrl'] ?? "",
        isDiscountedNow: json['isDiscountedNow'],
        discountValue: json['discountValue'] ?? 0,
        discountStartAt: json['discountStartAt'],
        discountEndAt: json['discountEndAt'],
        discountedPrice: json['discountedPrice']
    );
  }
}