import 'package:flutter/material.dart';
import '../../models/my_bookmarks_brand.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/category_brand_data.dart';
import '../../screens/brand-promotion/brand_detail_screen.dart';

class BookmarksCard extends StatelessWidget {
  final Brand brand;
  final VoidCallback? onReturn;

  const BookmarksCard({super.key, required this.brand, this.onReturn});

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 120;
    const double logoAreaHeight = 120;
    bool isDiscounting = brand.discountedProductCount > 0;
    return InkWell(
      onTap: () {
        final categoryBrandData = CategoryBrandData(
          brandId: brand.brandId,
          name: brand.brandName ?? "이름 없음",
          imageUrl: brand.imageUrl ?? "",
          discountedProductCount: brand.discountedProductCount,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrandDetail(brandData: categoryBrandData),
          ),
        ).then((_) {
          if (onReturn != null) {
            onReturn!();
          }
        });
      },
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: logoAreaHeight,
              width: cardWidth,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Color(0xFFFF333F),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  brand.imageUrl.toLowerCase().endsWith('.svg')
                      ? SvgPicture.network(
                          brand.imageUrl,
                          fit: BoxFit.cover,
                          placeholderBuilder: (context) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : Image.network(
                          brand.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Color(0xFFFF333F),
                              ),
                            );
                          },
                        ),
                  if (isDiscounting)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        color: const Color(0xFF323439).withOpacity(0.6),
                        // 반투명 검정 배경
                        alignment: Alignment.center,
                        child: const Text(
                          "할인 프로모션 진행중",
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 10.0, // 박스 크기에 맞춰 폰트 사이즈 조정
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 8.0),

            Text(
              brand.brandName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2.0),
            Text(
              '할인 중인 상품 ${brand.discountedProductCount}개',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
