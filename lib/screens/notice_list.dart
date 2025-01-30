import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class NoticeListPage extends StatelessWidget {
  const NoticeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('공지사항'),
        backgroundColor: isDarkMode ? AppColors.darkSurface : Colors.white,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return _NoticeItem(
            title: index < 3 
              ? ['[안내] 우리은행 앱 업데이트 안내',
                 '[이벤트] 신규 가입 고객 이벤트',
                 '[안내] 시스템 점검 안내'][index]
              : '[공지] 공지사항 ${index + 1}',
            date: '2024.03.${20 - index}',
            isDarkMode: isDarkMode,
            onTap: () => context.push('/notice/${index + 1}'),
          );
        },
      ),
    );
  }
}

class _NoticeItem extends StatelessWidget {
  const _NoticeItem({
    required this.title,
    required this.date,
    required this.isDarkMode,
    required this.onTap,
  });

  final String title;
  final String date;
  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : AppColors.darkText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode
                    ? AppColors.darkSecondaryText
                    : AppColors.lightSecondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 