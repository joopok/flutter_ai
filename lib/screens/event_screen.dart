import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/custom_end_drawer.dart';
import '../utils/format_utils.dart';
import '../api/api_service.dart';
import '../api/api_config.dart';
import '../models/api_response.dart';

final eventListProvider = FutureProvider.autoDispose<ApiResponse<List<Map<String, dynamic>>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);

  return apiService.request(
    method: 'POST',
    path: ApiConfig.eventList,
    fromJson: (json) {
      // 응답 데이터 로깅
      debugPrint('이벤트 응답 데이터: $json');
      
      if (json== null) {
         debugPrint('555555이벤트 응답 데이터: $json');
        return [];
      }

      // data가 Map인 경우
      if (json is Map) {
        //debugPrint('1111이벤트 응답 데이터: $json');
        final dataMap = json['data'] as Map<String, dynamic>;
        return [dataMap]; // Map을 List로 변환하여 반환
      }
      
      // data가 List인 경우
      if (json is List) {
        //debugPrint('2222이벤트 응답 데이터: $json');
        return json.map((item) {
          if (item is! Map) return <String, dynamic>{};
          return Map<String, dynamic>.from(item);
        }).toList();
      }

      // 예상치 못한 데이터 타입인 경우
      debugPrint('예상치 못한 데이터 타입: ${json['data'].runtimeType}');
      return [];
    },
  );
});

class EventScreen extends ConsumerWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final eventListAsync = ref.watch(eventListProvider);
    final scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/favor'),
        ),
        title: const Text(
          '이벤트',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      endDrawer: const CustomEndDrawer(),
      body: eventListAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: SelectableText.rich(
            TextSpan(
              text: '에러가 발생했습니다: ',
              children: [
                TextSpan(
                  text: error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
        data: (response) {
          if (!response.success || response.data == null) {
            return Center(
              child: Text(
                response.message ?? '데이터를 불러오는데 실패했습니다',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                ),
              ),
            );
          }

          final events = response.data!;
          if (events.isEmpty) {
            return Center(
              child: Text(
                '이벤트가 없습니다',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(eventListProvider.future),
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final isActive = event['isActive'] as bool? ?? false;
                final title = event['title'] as String? ?? '';
                final description = event['description'] as String? ?? '';
                final date = event['date'] as String? ?? '';

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green : Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isActive ? '진행중' : '종료',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
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
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '시작일: ${dotFormatDate(DateTime.tryParse(date) ?? DateTime.now())}',
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$title 상세 정보'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}