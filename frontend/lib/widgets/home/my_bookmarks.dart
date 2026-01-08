import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/models/my_bookmarks_brand.dart';
import 'package:frontend/widgets/home/bookmarks_card.dart';
import 'package:frontend/screens/mypage/my_bookmarks_screen.dart';

final List<Brand> bookmarkBrands = [
  Brand(
    brandId: 0,
    imageUrl: 'assets/images/logo_burgerking.svg',
    brandName: '버거킹',
    categoryId:0,
    discountedProductCount: 15,
  ),
  Brand(
    brandId: 1,
    imageUrl: 'assets/images/logo_burgerking.svg',
    brandName: '맥도날드',
    categoryId: 0,
    discountedProductCount: 0,
  ),
  Brand(
    brandId: 3,
    imageUrl: 'assets/images/logo_burgerking.svg',
    brandName: '신전떡볶이',
    categoryId: 1,
    discountedProductCount: 7,
  ),

  // ... 추가 브랜드
];

class MyBookmarks extends StatelessWidget {
  const MyBookmarks({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '나의 즐겨찾기',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w700,
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyBookmarksScreen(),
                  ),
                  );
                },
                child: Row(
                  children: [
                    const Text(
                      '전체보기 >',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Pretendard",
                        fontWeight: FontWeight.w400,
                        color: AppColors.nochigimaColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemBuilder: (context, index){
                return BookmarksCard(brand: bookmarkBrands[index]);
              },
              separatorBuilder: (_,_) => const SizedBox(width: 18.0),
              itemCount: bookmarkBrands.length,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}