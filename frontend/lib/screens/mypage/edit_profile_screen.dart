import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/screens/mypage/change_nickname_screen.dart';


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
                Container(
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
                      _buildEditMenu(
                        label: "닉네임",
                        trailing: Text(
                          "모아부기",
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
                              builder: (context) => ChangeNicknameScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(height: 12, color: Color(0xFFF9FAFB)),
                // alarm
                Container(
                  padding: EdgeInsets.only(top: 14),
                  child: Column(
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

                    ],
                  ),

                ),
                Container(height: 12, color: Color(0xFFF9FAFB)),
                // social account
                _buildEditMenu(
                  label: "연동된 소셜 계정",
                  trailing: SvgPicture.asset(
                    "assets/images/kakao_icon_mini.svg",
                    width: 36,
                  ),
                  onTap: () {},
                ),
                // 탈퇴하기
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildEditMenu({
  required String label,
  required Widget trailing,
  required VoidCallback onTap,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    onTap: onTap,
    title: Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontFamily: "Pretendard",
        fontWeight: FontWeight.w500,
        color: Color(0xFF686D78),
      ),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        trailing,
        SizedBox(width: 4),
        Icon(Icons.chevron_right_rounded, color: Color(0xFF858C9A), size: 20),
      ],
    ),
  );
}
