import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/debug_provider.dart';
import 'package:path/path.dart' as path;

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final String filePath;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  
  const CustomAppBar({
    super.key,
    required this.title,
    required this.filePath,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debugSettings = ref.watch(debugSettingsProvider);
    final fileName = path.basename(filePath);
    
    return AppBar(
      title: Row(
        children: [
          Flexible(
            flex: 3,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (debugSettings.showFileName) ...[
            const SizedBox(width: 8),
            Flexible(
              flex: 2,
              child: Text(
                '($fileName)',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 178),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 