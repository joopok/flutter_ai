import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class Account with _$Account {
  const factory Account({
    required String id,
    required String title,
    required String accountNumber,
    required int balance,
    required String type,
    @Default(false) bool isVisible,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
}

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String title,
    required DateTime date,
    required int amount,
    required bool isIncome,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
} 