import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'loading_overlay.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: isDarkMode ? Colors.grey[400] : Colors.grey[600],
      currentIndex: currentIndex,
      onTap: (index) async {
        try {
          ref.read(loadingProvider.notifier).show(LoadingType.navigating);
          debugPrint('index: $index');
          switch (index) {
            case 0:
              await context.pushNamed('/product');
              break;
            case 1:
              await context.pushNamed('/asset');
              break;
            case 2:
              await context.pushNamed('/');
              break;
            case 3:
              await context.pushNamed('/consume');
              break;
            case 4:
              await context.pushNamed('/favor');
              break;
          }
        } finally {
          ref.read(loadingProvider.notifier).hide();
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          activeIcon: Icon(Icons.shopping_bag),
          label: '상품',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_outlined),
          activeIcon: Icon(Icons.account_balance),
          label: '자산',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment_outlined),
          activeIcon: Icon(Icons.payment),
          label: '소비',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard_outlined),
          activeIcon: Icon(Icons.card_giftcard),
          label: '혜택',
        ),
      ],
    );
  }
}
