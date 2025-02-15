import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';

class ConsumeDetailScreen extends StatelessWidget {
  const ConsumeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return PopScope(
      canPop: true,
      // onPopInvokedWithResult: (didPop) async {
      //   context.go('/consume');
      //   return true;
      // },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: '전체 소비내역',
        ),
        body: ListView.builder(
          itemCount: 10, // 임시 데이터 개수
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('소비내역 ${index + 1}'),
              subtitle: Text('2024.01.${index + 1}'),
              trailing: Text(
                '₩${(index + 1) * 10000}',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
