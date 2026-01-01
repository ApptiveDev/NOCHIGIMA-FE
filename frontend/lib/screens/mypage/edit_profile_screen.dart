import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                SvgPicture.asset("assets/images/myProfile.svg", width: 140),
                SizedBox(height: 30),
                // info
                Container(height: 12, color: Color(0xFFF9FAFB)),
                // alarm
                Container(height: 12, color: Color(0xFFF9FAFB)),
                // social account
                
                // 탈퇴하기
              ],
            ),
          ),
        ),
      ),
    );
  }
}
