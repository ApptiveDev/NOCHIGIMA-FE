import 'package:flutter/material.dart';
import 'package:frontend/models/category_brand_data.dart';
import 'package:frontend/models/promotion_data.dart';
import 'package:frontend/services/promotion_service.dart';
import 'package:frontend/widgets/brand-promotion/brand_detail_widgets/brand_header_image.dart';

class BrandDetail extends StatefulWidget {
  final CategoryBrandData brandData;
  const BrandDetail({super.key, required this.brandData});

  @override
  State<BrandDetail> createState() => _BrandDetailState();
}

class _BrandDetailState extends State<BrandDetail> {
  late Future<List<PromotionData>> _promotionsFuture;

  @override
  void initState() {
    super.initState();
    _promotionsFuture =
        PromotionService.fetchPromotionsByBrand(widget.brandData.brandId);
  }

  @override
  Widget build(BuildContext context) {
    final brand = widget.brandData;

    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BrandHeaderImage(
                        brand: brand, promotionsFuture: _promotionsFuture,),
                      _buildBrandDescription(brand),
                      _buildInfoCard(brand.discountedProductCount),
                      const SizedBox(height: 26),
                      const Divider(thickness: 8, color: Color(0xFFF3F4F8)),
                    ],
                  ),
                ),

                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    const TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Color(0xFF9AA0A6),
                      indicatorColor: Colors.black,
                      indicatorWeight: 2,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      unselectedLabelStyle: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                      tabs: [
                        Tab(text: "프로모션"),
                        Tab(text: "메뉴"),
                      ],
                    ),
                  ),
                ),
              ];
            }, body: TabBarView(
            children: [
              _buildPromotionTab(),
              const Center(child: Text("준비 중인 메뉴입니다.")),
            ],
          ),)
      ),
    );
  }

  String _translateBrandName(String name) {
    if (name.toLowerCase() == 'burgerking') return '버거킹';
    return name;
  }

  Widget _buildBrandDescription(CategoryBrandData brand) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('햄버거', style: TextStyle(color: Colors.grey, fontSize: 13)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_translateBrandName(brand.name),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.favorite_border)),
            ],
          ),
          Wrap(
            spacing: 8,
            children: [
              _buildTag(
                  '프로모션 ${brand.discountedProductCount}개', Colors.red[50]!,
                  Colors.red),
              _buildTag('최대 50%', Colors.grey[100]!, Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: TextStyle(color: textColor, fontSize: 12)),
    );
  }

  Widget _buildInfoCard(int count) {
    final String statusText = count >= 5 ? '활발' : '노력';
    final Color statusColor = count >= 5 ? Colors.red : Colors.orange;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA), // 연한 회색 배경
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 1. 프로모션 활동도 행
          Row(
            children: [
              const SizedBox(
                width: 100, // 왼쪽 레이블 너비를 고정해서 정렬을 맞춥니다.
                child: Text(
                  '프로모션 활동도',
                  style: TextStyle(color: Color(0xFF4B4E52), fontSize: 14),
                ),
              ),
              Text(
                statusText,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(width: 4),
              const Text(
                '(최근 3개월 기준)',
                style: TextStyle(color: Color(0xFF9AA0A6), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4), // 행 사이 간격

          // 2. 내 근처 매장 행
          Row(
            children: [
              const SizedBox(
                width: 100,
                child: Text(
                  '내 근처 매장',
                  style: TextStyle(color: Color(0xFF4B4E52), fontSize: 14),
                ),
              ),
              const Expanded(
                child: Text(
                  '6개',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              // 지도 보기 버튼
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9ECEF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '지도 보기',
                  style: TextStyle(color: Color(0xFF4B4E52),
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

Widget _buildPromotionTab() {
  return ListView.builder(
    // 탭 뷰 안에서 리스트뷰를 쓸 때 스크롤 겹침을 방지하기 위해 사용합니다.
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    itemCount: 5, // 예시로 5개 생성
    itemBuilder: (context, index) {
      if (index == 0) {
        // 첫 번째 아이템 위에 "진행 중 프로모션" 텍스트 추가
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text(
                  "진행 중 프로모션 ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "18",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPromotionCard(),
          ],
        );
      }
      return _buildPromotionCard();
    },
  );
}

Widget _buildPromotionCard() {
  return Container(
    margin: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 프로모션 이미지 영역 (하트 버튼 포함)
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  'https://your-image-url.com/whopper_promo.jpg', // 프로모션 이미지
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite, color: Colors.red, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 2. 텍스트 정보
        const Text(
          "버거킹 와퍼 52% 할인",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          "행사 기간 | 2025.08.01 ~ 2025.09.25",
          style: TextStyle(fontSize: 13, color: Color(0xFF9AA0A6)),
        ),
        const SizedBox(height: 10),

        // 3. 태그 그룹
        Wrap(
          spacing: 8,
          children: [
            _buildBadge("50% 이상 할인", const Color(0xFFFFEBF0), const Color(0xFFFF4D77)),
            _buildBadge("신제품 출시", const Color(0xFFF3F4F8), const Color(0xFF9AA0A6)),
            _buildBadge("이번달 마감", const Color(0xFFF3F4F8), const Color(0xFF9AA0A6)),
          ],
        ),
      ],
    ),
  );
}

// 공통 배지 위젯
Widget _buildBadge(String text, Color bgColor, Color textColor) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      text,
      style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600),
    ),
  );
}
