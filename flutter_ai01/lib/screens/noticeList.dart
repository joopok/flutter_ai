import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoticeListScreen extends StatelessWidget {
  const NoticeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('공지사항'),
      ),
      body: ListView.separated(
        itemCount: notices.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final notice = notices[index];
          return Container(
            color: Colors.white,
            child: ListTile(
              tileColor: Colors.white,
              contentPadding: const EdgeInsets.all(16),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        notice['date'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notice['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                context.push('/notice');
              },
            ),
          );
        },
      ),
    );
  }
} 