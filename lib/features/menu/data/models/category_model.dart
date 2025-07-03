import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.token,
    required super.name,
    required super.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      token: json['token'],
      name: json['name'],
      description: json['description'],
    );
  }
}
