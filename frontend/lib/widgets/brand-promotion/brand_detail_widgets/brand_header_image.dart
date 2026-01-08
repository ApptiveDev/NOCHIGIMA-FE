import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class BrandHeaderImage extends StatefulWidget {
  final dynamic brand;
  final Future<List<dynamic>> promotionsFuture;

  const BrandHeaderImage({
    super.key,
    required this.brand,
    required this.promotionsFuture,
  });

  @override
  State<BrandHeaderImage> createState() => _BrandHeaderImageState();
}

class _BrandHeaderImageState extends State<BrandHeaderImage> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: widget.promotionsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("가져온 이미지 개수: ${snapshot.data!.length}");
        }

        // 1. 로딩 중일 때 처리
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AspectRatio(
            aspectRatio: 1 / 0.8,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. 에러가 났을 때 처리
        if (snapshot.hasError) {
          print("에러 발생: ${snapshot.error}");
          return Container(height: 200, color: Colors.red[50], child: const Text("이미지 로드 실패"));
        }

        List<String> imageUrls = [];
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          imageUrls = snapshot.data!.map((e) => e.imageURL).where((url) => url.isNotEmpty).toList().cast<String>();
        } else {
          imageUrls = ['https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800'];
        }

        return Stack(
          children: [
            AspectRatio(
              aspectRatio: 1 / 0.8,
              child: PageView.builder(
                itemCount: imageUrls.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, e, s) => Container(
                      color: const Color(0xFFF3F4F8),
                      child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: SafeSvg(url: widget.brand.imageUrl, size: 44),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentPage + 1} / ${imageUrls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              left: 12,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


class SafeSvg extends StatelessWidget {
  final String url;
  final double size;

  const SafeSvg({super.key, required this.url, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: http.read(Uri.parse(url)).then((value) =>
          value.replaceAll('100%', size.toString())),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SvgPicture.string(
            snapshot.data!,
            width: size,
            height: size,
            fit: BoxFit.contain,
          );
        } else if (snapshot.hasError) {
          return const Icon(Icons.broken_image, color: Colors.grey);
        }
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      },
    );
  }
}