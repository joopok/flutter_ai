import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/custom_bottom_navigation_bar.dart';
import '../components/custom_end_drawer.dart';
import '../components/loading_overlay.dart';

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

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeScreen());
  }

  Future<void> _initializeScreen() async {
    if (!mounted) return;

    try {
      ref.read(loadingProvider.notifier).show(LoadingType.productLoading);
      // 여기에 상품 데이터 로딩 로직 추가
      await Future.delayed(const Duration(milliseconds: 1000));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('상품 정보 로딩 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        ref.read(loadingProvider.notifier).hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: isDarkMode ? Colors.white : Colors.black87),
            onPressed: () => context.go('/'),
          ),
          title: Text(
            '상품',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ),
        endDrawer: const CustomEndDrawer(),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
            ),
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
                          context,
                          title: '입출금/예금/적금',
                          subtitle: '자산형성은 꾸준히 안전하게',
                          isBlue: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 4,
                        child: _buildLargeMenuItem(
                          context,
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
                        context,
                        title: '대출',
                        subtitle: '대출 금리와\n한도는?',
                      ),
                      _buildMenuItem(
                        context,
                        title: '펀드',
                        subtitle: '더 높기 전에\n투자하자!',
                      ),
                      _buildMenuItem(
                        context,
                        title: '퇴직연금',
                        subtitle: '개인형IRP로\n준비하자!',
                      ),
                      _buildMenuItem(
                        context,
                        title: '신탁',
                        subtitle: 'ELT/ETF/채권형/\n상속·증여신탁상담',
                      ),
                      _buildMenuItem(
                        context,
                        title: 'ISA',
                        subtitle: '개인종합\n자산관리',
                      ),
                      _buildMenuItem(
                        context,
                        title: '외환',
                        subtitle: '최대 100%\n환율우대',
                      ),
                      _buildMenuItem(
                        context,
                        title: '개인사업자',
                        subtitle: '사장님을\n위한 상품이?',
                      ),
                      _buildMenuItem(
                        context,
                        title: '보험',
                        subtitle: '더 높기 전에\n준비하자!',
                      ),
                      _buildMenuItem(
                        context,
                        title: '골드/실버',
                        subtitle: '재테크도\n실물로',
                      ),
                      _buildMenuItem(
                        context,
                        title: '카드',
                        subtitle: '혜택으로 우대받고\n할인으로 알뜰하게',
                      ),
                      _buildMenuItem(
                        context,
                        title: '증권계좌',
                        subtitle: '우리로 증권계좌\n연결까지',
                      ),
                      _buildMenuItem(
                        context,
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
                      SizedBox(
                        height: 240,
                        child: _buildTravelCard(context),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildLargeMenuItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    bool isBlue = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.grey.withAlpha(25),
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              _menuIcons[title] ?? Icons.help_outline,
              size: 32,
              color: isDarkMode ? Colors.blue[300] : Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.grey.withAlpha(25),
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
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                height: 1.2,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                _menuIcons[title] ?? Icons.help_outline,
                size: 24,
                color: isDarkMode ? Colors.blue[300] : Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelCard(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                  isDarkMode
                      ? Colors.black.withAlpha(150)
                      : Colors.black.withAlpha(77),
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
                Text(
                  '환전주머니',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildTag('여행', isDarkMode),
                    const SizedBox(width: 8),
                    _buildTag('즐거움', isDarkMode),
                    const SizedBox(width: 8),
                    _buildTag('편리한', isDarkMode),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.black.withAlpha(150)
            : Colors.black.withAlpha(77),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
