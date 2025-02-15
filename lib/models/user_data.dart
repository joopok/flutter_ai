import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String id,
    required String name,
    required String username,
    required String email,
    required String role,
    required String updatedAt,
    String? profileImage,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) => 
      _$UserDataFromJson(json);
} 