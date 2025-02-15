import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../api/api_service.dart';
import '../models/api_response.dart';
import '../api/api_config.dart';
import '../models/notice.dart';

final noticeListProvider = FutureProvider.autoDispose<ApiResponse<List<Notice>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);

  debugPrint('!!!!dataList ::::::');
  return apiService.request(
    method: 'POST',
    path: ApiConfig.noticeList,
    fromJson: (json) {
      final dataList = json['data'] as List<dynamic>? ?? [];

      debugPrint('!!!!dataList :::::: $dataList');

      return dataList.map((item) {
        final Map<String, dynamic> typedItem = Map<String, dynamic>.from(item as Map);
         debugPrint('!!!!typedItem!!!!! :::::: $typedItem');
        // id가 String으로 오는 경우 int로 변환
        if (typedItem['noticeId'] is String) {
          typedItem['noticeId'] = int.tryParse(typedItem['noticeId'] as String) ?? 0;
        }
        // createdAt이 String으로 오는 경우 DateTime으로 변환
        if (typedItem['created_at'] is String) {
          typedItem['created_at'] = DateTime.parse(typedItem['created_at'] as String);
        }
        return Notice.fromJson(typedItem);
      }).toList();
    },
  );
});

class NoticeListPage extends ConsumerWidget {
  const NoticeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final noticeListAsync = ref.watch(noticeListProvider);
    final dateFormat = DateFormat('yyyy.MM.dd');

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('공지사항'),
        backgroundColor: isDarkMode ? AppColors.darkSurface : Colors.white,
      ),
      body: noticeListAsync.when(
        data: (response) {
          if (!response.success) {
            return Center(
              child: Text(
                response.message ?? '데이터를 불러오는데 실패했습니다.',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : AppColors.darkText,
                ),
              ),
            );
          }

          final notices = response.data ?? [];
          if (notices.isEmpty) {
            return Center(
              child: Text(
                '공지사항이 없습니다.',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : AppColors.darkText,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(noticeListProvider.future),
            child: ListView.builder(
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final notice = notices[index];
                return _NoticeItem(
                  title: notice.title,
                  date: dateFormat.format(notice.createdAt),
                  isDarkMode: isDarkMode,
                  onTap: () => context.push('/notice/${notice.id}'),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            '오류가 발생했습니다: $error',
            style: TextStyle(
              color: isDarkMode ? Colors.white : AppColors.darkText,
            ),
          ),
        ),
      ),
    );
  }
}

class _NoticeItem extends StatelessWidget {
  const _NoticeItem({
    required this.title,
    required this.date,
    required this.isDarkMode,
    required this.onTap,
  });

  final String title;
  final String date;
  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : AppColors.darkText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode
                    ? AppColors.darkSecondaryText
                    : AppColors.lightSecondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}