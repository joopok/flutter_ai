import 'package:flutter/material.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({
    super.key,
    required this.message,
    this.title = '알림',
    this.onConfirm,
    this.confirmText = '확인',
  });

  final String message;
  final String title;
  final VoidCallback? onConfirm;
  final String confirmText;

  static Future<void> show({
    required BuildContext context,
    required String message,
    String title = '알림',
    VoidCallback? onConfirm,
    String confirmText = '확인',
  }) {
    return showDialog(
      context: context,
      builder: (context) => CustomAlert(
        message: message,
        title: title,
        onConfirm: onConfirm,
        confirmText: confirmText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: SelectableText(
        message,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm?.call();
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}
