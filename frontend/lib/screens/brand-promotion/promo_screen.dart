import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/screens/brand-promotion/detail_promo_screen.dart';
import 'package:frontend/widgets/brand-promotion/brand_promotion_widgets.dart';
import 'package:frontend/models/menu_category.dart';
import 'package:frontend/models/promotion_data.dart';
import 'package:frontend/widgets/brand-promotion/filter_modal.dart';

class PromoScreen extends StatefulWidget {
  final MenuCategory initialCategory;

  const PromoScreen({super.key, this.initialCategory = MenuCategory.pizza});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

//promo-screen build
class _PromoScreenState extends State<PromoScreen> {
  late MenuCategory _selectedCategory;

  // 임시데이터
  final Map<MenuCategory, List<PromotionData>> _dummyData = {
    MenuCategory.pizza: [
      PromotionData(
        imageURL: "assets/images/test_Mask group.jpg",
        title: "피자헛 10% 할인",
        deadline: "2025.09.12 ~",
      ),
      PromotionData(
        imageURL: "assets/images/test_Mask group.jpg",
        title: "도미노 1+1",
        deadline: "2025.10.11 ~ 2025.10.18",
      ),
    ],
    MenuCategory.burger: [
      PromotionData(
        imageURL: "assets/images/logo_burgerking.png",
        title: "버거킹 와퍼 행사",
        deadline: "2025.08.01 ~ 2025.09.01",
      ),
      PromotionData(
        imageURL: "assets/images/test_Mask group.jpg",
        title: "맥도날드 맥런치",
        deadline: "상시",
      ),
      PromotionData(
        imageURL: "assets/images/test_Mask group.jpg",
        title: "맘스터치 신메뉴",
        deadline: "2025.11.31 ~ 2025.12.31",
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  Widget _buildMenuItem(MenuCategory category) {
    bool isSelected = (_selectedCategory == category);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        constraints: BoxConstraints(minWidth: 70),
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(12, 0, 12, isSelected ? 12 : 13),
        decoration: BoxDecoration(
          border: Border(
            bottom: isSelected
                ? BorderSide(color: Colors.grey[800]!, width: 2)
                : BorderSide(color: Color(0xFFF3F4F8), width: 1),
          ),
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: SvgPicture.asset(category.imagePath, height: 35)),
            Text(
              category.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.black : Colors.grey[600],
                fontFamily: "Prentendard",
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPromotions = _dummyData[_selectedCategory] ?? [];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: MenuCategory.values.map((category) {
                    return _buildMenuItem(category);
                  }).toList(),
                ),
              ),
              SizedBox(height: 25),
              SizedBox(
                //filter
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    //FILTER
                    FilterButton(
                      // 추천순 button
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "추천순",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF323439),
                              fontFamily: "Pretendard",
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.expand_more_rounded,
                            color: Color(0xFF323439),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    FilterButton(
                      // 필터 button
                      onPressed: () {
                        showModalBottomSheet(context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return FilterBottomSheet();
                          },
                        );
                      },
                      padding: EdgeInsets.all(8.0),
                      borderColor: Color(0xFFE2E4EC),
                      child: Icon(Icons.tune_rounded, color: Color(0xFF323439)),
                    ),
                    SizedBox(width: 8),
                    VerticalDivider(
                      thickness: 1,
                      width: 1,
                      color: Color(0xFFF3F4F8),
                      indent: 4,
                      endIndent: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              //promo view
              Expanded(
                child: currentPromotions.isEmpty
                    ? Center(child: Text("등록된 프로모션이 없습니다."))
                    : ListView.builder(
                        itemCount: currentPromotions.length,
                        itemBuilder: (context, index) {
                          final data = currentPromotions[index];
                          return PromotionBlock(
                            imageURL: data.imageURL,
                            title: data.title,
                            deadline: data.deadline,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPromotion(),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(),
    );
  }
}
