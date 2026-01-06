import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/screens/brand-promotion/detail_promo_screen.dart';
import 'package:frontend/widgets/brand-promotion/brand_promotion_widgets.dart';
import 'package:frontend/models/menu_category.dart';
import 'package:frontend/models/promotion_data.dart';
import 'package:frontend/widgets/brand-promotion/filter_modal.dart';
import 'package:frontend/widgets/brand-promotion/sort_bottom_modal.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PromoScreen extends StatefulWidget {
  final MenuCategory initialCategory;

  const PromoScreen({super.key, this.initialCategory = MenuCategory.pizza});
  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

//promo-screen build
class _PromoScreenState extends State<PromoScreen> {
  late MenuCategory _selectedCategory;
  PromotionFilter? _currentFilter;
  String _currentSort = "추천순";

  List<PromotionData> _currentPromotions = [];
  bool _isLoading = false;

  Future<void> _fetchCategoryPromotions(int categoryId) async{
    setState(() {
      _isLoading = true;
    });
    List<PromotionData> allProducts = [];

    try{
      final brandRes = await http.get(
        Uri.parse('http://api.nochigima.shop/v1/categories/$categoryId/brands'),
        headers: {'accept': '*/*'},
      );
      print("브랜드 응답 코드: ${brandRes.statusCode}");

      if(brandRes.statusCode == 200){
        print("브랜드 데이터: ${brandRes.body}");
        List<dynamic> brands = json.decode(brandRes.body);
        for(var brand in brands){
          if((brand['discountedProductCount'] ?? 0) > 0){
            final int? brandId = brand['brandId'];
            final int count = brand['discountedProductCount'] ?? 0;

            if (brandId != null && count > 0) {
              print("${brand['name']} 브랜드의 할인 상품 $count개를 가져옵니다...");

              final productRes = await http.get(
                Uri.parse(
                    'https://api.nochigima.shop/v1/brands/$brandId/products?onlyDiscounted=true'),
                headers: {'accept': '*/*'},
              );

              if (productRes.statusCode == 200) {
                List<dynamic> products = json.decode(productRes.body);
                print("${brand['name']}의 상품 개수: ${products.length}");
                allProducts.addAll(
                    products.map((p) => PromotionData.fromJson(p)).toList());
              }
            }
          }
        }

        setState(() {
          _currentPromotions = allProducts;
          _isLoading = false;
        });
      }
    }catch(e){
      print("데이터 연동 오류: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSelectedFiltering(Map<String, String> filter) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF25454)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              filter['label'] ?? "",
              style: const TextStyle(color: Color(0xFFF25454), fontWeight: FontWeight.w500)
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                if(_currentFilter != null) {
                  if (filter['type'] == 'discount') {
                    _currentFilter!.discountRange = null;
                  } else {
                    _currentFilter!.period = null;
                  }
                  if (_currentFilter!.discountRange == null && _currentFilter!.period == null) {
                    _currentFilter = null;
                  }
                }
              });
            },
            child: const Icon(Icons.close, size: 16, color: Color(0xFFF25454)),
          ),
        ],
      ),
    );
  }

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

        if(category.serverId != null){
          _fetchCategoryPromotions(category.serverId!);
        }else{
          setState(() {
            _currentPromotions = [];
          });
        }

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
    final displayPromotions = _currentPromotions;

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
                      onPressed: () async {
                        final String? result = await showModalBottomSheet<String>(
                          context: context,
                          backgroundColor: Colors.transparent, // 모달의 둥근 모서리를 살리기 위해 투명 설정
                          isScrollControlled: true,
                          builder: (context) => SortBottomModal(selectedSort: _currentSort),
                        );

                        if (result != null && mounted) {
                          setState(() {
                            _currentSort = result;
                          });
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentSort,
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
                      onPressed: () async {
                        final PromotionFilter? result = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return FilterBottomSheet();
                          },
                        );

                        if(!mounted) return;

                        if (result != null){
                          setState(() {
                            _currentFilter = result;
                          });
                        }
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
                    const SizedBox(width: 8,),
                    if(_currentFilter != null)
                      if(_currentFilter?.discountRange != null)
                        Padding(
                          padding: const EdgeInsets.only(right:8),
                          child: _buildSelectedFiltering({
                            'label': "${_currentFilter!.discountRange!.start.round()}~${_currentFilter!.discountRange!.end.round()}% 할인",
                            'type': 'discount'
                          }),
                        ),
                    if (_currentFilter?.period != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildSelectedFiltering({
                          'label': _currentFilter!.period!,
                          'type': 'period'
                        }),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              //promo view
              Expanded(
                child: _isLoading
                    ? const Center(child: Text("등록된 프로모션이 없습니다."))
                    : ListView.builder(
                  itemCount: displayPromotions.length,
                  itemBuilder: (context, index) {
                    final data = displayPromotions[index];
                    return PromotionBlock(
                      imageURL: data.imageURL,
                      title: "${data.name} ${data.discountValue}% 할인",
                      deadline: "${data.discountStartAt} ~ ${data.discountEndAt}",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPromotion(promotionData: data,),
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