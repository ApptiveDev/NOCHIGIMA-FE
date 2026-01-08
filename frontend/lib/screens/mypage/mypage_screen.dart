import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/screens/mypage/edit_profile_screen.dart';
import 'package:frontend/screens/mypage/my_bookmarks_screen.dart';
import 'package:frontend/screens/mypage/terms_of_service_screen.dart';
import 'package:frontend/widgets/mypage/mypage_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../login/login.dart';

class MypageScreen extends StatefulWidget {
  final int initialIndex;

  const MypageScreen({super.key, this.initialIndex = 0});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  String _nickname = "";
  int _brandCount = 0;
  int _promotionCount = 0;
  bool _isLoading = true;

  final storage = const FlutterSecureStorage();
  final String baseUrl = "api.nochigima.shop";

  @override
  void initState() {
    super.initState();
    _fetchMyProfile();
  }

  Future<void> _fetchMyProfile() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        setState(() {
          _isLoading = false;
        });
      }

      final profileUri = Uri.https(baseUrl, '/v1/users/me');
      final promoUri = Uri.https(baseUrl, '/v1/favorites/discounts');
      final brandUri = Uri.https(baseUrl, '/v1/favorites/brand');

      final responses = await Future.wait([
        http.get(profileUri, headers: {'Authorization': 'Bearer $accessToken'}),
        http.get(brandUri, headers: {'Authorization': 'Bearer $accessToken'}),
        http.get(promoUri, headers: {'Authorization': 'Bearer $accessToken'}),
      ]);

      final profileResponse = responses[0];
      final brandResponse = responses[1];
      final promoResponse = responses[2];

      if (mounted) {
        setState(() {
          if (profileResponse.statusCode == 200) {
            final profileData = jsonDecode(
              utf8.decode(profileResponse.bodyBytes),
            );
            _nickname = profileData['nickname'] ?? "알 수 없음";
          } else {
            print("프로필 로드 실패: ${profileResponse.statusCode}");
          }

          if (brandResponse.statusCode == 200) {
            final List<dynamic> brandList = jsonDecode(
              utf8.decode(brandResponse.bodyBytes),
            );
            _brandCount = brandList.length;
          }

          if (promoResponse.statusCode == 200) {
            final List<dynamic> promoList = jsonDecode(
              utf8.decode(promoResponse.bodyBytes),
            );
            _promotionCount = promoList.length;
          }

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
                    buildDialogButton(
                      text: "취소",
                      textColor: Color(0xFF686D78),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      borderColor: Color(0xFFE2E4EC),
                    ),
                    SizedBox(width: 10),
                    buildDialogButton(
                      text: "로그아웃",
                      textColor: Colors.white,
                      onTap: () async {
                        try {
                          await storage.delete(key: 'accessToken');
                          if (!mounted) return;
                          Navigator.pop(context);
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                            (route) => false,
                          );
                        } catch (e) {
                          print("로그아웃 에러 : $e");
                        }
                      },
                      backgroundColor: Color(0xFFFF333F),
                    ),
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
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(),
                            ),
                          );
                          _fetchMyProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          backgroundColor: Color(0xFFF9FAFB),
                          elevation: 0,
                          shadowColor: Colors.transparent,
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
                          child: buildItem("$_brandCount", "나의 브랜드", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MyBookmarksScreen(initialIndex: 0),
                              ),
                            ).then((_) {
                              _fetchMyProfile();
                            });
                          }),
                        ),
                        buildDivider(),
                        Expanded(
                          child: buildItem("$_promotionCount", "저장한 프로모션", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MyBookmarksScreen(initialIndex: 1),
                              ),
                            ).then((_) {
                              _fetchMyProfile();
                            });
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

class MypageNavigator extends StatelessWidget {
  const MypageNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      // 마이페이지 탭 내부의 첫 화면 지정
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => const MypageScreen(), // 기존의 마이페이지
        );
      },
    );
  }
}
