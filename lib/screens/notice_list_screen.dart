import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/notice.dart';

class NoticeListScreen extends StatelessWidget {
  const NoticeListScreen({super.key});

  List<Notice> _getDemoNotices() {
    return List.generate(
      10,
      (index) => Notice(
        id: 'notice_${index + 1}',
        title: '공지사항 ${index + 1}',
        content: '이것은 공지사항 ${index + 1}의 내용입니다. 자세한 내용은 본문을 확인해주세요.',
        createdAt: DateTime.now().subtract(Duration(days: index)),
        isImportant: index < 2, // 처음 2개는 중요 공지로 표시
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final notices = _getDemoNotices();
    final dateFormat = DateFormat('yyyy.MM.dd');

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black87),
          onPressed: () => context.go('/'),
        ),
        title: Text('공지사항',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notices.length,
        separatorBuilder: (context, index) => Divider(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
        ),
        itemBuilder: (context, index) {
          final notice = notices[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                if (notice.isImportant)
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
              // 공지사항 상세 화면으로 이동
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${notice.title} 상세 내용을 보여줍니다.'),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 