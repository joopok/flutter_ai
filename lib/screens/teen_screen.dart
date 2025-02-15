import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeenScreen extends StatelessWidget {
  const TeenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/favor'),
        ),
        title: const Text(
          '우리틴틴',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue[400]!,
                    Colors.blue[900]!,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '청소년을 위한\n특별한 금융 서비스',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '상상은행과 함께 성장하는 청소년 금융생활',
                    style: TextStyle(
                      color: Colors.white.withAlpha(204),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildServiceSection('틴틴 계좌'),
                  _buildServiceSection('틴틴 카드'),
                  _buildServiceSection('틴틴 적금'),
                  _buildServiceSection('틴틴 금융교육'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSection(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    _getIconForService(title),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getDescriptionForService(title),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForService(String service) {
    switch (service) {
      case '틴틴 계좌':
        return Icons.account_balance_wallet;
      case '틴틴 카드':
        return Icons.credit_card;
      case '틴틴 적금':
        return Icons.savings;
      case '틴틴 금융교육':
        return Icons.school;
      default:
        return Icons.star;
    }
  }

  String _getDescriptionForService(String service) {
    switch (service) {
      case '틴틴 계좌':
        return '청소년을 위한 맞춤형 계좌 서비스';
      case '틴틴 카드':
        return '안전하고 편리한 청소년 전용 카드';
      case '틴틴 적금':
        return '미래를 준비하는 청소년 맞춤 적금';
      case '틴틴 금융교육':
        return '똑똑한 금융생활을 위한 교육 프로그램';
      default:
        return '';
    }
  }
} 