import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';

class CustomEndDrawer extends ConsumerWidget {
  const CustomEndDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
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
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '도승현님',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'test@example.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey,
                      ),
                    ),
                  ],
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
          ListTile(
            leading: Icon(Icons.dark_mode_outlined,
                color: isDarkMode ? Colors.white : Colors.black87),
            title: Text('테마설정',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                )),
            trailing: Container(
              width: 120,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              ),
              child: Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeInOut,
                    alignment: isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 60,
                      height: 22,
                      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: isDarkMode ? Colors.blue[900] : Colors.blue[100],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => ref.read(themeProvider.notifier).setThemeMode(ThemeMode.light),
                        child: Container(
                          height: 22,
                          width: 60,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '라이트',
                            style: TextStyle(
                              color: !isDarkMode ? Colors.blue[900] : Colors.grey[400],
                              fontWeight: !isDarkMode ? FontWeight.bold : FontWeight.normal,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark),
                        child: Container(
                          height: 22,
                          width: 60,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '다크',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.grey[600],
                              fontWeight: isDarkMode ? FontWeight.bold : FontWeight.normal,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info_outline,
                color: isDarkMode ? Colors.white : Colors.black87),
            title: Text('앱 정보',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                )),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              '로그아웃',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('로그아웃'),
                  content: const Text('정말 로그아웃 하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                        context.go('/login');
                      },
                      child: const Text(
                        '로그아웃',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


