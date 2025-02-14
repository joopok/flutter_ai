// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      accountNumber: json['accountNumber'] as String,
      balance: (json['balance'] as num).toInt(),
      type: json['type'] as String,
      isVisible: json['isVisible'] as bool? ?? false,
    );

Map<String, dynamic> _$$AccountImplToJson(_$AccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'accountNumber': instance.accountNumber,
      'balance': instance.balance,
      'type': instance.type,
      'isVisible': instance.isVisible,
    };

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toInt(),
      isIncome: json['isIncome'] as bool,
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
      'isIncome': instance.isIncome,
    };
