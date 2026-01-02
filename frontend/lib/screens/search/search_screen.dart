import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _resetController = TextEditingController();

  @override
  void dispose(){
    _resetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFAFB8C1)),
        title: SearchBar(
          controller: _resetController,
          hintText: "주소 검색",
          hintStyle: WidgetStateProperty.all(
            TextStyle(
              color: Colors.grey[400],
              fontFamily: "Pretendard",
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.grey[050]!),
          elevation: WidgetStateProperty.all<double>(0.0),
          trailing: [
            IconButton(onPressed: () {_resetController.clear();}, icon: Icon(Icons.cancel)),
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          ],
          shape: WidgetStateProperty.all(
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          constraints: BoxConstraints(maxHeight: 60),
        ),
      ),
      // 인기 검색어
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          ],
        ),
      ),
    );
  }
}
