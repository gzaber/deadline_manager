// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as String?,
      userEmail: json['userEmail'] as String,
      authorizedUserEmails: (json['authorizedUserEmails'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: (json['color'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'userEmail': instance.userEmail,
      'authorizedUserEmails': instance.authorizedUserEmails,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
    };
