// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      role: json['role'] as String,
      updatedAt: json['updatedAt'] as String? ?? null,
      profileImage: json['profileImage'] as String? ?? null,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'username': instance.username,
      'role': instance.role,
      'updatedAt': instance.updatedAt,
      'profileImage': instance.profileImage,
    };
