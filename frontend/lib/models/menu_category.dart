import 'package:flutter/material.dart';

enum MenuCategory {
  newEvent('신규이벤트', 'assets/images/menu/menu_newEvent.svg', Color(0xFFFFEDED), null),
  top20('TOP 20', 'assets/images/menu/menu_top20.svg', Color(0xFFFFEDED), null),
  chicken('치킨', 'assets/images/menu/menu_chicken.svg', Color(0xFFFDF5E8), 3),
  pizza('피자', 'assets/images/menu/menu_pizza.svg', Color(0xFFFDF5E8), 2),
  burger('햄버거', 'assets/images/menu/menu_hamburger.svg', Color(0xFFFDF5E8), 1),
  cafe('카페', 'assets/images/menu/menu_cafe.svg', Color(0xFFFFEDED), 4),
  tteokbokki('떡볶이', 'assets/images/menu/menu_tteokbokki.svg', Color(0xFFFDF5E8), 5),
  convenience('편의점', 'assets/images/menu/menu_convenienceStore.svg', Color(0xFFF6EEFF), 6),
  etc('기타', '', Color(0xFFF7F7F7), null);

  final String label;
  final String imagePath;
  final Color backgroundColor;
  final int? serverId;

  const MenuCategory(this.label, this.imagePath, this.backgroundColor, this.serverId);

  static MenuCategory fromApiName(String apiName) {
    switch (apiName.toLowerCase()) {
      case 'burgers': return MenuCategory.burger;
      case 'pizzas': return MenuCategory.pizza;
      case 'chickens': return MenuCategory.chicken;
      case 'cafes': return MenuCategory.cafe;
      case 'tteokbokki': return MenuCategory.tteokbokki;
      case 'cvs': return MenuCategory.convenience;
      default: return MenuCategory.etc;
    }
  }
}