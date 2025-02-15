import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../providers/auto_logout_provider.dart';

class AutoLogoutWarning extends HookConsumerWidget {
  const AutoLogoutWarning({super.key, required this.child});
  
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoLogout = ref.watch(autoLogoutProvider.notifier);
    
    useEffect(() {
      autoLogout.setContext(context);
      return null;
    }, []);

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => autoLogout.onUserActivity(),
      onPointerMove: (_) => autoLogout.onUserActivity(),
      child: Stack(
        children: [
          child,
          if (ref.watch(autoLogoutProvider).isWarningVisible)
            const _WarningDialog(),
        ],
      ),
    );
  }
}

class _WarningDialog extends ConsumerWidget {
  const _WarningDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(autoLogoutProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      backgroundColor: isDarkMode 
        ? const Color(0xFF2C2C2E) 
        : Colors.white,
      elevation: 8,
      title: Text(
        '자동 로그아웃',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '장시간 활동이 없어 자동 로그아웃됩니다.',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${state.remainingSeconds}초 후 자동 로그아웃',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.red[300] : Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => ref.read(autoLogoutProvider.notifier).extendSession(),
                  style: TextButton.styleFrom(
                    backgroundColor: isDarkMode 
                      ? Colors.blue[700] 
                      : Colors.blue[600],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '로그인 연장',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 