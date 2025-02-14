import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../api/api_service.dart';
import '../models/api_response.dart';
import '../api/api_config.dart';

final noticeListProvider = FutureProvider.autoDispose<ApiResponse<List<Map<String, dynamic>>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.request(
    method: 'POST',
    path: ApiConfig.noticeList,
    fromJson: (json) => (json['data'] as List).cast<Map<String, dynamic>>(),
  );
});

class NoticeListPage extends ConsumerWidget {
  const NoticeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final noticeListAsync = ref.watch(noticeListProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('공지사항111'),
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
                  title: notice['title'] as String,
                  date: notice['created_at'] as String,
                  isDarkMode: isDarkMode,
                  onTap: () => context.push('/notice/${notice['id']}'),
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