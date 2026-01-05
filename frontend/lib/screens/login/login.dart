import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/main_screen.dart';
import './setting_name.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatelessWidget {
  static final storage = FlutterSecureStorage();
  const Login({super.key});
  
  Future<Map<String, dynamic>?> sendTokenToServer(String kakaoAccessToken) async {
    final url = Uri.parse('https://api.nochigima.shop/v1/auth/kakao/callback');
    print("🚀 [서버통신 시작] 주소: $url"); // 1. 함수 진입 확인
    print("🚀 [보내는 토큰]: $kakaoAccessToken");
    try {
      final response = await http.post(
          url,
        headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'accessToken':kakaoAccessToken
          }),
      );
      print("📩 [서버 응답 코드]: ${response.statusCode}");
      if (response.statusCode == 200){
        print("서버 로그인 성공!");
        return jsonDecode(response.body);
      } else {
        print("서버 에러 ${response.statusCode} / ${response.body}");
        return null;
      }
    } catch (e) {
      print("네트워크 에러 $e");
      return null;
    }
  }
  
  void _handleLogin(BuildContext context, String provider) async {
    String? socialId;
    print("🔥 [내 진짜 키 해시]: ${await KakaoSdk.origin}");
    try {
      if (provider == 'kakao') {
        print("카카오 로그인 실행");
        OAuthToken token;
        if (await isKakaoTalkInstalled()){
          try{
            token = await UserApi.instance.loginWithKakaoTalk();
            print("kakao login 성공");
          } catch (e) {
            print("kakao login 실패 $e");
            token = await UserApi.instance.loginWithKakaoAccount();
          }
        } else {
          token = await UserApi.instance.loginWithKakaoAccount();
          print("kakao login with account 성공");
        }
        print("============================");
        print("내 카카오 access token : ${token.accessToken}");
        print("============================");

        final serverResponse = await sendTokenToServer(token.accessToken);
        if (serverResponse != null) {
          String accessToken = serverResponse['accessToken'];
          String refreshToken = serverResponse['refreshToken'];
          bool isNewMember = serverResponse['isNewMember'];

          print("✅ 서버 로그인 성공");
          print("- New Member? : $isNewMember");
          print("- Access Token : $accessToken");

          await storage.write(key: 'accessToken', value: accessToken);
          await storage.write(key: 'refreshToken', value: refreshToken);
          if (!context.mounted) return;
          if (isNewMember) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settingname()),
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
                  (Route<dynamic> route) => false,
            );
          }
        }
      } else if (provider == 'google') {
        print("구글 로그인 실행");
      }


    } catch (error) {
      print("$provider 로그인Error : $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: SvgPicture.asset('assets/images/Logo.svg', width: 150),
              ),
              Text(
                "세상의 모든 프로모션을 모아 한눈에",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: "Pretendard",
                ),
              ),
              SizedBox(height: 100),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    _handleLogin(context, 'kakao');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFDE500),
                    disabledBackgroundColor: Color(0xFFFDE500),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: SvgPicture.asset(
                            'assets/images/kakao_icon.svg',
                            width: 20,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "카카오로 시작하기",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: "Pretendard",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                // google로 시작하기 버튼
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    _handleLogin(context, 'google');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    disabledBackgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[900]!, width: 1.0),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: SvgPicture.asset(
                            'assets/images/google_icon.svg',
                            width: 20,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Google로 시작하기",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: "Pretendard",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
