import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/account_list_bottom_sheet.dart';
import '../components/custom_bottom_navigation_bar.dart';
import '../components/custom_end_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/loading_overlay.dart';



class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  bool _isAmountVisible = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeScreen());
  }

  Future<void> _initializeScreen() async {
    if (!mounted) return;
    
    try {
      ref.read(loadingProvider.notifier).show(LoadingType.initializing);
      // 여기에 초기 데이터 로딩 로직 추가
      await Future.delayed(const Duration(milliseconds: 1000));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('데이터 로딩 중 오류가 발생했습니다: $e'),
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

  void _toggleAmountVisibility() {
    setState(() {
      _isAmountVisible = !_isAmountVisible;
    });
  }

  Future<void> _refreshData() async {
    try {
      await ref.read(loadingProvider.notifier).during(
        () => Future.delayed(const Duration(seconds: 2)),
        type: LoadingType.refreshing,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('새로고침 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showAccountList(BuildContext context) async {
    if (!mounted) return;
    
    try {
      await ref.read(loadingProvider.notifier).during(
        () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => AccountListBottomSheet(
              isAmountVisible: _isAmountVisible,
              onToggleAmountVisibility: _toggleAmountVisibility,
              onRefresh: _refreshData,
            ),
          );
        },
        type: LoadingType.accountLoading,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('계좌 정보 로딩 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isLoading = ref.watch(loadingProvider).isLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              '도승현님!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Image.network(
              'https://cdn-icons-png.flaticon.com/512/2171/2171947.png',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "홍길동",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "example@gmail.com",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  debugPrint("프로필 편집 클릭됨");
                                },
                                child: const Text("편집"),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("닫기"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined),
                onPressed: () {
                  context.go('/notice-list');
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: const CustomEndDrawer(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '고객님을 위한 나만의',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        letterSpacing: -1.0,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '전담직원이 기다리고 있어요',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            letterSpacing: -1.0,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        Icon(Icons.arrow_forward,
                          color: isDarkMode ? Colors.white : Colors.black87),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '더보기 1',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : const Color(0xFFF8E8FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '저축예금',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDarkMode ? Colors.grey[300] : Colors.black54,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_horiz,
                              color: isDarkMode ? Colors.white : Colors.black87),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    color: isDarkMode ? Colors.grey[900] : Colors.white,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.edit,
                                              color: Colors.blue),
                                          title: Text('수정하기',
                                            style: TextStyle(
                                              color: isDarkMode ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.delete,
                                              color: Colors.red),
                                          title: Text('삭제하기',
                                            style: TextStyle(
                                              color: isDarkMode ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.close,
                                            color: isDarkMode ? Colors.grey[400] : Colors.grey),
                                          title: Text('닫기',
                                            style: TextStyle(
                                              color: isDarkMode ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '9,742,028원',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '우리 122-201290-02-101',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.grey[300] : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => _showAccountList(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDarkMode ? Colors.white : Colors.grey),
                          ),
                        )
                      : Text(
                          '전체계좌보기',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 18,
                            letterSpacing: -1.0,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[900] : const Color(0xFFE8F3FF),
                        borderRadius: BorderRadius.circular(12),
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
                                    '우리 틴틴이라면 당첨 확인!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    '스타벅스 커피부터\n댕펫킹 인형까지!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDarkMode ? Colors.grey[300] : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.network(
                              'https://cdn-icons-png.flaticon.com/512/2171/2171947.png',
                              width: 48,
                              height: 48,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  7,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.blue
                          : Colors.grey.withAlpha(77),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '우리금융그룹 바로가기',
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MenuButton(
                      icon: Icons.monetization_on,
                      label: '꿀머니',
                      color: Colors.amber,
                      onPressed: () {},
                    ),
                    _MenuButton(
                      icon: Icons.credit_card,
                      label: '카드',
                      color: Colors.blue,
                      onPressed: () {},
                    ),
                    _MenuButton(
                      icon: Icons.account_balance,
                      label: '캐피탈',
                      color: Colors.indigo,
                      onPressed: () {},
                    ),
                    _MenuButton(
                      icon: Icons.trending_up,
                      label: '증권',
                      color: Colors.red,
                      onPressed: () {},
                    ),
                    _MenuButton(
                      icon: Icons.savings,
                      label: '저축은행',
                      color: Colors.green,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.blue : Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '공지',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  title: Text(
                    '우리WON뱅킹이 새로운 모습으로 바뀌어요',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  onTap: () {
                    context.go('/notice-list');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
