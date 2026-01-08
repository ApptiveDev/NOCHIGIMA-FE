import 'package:flutter/material.dart';

class BrandDetailScreen extends StatelessWidget {
  const BrandDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("버거킹")),
      body: const Center(child: Text("브랜드 상세 화면")),
    );
  }
}
