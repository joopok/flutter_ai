import 'package:intl/intl.dart';

String formatWon(dynamic amount) {
  if (amount == null) return '0원';
  
  final format = NumberFormat.currency(
    locale: 'ko_KR',
    symbol: '원',
  );
  
  // String이 들어올 경우 double로 변환
  final numericAmount = amount is String ? double.tryParse(amount) ?? 0 : amount;
  return format.format(numericAmount);
} 