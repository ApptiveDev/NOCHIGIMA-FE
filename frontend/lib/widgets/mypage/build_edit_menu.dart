import 'package:flutter/material.dart';

Widget buildEditMenu({
  required String label,
  required Widget trailing,
  required VoidCallback onTap,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    onTap: onTap,
    title: Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontFamily: "Pretendard",
        fontWeight: FontWeight.w500,
        color: Color(0xFF686D78),
      ),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        trailing,
        SizedBox(width: 4),
        Icon(Icons.chevron_right_rounded, color: Color(0xFF858C9A), size: 20),
      ],
    ),
  );
}
