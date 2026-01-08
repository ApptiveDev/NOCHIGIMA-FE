import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/models/promotion_data.dart';
import 'package:frontend/models/category_brand_data.dart';
import 'package:frontend/screens/brand-promotion/brand_detail_screen.dart';
import 'package:frontend/models/category_brand_data.dart';
import 'package:frontend/services/brand_service.dart';
import 'package:http/http.dart' as http;

class DetailPromotion extends StatefulWidget {
  final PromotionData promotionData;
  const DetailPromotion({super.key, required this.promotionData});

  @override
  State<DetailPromotion> createState() => _DetailPromotionState();
}

class _DetailPromotionState extends State<DetailPromotion> {
  late Future<CategoryBrandData>_brandsFuture;

  @override
  void initState() {
    super.initState();
    _brandsFuture =
        BrandService.findBrandInAllCategories(widget.promotionData.brandId);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.promotionData;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildUpperImage(data),
              _buildProductInfo(data),
              Divider(thickness: 1, color: Colors.grey[100]),
              _buildBrandInfo(data),
              Divider(thickness: 10, color: Colors.grey[050]),
              _buildPriceGraph(data),
              _buildNoticeSection(),
            ],
          ),
        )

    );
  }

  Widget _buildUpperImage(PromotionData data) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1 / 0.7,
          child: Image.network(
            data.imageURL,
            fit: BoxFit.cover,
          ),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bookmark_border,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 16,
          right: 16,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(width: 4),
              // 📌 책갈피 알림 내용 추가할 공간
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildPriceGraph(PromotionData data) {
    const double maxBarHeight = 140.0;
    final double regularPrice = data.price.toDouble();
    final double currentPrice = data.discountedPrice.toDouble();

    double currentBarHeight = (currentPrice / regularPrice) * maxBarHeight;
    currentBarHeight = currentBarHeight.clamp(40.0, maxBarHeight);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("할인율 추이",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar("현재", "${data.discountedPrice}원", 100,
                  AppColors.nochigimaColor, true),
              _buildBar("정가", "${data.price}원",
                  maxBarHeight,
                  const Color(0xFFF3F4F8), false),
            ],
          ),
          const SizedBox(height: 20),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3F4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "정가보다 "),
                    TextSpan(
                      text: "${data.price - data.discountedPrice}원",
                      style: TextStyle(
                        color: AppColors.nochigimaColor,
                      ),
                    ),
                    const TextSpan(text: " 더 저렴해요!"),
                  ],
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFF8B92),
                  fontWeight: FontWeight.bold,
                ),
              )
          )
        ],
      ),
    );
  }

  Widget _buildBrandInfo(PromotionData data) {
    return FutureBuilder<CategoryBrandData>(
        future: _brandsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2,),
              ),
            );
          }

          if (snapshot.hasError) {
            debugPrint("API Error: ${snapshot.error}");
            return Container(
              height: 80,
              alignment: Alignment.center,
              child: const Text("브랜드 정보를 불러오지 못했습니다."),
            );
          }

          if (!snapshot.hasData) {
            return const SizedBox(
                height: 80, child: Center(child: Text("데이터가 없습니다.")));
          }

          final brand = snapshot.data!;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BrandDetail(brandData: brand,),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFF5EBDC),
                    child: FutureBuilder<String>(
                      future: http.read(Uri.parse(brand.imageUrl)).then((
                          value) =>
                          value.replaceAll('100%', '24')
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SvgPicture.string(
                            snapshot.data!,
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          );
                        }
                        return const Icon(
                            Icons.business, color: Colors.grey, size: 20);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          brand.koreanName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "프로모션 ${brand.discountedProductCount}개 진행중",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9AA0A6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF9AA0A6),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  Widget _buildProductInfo(PromotionData data) {
    final String dDayText = _calculateDDay(data.discountEndAt);
    final String formattedStart = _formatDate(data.discountStartAt);
    final String formattedEnd = _formatDate(data.discountEndAt);

    String formattedDate = data.discountEndAt.replaceAll('.', '-');
    DateTime endDate = DateTime.parse(formattedDate);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime targetDay = DateTime(endDate.year, endDate.month, endDate.day);
    int difference = targetDay
        .difference(today)
        .inDays;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "[D-${difference}] ${data.name} ${data.discountValue}% 할인",
            style: TextStyle(color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pretendard',),
          ),
          const SizedBox(height: 16,),
          Wrap(
            spacing: 8,
            children: [
              _buildTag("#${data.discountValue}% 할인"),
              _buildTag("#이번주 마감"),
              _buildTag("#인기 급상승"),
            ],
          ),
          const SizedBox(height: 12),
          Divider(thickness: 1, color: Colors.grey[100]),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.calendar_today_outlined, dDayText,
              "${formattedStart} ~ ${formattedEnd}", Colors.black),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
          text, style: TextStyle(fontSize: 12, color: Colors.grey[700],)
      ),
    );
  }

  Widget _buildBar(String label, String price, double height, Color color,
      bool isBold) {
    return Column(
      children: [
        if (label == "현재")
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.nochigimaColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -13),
                child: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.nochigimaColor,
                  size: 30,
                ),
              ),
            ],
          )
        else
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              price,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        Container(
          width: 40,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12,
            fontWeight: FontWeight.bold,
            color: label == "현재" ? AppColors.nochigimaColor : Colors
                .grey[600])),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      Color valueColor) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(
            color: const Color(0xFFF25454), fontWeight: FontWeight.w700)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            "·",
            style: TextStyle(color: Color(0xFFD1D3D9),
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
        ),
        Text(value, style: TextStyle(
          color: Color(0xFF4E5058),
          fontSize: 14,)),
      ],
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return "";
    return dateStr.replaceAll('-', '.');
  }

  String _calculateDDay(String endAt) {
    try {
      String formattedDate = endAt.replaceAll('.', '-');
      DateTime endDate = DateTime.parse(formattedDate);
      DateTime now = DateTime.now();

      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime targetDay = DateTime(endDate.year, endDate.month, endDate.day);

      int difference = targetDay
          .difference(today)
          .inDays;

      if (difference == 0) return "오늘 마감";
      if (difference < 0) return "마감됨";
      return "마감 $difference일 전";
    } catch (e) {
      return "기간 정보 없음";
    }
  }

  Widget _buildNoticeSection() {
    final notices = [
      "본 제품은 실제 이미지와 다를 수 있습니다.",
      "1인 5개까지만 판매",
      "매장별로 조기 종료될 수 있습니다.",
      "다른 할인 및 쿠폰과 중복 혜택 불가",
      "해당 프로모션은 제휴 포인트 적립 불가",
      "딜리버리 주문 불가 및 예약 주문 불가",
      "일부 매장은 행사에서 제외될 수 있습니다.",
      "단체 주문에서는 제외됩니다.",
    ];

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "유의 사항",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9AA0A6),
            ),
          ),
          const SizedBox(height: 12),
          ...notices.map(
                (text) =>
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "•",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFB0B4BC),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: Color(0xFFB0B4BC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        ],
      ),
    );
  }
}


