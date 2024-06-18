import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'permission.g.dart';

@JsonSerializable()
class Permission extends Equatable {
  const Permission({
    required this.id,
    required this.giver,
    required this.receiver,
    required this.categoryIds,
  });

  final String? id;
  final String giver;
  final String receiver;
  final List<String> categoryIds;

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionToJson(this);

  @override
  List<Object?> get props => [id, giver, receiver, categoryIds];

  Permission copyWith({
    String? id,
    String? giver,
    String? receiver,
    List<String>? categoryIds,
  }) {
    return Permission(
      id: id ?? this.id,
      giver: giver ?? this.giver,
      receiver: receiver ?? this.receiver,
      categoryIds: categoryIds ?? this.categoryIds,
    );
  }
}
