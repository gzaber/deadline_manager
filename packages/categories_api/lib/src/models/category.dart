import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category extends Equatable {
  Category({
    this.id,
    required this.userEmail,
    required this.authorizedUserEmails,
    required this.name,
    required this.icon,
    required this.color,
  });

  final String? id;
  final String userEmail;
  final List<String> authorizedUserEmails;
  final String name;
  final String icon;
  final int color;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  Category copyWith({
    String? id,
    String? userEmail,
    List<String>? authorizedUserEmails,
    String? name,
    String? icon,
    int? color,
  }) {
    return Category(
      id: id ?? this.id,
      userEmail: userEmail ?? this.userEmail,
      authorizedUserEmails: authorizedUserEmails ?? this.authorizedUserEmails,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props =>
      [id, userEmail, authorizedUserEmails, name, icon, color];
}
