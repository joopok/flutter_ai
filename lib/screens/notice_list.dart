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
import '../components/custom_bottom_navigation_bar.dart';
import '../components/custom_app_bar.dart';
final _random = Random();
final _imageIds = List.generate(100, (index) => _random.nextInt(1000));

// 페이지당 아이템 수
const _itemsPerPage = 10;

// 현재 로드된 아이템 수를 관리하는 provider
final loadedItemCountProvider = StateProvider<int>((ref) => _itemsPerPage);

// 로딩 상태를 관리하는 provider
final isLoadingMoreProvider = StateProvider<bool>((ref) => false);

// 모든 데이터가 로드되었는지 확인하는 provider
final allItemsLoadedProvider = StateProvider<bool>((ref) => false);

// 새로고침 상태를 관리하는 provider
final isRefreshingProvider = StateProvider<bool>((ref) => false);

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
              date: '날짜 없음',
              type: '일반',
              createdAt: DateTime.now(),
            );
          }

          final id = (item['id'] as num?)?.toInt() ?? 0;
          final title = item['title'] as String? ?? '';
          final content = item['content'] as String? ?? '';
          final date = item['date'] as String? ?? DateFormat('yyyy.MM.dd').format(DateTime.now());
          final type = item['type'] as String? ?? '일반';
          final createdAt = item['created_at'] != null
              ? DateTime.parse(item['created_at'] as String)
              : DateTime.now();

          return Notice(
            id: id,
            title: title,
            content: content,
            date: date,
            type: type,
            createdAt: createdAt,
          );
        }).toList();
      }

      return [];
    },
  );
});

class NoticeListPage extends ConsumerStatefulWidget {
  const NoticeListPage({super.key});

  @override
  ConsumerState<NoticeListPage> createState() => _NoticeListPageState();
}

class _NoticeListPageState extends ConsumerState<NoticeListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreItems();
    }
  }
  
  Future<void> _loadMoreItems() async {
    final isLoadingMore = ref.read(isLoadingMoreProvider);
    final allItemsLoaded = ref.read(allItemsLoadedProvider);
    if (isLoadingMore || allItemsLoaded) return;
    
    final noticeListAsync = ref.read(noticeListProvider);
    await noticeListAsync.whenData((response) async {
      final notices = response.data ?? [];
      final loadedCount = ref.read(loadedItemCountProvider);
      
      if (loadedCount < notices.length) {
        ref.read(isLoadingMoreProvider.notifier).state = true;
        
        // 로딩 효과를 위한 지연 (1초)
        await Future.delayed(const Duration(seconds: 1));
        
        if (!mounted) return;
        // 10개씩 추가 로드
        final newLoadedCount = loadedCount + _itemsPerPage > notices.length
            ? notices.length
            : loadedCount + _itemsPerPage;
        
        ref.read(loadedItemCountProvider.notifier).state = newLoadedCount;
        
        // 모든 아이템이 로드되었는지 확인
        if (newLoadedCount >= notices.length) {
          ref.read(allItemsLoadedProvider.notifier).state = true;
        }
        
        ref.read(isLoadingMoreProvider.notifier).state = false;
      } else {
        ref.read(allItemsLoadedProvider.notifier).state = true;
      }
    });
  }

  Future<void> _refreshData() async {
    try {
      ref.read(isRefreshingProvider.notifier).state = true;
      
      // 새로고침 효과를 위한 지연 (1초)
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;
      
      // 상태 초기화
      ref.read(loadedItemCountProvider.notifier).state = _itemsPerPage;
      ref.read(isLoadingMoreProvider.notifier).state = false;
      ref.read(allItemsLoadedProvider.notifier).state = false;
      
      // 데이터 새로고침
      await ref.refresh(noticeListProvider.future);
      
      ref.read(isRefreshingProvider.notifier).state = false;
    } catch (e) {
      ref.read(isRefreshingProvider.notifier).state = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('새로고침 중 오류가 발생했습니다: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final noticeListAsync = ref.watch(noticeListProvider);
    final dateFormat = DateFormat('yyyy.MM.dd');
    final loadedItemCount = ref.watch(loadedItemCountProvider);
    final isLoadingMore = ref.watch(isLoadingMoreProvider);
    final allItemsLoaded = ref.watch(allItemsLoadedProvider);
    final isRefreshing = ref.watch(isRefreshingProvider);

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CustomAppBar(
        title: '공지사항',
        filePath: 'lib/screens/notice_list.dart',
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

          // 현재 로드된 아이템들
          final visibleItems = notices.take(loadedItemCount).toList();

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: visibleItems.length + (isLoadingMore || (!allItemsLoaded && loadedItemCount < notices.length) ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == visibleItems.length) {
                  if (isLoadingMore) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 8),
                            Text(
                              '더 많은 공지사항 불러오는 중...',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white70 : Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (allItemsLoaded) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '모든 공지사항을 확인하셨습니다.',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink(); // 로딩도 아니고 완료도 아닌 경우 빈 위젯 반환
                }
                
                final notice = visibleItems[index];
                final imageId = index < _imageIds.length ? _imageIds[index] : _random.nextInt(1000);
                final formattedDate = notice.createdAt != null 
                    ? dateFormat.format(notice.createdAt!) 
                    : notice.date;
                
                return _NoticeItem(
                  title: notice.title,
                  content: notice.content,
                  date: formattedDate,
                  isDarkMode: isDarkMode,
                  onTap: () => context.push('/notice/${notice.id}'),
                  imageId: imageId,
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
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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
                        fontWeight: FontWeight.w600,
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
                borderRadius: BorderRadius.circular(12),
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

List<Notice> _getFallbackNotices() {
  return [
    Notice(
      id: 1,
      title: '[안내] 우리은행 앱 업데이트 안내',
      content: '더 나은 서비스 제공을 위한 업데이트 안내입니다.',
      date: '2024.03.20',
      type: '안내',
      createdAt: DateTime.now(),
    ),
    Notice(
      id: 2,
      title: '[이벤트] 신규 가입 고객 이벤트',
      content: '신규 가입 고객을 위한 특별 이벤트입니다.',
      date: '2024.03.19',
      type: '이벤트',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}
