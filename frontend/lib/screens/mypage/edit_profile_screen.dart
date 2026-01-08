import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/screens/login/setting_name.dart';
import 'package:frontend/widgets/mypage/mypage_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../login/login.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isMarketingAgreed = true;
  String _nickname = "";
  String _socialType = "";
  bool _isLoading = true;

  final storage = const FlutterSecureStorage();
  final String baseUrl = "api.nochigima.shop";

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) return;

      final uri = Uri.https(baseUrl, '/v1/users/me');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        if (mounted) {
          setState(() {
            _nickname = data['nickname'] ?? "알 수 없음";
            _socialType = data['oauthProvider'] ?? "KAKAO"; // 기본값 혹은 null 처리
            _isLoading = false;
          });
        }
      } else {
        print("프로필 로드 실패: ${response.statusCode}");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("네트워크 에러: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAccount() async {
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) return;
      final uri = Uri.https(baseUrl, '/v1/users/me');
      final response = await http.delete(
        uri,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await storage.deleteAll();
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false,
        );
      } else {
        print("탈퇴 실패 : ${response.statusCode}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("탈퇴 처리에 실패했습니다. 다시 시도해주세요.")),
          );
        }
      }
    } catch (e) {
      print("탈퇴 에러 : $e");
    }
  }

  void _showWithdrawalDialog() {
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
                  "정말 탈퇴하시겠습니까?",
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
                      text: "탈퇴하기",
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.pop(context);
                        _deleteAccount();
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

  Widget _getSocialIcon(String type) {
    String iconPath;
    switch (type.toUpperCase()) {
      case 'GOOGLE':
        iconPath = "assets/images/google_icon.svg";
        break;
      case 'KAKAO':
      default:
        iconPath = "assets/images/kakao_icon_mini.svg";
        break;
    }
    return SvgPicture.asset(
      iconPath,
      width: 36,
      placeholderBuilder: (context) => const Icon(Icons.account_circle, color: Colors.grey,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_rounded, color: Color(0xFF323439)),
        ),
        title: Text(
          "프로필 편집",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Pretendard",
            fontWeight: FontWeight.w500,
            color: Color(0xFF323439),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Center(
                        child: SvgPicture.asset(
                          "assets/images/myProfile.svg",
                          width: 140,
                        ),
                      ),
                      SizedBox(height: 30),
                      // info
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "기본정보",
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF949BA8),
                              ),
                            ),
                            buildEditMenu(
                              label: "닉네임",
                              trailing: Text(
                                _nickname,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Pretendard",
                                  fontSize: 16,
                                  color: Color(0xFF323439),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Settingname(),
                                  ),
                                ).then((_) {
                                  _fetchUserProfile();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(height: 12, color: Color(0xFFF9FAFB)),
                      // alarm
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "알림",
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF949BA8),
                              ),
                            ),
                            SizedBox(height: 8),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                "마케팅 수신 동의",
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF323439),
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Text(
                                  "알림이 오지 않을 경우,\n기기 설정 > 놓치지마 앱의 알림 허용 여부를 확인해 주세요!",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFAFB8C1),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              trailing: CupertinoSwitch(
                                value: _isMarketingAgreed,
                                activeTrackColor: Colors.green,
                                onChanged: (value) {
                                  setState(() {
                                    _isMarketingAgreed = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(height: 12, color: Color(0xFFF9FAFB)),

                      // social account
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildEditMenu(
                              label: "연동된 소셜 계정",
                              trailing: _getSocialIcon(_socialType),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      // 탈퇴하기
                      Spacer(),
                      Center(
                        child: TextButton(
                          onPressed: _showWithdrawalDialog,
                          child: Text(
                            "탈퇴하기",
                            style: TextStyle(
                              color: Color(0xFFFF333F),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              fontFamily: "Pretendard",
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFFFF333F),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
