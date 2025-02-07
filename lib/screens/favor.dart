import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/custom_bottom_navigation_bar.dart';
import '../components/custom_end_drawer.dart';
import '../components/loading_overlay.dart';

class FavorScreen extends ConsumerStatefulWidget {
  const FavorScreen({super.key});

  @override
  ConsumerState<FavorScreen> createState() => _FavorScreenState();
}

class _FavorScreenState extends ConsumerState<FavorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => _initializeScreen());
  }

  Future<void> _initializeScreen() async {
    if (!mounted) return;
    
    try {
      ref.read(loadingProvider.notifier).show(LoadingType.benefitLoading);
      // 여기에 혜택 데이터 로딩 로직 추가
      await Future.delayed(const Duration(milliseconds: 1000));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('혜택 정보 로딩 중 오류가 발생했습니다: $e'),
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            icon: Icon(
              Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            onPressed: () => context.go('/'),
          ),
          title: Text(
            '혜택',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu,
                  color: isDarkMode ? Colors.white : Colors.black87),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDarkMode ? Colors.grey[800]! : Colors.black12,
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: '혜택·이벤트'),
                  Tab(text: '생활편의'),
                ],
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                indicatorColor: isDarkMode ? Colors.white : Colors.black87,
                labelColor: isDarkMode ? Colors.white : Colors.black87,
                unselectedLabelColor: Colors.grey,
                indicatorWeight: 2,
              ),
            ),
          ),
        ),
        endDrawer: const CustomEndDrawer(),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildBenefitsTab(isDarkMode),
            _buildLifestyleTab(isDarkMode),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 4),
      ),
    );
  }

  Widget _buildBenefitsTab(bool isDarkMode) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 내 꿀머니
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      '내 꿀머니',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    const Spacer(),
                    Text(
                      '43,099',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '꿀머니 지급 0원 더 받을 수 있어요',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // MY쿠폰
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'MY쿠폰',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.confirmation_number_outlined,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[400],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ],
            ),
          ),
          // 도승현님만을 위한 이벤트
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '도승현님만을 위한 이벤트',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              '더보기',
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: isDarkMode
                          ? [Colors.blue[900]!, Colors.indigo[900]!, Colors.blue[800]!]
                          : [const Color(0xFF2196F3), const Color.fromARGB(255, 26, 117, 192), const Color(0xFF64B5F6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '설날 맞이 선물 SET\n고객님만 받을 수 있어요!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '2024.01.28 ~ 2024.02.28',
                              style: TextStyle(
                                color: Colors.white.withAlpha(204),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.card_giftcard,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 매일매일 WON PLAY
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '매일매일 WON PLAY',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              '더보기',
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildWonPlayItem(
                        icon: Icons.monetization_on,
                        iconColor: Colors.amber,
                        title: 'WON으로 출석하면~!',
                        subtitle: 'WOW! 꿀머니가~?!',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      _buildWonPlayItem(
                        icon: Icons.card_giftcard,
                        iconColor: Colors.purple,
                        title: '즉석 당첨 응모',
                        subtitle: '매일 참여하는 달콤~한 간식 뽑기!',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      _buildWonPlayItem(
                        icon: Icons.favorite,
                        iconColor: Colors.red,
                        title: '2025년',
                        subtitle: '새해 다짐을 작성해주세요!',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      _buildWonPlayItem(
                        icon: Icons.star,
                        iconColor: Colors.blue,
                        title: '색깔에 맞게 위비 GO!',
                        subtitle: '미션점수 달성 GO!',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      _buildWonPlayItem(
                        icon: Icons.grid_view,
                        iconColor: Colors.orange,
                        title: '글자에 맞는 색?! 컬러픽',
                        subtitle: '컬러 고르고 미션 달성!',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      _buildWonPlayItem(
                        icon: Icons.cake,
                        iconColor: Colors.pink,
                        title: '봄봄이를 구해줘~! 레디저프트',
                        subtitle: '레디~ 점프! 해서 미션 달성!',
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLifestyleTab(bool isDarkMode) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 추천혜택
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '추천혜택',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRecommendedItem(
                      icon: Icons.event,
                      label: '이벤트',
                      onTap: () => context.go('/event'),
                      isDarkMode: isDarkMode,
                    ),
                    _buildRecommendedItem(
                      icon: Icons.business_center,
                      label: '우리직장인\n설렘',
                      onTap: () => context.go('/workplace'),
                      isDarkMode: isDarkMode,
                    ),
                    _buildRecommendedItem(
                      icon: Icons.emoji_events,
                      label: 'e스포츠관',
                      onTap: () => context.go('/esports'),
                      isDarkMode: isDarkMode,
                    ),
                    _buildRecommendedItem(
                      icon: Icons.backpack,
                      label: '우리턴',
                      onTap: () => context.go('/teen'),
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 또 다른 다양한 혜택
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '또 다른 다양한 혜택',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildOtherBenefitItem(
                  icon: Icons.auto_awesome,
                  title: '운세 보기',
                  subtitle: '재미있고 다양한 14가지',
                  isDarkMode: isDarkMode,
                ),
                _buildOtherBenefitItem(
                  icon: Icons.local_cafe,
                  title: '쿠폰함',
                  subtitle: '모바일 쿠폰 구매하기',
                  isDarkMode: isDarkMode,
                ),
                _buildOtherBenefitItem(
                  icon: Icons.child_care,
                  title: '우리아이',
                  subtitle: '우리아이 금융생활 시작',
                  isDarkMode: isDarkMode,
                ),
                _buildOtherBenefitItem(
                  icon: Icons.looks_two,
                  title: '스무살 우리',
                  subtitle: '20대를 위한 서비스',
                  isDarkMode: isDarkMode,
                ),
                _buildOtherBenefitItem(
                  icon: Icons.school,
                  title: '시니어W클래스',
                  subtitle: '시니어고객님을 위한 무료 강의',
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.blue,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherBenefitItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.blue,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWonPlayItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 