import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/screens/login/setting_name_complete.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Settingname extends StatefulWidget {
  final bool isEditMode;
  final String? initialNickname;

  const Settingname({super.key, this.isEditMode = false, this.initialNickname});

  @override
  State<Settingname> createState() => _SettingnameState();
}

class _SettingnameState extends State<Settingname> {
  final _nicknameController = TextEditingController();

  static final storage = FlutterSecureStorage();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  String? _serverErrorText;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      int textLength = _nicknameController.text.length;
      _isButtonEnabled = textLength >= 2 && textLength <= 8;
      if (_serverErrorText != null) {
        _serverErrorText = null;
      }
    });
  }

  Future<void> _checkNicknameAndSubmit(String nickname) async {
    setState(() {
      _isLoading = true;
      _serverErrorText = null;
    });

    String? accessToken = await storage.read(key: 'accessToken');
    final url = Uri.https('api.nochigima.shop', 'v1/users/exists', {
      'nickname': nickname,
    });
    try {
      print("닉네임 전송 시도: $url");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      print("서버 응답 코드: ${response.statusCode}");
      print("서버 응답 바디: ${response.body}");

      if (response.statusCode == 200) {
        final bool isDuplicate = jsonDecode(response.body);

        if (isDuplicate == true) {
          setState(() {
            _serverErrorText = "이미 사용 중인 닉네임입니다.";
          });
        } else {
          final updateUrl = Uri.https(
            'api.nochigima.shop',
            '/v1/users/nickname',
          );
          final updateResponse = await http.patch(
            updateUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode({'newNickname': nickname}),
          );
          print("변경 요청 응답 코드: ${updateResponse.statusCode}");
          if (updateResponse.statusCode == 200) {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Namecomplete(nickName: nickname),
              ),
            );
          } else {
            setState(() {
              _serverErrorText = "닉네임 변경에 실패했습니다.";
            });
          }
        }
      } else {
        setState(() {
          _serverErrorText = "오류가 발생했습니다. 다시 시도해주세요. ";
        });
      }
    } catch (e) {
      print("네트워크 에러 : $e");
      setState(() {
        _serverErrorText = "인터넷 연결을 확인해주세요";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void submitButton(String nickname) {
    // nickname needs to be sent to backend
    print("제출할 닉네임: $nickname");
    //go to next page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Namecomplete(nickName: nickname)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.navigate_before_rounded,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "닉네임을 입력해주세요",
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 24,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  hintText: "닉네임 입력",
                  hintStyle: TextStyle(
                    fontFamily: "Pretendard",
                    color: Colors.grey[400],
                  ),
                  errorText: _serverErrorText,
                  errorStyle: TextStyle(
                    color: Color(0xFFFF333F),
                    fontFamily: "Pretendard",
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFF333F),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFF333F),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFFF333F),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            if (_serverErrorText == null)
              Text(
                "2~8자까지 입력할 수 있어요.",
                style: TextStyle(
                  color: _isButtonEnabled
                      ? Colors.grey[400]
                      : Color(0xffFF333F),
                  fontSize: 14,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.normal,
                ),
              ),

            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: (_isButtonEnabled && !_isLoading)
                    ? () {
                        FocusScope.of(context).unfocus();
                        _checkNicknameAndSubmit(_nicknameController.text);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF333F),
                  disabledBackgroundColor: Color(0xFFFFD9DC),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "다음",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Pretendard",
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
