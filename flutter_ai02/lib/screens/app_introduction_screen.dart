import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/custom_end_drawer.dart';

class AppIntroductionScreen extends StatelessWidget {
  const AppIntroductionScreen({super.key});

  Future<void> _downloadPPT() async {
    // PPT 파일의 다운로드 URL (예시)
    const url = 'https://example.com/app_introduction.pptx';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw '다운로드할 수 없습니다.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('앱 소개'),
      ),
      endDrawer: const CustomEndDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '생생은행 앱의 주요 특징',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildFeatureCard(
              '편리한 금융 서비스',
              '계좌 조회, 이체, 상품 가입 등 다양한 금융 서비스를 손쉽게 이용할 수 있습니다.',
              Icons.account_balance,
            ),
            _buildFeatureCard(
              '안전한 보안',
              '최신 보안 기술을 적용하여 안전한 금융 거래를 보장합니다.',
              Icons.security,
            ),
            _buildFeatureCard(
              '맞춤형 상품 추천',
              '고객의 니즈에 맞는 금융 상품을 추천해드립니다.',
              Icons.recommend,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: _downloadPPT,
                icon: const Icon(Icons.download),
                label: const Text('상세 소개자료 다운로드'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
} 