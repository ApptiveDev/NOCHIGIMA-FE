import 'package:flutter/material.dart';
import '../../models/my_bookmarks_brand.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookmarksCard extends StatelessWidget{
  final Brand brand;
  const BookmarksCard({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 120;
    const double logoAreaHeight = 120;
    const double logoBoxSize = 72;
    return InkWell(
      onTap: (){

      },
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: logoAreaHeight,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: brand.promotionColor,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: SizedBox(
                      width: logoBoxSize,
                      height: logoBoxSize,

                      child: SvgPicture.asset(
                        brand.logoImagePath,
                        fit: BoxFit.contain,
                      ),

                    ),
                  ),


                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      color: Color(0xFF323439).withOpacity(0.4),
                      alignment: Alignment.center,
                      child: Text(
                        brand.promotionText,
                        style: TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 12.0,
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2.0),
            Text(
              '${brand.category} · ${brand.promotionCount}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
            ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}