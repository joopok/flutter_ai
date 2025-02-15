import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/custom_bottom_navigation_bar.dart';
import '../components/custom_end_drawer.dart';
import '../components/loading_overlay.dart';

class AssetScreen extends ConsumerStatefulWidget {
  const AssetScreen({super.key});

  @override
  ConsumerState<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends ConsumerState<AssetScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeScreen());
  }

  Future<void> _initializeScreen() async {
    if (!mounted) return;

    try {
      ref.read(loadingProvider.notifier).show(LoadingType.assetLoading);
      // 여기에 자산 데이터 로딩 로직 추가
      await Future.delayed(const Duration(milliseconds: 1000));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('자산 정보 로딩 중 오류가 발생했습니다: $e'),
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

    return Scaffold(
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
          '자산',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ),
      endDrawer: const CustomEndDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    _buildCategoryButton('전체', isSelected: true, isDarkMode: isDarkMode),
                    _buildCategoryButton('입출금/저축', isDarkMode: isDarkMode),
                    _buildCategoryButton('대출', isDarkMode: isDarkMode),
                    _buildCategoryButton('투자', isDarkMode: isDarkMode),
                    _buildCategoryButton('연금/보험', isDarkMode: isDarkMode),
                    _buildCategoryButton('부동산', isDarkMode: isDarkMode),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color:
                    isDarkMode ? Colors.grey[900] : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.grey[800]!
                      : Theme.of(context).dividerColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '흩어져 있는 내자산',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    '한 번에 등록하고 쉽게 관리해 보세요.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.blue[900] : Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '자산 연결하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.blue[900],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '은행, 증권사 등의 금융자산을\n한 번에 모아보세요.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: isDarkMode
                                ? Colors.grey[300]
                                : Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/chart.png',
                          width: 20,
                          height: 20,
                          color: isDarkMode ? Colors.white : Colors.black87,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.bar_chart,
                              size: 20,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '우리마이데이터',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '나는 상위 몇 %일까?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    '자산등록하고 비교 분석까지!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[900] : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '김우리님은',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                            const Text(
                              ' 부동산 올인러',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              ' 유형?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Stack(
                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: CustomPaint(
                                painter:
                                    BarChartPainter(isDarkMode: isDarkMode),
                                size: const Size(double.infinity, 200),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF2C2C2E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode
                      ? const Color(0xFF3A3A3C)
                      : const Color(0xFFE5E7EC),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '자산목표설정',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF1B1D1F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '자산 등록하고 목표를 세워보세요.\n자산관리는 부자되는 지름길!',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode
                                ? const Color(0xFF8E8E93)
                                : const Color(0xFF666666),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/icons/target.png',
                    width: 60,
                    height: 60,
                    color: isDarkMode ? Colors.white : null,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.track_changes,
                        size: 60,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF2C2C2E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode
                      ? const Color(0xFF3A3A3C)
                      : const Color(0xFFE5E7EC),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '월말리포트',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF1B1D1F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '매달 제공되는 자산분석리포트로\n내자산을 관리해 보세요',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode
                                ? const Color(0xFF8E8E93)
                                : const Color(0xFF666666),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/icons/calendar.png',
                    width: 60,
                    height: 60,
                    color: isDarkMode ? Colors.white : null,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.calendar_today,
                        size: 60,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: isDarkMode ? Colors.grey[700]! : Colors.grey,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        '+ 자산 연결',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: isDarkMode ? Colors.grey[700]! : Colors.grey,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/chart.png',
                            width: 20,
                            height: 20,
                            color: isDarkMode ? Colors.white : Colors.black87,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.bar_chart,
                                size: 20,
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '우리마이데이터',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildCategoryButton(String text,
      {bool isSelected = false, required bool isDarkMode}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: isSelected
              ? (isDarkMode ? Colors.blue[900] : Colors.blue)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected
                  ? (isDarkMode ? Colors.blue[800]! : Colors.blue)
                  : (isDarkMode ? Colors.grey[700]! : Colors.grey[400]!),
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Colors.white
                : (isDarkMode ? Colors.white : Colors.black87),
          ),
        ),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final bool isDarkMode;

  const BarChartPainter({this.isDarkMode = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode ? Colors.blue[700]! : Colors.blue[100]!
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final paint2 = Paint()
      ..color = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Draw three bars
    canvas.drawLine(
      Offset(20, size.height - 20),
      Offset(20, size.height - 40),
      paint,
    );
    canvas.drawLine(
      Offset(60, size.height - 20),
      Offset(60, size.height - 60),
      paint,
    );
    canvas.drawLine(
      Offset(100, size.height - 20),
      Offset(100, size.height - 80),
      paint2,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
