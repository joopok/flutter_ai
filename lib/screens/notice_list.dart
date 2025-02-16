import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';
import '../api/api_service.dart';
import '../models/api_response.dart';
import '../api/api_config.dart';
import '../models/notice.dart';
import 'dart:math';
import '../components/custom_end_drawer.dart';

final _random = Random();
final _imageIds = List.generate(10, (index) => _random.nextInt(1000));

// 페이지당 아이템 수
const _itemsPerPage = 10;

// 현재 페이지 상태 관리를 위한 provider
final currentPageProvider = StateProvider<int>((ref) => 0);

final noticeListProvider =
    FutureProvider.autoDispose<ApiResponse<List<Notice>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);

  return apiService.request(
    method: 'POST',
    path: ApiConfig.noticeList,
    fromJson: (json) {
      if (json == null) {
        return [];
      }

      if (json is Map) {
        final dataMap = json['data'] as Map<String, dynamic>;
        return [Notice.fromJson(dataMap)];
      }

      if (json is List) {
        return json.map((item) {
          if (item is! Map<String, dynamic>) {
            return Notice(
              id: 0,
              title: '',
              content: '',
              createdAt: DateTime.now(),
            );
          }

          final id = (item['id'] as num?)?.toInt() ?? 0;
          final title = item['title'] as String? ?? '';
          final content = item['content'] as String? ?? '';
          final createdAt = item['created_at'] != null
              ? DateTime.parse(item['created_at'] as String)
              : DateTime.now();

          return Notice(
            id: id,
            title: title,
            content: content,
            createdAt: createdAt,
          );
        }).toList();
      }

      return [];
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
    final currentPage = ref.watch(currentPageProvider);

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('공지사항'),
        backgroundColor: isDarkMode ? AppColors.darkSurface : Colors.white,
      ),
      endDrawer: const CustomEndDrawer(),
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

          // 전체 페이지 수 계산
          final totalPages = (notices.length / _itemsPerPage).ceil();
          
          // 현재 페이지의 아이템들
          final startIndex = currentPage * _itemsPerPage;
          final endIndex = (startIndex + _itemsPerPage < notices.length) 
              ? startIndex + _itemsPerPage 
              : notices.length;
          final currentPageItems = notices.sublist(startIndex, endIndex);

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref.refresh(noticeListProvider.future),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: currentPageItems.length,
                    itemBuilder: (context, index) {
                      final notice = currentPageItems[index];
                      final imageId = _imageIds[index % _imageIds.length];
                      return _NoticeItem(
                        title: notice.title,
                        content: notice.content,
                        date: dateFormat.format(notice.createdAt),
                        isDarkMode: isDarkMode,
                        onTap: () => context.push('/notice/${notice.id}'),
                        imageId: imageId,
                      );
                    },
                  ),
                ),
              ),
              // 페이지네이션 컨트롤
              if (totalPages > 1)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: currentPage > 0
                            ? () => ref.read(currentPageProvider.notifier).state--
                            : null,
                      ),
                      Text('${currentPage + 1} / $totalPages'),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: currentPage < totalPages - 1
                            ? () => ref.read(currentPageProvider.notifier).state++
                            : null,
                      ),
                    ],
                  ),
                ),
            ],
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
    required this.content,
    required this.date,
    required this.isDarkMode,
    required this.onTap,
    required this.imageId,
  });

  final String title;
  final String content;
  final String date;
  final bool isDarkMode;
  final VoidCallback onTap;
  final int imageId;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: isDarkMode ? AppColors.darkSurface : Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : AppColors.darkText,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: 'https://picsum.photos/id/$imageId/80/80',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
