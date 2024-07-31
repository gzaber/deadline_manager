import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'permission.g.dart';

@JsonSerializable()
class Permission extends Equatable {
  Permission({
    String? id,
    required this.giver,
    required this.receiver,
    required this.categoryIds,
  }) : id = id ?? const Uuid().v1();

  final String id;
  final String giver;
  final String receiver;
  final List<String> categoryIds;

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionToJson(this);

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

  @override
  List<Object> get props => [id, giver, receiver, categoryIds];
}
