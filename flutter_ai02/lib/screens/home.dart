import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/custom_bottom_navigation_bar.dart';
import '../components/custom_end_drawer.dart';
import '../components/loading_overlay.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';
import '../components/account_list_bottom_sheet.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  static const double _kAppBarElevation = 0.5;
  static const double _kAvatarRadius = 18.0;
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
        await Future.delayed(const Duration(milliseconds: 1000));
      }, LoadingType.initializing);
    } catch (e) {
      _showErrorSnackBar('데이터 로딩 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> _refreshData() async {
    try {
      await _showLoading(
        () => Future.delayed(const Duration(seconds: 2)),
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
    return AppBar(
      backgroundColor: _isScrolled
          ? (isDarkMode ? AppColors.darkSurface : Colors.white)
          : Colors.transparent,
      elevation: _isScrolled ? _kAppBarElevation : 0,
      title: _AppBarTitle(userData: userData, isDarkMode: isDarkMode),
      actions: _buildAppBarActions(isDarkMode),
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
class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({
    required this.userData,
    required this.isDarkMode,
  });

  final UserData? userData;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: _MyHomePageState._kAvatarRadius,
          backgroundImage: NetworkImage(
            userData?.profileImage ?? AppConstants.defaultProfileImage,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '안녕하세요,',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : AppColors.darkText,
              ),
            ),
            Text(
              '${userData?.name ?? '게스트'}님',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : AppColors.darkText,
              ),
            ),
          ],
        ),
      ],
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode ? AppColors.darkGradient : AppColors.lightGradient,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
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
              color: isDarkMode ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Icon(
              icon,
              color: isDarkMode ? AppColors.primary : AppColors.secondary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
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
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TransactionHeader(isDarkMode: isDarkMode),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
          Text(
            '추천 상품',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : AppColors.darkText,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: _MyHomePageState._kProductCardHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:const [
                _ProductCard(
                  title: '우리 급여통장',
                  description: '급여 고객을 위한\n특별한 혜택',
                  color: AppColors.primary,
                ),
                _ProductCard(
                  title: '우리 주거래통장',
                  description: '수수료 면제 혜택으로\n편리한 금융생활',
                  color: AppColors.secondary,
                ),
                _ProductCard(
                  title: '우리 청년통장',
                  description: '청년을 위한\n자산형성 프로그램',
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeList extends StatelessWidget {
  const _NoticeList({required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 16),
          _NoticeItem(
            title: '[안내] 우리은행 앱 업데이트 안내',
            date: '2024.03.20',
            isDarkMode: isDarkMode,
            onTap: () => context.push('/notice/1'),
          ),
          _NoticeItem(
            title: '[이벤트] 신규 가입 고객 이벤트',
            date: '2024.03.19',
            isDarkMode: isDarkMode,
            onTap: () => context.push('/notice/2'),
          ),
          _NoticeItem(
            title: '[안내] 시스템 점검 안내',
            date: '2024.03.18',
            isDarkMode: isDarkMode,
            onTap: () => context.push('/notice/3'),
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

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.title,
    required this.description,
    required this.color,
  });

  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _MyHomePageState._kProductCardWidth,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withAlpha(204),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withAlpha(204),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '자세히 보기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
