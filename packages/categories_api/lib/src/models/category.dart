import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'category.g.dart';

@JsonSerializable()
class Category extends Equatable {
  Category({
    String? id,
    required this.owner,
    required this.name,
    required this.icon,
    required this.color,
  }) : id = id ?? const Uuid().v1();

  final String id;
  final String owner;
  final String name;
  final int icon;
  final int color;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  Category copyWith({
    String? id,
    String? owner,
    String? name,
    int? icon,
    int? color,
  }) {
    return Category(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  List<Object> get props => [id, owner, name, icon, color];
}
