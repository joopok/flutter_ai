import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notice.dart';
import '../services/notice_service.dart';
import '../api/dio_client.dart';

final noticeServiceProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return NoticeService(dioClient);
});

final noticesProvider = FutureProvider<List<Notice>>((ref) async {
  final noticeService = ref.watch(dioClientProvider);
  return await noticeService.getNotices();
}); 