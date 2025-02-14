import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_service.dart';
import '../api/api_config.dart';
import '../models/api_response.dart';
import '../components/custom_end_drawer.dart';
import '../models/notice.dart';

final noticeListProvider = FutureProvider.autoDispose<ApiResponse<List<Notice>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.request(
    method: 'POST',
    path: ApiConfig.notices,
    fromJson: (json) => 
      (json['data'] as List).map((item) => Notice.fromJson(item)).toList(),
  );
});

class NoticeListScreen extends ConsumerStatefulWidget {
  const NoticeListScreen({super.key});

  @override
  ConsumerState<NoticeListScreen> createState() => _NoticeListScreenState();
}

class _NoticeListScreenState extends ConsumerState<NoticeListScreen> {
  final List<Notice> _displayedNotices = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _loadMoreNotices();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent && !_isLoading) {
      _loadMoreNotices();
    }
  }

  Future<void> _loadMoreNotices() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ref.read(noticeListProvider.future);
      if (response.success && response.data != null) {
        final notices = response.data!;
        if (notices.isEmpty) {
          setState(() {
            _isLoading = false;
          });
          return;
        }

        setState(() {
          final currentLength = _displayedNotices.length;
          final remainingNotices = notices.skip(currentLength).take(_pageSize);
          _displayedNotices.addAll(remainingNotices);
        });
      }
    } catch (e) {
      debugPrint('공지사항 로딩 중 오류 발생: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dateFormat = DateFormat('yyyy.MM.dd');

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black87),
          onPressed: () => context.go('/home'),
        ),
        title: Text('공지사항ddd',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ),
      endDrawer: const CustomEndDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _displayedNotices.clear();
          });
          await _loadMoreNotices();
        },
        child: Consumer(
          builder: (context, ref, child) {
            final noticesAsyncValue = ref.watch(noticeListProvider);
            
            return noticesAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('오류가 발생했습니다: $err',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                ),
              ),
              data: (response) {
                if (!response.success) {
                  return Center(
                    child: Text(response.message ?? '데이터를 불러올 수 없습니다.',
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                    ),
                  );
                }

                if (_displayedNotices.isEmpty && !_isLoading) {
                  return const Center(
                    child: Text('공지사항이 없습니다.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _displayedNotices.length + 1,
                  separatorBuilder: (context, index) => Divider(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  ),
                  itemBuilder: (context, index) {
                    if (index == _displayedNotices.length) {
                      return _isLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : const SizedBox.shrink();
                    }

                    final notice = _displayedNotices[index];
                    final isImportant = notice.isImportant;
                    
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          if (isImportant)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '중요',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              notice.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            notice.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateFormat.format(notice.createdAt),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        context.push('/notice/${notice.id}');
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}