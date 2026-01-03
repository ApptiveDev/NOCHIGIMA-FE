import 'package:flutter/material.dart';
import 'package:frontend/screens/login/setting_name_complete.dart';

class Settingname extends StatefulWidget {
  final bool isEditMode;
  final String? initialNickname;

  const Settingname({
    super.key,
    this.isEditMode = false,
    this.initialNickname
  });

  @override
  State<Settingname> createState() => _SettingnameState();
}

class _SettingnameState extends State<Settingname> {
  final _nicknameController = TextEditingController();
  bool _isButtonEnabled = false;

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
    });
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
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "2~8자까지 입력할 수 있어요.",
              style: TextStyle(
                color: _isButtonEnabled ? Colors.grey[400] : Color(0xffFF333F),
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
                onPressed: _isButtonEnabled
                    ? () {
                        submitButton(_nicknameController.text);
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
                child: Text(
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
