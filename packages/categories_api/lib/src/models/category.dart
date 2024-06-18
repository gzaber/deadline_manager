import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category extends Equatable {
  const Category({
    this.id,
    required this.userEmail,
    required this.name,
    required this.icon,
    required this.color,
  });

  final String? id;
  final String userEmail;
  final String name;
  final int icon;
  final int color;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  Category copyWith({
    String? id,
    String? userEmail,
    String? name,
    int? icon,
    int? color,
  }) {
    return Category(
      id: id ?? this.id,
      userEmail: userEmail ?? this.userEmail,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [id, userEmail, name, icon, color];
}
