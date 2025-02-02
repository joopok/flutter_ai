import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoticeListScreen extends StatelessWidget {
  const NoticeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final notices = [
      {
        'id': 1,
        'title': '우리WON뱅킹이 새로운 모습으로 바뀌어요',
        'date': '2024.03.19',
        'isNew': true,
      },
      {
        'id': 2,
        'title': '2024년 설 연휴 금융거래 안내',
        'date': '2024.02.05',
        'isNew': false,
      },
      {
        'id': 3,
        'title': '상상은행 앱 보안 업데이트 안내',
        'date': '2024.01.15',
        'isNew': false,
      },
      {
        'id': 4,
        'title': '개인정보처리방침 개정 안내',
        'date': '2024.01.02',
        'isNew': false,
      },
      {
        'id': 5,
        'title': '연말연시 금융거래 안내',
        'date': '2023.12.20',
        'isNew': false,
      },
    ];

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
        itemCount: notices.length,
        separatorBuilder: (context, index) => Divider(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
        ),
        itemBuilder: (context, index) {
          final notice = notices[index];
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    notice['title'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                if (notice['isNew'] as bool)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.blue[900] : Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'NEW',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white : Colors.blue[900],
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Text(
              notice['date'] as String,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            onTap: () => context.push('/notice/${notice['id']}'),
          );
        },
      ),
    );
  }
} 