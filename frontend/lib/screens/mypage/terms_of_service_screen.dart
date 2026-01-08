import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFF323439),
          ),
        ),
        title: Text(
          "약관 및 정책",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: "Pretendard",
            color: Color(0xFF323439),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("제 1장 총칙"),
                const SizedBox(height: 16),
                _buildArticleTitle("제 1조 (목적)"),
                _buildBodyText(
                    "본 약관은 주식회사 더아너스(이하 '회사')가 제공하는 놓치지마 서비스(이하 '서비스')의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다."
                ),
                const SizedBox(height: 24),

                _buildArticleTitle("제 2조 (용어의 정의)"),
                _buildBodyText(
                    "1. '서비스'란 대학생들의 원활한 식생활과 소비 생활을 돕기 위해 제공하는 통합 정보 플랫폼을 의미합니다.\n"
                        "2. '이용자'란 본 약관에 따라 회사가 제공하는 서비스를 이용하는 회원 및 비회원을 말합니다.\n"
                        "3. '회원'이란 회사에 개인정보를 제공하여 회원등록을 한 자로서, 회사의 정보를 지속적으로 제공받으며 서비스를 이용할 수 있는 자를 말합니다.\n"
                        "4. '대학생 인증'이란 이용자가 실제 대학생임을 증명하기 위한 절차를 말합니다."
                ),
                const SizedBox(height: 24),

                _buildArticleTitle("제 3조 (약관의 게시 및 변경)"),
                _buildBodyText(
                    "1. 회사는 본 약관의 내용을 이용자가 쉽게 알 수 있도록 서비스 초기 화면에 게시합니다.\n"
                        "2. 회사는 필요한 경우 관련 법령을 위배하지 않는 범위에서 본 약관을 변경할 수 있으며, 변경된 약관은 적용일자 및 개정사유를 명시하여 현행약관과 함께 서비스 초기화면에 그 적용일자 7일 이전부터 적용일자 전일까지 공지합니다."
                ),

                _buildSectionTitle("제 2장 서비스 이용"),
                const SizedBox(height: 16),
                _buildArticleTitle("제 4조 (서비스의 제공 및 변경)"),
                _buildBodyText(
                    "1. 회사는 다음과 같은 서비스를 제공합니다.\n"
                        "   • 대학생들의 학교 식단표 제공 및 조회 서비스\n"
                        "   • 학생 인증을 통한 선후배 매칭 커뮤니티 시스템\n"
                        "   • 지도 기반 업체 추천 서비스\n"
                        "   • 리뷰 평점 기반의 커뮤니티\n"
                        "   • 기타 회사가 추가 개발하거나 제휴 계약 등을 통해 이용자에게 제공하는 일체의 서비스\n"
                        "2. 회사는 서비스의 내용, 이용방법, 운영시간에 대하여 변경이 있는 경우에는 변경사유, 변경된 서비스의 내용 및 제공일자 등을 그 변경 전에 서비스 내에 공지합니다."
                ),
                const SizedBox(height: 24),

                _buildArticleTitle("제 5조 (회원가입)"),
                _buildBodyText(
                    "1. 이용자는 회사가 정한 가입 양식에 따라 회원정보를 기입한 후 이 약관에 동의한다는 의사표시를 함으로서 회원가입을 신청합니다.\n"
                        "2. 회사는 전항과 같이 회원으로 가입을 신청한 이용자 중 다음 각 호에 해당하지 않는 한 회원으로 등록합니다.\n"
                        "   가. 가입신청자가 이 약관에 의하여 이전에 회원자격을 상실한 적이 있는 경우\n"
                        "   나. 실명이 아니거나 타인의 명의를 이용한 경우\n"
                        "   다. 등록 내용에 허위, 기재누락, 오기가 있는 경우\n"
                        "   라. 기타 회원으로 등록하는 것이 회사의 서비스 운영에 현저히 지장이 있다고 판단되는 경우"
                ),
                const SizedBox(height: 24),

                _buildArticleTitle("제 6조 (대학생 인증)"),
                _buildBodyText(
                    "1. 회원은 서비스 이용시, 대학생 신분을 증명하기 위해 재학증명서를 인증해야 합니다.\n"
                        "2. 대학생 인증 방식은 재학 증명서 등에 대해 자동화된 OCR 기반 이용자 인증 혹은 관리자의 수동 검수를 통해 이루어집니다.\n"
                        "3. 인증 실패 또는 타인의 정보 도용이 확인될 경우, 즉시 회원자격이 정지되며 법적 책임을 질 수 있습니다."
                ),
                const SizedBox(height: 32),

                _buildSectionTitle("제 3장 의무 및 책임"),
                const SizedBox(height: 16),
                _buildArticleTitle("제 8조 (회사의 의무)"),
                _buildBodyText(
                    "1. 회사는 법령과 본 약관이 금지하거나 공서양속에 반하는 행위를 하지 않으며 본 약관이 정하는 바에 따라 지속적이고 안정적으로 서비스를 제공하기 위해 최선을 다합니다.\n"
                        "2. 회사는 이용자가 안전하게 서비스를 이용할 수 있도록 이용자의 개인정보보호를 위한 보안 시스템을 갖추어야 합니다."
                ),
                const SizedBox(height: 32),

                _buildSectionTitle("제 4장 기타"),
                const SizedBox(height: 16),
                _buildArticleTitle("제 11조 (개인정보보호)"),
                _buildBodyText(
                    "1. 회사는 이용자의 개인정보 수집 시 서비스 제공에 필요한 최소한의 정보를 수집합니다.\n"
                        "2. 회사는 회원가입 시 제공한 개인정보를 수집하며, 수집된 개인정보는 개인정보보호정책에 따라 관리 및 보호됩니다."
                ),
                const SizedBox(height: 24),

                _buildArticleTitle("제 13조 (시행일)"),
                _buildBodyText(
                    "본 약관은 2025년 3월 10일부터 시행됩니다."
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Pretendard",
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF323439),
        height: 1.5
      ),
    );
  }

  Widget _buildArticleTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "Pretendard",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF323439),
          height: 1.5
        ),
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "Pretendard",
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFF686D78),
        height: 1.5,
      ),
    );
  }

}
