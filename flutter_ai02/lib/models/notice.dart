import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice.freezed.dart';
part 'notice.g.dart';

@freezed
class Notice with _$Notice {
  const factory Notice({
    required int id,
    required String title,
    required String content,
    required DateTime createdAt,
    @Default(false) bool isImportant,
  }) = _Notice;

  factory Notice.fromJson(Map<String, dynamic> json) => 
    _$NoticeFromJson({
      'id': json['noticeId'],
      'title': json['title'],
      'content': json['content'],
      'createdAt': json['created_at'],
      'isImportant': json['isImportant'] ?? false,
    });
} 