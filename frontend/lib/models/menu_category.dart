import 'package:flutter/material.dart';

enum MenuCategory {
  newEvent('신규이벤트', 'assets/images/menu/menu_newEvent.svg', Color(0xFFFFEDED)),
  top20('TOP 20', 'assets/images/menu/menu_top20.svg', Color(0xFFFFEDED)),
  chicken('치킨', 'assets/images/menu/menu_chicken.svg', Color(0xFFFDF5E8)),
  pizza('피자', 'assets/images/menu/menu_pizza.svg', Color(0xFFFDF5E8)),
  burger('햄버거', 'assets/images/menu/menu_hamburger.svg', Color(0xFFFDF5E8)),
  cafe('카페', 'assets/images/menu/menu_cafe.svg', Color(0xFFFFEDED)),
  tteokbokki('떡볶이', 'assets/images/menu/menu_tteokbokki.svg', Color(0xFFFDF5E8)),
  convenience('편의점', 'assets/images/menu/menu_convenienceStore.svg', Color(0xFFF6EEFF)),
  etc('기타', '', Color(0xFFF7F7F7));

  final String label;
  final String imagePath;
  final Color backgroundColor;

  const MenuCategory(this.label, this.imagePath, this.backgroundColor);
}