import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'deadline.g.dart';

@JsonSerializable()
class Deadline extends Equatable {
  const Deadline({
    this.id,
    required this.categoryId,
    required this.name,
    required this.expirationDate,
  });

  final String? id;
  final String categoryId;
  final String name;
  final DateTime expirationDate;

  factory Deadline.fromJson(Map<String, dynamic> json) =>
      _$DeadlineFromJson(json);

  Map<String, dynamic> toJson() => _$DeadlineToJson(this);

  Deadline copyWith({
    String? id,
    String? categoryId,
    String? name,
    DateTime? expirationDate,
  }) {
    return Deadline(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }

  @override
  List<Object?> get props => [id, categoryId, name, expirationDate];
}
