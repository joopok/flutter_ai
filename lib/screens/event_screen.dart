import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/custom_end_drawer.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final List<Map<String, dynamic>> _allEvents = List.generate(
    100,
    (index) => {
      'id': 'event_${index + 1}',
      'title': '이벤트 ${index + 1}',
      'description': '이벤트 ${index + 1}에 대한 상세 설명입니다. 많은 참여 부탁드립니다!',
      'date': DateTime.now().subtract(Duration(days: index)),
      'isActive': index < 50, // 첫 50개는 진행중, 나머지는 종료된 이벤트
    },
  );

  final List<Map<String, dynamic>> _displayedEvents = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _loadMoreEvents();
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
      _loadMoreEvents();
    }
  }

  Future<void> _loadMoreEvents() async {
    if (_isLoading) return;
    if (_displayedEvents.length >= _allEvents.length) return;

    setState(() {
      _isLoading = true;
    });

    // 실제 API 호출을 시뮬레이션하기 위한 지연
    await Future.delayed(const Duration(seconds: 1)); // 로딩 시간을 좀 더 길게 설정

    setState(() {
      final nextItems = _allEvents.skip(_displayedEvents.length).take(_pageSize);
      _displayedEvents.addAll(nextItems);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _displayedEvents.length + 1,
              itemBuilder: (context, index) {
                if (index == _displayedEvents.length) {
                  if (_isLoading) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            '다음 페이지 로딩 중...',
                            style: TextStyle(
                              color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (_displayedEvents.length < _allEvents.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '아래로 스크롤하여 더 보기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '모든 이벤트를 불러왔습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                      ),
                    ),
                  );
                }

                final event = _displayedEvents[index];
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
                            color: event['isActive'] ? Colors.green : Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            event['isActive'] ? '진행중' : '종료',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event['title'],
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
                          event['description'],
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '시작일: ${_formatDate(event['date'])}',
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
                          content: Text('${event['title']} 상세 정보'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
} 