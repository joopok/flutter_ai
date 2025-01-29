import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_navigation_bar.dart';

// 클래스 외부로 이동
final Map<String, IconData> _menuIcons = {
  '입출금/예금/적금': Icons.account_balance,
  '청약': Icons.home,
  '대출': Icons.monetization_on,
  '펀드': Icons.trending_up,
  '퇴직연금': Icons.savings,
  '신탁': Icons.account_balance_wallet,
  'ISA': Icons.folder_shared,
  '외환': Icons.currency_exchange,
  '개인사업자': Icons.business,
  '보험': Icons.umbrella,
  '골드/실버': Icons.diamond,
  '카드': Icons.credit_card,
  '증권계좌': Icons.bar_chart,
  '우금융상품': Icons.account_balance,
};

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: '상품몰'),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildLargeMenuItem(
                        title: '입출금/예금/적금',
                        subtitle: '자산형성은 꾸준히 안전하게',
                        isBlue: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: _buildLargeMenuItem(
                        title: '청약',
                        subtitle: '내집 마련의 시작',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 0.85,
                  children: [
                    _buildMenuItem(
                      title: '대출',
                      subtitle: '대출 금리와\n한도는?',
                    ),
                    _buildMenuItem(
                      title: '펀드',
                      subtitle: '더 높기 전에\n투자하자!',
                    ),
                    _buildMenuItem(
                      title: '퇴직연금',
                      subtitle: '개인형IRP로\n준비하자!',
                    ),
                    _buildMenuItem(
                      title: '신탁',
                      subtitle: 'ELT/ETF/채권형/\n상속·증여신탁상담',
                    ),
                    _buildMenuItem(
                      title: 'ISA',
                      subtitle: '개인종합\n자산관리',
                    ),
                    _buildMenuItem(
                      title: '외환',
                      subtitle: '최대 100%\n환율우대',
                    ),
                    _buildMenuItem(
                      title: '개인사업자',
                      subtitle: '사장님을\n위한 상품이?',
                    ),
                    _buildMenuItem(
                      title: '보험',
                      subtitle: '더 높기 전에\n준비하자!',
                    ),
                    _buildMenuItem(
                      title: '골드/실버',
                      subtitle: '재테크도\n실물로',
                    ),
                    _buildMenuItem(
                      title: '카드',
                      subtitle: '혜택으로 우대받고\n할인으로 알뜰하게',
                    ),
                    _buildMenuItem(
                      title: '증권계좌',
                      subtitle: '우리로 증권계좌\n연결까지',
                    ),
                    _buildMenuItem(
                      title: '상상은행상품',
                      subtitle: '상상은행그룹\n상품을 한 곳에서',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '우리 PICK!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '즐거운 여행을 준비하세요.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTravelCard(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildLargeMenuItem({
    required String title,
    required String subtitle,
    bool isBlue = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              _menuIcons[title] ?? Icons.help_outline,
              size: 32,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.2,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                _menuIcons[title] ?? Icons.help_outline,
                size: 24,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelCard() {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/travel.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withAlpha(77),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '환전주머니',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildTag('여행'),
                    const SizedBox(width: 8),
                    _buildTag('즐거움'),
                    const SizedBox(width: 8),
                    _buildTag('편리한'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(77),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
