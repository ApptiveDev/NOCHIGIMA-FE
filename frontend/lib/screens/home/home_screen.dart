import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/models/menu_category.dart';
import 'package:frontend/screens/search/search_screen.dart';
import 'package:frontend/widgets/home/home_widgets.dart';

class HomeScreen extends StatefulWidget{
  final Function(MenuCategory) onCategoryTap;
  const HomeScreen({
    super.key,
    required this.onCategoryTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{

  final int _currentBannerPage = 0;
  final List<Map<String, String>> bannerItems = [
    {
      "image": "assets/images/slider_burger.png",
      "title": "골든 에그\n트러플 머쉬룸 출시",
      "subtitle": "가을에 푹-빠질 골든 타임, 신제품 출시",
      "date": "2025.10.06(목) ~ 2026.01.07(수)"
    },
    {
      "image": "assets/images/slider_burger.png",
      "title": "골든 에그\n트러플 머쉬룸 출시",
      "subtitle": "가을에 푹-빠질 골든 타임, 신제품 출시",
      "date": "2025.10.06(목) ~ 2026.01.07(수)"
    },
  ];

  @override
  Widget build(BuildContext context){
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                  },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/appbar_location.svg',
                          width: 15,
                          height: 18,
                          colorFilter: ColorFilter.mode(AppColors.nochigimaColor, BlendMode.srcIn),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '부산대학로 63번길 2',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, color: Colors.black),
                      ],
                    )
                ),
                IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/images/notification.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    )
                ),
              ],
            ),
          ),
          actions:[]
      ), // 상단

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 5, color: Colors.white),
            BannerSlider(items: bannerItems),
            CategoryGrid(onCategoryTap: widget.onCategoryTap,),
            MyBookmarks(),
          ],
        ),
      ), // 중단

      bottomNavigationBar: Row(), // 하단

    );

  }
}