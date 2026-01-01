import 'package:flutter/material.dart';

Widget buildDialogButton({
  required String text,
  required Color textColor,
  required VoidCallback onTap,
  Color? backgroundColor,
  Color? borderColor,
}) {
  return Expanded(
    child: TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        minimumSize: Size(0, 50),
        backgroundColor: backgroundColor ?? Colors.transparent,
        foregroundColor: textColor,
        side: borderColor != null
            ? BorderSide(color: borderColor, width: 0.8)
            : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: TextStyle(
          fontFamily: "Pretendard",
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
      child: Text(text),
    ),
  );
}