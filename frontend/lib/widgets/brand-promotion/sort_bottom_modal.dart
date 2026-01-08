import 'package:flutter/material.dart';

class SortBottomModal extends StatelessWidget {
  final String selectedSort; // 현재 선택된 정렬 값

  const SortBottomModal({super.key, required this.selectedSort});

  @override
  Widget build(BuildContext context) {
    // 정렬 옵션 리스트
    final List<String> sortOptions = ["최신순", "인기순", "할인율", "추천순"];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 내용만큼만 높이 차지
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 핸들 바
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Text(
              "정렬",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // 정렬 옵션 목록
          ...sortOptions.map((option) => _buildSortItem(context, option)),
          const SizedBox(height: 30), // 하단 여백
        ],
      ),
    );
  }

  Widget _buildSortItem(BuildContext context, String title) {
    final isSelected = selectedSort == title;

    return InkWell(
      onTap: () {
        // 선택한 값을 넘겨주며 모달 닫기
        Navigator.pop(context, title);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.black87 : Colors.black54,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Colors.black87, size: 20),
          ],
        ),
      ),
    );
  }
}