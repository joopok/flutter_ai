import 'dart:convert';
import 'package:intl/intl.dart';
// 원화 또는 외화 표시
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


// JSON을 보기 좋게 포맷팅하는 함수
String prettyJson(Map<String, dynamic> json) {
  const encoder = JsonEncoder.withIndent('  ');
  try {
    return encoder
        .convert(json)
        .replaceAll('{', '{')
        .replaceAll('}', '}')
        .replaceAll('": ', '": ');
  } catch (e) {
    return json.toString();
  }
}


String dotFormatDate(DateTime date) {
  return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
}
