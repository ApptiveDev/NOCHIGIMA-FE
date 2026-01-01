import 'package:flutter/material.dart';

Widget buildItem(String count, String label, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF323439),
              fontFamily: "Pretendard",
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF858C9A),
              fontFamily: "Pretendard",
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildDivider() {
  return const VerticalDivider(
    color: Color(0xFFE2E4EC),
    thickness: 0.7,
    width: 1,
  );
}

