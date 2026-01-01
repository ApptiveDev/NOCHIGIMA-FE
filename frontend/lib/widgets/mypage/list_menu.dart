import 'package:flutter/material.dart';

Widget buildMenu(String label, VoidCallback onTap) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20),
    onTap: onTap,
    title: Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontFamily: "Pretendard",
        fontWeight: FontWeight.w500,
        color: Color(0xFF323439),
      ),
    ),
    trailing: Icon(
      Icons.chevron_right_rounded,
      color: Color(0xFFAFB8C1),
      size: 24,
    ),
  );
}
