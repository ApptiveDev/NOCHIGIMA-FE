import 'package:flutter/material.dart';
import 'package:frontend/main_screen.dart';
import 'package:frontend/screens/login/login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // KakaoSdk.init(nativeAppKey: '8667568839d73106932028edac842fef');
  // print("🔥 현재 내 앱의 키 해시: ${KakaoSdk.origin}");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MainScreen(),
    );
  }
}