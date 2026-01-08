class CategoryData {
  final int categoryId;
  final String name;

  CategoryData({
    required this.categoryId,
    required this.name,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      categoryId: json['categoryId'],
      name: json['name'],
    );
  }
}
