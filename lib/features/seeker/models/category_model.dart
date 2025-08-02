import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final int id;
  final String name;
  final String type;
  final int parentId;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.parentId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      parentId: json['parent_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'type': type, 'parent_id': parentId};
  }

  @override
  List<Object?> get props => [id, name, type, parentId];
}
