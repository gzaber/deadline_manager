// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deadline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Deadline _$DeadlineFromJson(Map<String, dynamic> json) => Deadline(
      id: json['id'] as String?,
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      expirationDate: DateTime.parse(json['expirationDate'] as String),
    );

Map<String, dynamic> _$DeadlineToJson(Deadline instance) => <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'name': instance.name,
      'expirationDate': instance.expirationDate.toIso8601String(),
    };
