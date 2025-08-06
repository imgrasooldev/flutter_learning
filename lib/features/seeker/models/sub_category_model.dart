import 'package:equatable/equatable.dart';

class SubCategoryModel extends Equatable {
  final int id;
  final String name;
  final String type;
  final int parentId;

  const SubCategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.parentId,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
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
