// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      updatedAt: json['updatedAt'] as String,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'role': instance.role,
      'updatedAt': instance.updatedAt,
      'profileImage': instance.profileImage,
    };
