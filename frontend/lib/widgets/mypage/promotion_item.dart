import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/my_bookmarks_promotion.dart';
import '../../models/my_bookmarks_promotion.dart';
import '../../models/promotion_data.dart';
import '../../screens/brand-promotion/detail_promo_screen.dart';

class PromotionItem extends StatelessWidget {
  final Promotion promotion;
  final VoidCallback onRemove;

  const PromotionItem({
    super.key,
    required this.promotion,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('###,###,###,###');
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        final promotionData = PromotionData(
            productId: promotion.productId,
            name: promotion.productName,
            price: promotion.price,
            imageURL: promotion.imageUrl,
            isDiscountedNow: promotion.isDiscountedNow,
            discountValue: 0,
            discountStartAt: promotion.discountStartAt,
            discountEndAt: promotion.discountEndAt,
            discountedPrice: promotion.discountedPrice);

        Navigator.push(
          context, MaterialPageRoute(builder: (context)=>DetailPromotion(promotionData: promotionData))
        );
      },
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  promotion.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // 2. 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  promotion.brandName,
                  style: const TextStyle(
                    color: Color(0xFF858C9A),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        promotion.productName,
                        style: const TextStyle(
                          color: Color(0xFF323439),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${numberFormat.format(promotion.discountedPrice)}원",
                      style: const TextStyle(
                        color: Color(0xFF323439),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${promotion.discountStartAt} ~ ${promotion.discountEndAt}",
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      'assets/images/SearchOutline.svg',
                      width: 16,
                      colorFilter: ColorFilter.mode(
                        promotion.isDiscountedNow
                            ? Color(0xFF009345)
                            : Colors.grey[400]!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. 하트
          IconButton(
            onPressed: onRemove,
            icon: const Icon(
              Icons.favorite,
              color: Color(0xFFFF3B30),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
