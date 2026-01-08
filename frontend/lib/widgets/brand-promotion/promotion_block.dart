import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

// Promotion block
class PromotionBlock extends StatelessWidget {
  final VoidCallback onPressed;
  final String imageURL;
  final String title;
  final String deadline;
  final List<String> filters;
  final bool isBookmarked;
  final VoidCallback onHeartTap;

  const PromotionBlock({
    super.key,
    required this.imageURL,
    required this.title,
    required this.deadline,
    this.filters = const [],
    required this.onPressed,
    required this.isBookmarked,
    required this.onHeartTap,

  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageURL,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace){
                      return Container(
                        width: double.infinity,
                        height: 180,
                        color: Colors.grey,
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                      );
                    },
                  ),
                ),
                // like
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onHeartTap,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.6),
                      ),
                      child: Icon(
                        isBookmarked ? Icons.favorite : Icons.favorite_border,
                        color: isBookmarked ? AppColors.nochigimaColor : Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                ),
              ],
            ),
            SizedBox(height: 10),
            // title
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF323439),
                fontSize: 18,
              ),
            ),
            Row(
              children: [
                // deadline
                Text(
                  "행사 기간",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF858C9A),
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  height: 12,
                  child: VerticalDivider(
                    thickness: 1,
                    width: 1,
                    indent: 2,
                    color: Color(0xFF858C9A),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  deadline,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF858C9A),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            // filter
          ],
        ),
      ),
    );
  }
}