import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('공지사항'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '우리WON뱅킹이 새로운 모습으로 바뀌어요',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(Icons.person_outline, '등록자', '상상은행'),
                  _buildInfoItem(Icons.calendar_today, '등록일', '2024.03.19'),
                  _buildInfoItem(Icons.remove_red_eye, '조회수', '1,234'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '안녕하세요, 상상은행입니다.\n\n'
              '우리WON뱅킹이 고객님들의 더 나은 금융생활을 위해 새로운 모습으로 변화됩니다.\n\n'
              '주요 변경사항\n'
              '1. 직관적이고 편리한 새로운 UI/UX\n'
              '2. 개인화된 금융 서비스 제공\n'
              '3. 보안 강화 및 성능 개선\n'
              '4. 새로운 금융 서비스 추가\n\n'
              '변경 일정\n'
              '- 테스트 기간: 2024.03.25 ~ 2024.04.07\n'
              '- 정식 오픈: 2024.04.08\n\n'
              '새로운 우리WON뱅킹과 함께 더욱 편리한 금융생활을 경험해보세요.\n'
              '감사합니다.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '문의사항',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '고객센터: 1588-5000\n'
                    '운영시간: 평일 09:00 ~ 18:00',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
} 