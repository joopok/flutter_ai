import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConsumeDetailScreen extends StatelessWidget {
  const ConsumeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          context.go('/consume');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/consume'),
          ),
          title: const Text(
            '전체 소비내역',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: 10, // 임시 데이터 개수
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('소비내역 ${index + 1}'),
              subtitle: Text('2024.01.${index + 1}'),
              trailing: Text('₩${(index + 1) * 10000}'),
            );
          },
        ),
      ),
    );
  }
} 