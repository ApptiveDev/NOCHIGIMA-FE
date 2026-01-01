import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/models/menu_category.dart';
import 'package:frontend/screens/brand-promotion/search_promo_screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/screens/mypage/mypage_screen.dart';
import 'package:frontend/screens/brand-promotion/promo_screen.dart';
import 'package:frontend/screens/social/social_screen.dart';
import 'package:frontend/widgets/nav_widget.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  int _selectedIndex = 0;
  MenuCategory _targetCatetory = MenuCategory.pizza;


  void _onTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCategorySelected(MenuCategory category){
    setState(() {
      _targetCatetory = category;
      _selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context){

    final List<Widget> pages = <Widget>[
      HomeScreen(onCategoryTap: _onCategorySelected,),
      const SearchPromotion(),
      PromoScreen(
        key: ValueKey(_targetCatetory),
        initialCategory: _targetCatetory,
      ),
      const SocialScreen(),
      const MypageScreen(),
    ];

    BottomNavigationBarItem svgItem(String asset, String label, int idx){
      final bool active = _selectedIndex == idx;
      final Color color = active? AppColors.nochigimaColor : Colors.grey[300]!;

      return BottomNavigationBarItem(icon: SvgPicture.asset(
        asset,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
      label: label,
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 89,

        color: Colors.white,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            NavItemWidget(
              assetName: 'assets/images/nav/nav_home.svg',
              label:'홈',
              isSelected: (_selectedIndex == 0),
              onTap: () => _onTapped(0),
            ),
            NavItemWidget(
              assetName: 'assets/images/nav/nav_search.svg',
              label:'검색',
              isSelected: (_selectedIndex == 1),
              onTap: () => _onTapped(1),
            ),
            NavItemWidget(
              assetName: 'assets/images/nav/nav_ourtown.svg',
              label:'우리동네',
              isSelected: (_selectedIndex == 2),
              onTap: () => _onTapped(2),
            ),
            NavItemWidget(
              assetName: 'assets/images/nav/nav_social.svg',
              label:'소셜',
              isSelected: (_selectedIndex == 3),
              onTap: () => _onTapped(3),
            ),
            NavItemWidget(
              assetName: 'assets/images/nav/nav_mypage.svg',
              label:'마이',
              isSelected: (_selectedIndex == 4),
              onTap: () => _onTapped(4),
            ),
          ],
        ),
      ),
    );
  }
}