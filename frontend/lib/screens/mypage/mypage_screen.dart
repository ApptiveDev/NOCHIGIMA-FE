import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/screens/mypage/my_bookmarks_screen.dart';
import 'package:frontend/widgets/mypage/mypage_widgets.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  String _nickname = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMyProfile();
  }

  Future<void> _fetchMyProfile() async {
    try {
      // backend 연결 필요
      await Future.delayed(const Duration(seconds: 1));
      final nickname = "모아부기";

      if (mounted) {
        setState(() {
          _nickname = nickname;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("에러 발생 : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단(프로필, 북마크)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // profile
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/myProfile.svg",
                        width: 70,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _isLoading
                            ? const Align(
                                alignment: Alignment.centerLeft,
                                child: CircularProgressIndicator(),
                              )
                            : RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF323439),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: _nickname,
                                      style: TextStyle(
                                        fontFamily: "Pretendard",
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(text: " 님,\n안녕하세요!"),
                                  ],
                                ),
                              ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Text(
                              "프로필 편집",
                              style: TextStyle(
                                color: Color(0xFF858C9A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.edit,
                              size: 10,
                              color: Color(0xFF858C9A),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          backgroundColor: Color(0xFFF9FAFB),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  // bookmark
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: buildItem("4", "나의 브랜드", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyBookmarksScreen(),
                              ),
                            );
                          }),
                        ),
                        buildDivider(),
                        Expanded(
                          child: buildItem("13", "저장한 프로모션", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyBookmarksScreen(),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 12, color: Color(0xFFF9FAFB)),
            // 하단(약관, 로그아웃)
            Column(children: []),
          ],
        ),
      ),
    );
  }
}