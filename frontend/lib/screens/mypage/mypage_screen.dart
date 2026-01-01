import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/screens/mypage/my_bookmarks_screen.dart';
import 'package:frontend/screens/mypage/terms_of_service_screen.dart';
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

  void _LogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 28, 20, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "로그아웃 하시겠습니까?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Pretendard",
                    color: Color(0xFF323439),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildDialogButton(text: "취소", textColor: Color(0xFF686D78), onTap: (){Navigator.pop(context);}, borderColor: Color(0xFFE2E4EC)),
                    SizedBox(width: 10),
                    buildDialogButton(text: "로그아웃", textColor: Colors.white, onTap: (){}, backgroundColor: Color(0xFFFF333F))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
            Column(
              children: [
                buildMenu("약관 및 정책", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsOfServiceScreen(),
                    ),
                  );
                }),
                buildMenu("로그아웃", () {
                  _LogoutDialog();
                }),
              ],
            ),
            Column(children: []),
          ],
        ),
      ),
    );
  }
}

