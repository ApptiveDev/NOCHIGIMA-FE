import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MypageScreen extends StatelessWidget {
  const MypageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단(프로필, 북마크)
            Container(
              child: Column(
                children: [
                  Row(), // profile
                  Row(),
                ],
              ),
            ),
            Container(
              height: 12,
              color: Color(0xFFF9FAFB),
            ),
            // 하단(약관, 로그아웃)
            Column(
              children: [

              ],
            )
          ],
        ),
      ),
    );
  }
}
