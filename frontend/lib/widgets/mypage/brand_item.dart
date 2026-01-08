import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/my_bookmarks_brand.dart';

class BrandItem extends StatelessWidget {
  final Brand brand;
  final VoidCallback onRemove;
  final VoidCallback? onTap;

  const BrandItem({super.key, required this.brand, required this.onRemove, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap, // 브랜드 페이지로 넘어가기
      child: Row(
        children: [
          // 1. 로고 이미지
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
                  brand.imageUrl,
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
              children: [
                Text(
                  brand.brandName,
                  style: const TextStyle(
                    color: Color(0xFF323439),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "할인 중인 ${brand.discountedProductCount}개의 상품",
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      'assets/images/SearchOutline.svg',
                      width: 16,
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
