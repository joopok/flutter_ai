import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../components/custom_end_drawer.dart';
class NoticeDetailPage extends StatelessWidget {
  const NoticeDetailPage({super.key, required this.noticeId});

  final String noticeId;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('공지사항'),
        backgroundColor: isDarkMode ? AppColors.darkSurface : Colors.white,
      ),
      endDrawer: const CustomEndDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '[안내] 우리은행 앱 업데이트 안내',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '2024.03.20',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '안녕하세요.\n우리은행 앱이 업데이트되었습니다.\n\n'
                    '주요 업데이트 내용:\n'
                    '1. 다크모드 지원\n'
                    '2. UI/UX 개선\n'
                    '3. 성능 최적화\n'
                    '4. 버그 수정\n\n'
                    '더 나은 서비스를 제공하기 위해 노력하겠습니다.\n'
                    '감사합니다.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: isDarkMode ? Colors.white : AppColors.darkText,
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
} 