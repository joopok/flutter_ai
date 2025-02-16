import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import 'custom_confirm_alert.dart';

class CustomEndDrawer extends ConsumerWidget {
  const CustomEndDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeState = ref.watch(themeNotifierProvider);
    final authState = ref.watch(authStateProvider);
    final userData = authState.userData;

    return Drawer(
      backgroundColor: isDarkMode ? AppColors.darkBackground : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [Colors.blue.shade900, Colors.indigo.shade900]
                      : [const Color(0xFFF8E8FF), const Color(0xFFE8F8FF)],
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      userData?.profileImage ?? 
                      'https://ui-avatars.com/api/?name=Guest&background=random',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userData?.name ?? 'Guest'}님 안녕하세요!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (userData?.email != null)
                          Text(
                            userData!.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.grey[300] : Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home_outlined,
                  color: isDarkMode ? Colors.white : Colors.black87),
              title: Text('홈',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  )),
              onTap: () {
                Navigator.pop(context);
                context.go('/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings_outlined,
                  color: isDarkMode ? Colors.white : Colors.black87),
              title: Text('설정',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  )),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.dark_mode_outlined,
                            color: isDarkMode ? Colors.white : AppColors.darkText,
                            size: 20,
                          ),
                          const SizedBox(width: 21),
                          Text(
                            '테마 설정',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : AppColors.darkText,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 32,
                        width: 120,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.darkSurface
                              : AppColors.lightBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDarkMode
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              left: themeState ? 58 : 0,
                              child: Container(
                                width: 58,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? AppColors.primary
                                      : AppColors.secondary,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      await ref
                                          .read(themeNotifierProvider.notifier)
                                          .toggleTheme();
                                    },
                                    child: Center(
                                      child: Text(
                                        '라이트',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: !themeState
                                              ? Colors.white
                                              : (isDarkMode
                                                  ? Colors.white70
                                                  : Colors.black54),
                                          fontWeight: !themeState
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      await ref
                                          .read(themeNotifierProvider.notifier)
                                          .toggleTheme();
                                    },
                                    child: Center(
                                      child: Text(
                                        '다크',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: themeState
                                              ? Colors.white
                                              : (isDarkMode
                                                  ? Colors.white70
                                                  : Colors.black54),
                                          fontWeight: themeState
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('공지사항'),
              onTap: () => context.push('/notice-list'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('앱 소개'),
              onTap: () => context.push('/app-introduction'),
            ),
            ListTile(
              leading: Icon(Icons.logout,
                  color: isDarkMode ? Colors.white : Colors.black87),
              title: Text('로그아웃',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  )),
              onTap: () async {
                final confirmed = await showCustomConfirmAlert(
                  context: context,
                  title: '로그아웃',
                  message: '정말 로그아웃 하시겠습니까?',
                );
                
                if (confirmed == true && context.mounted) {
                  ref.read(authStateProvider.notifier).logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
