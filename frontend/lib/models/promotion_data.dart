class PromotionData{
  final int id;
  final String name;
  final int price;
  final String imageURL;
  final bool isDiscountedNow;
  final int discountValue;
  final String discountStartAt;
  final String discountEndAt;
  final int discountedPrice;

  PromotionData({
    required this.id,
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
        id: json['id'],
        name: json['name'],
        price: json['price'],
        imageURL: json['imageUrl'],
        isDiscountedNow: json['isDiscountedNow'],
        discountValue: json['discountValue'],
        discountStartAt: json['discountStartAt'],
        discountEndAt: json['discountEndAt'],
        discountedPrice: json['discountedPrice']
    );
  }
}