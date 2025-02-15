// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountNotifierHash() => r'1ff7f1b8bbff436d7d4c29fe7c2ccb2fc66f55a5';

/// See also [AccountNotifier].
@ProviderFor(AccountNotifier)
final accountNotifierProvider =
    AutoDisposeNotifierProvider<AccountNotifier, List<Account>>.internal(
  AccountNotifier.new,
  name: r'accountNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountNotifier = AutoDisposeNotifier<List<Account>>;
String _$transactionNotifierHash() =>
    r'be7e295b1695f303323c9fd00f68a6b4821d5a56';

/// See also [TransactionNotifier].
@ProviderFor(TransactionNotifier)
final transactionNotifierProvider = AutoDisposeNotifierProvider<
    TransactionNotifier, List<Transaction>>.internal(
  TransactionNotifier.new,
  name: r'transactionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionNotifier = AutoDisposeNotifier<List<Transaction>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
