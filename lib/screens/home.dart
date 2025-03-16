import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import '../components/custom_bottom_navigation_bar.dart';
import '../components/custom_end_drawer.dart';
import '../components/custom_app_bar.dart';
import '../components/loading_overlay.dart';
import '../providers/auth_provider.dart';
import '../providers/notice_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import '../components/account_list_bottom_sheet.dart';
import '../models/notice.dart';
import '../theme/app_theme.dart';
import '../api/api_service.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  static const double _kQuickActionSize = 56.0;
  static const double _kTransactionIconSize = 40.0;
  static const double _kProductCardWidth = 280.0;
  static const double _kProductCardHeight = 160.0;

  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_initializeScreen);
    _scrollController.addListener(_onScroll);
  }

  Future<void> _initializeScreen() async {
    if (!mounted) return;
    await _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      await _showLoading(() async {
        await ref.read(noticesProvider.future);
        await Future.delayed(const Duration(milliseconds: 1000));
      }, LoadingType.initializing);
    } catch (e) {
      _showErrorSnackBar('데이터 로딩 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> _refreshData() async {
    try {
      await _showLoading(
        () async {
          await ref.refresh(noticesProvider.future);
          await Future.delayed(const Duration(seconds: 1));
        },
        LoadingType.refreshing,
      );
    } catch (e) {
      _showErrorSnackBar('새로고침 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> _showLoading(
      Future<void> Function() callback, LoadingType type) async {
    if (!mounted) return;
    await ref.read(loadingProvider.notifier).during(callback, type: type);
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 0 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authStateProvider);
    final userData = authState.userData;

    return Scaffold(
      backgroundColor: _getBackgroundColor(isDarkMode),
      appBar: _buildAppBar(isDarkMode, userData),
      endDrawer: const CustomEndDrawer(),
      body: _buildBody(isDarkMode, authState),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }

  Color _getBackgroundColor(bool isDarkMode) {
    return isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode, UserData? userData) {
    return CustomAppBar(
      title: '홈',
      filePath: 'lib/screens/home.dart',
      backgroundColor: _isScrolled
          ? (isDarkMode ? AppColors.darkSurface : Colors.white)
          : Colors.transparent,
      actions: _buildAppBarActions(isDarkMode),
      automaticallyImplyLeading: false,
    );
  }

  List<Widget> _buildAppBarActions(bool isDarkMode) {
    return [
      _AppBarActionButton(
        icon: Icons.search,
        isDarkMode: isDarkMode,
        onPressed: () {},
      ),
      _NotificationButton(isDarkMode: isDarkMode),
      _MenuButton(isDarkMode: isDarkMode),
    ];
  }

  Widget _buildBody(bool isDarkMode, AuthState authState) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BalanceCard(
              isDarkMode: isDarkMode,
              authState: authState,
            ),
            _QuickActions(isDarkMode: isDarkMode),
            _TransactionHistory(isDarkMode: isDarkMode),
            _ProductRecommendations(isDarkMode: isDarkMode),
            _NoticeList(isDarkMode: isDarkMode),
          ],
        ),
      ),
    );
  }
}

class _AppBarActionButton extends StatelessWidget {
  const _AppBarActionButton({
    required this.icon,
    required this.isDarkMode,
    required this.onPressed,
  });

  final IconData icon;
  final bool isDarkMode;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: isDarkMode ? Colors.white : AppColors.darkText,
      ),
      onPressed: onPressed,
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        children: [
          Icon(
            Icons.notifications_none,
            color: isDarkMode ? Colors.white : AppColors.darkText,
          ),
          const Positioned(
            right: 0,
            top: 0,
            child: _NotificationBadge(),
          ),
        ],
      ),
      onPressed: () => context.push('/notice-list'),
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  const _NotificationBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      constraints: const BoxConstraints(
        minWidth: 12,
        minHeight: 12,
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.menu,
        color: isDarkMode ? Colors.white : AppColors.darkText,
      ),
      onPressed: () => Scaffold.of(context).openEndDrawer(),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.isDarkMode,
    required this.authState,
  });

  final bool isDarkMode;
  final AuthState authState;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode 
                  ? [
                      Color(0xFF2C3E50),
                      Color(0xFF3498DB),
                    ]
                  : [
                      Color(0xFF6DD5ED),
                      Color(0xFF2193B0),
                    ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode 
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BalanceHeader(authState: authState),
                  const SizedBox(height: 8),
                  _BalanceAmount(authState: authState),
                  const SizedBox(height: 16),
                  _AccountInfo(),
                ],
              ),
            ),
          ),
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceHeader extends StatelessWidget {
  const _BalanceHeader({required this.authState});

  final AuthState authState;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '총 자산',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Consumer(
          builder: (context, ref, _) => IconButton(
            icon: Icon(
              authState.isAmountVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => ref
                .read(authStateProvider.notifier)
                .toggleAmountVisibility(),
          ),
        ),
      ],
    );
  }
}

class _BalanceAmount extends StatelessWidget {
  const _BalanceAmount({required this.authState});

  final AuthState authState;

  @override
  Widget build(BuildContext context) {
    return Text(
      authState.isAmountVisible ? '₩12,345,678' : '********',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _AccountInfo extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return Row(
      children: [
        Text(
          '우리 입출금 | 1234-567-890123',
          style: TextStyle(
            color: Colors.white.withAlpha(204),
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51),
            borderRadius: BorderRadius.circular(20),
          ),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => AccountListBottomSheet(
                  isAmountVisible: authState.isAmountVisible,
                  onToggleAmountVisibility: () => ref.read(authStateProvider.notifier).toggleAmountVisibility(),
                  onRefresh: () async => Future.value(),
                ),
              );
            },
            child: const Text(
              '전체보기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _QuickActionButton(
            icon: Icons.account_balance_wallet,
            label: 'API테스트',
            isDarkMode: isDarkMode,
            onTap: () {
               context.push('/api-test');
            },
          ),
          _QuickActionButton(
            icon: Icons.qr_code_scanner,
            label: 'e스포츠관',
            isDarkMode: isDarkMode,
            onTap: () {
              context.push('/esports');
            },
          ),
          _QuickActionButton(
            icon: Icons.savings,
            label: '이벤트',
            isDarkMode: isDarkMode,
            onTap: () {
              context.go('/event');
            },
          ),
          _QuickActionButton(
            icon: Icons.currency_exchange,
            label: '베넷핏',
            isDarkMode: isDarkMode,
            onTap: () {
              context.go('/benefit');
            },
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.isDarkMode,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: _MyHomePageState._kQuickActionSize,
            height: _MyHomePageState._kQuickActionSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [Color(0xFF2C3E50), Color(0xFF3498DB)]
                    : [Color(0xFF6DD5ED), Color(0xFF2193B0)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionHistory extends StatelessWidget {
  const _TransactionHistory({required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface.withOpacity(0.7) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _TransactionHeader(isDarkMode: isDarkMode),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                final isExpense = index % 2 == 0;
                return _TransactionItem(
                  date: '2024.03.${20 - index}',
                  title: isExpense ? '스타벅스 강남점' : '급여',
                  amount: isExpense ? '- ₩5,800' : '+ ₩3,500,000',
                  isExpense: isExpense,
                  isDarkMode: isDarkMode,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionHeader extends StatelessWidget {
  const _TransactionHeader({required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '최근 거래내역',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : AppColors.darkText,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            '전체보기',
            style: TextStyle(
              color: isDarkMode ? AppColors.primary : AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({
    required this.date,
    required this.title,
    required this.amount,
    required this.isExpense,
    required this.isDarkMode,
  });

  final String date;
  final String title;
  final String amount;
  final bool isExpense;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          _TransactionIcon(
            isExpense: isExpense,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TransactionDetails(
              title: title,
              date: date,
              isDarkMode: isDarkMode,
            ),
          ),
          _TransactionAmount(
            amount: amount,
            isExpense: isExpense,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }
}

class _TransactionIcon extends StatelessWidget {
  const _TransactionIcon({
    required this.isExpense,
    required this.isDarkMode,
  });

  final bool isExpense;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _MyHomePageState._kTransactionIconSize,
      height: _MyHomePageState._kTransactionIconSize,
      decoration: BoxDecoration(
        color: isExpense
            ? (isDarkMode ? AppColors.darkSurface : AppColors.lightBackground)
            : (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isExpense ? Icons.arrow_upward : Icons.arrow_downward,
        color: isExpense
            ? (isDarkMode ? Colors.white : AppColors.darkText)
            : (isDarkMode ? AppColors.primary : AppColors.secondary),
      ),
    );
  }
}

class _TransactionDetails extends StatelessWidget {
  const _TransactionDetails({
    required this.title,
    required this.date,
    required this.isDarkMode,
  });

  final String title;
  final String date;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : AppColors.darkText,
          ),
        ),
        Text(
          date,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode
                ? AppColors.darkSecondaryText
                : AppColors.lightSecondaryText,
          ),
        ),
      ],
    );
  }
}

class _TransactionAmount extends StatelessWidget {
  const _TransactionAmount({
    required this.amount,
    required this.isExpense,
    required this.isDarkMode,
  });

  final String amount;
  final bool isExpense;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Text(
      amount,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isExpense
            ? AppColors.error
            : (isDarkMode ? AppColors.primary : AppColors.secondary),
      ),
    );
  }
}

class _ProductRecommendations extends StatelessWidget {
  const _ProductRecommendations({required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '추천 상품',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : AppColors.darkText,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: isDarkMode ? AppColors.primary : AppColors.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '전체보기',
                        style: TextStyle(
                          color: isDarkMode ? AppColors.primary : AppColors.secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: isDarkMode ? AppColors.primary : AppColors.secondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: _MyHomePageState._kProductCardHeight + 16,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                _buildProductCard(
                  '우리 급여통장',
                  '급여 고객을 위한\n특별한 혜택',
                  AppColors.primary,
                  Icons.account_balance_wallet,
                  context,
                  isDarkMode,
                ),
                _buildProductCard(
                  '우리 주거래통장',
                  '수수료 면제 혜택으로\n편리한 금융생활',
                  AppColors.secondary,
                  Icons.credit_card,
                  context,
                  isDarkMode,
                ),
                _buildProductCard(
                  '우리 청년통장',
                  '청년을 위한\n자산형성 프로그램',
                  AppColors.accent,
                  Icons.savings,
                  context,
                  isDarkMode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String title, String description, Color color, IconData icon, BuildContext context, bool isDarkMode) {
    return Container(
      width: _MyHomePageState._kProductCardWidth,
      height: _MyHomePageState._kProductCardHeight,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.7),
          ],
          stops: const [0.3, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            splashColor: Colors.white.withOpacity(0.1),
            highlightColor: Colors.white.withOpacity(0.05),
            child: Stack(
              children: [
                Positioned(
                  right: -30,
                  top: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  bottom: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 20,
                  child: Icon(
                    icon,
                    size: 32,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: Text(
                          description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            height: 1.3,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '자세히 보기',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white.withOpacity(0.95),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoticeList extends ConsumerWidget {
  const _NoticeList({required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesAsyncValue = ref.watch(noticesProvider);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '공지사항',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : AppColors.darkText,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/notice-list'),
                child: Text(
                  '전체보기',
                  style: TextStyle(
                    color: isDarkMode ? AppColors.primary : AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: noticesAsyncValue.when(
              data: (notices) {
                if (notices.isEmpty) {
                  return Center(
                    child: Text(
                      '공지사항이 없습니다.',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: notices.length,
                  itemBuilder: (context, index) {
                    final notice = notices[index];
                    return _NoticeItem(
                      title: notice.title,
                      date: notice.date,
                      isDarkMode: isDarkMode,
                      onTap: () => context.push('/notice/${notice.id}'),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
              error: (error, stack) {
                print('Notice error: $error\n$stack');
                return Center(
                  child: Text(
                    '공지사항을 불러오는데 실패했습니다.',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class _NoticeItem extends StatelessWidget {
  const _NoticeItem({
    required this.title,
    required this.date,
    required this.isDarkMode,
    required this.onTap,
  });

  final String title;
  final String date;
  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : AppColors.darkText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode
                    ? AppColors.darkSecondaryText
                    : AppColors.lightSecondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
