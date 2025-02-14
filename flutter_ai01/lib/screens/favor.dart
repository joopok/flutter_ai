import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/custom_bottom_navigation_bar.dart';

class FavorScreen extends StatefulWidget {
  const FavorScreen({super.key});

  @override
  State<FavorScreen> createState() => _FavorScreenState();
}

class _FavorScreenState extends State<FavorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
          title: const Text(
            '혜택',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '혜택·이벤트'),
              Tab(text: '생활편의'),
            ],
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildBenefitsTab(),
            _buildLifestyleTab(),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 4),
      ),
    );
  }

  Widget _buildBenefitsTab() {
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
                    const Text(
                      '내 꿀머니',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                    const Spacer(),
                    Text(
                      '43,099',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '꿀머니 지급 0원 더 받을 수 있어요',
                    style: TextStyle(color: Colors.grey),
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
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'MY쿠폰',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Icon(Icons.confirmation_number_outlined, color: Colors.grey[400]),
                const Icon(Icons.arrow_forward_ios, size: 16),
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
                    const Text(
                      '도승현님만을 위한 이벤트',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(
                              '더보기',
                              style: TextStyle(
                                color: Colors.grey[600],
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
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF2196F3),
                         Color.fromARGB(255, 26, 117, 192),
                        Color(0xFF64B5F6),
                      ],
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
                              '2025.01.02 ~ 2025.01.31',
                              style: TextStyle(
                                color: Colors.white.withAlpha(204),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.card_giftcard,
                        size: 80,
                        color: Colors.white,
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
                    const Text(
                      '매일매일 WON PLAY',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(
                              '더보기',
                              style: TextStyle(
                                color: Colors.grey[600],
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
                _buildWonPlayItem(
                  icon: Icons.play_circle_outline,
                  title: 'WON으로 출석하면~!',
                  subtitle: 'WOW! 꿀머니가~?!',
                ),
                _buildWonPlayItem(
                  icon: Icons.card_giftcard,
                  title: '즉석 당첨 응모',
                  subtitle: '매일 참여하는 달콤~한 간식 뽑기!',
                ),
                _buildWonPlayItem(
                  icon: Icons.favorite_border,
                  title: '2025년',
                  subtitle: '새해 다짐을 작성해주세요!',
                ),
                _buildWonPlayItem(
                  icon: Icons.emoji_emotions_outlined,
                  title: '색깔에 맞게 위비 GO!',
                  subtitle: '미션점수 달성 GO!',
                ),
                _buildWonPlayItem(
                  icon: Icons.grid_view,
                  title: '클자에 맞는 색?! 컬러픽',
                  subtitle: '컬러 고르고 미션 달성!',
                ),
                _buildWonPlayItem(
                  icon: Icons.restaurant_menu,
                  title: '봄봄이를 구해줘~! 레시피프',
                  subtitle: '레디~ 점프! 해서 미션 달성!',
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
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
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

  Widget _buildLifestyleTab() {
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
                const Text(
                  '추천혜택',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
                    ),
                    _buildRecommendedItem(
                      icon: Icons.business_center,
                      label: '우리직장인\n설렘',
                      onTap: () => context.go('/workplace'),
                    ),
                    _buildRecommendedItem(
                      icon: Icons.emoji_events,
                      label: 'e스포츠관',
                      onTap: () => context.go('/esports'),
                    ),
                    _buildRecommendedItem(
                      icon: Icons.backpack,
                      label: '우리턴',
                      onTap: () => context.go('/teen'),
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
                const Text(
                  '또 다른 다양한 혜택',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildOtherBenefitItem(
                  icon: Icons.auto_awesome,
                  title: '운세 보기',
                  subtitle: '재미있고 다양한 14가지',
                ),
                _buildOtherBenefitItem(
                  icon: Icons.local_cafe,
                  title: '쿠폰함',
                  subtitle: '모바일 쿠폰 구매하기',
                ),
                _buildOtherBenefitItem(
                  icon: Icons.child_care,
                  title: '우리아이',
                  subtitle: '우리아이 금융생활 시작',
                ),
                _buildOtherBenefitItem(
                  icon: Icons.looks_two,
                  title: '스무살 우리',
                  subtitle: '20대를 위한 서비스',
                ),
                _buildOtherBenefitItem(
                  icon: Icons.school,
                  title: '시니어W클래스',
                  subtitle: '시니어고객님을 위한 무료 강의',
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
            style: const TextStyle(
              fontSize: 12,
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
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
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
} 