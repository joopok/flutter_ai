// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Notice _$NoticeFromJson(Map<String, dynamic> json) {
  return _Notice.fromJson(json);
}

/// @nodoc
mixin _$Notice {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isImportant => throw _privateConstructorUsedError;

  /// Serializes this Notice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Notice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoticeCopyWith<Notice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoticeCopyWith<$Res> {
  factory $NoticeCopyWith(Notice value, $Res Function(Notice) then) =
      _$NoticeCopyWithImpl<$Res, Notice>;
  @useResult
  $Res call(
      {int id,
      String title,
      String content,
      DateTime createdAt,
      bool isImportant});
}

/// @nodoc
class _$NoticeCopyWithImpl<$Res, $Val extends Notice>
    implements $NoticeCopyWith<$Res> {
  _$NoticeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Notice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? isImportant = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isImportant: null == isImportant
          ? _value.isImportant
          : isImportant // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoticeImplCopyWith<$Res> implements $NoticeCopyWith<$Res> {
  factory _$$NoticeImplCopyWith(
          _$NoticeImpl value, $Res Function(_$NoticeImpl) then) =
      __$$NoticeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String content,
      DateTime createdAt,
      bool isImportant});
}

/// @nodoc
class __$$NoticeImplCopyWithImpl<$Res>
    extends _$NoticeCopyWithImpl<$Res, _$NoticeImpl>
    implements _$$NoticeImplCopyWith<$Res> {
  __$$NoticeImplCopyWithImpl(
      _$NoticeImpl _value, $Res Function(_$NoticeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Notice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? isImportant = null,
  }) {
    return _then(_$NoticeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isImportant: null == isImportant
          ? _value.isImportant
          : isImportant // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NoticeImpl implements _Notice {
  const _$NoticeImpl(
      {required this.id,
      required this.title,
      required this.content,
      required this.createdAt,
      this.isImportant = false});

  factory _$NoticeImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoticeImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isImportant;

  @override
  String toString() {
    return 'Notice(id: $id, title: $title, content: $content, createdAt: $createdAt, isImportant: $isImportant)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoticeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isImportant, isImportant) ||
                other.isImportant == isImportant));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, content, createdAt, isImportant);

  /// Create a copy of Notice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoticeImplCopyWith<_$NoticeImpl> get copyWith =>
      __$$NoticeImplCopyWithImpl<_$NoticeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoticeImplToJson(
      this,
    );
  }
}

abstract class _Notice implements Notice {
  const factory _Notice(
      {required final int id,
      required final String title,
      required final String content,
      required final DateTime createdAt,
      final bool isImportant}) = _$NoticeImpl;

  factory _Notice.fromJson(Map<String, dynamic> json) = _$NoticeImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get content;
  @override
  DateTime get createdAt;
  @override
  bool get isImportant;

  /// Create a copy of Notice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoticeImplCopyWith<_$NoticeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
