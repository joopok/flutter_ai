import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/account.dart';

part 'account_provider.g.dart';

@riverpod
class AccountNotifier extends _$AccountNotifier {
  @override
  List<Account> build() {
    return [
      const Account(
        id: '1',
        title: '저축예금',
        accountNumber: '우리 122-201290-02-101',
        balance: 9742028,
        type: 'savings',
      ),
      const Account(
        id: '2',
        title: '입출금통장',
        accountNumber: '신한 110-123-456789',
        balance: 2580000,
        type: 'checking',
      ),
      const Account(
        id: '3',
        title: 'CMA 통장',
        accountNumber: 'KB 123-45-6789012',
        balance: 5320450,
        type: 'cma',
      ),
    ];
  }

  void toggleVisibility() {
    state = [
      for (final account in state)
        account.copyWith(isVisible: !account.isVisible)
    ];
  }

  Future<void> refreshAccounts() async {
    // TODO: API 호출로 실제 계좌 정보 갱신
    await Future.delayed(const Duration(seconds: 1));
  }
}

@riverpod
class TransactionNotifier extends _$TransactionNotifier {
  @override
  List<Transaction> build() {
    return [
      for (int i = 0; i < 10; i++)
        Transaction(
          id: i.toString(),
          title: '거래내역 ${i + 1}',
          date: DateTime.now().subtract(Duration(days: i)),
          amount: (i + 1) * 10000,
          isIncome: i % 2 == 0,
        ),
    ];
  }

  Future<void> refreshTransactions() async {
    // TODO: API 호출로 실제 거래내역 갱신
    await Future.delayed(const Duration(seconds: 1));
  }
} 