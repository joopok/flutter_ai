import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/custom_bottom_navigation_bar.dart';
import '../components/custom_end_drawer.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:math'; // dart:math 패키지 추가
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/loading_overlay.dart';

class ConsumeScreen extends ConsumerStatefulWidget {
  const ConsumeScreen({super.key});

  @override
  ConsumerState<ConsumeScreen> createState() => _ConsumeScreenState();
}

class _ConsumeScreenState extends ConsumerState<ConsumeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showReconnectDialog = true;
  DateTime _selectedDate = DateTime.now();
  bool _showExpenseDetails = false;  // 지출내역 표시 여부
  final NumberFormat _numberFormat = NumberFormat("#,###");
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  bool _showAllCategories = false; // 모든 카테고리 표시 여부

  // 소비 데이터를 저장할 Map (날짜별 소비금액)
  final Map<DateTime, int> _consumeData = {
    DateTime(2024, 1, 15): 30000, // 3만원
    DateTime(2024, 1, 19): 50000, // 5만원
    DateTime(2024, 1, 23): 696974, // 696,974원
    DateTime(2024, 1, 26): 300000, // 30만원
    DateTime(2024, 1, 28): 1540000, // 154만원
  };

  // 지출내역 데이터
  final Map<DateTime, List<Map<String, dynamic>>> _expenseDetails = {
    DateTime(2024, 1, 19): [
      {'time': '09:30', 'title': '스타벅스', 'amount': 5000},
      {'time': '12:30', 'title': '점심식사', 'amount': 15000},
      {'time': '19:00', 'title': '마트 장보기', 'amount': 30000},
    ],
    DateTime(2024, 1, 26): [
      {'time': '11:00', 'title': '주유소', 'amount': 50000},
      {'time': '14:00', 'title': '백화점', 'amount': 250000},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    initializeDateFormatting('ko_KR', null); // 한국어 로케일 초기화
    Future.microtask(() => _initializeScreen());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeScreen() async {
    if (!mounted) return;

    try {
      ref.read(loadingProvider.notifier).show(LoadingType.consumeLoading);
      // 여기에 소비 데이터 로딩 로직 추가
      await Future.delayed(const Duration(milliseconds: 1000));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('소비 정보 로딩 중 오류가 발생했습니다: $e'),
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
            '소비',
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
                  Tab(text: '현황'),
                  Tab(text: '분석'),
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
            _buildCurrentTab(isDarkMode),
            _buildAnalysisTab(isDarkMode),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 3),
      ),
    );
  }

  Widget _buildCurrentTab(bool isDarkMode) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 자산정보 연결 알림
            if (_showReconnectDialog)
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black26
                          : Colors.grey.withAlpha(26),
                      spreadRadius: 1,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.notifications_active,
                      size: 48,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '자산정보를 다시 연결해 주세요',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '자산조회기간이 만료되어\n최신정보를 확인할 수 없습니다.',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close,
                          color: isDarkMode ? Colors.white : Colors.black87),
                      onPressed: () {
                        setState(() {
                          _showReconnectDialog = false;
                        });
                      },
                    ),
                  ],
                ),
              ),

            // 1월 소비 금액
            Container(
              padding: EdgeInsets.only(
                top: _showReconnectDialog ? 0 : 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_back_ios,
                              size: 16,
                              color:
                                  isDarkMode ? Colors.white : Colors.black87),
                          Text(
                            '1월',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 16,
                              color:
                                  isDarkMode ? Colors.white : Colors.black87),
                        ],
                      ),
                      Text(
                        '2025.01.28 11:03',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '3,321,742원',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '지난 달에는 2,529,190원 사용했어요',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // 달력
            _buildCalendar(isDarkMode),
            _buildExpenseDetails(isDarkMode),  // 지출내역 위젯 추가

            // 전체 소비내역 보기 버튼
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                onPressed: () => context.go('/consume/detail'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                      color:
                          isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('전체 소비내역 보기',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    )),
              ),
            ),

            const SizedBox(height: 20),

            // 지출 수단별 이용내역
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '지출 수단별 이용내역',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPaymentMethodItem(
                    icon: Icons.credit_card,
                    title: '카드',
                    count: 0,
                    amount: '0원',
                    isDarkMode: isDarkMode,
                  ),
                  _buildPaymentMethodItem(
                    icon: Icons.account_balance,
                    title: '계좌',
                    count: 3,
                    amount: '3,321,742원',
                    isDarkMode: isDarkMode,
                  ),
                  _buildPaymentMethodItem(
                    icon: Icons.payment,
                    title: '페이',
                    count: 0,
                    amount: '0원',
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),

            // 통신요금 관리 배너
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.blue[900] : Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '휴대폰, 인터넷 등의 통신요금을 한꺼번에 관리해 보세요',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.blue[900],
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.phone_iphone,
                    color: isDarkMode ? Colors.white : Colors.blue[900],
                    size: 32,
                  ),
                ],
              ),
            ),

            // 고정지출 매달
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '고정지출 매달',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        '4건',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[900] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: isDarkMode
                              ? Colors.grey[800]!
                              : Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        _buildFixedExpenseItem(
                          title: '원금',
                          amount: '1,052,717원',
                          subtitle: '1203701484134 외',
                          count: 4,
                          isDarkMode: isDarkMode,
                        ),
                        Divider(
                          height: 32,
                          color:
                              isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        ),
                        _buildFixedExpenseItem(
                          title: '예정',
                          amount: '0원',
                          subtitle: '예정된 내역이 없어요',
                          count: 0,
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 보유카드 관리 배너
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '보유카드 관리',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '카드별 이용금액 확인하고\n월별 청구서 관리해 보세요.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.blue[700],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('2'),
                      Text(
                        ' / 4',
                        style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 하단 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                  label: Text('소비알림',
                      style: TextStyle(
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600])),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.bar_chart,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                  label: Text('우리마이데이터',
                      style: TextStyle(
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600])),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodItem({
    required IconData icon,
    required String title,
    required int count,
    required String amount,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Text(
            '$title $count',
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              size: 16, color: isDarkMode ? Colors.white : Colors.black87),
        ],
      ),
    );
  }

  Widget _buildFixedExpenseItem({
    required String title,
    required String amount,
    required String subtitle,
    required int count,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: TextStyle(
                fontSize: 18,
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
        const Spacer(),
        Row(
          children: [
            Text(
              '$count건',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: isDarkMode ? Colors.white : Colors.black87),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendar(bool isDarkMode) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month - 3, 1);
    final lastDay = DateTime(now.year, now.month + 3, 0);

    // 현재 달의 마지막 날짜 구하기
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
    // 마지막 날짜가 31일이면 405, 아니면 380
    final calendarHeight = lastDayOfMonth == 31 ? 405.0 : 360.0;

    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
          constraints: BoxConstraints(maxHeight: calendarHeight),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black26 : Colors.grey.withAlpha(20),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDarkMode ? Colors.grey[800]! : Colors.grey.withAlpha(50),
              width: 1,
            ),
          ),
          child: TableCalendar(
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: _focusedDay,
            currentDay: now,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              leftChevronMargin: EdgeInsets.zero,
              rightChevronMargin: EdgeInsets.zero,
              headerMargin: EdgeInsets.zero,
              headerPadding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              leftChevronPadding: EdgeInsets.zero,
              rightChevronPadding: EdgeInsets.zero,
              leftChevronIcon: Icon(Icons.arrow_back_ios,
                  size: 14, color: isDarkMode ? Colors.white : Colors.black87),
              rightChevronIcon: Icon(Icons.arrow_forward_ios,
                  size: 14, color: isDarkMode ? Colors.white : Colors.black87),
            ),
            daysOfWeekHeight: 20,
            rowHeight: 50,
            availableGestures: AvailableGestures.none,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle:
                  TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
              weekendStyle: const TextStyle(color: Colors.red),
            ),
            locale: 'ko_KR',
            onDaySelected: onDaySelected,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              defaultTextStyle:
                  TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
              weekendTextStyle: const TextStyle(color: Colors.red),
              holidayTextStyle: const TextStyle(color: Colors.blue),
              selectedDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: const BoxDecoration(
                color: Color(0xFF8B63FF),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              cellMargin: const EdgeInsets.all(4),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (_consumeData
                    .containsKey(DateTime(date.year, date.month, date.day))) {
                  final amount =
                      _consumeData[DateTime(date.year, date.month, date.day)]!;
                  return Positioned(
                    bottom: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _numberFormat.format(amount),
                        style: TextStyle(
                          fontSize: 10,
                          color:
                              isDarkMode ? Colors.grey[300] : Colors.grey[600],
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }

  void onDaySelected(selectedDay, focusedDay) {
    if (!isSameDay(_selectedDate, selectedDay)) {
      setState(() {
        _selectedDate = selectedDay;
        _focusedDay = focusedDay;
        _showExpenseDetails = true;  // 날짜 선택 시 지출내역 표시
      });
    }
  }

  Widget _buildExpenseDetails(bool isDarkMode) {
    if (!_showExpenseDetails) return const SizedBox.shrink();

    final expenses = _expenseDetails[DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    )];

    if (expenses == null || expenses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          '선택한 날짜의 지출내역이 없습니다.',
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_selectedDate.month}월 ${_selectedDate.day}일 지출내역',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...expenses.map((expense) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  expense['time'],
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    expense['title'],
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Text(
                  '${_numberFormat.format(expense['amount'])}원',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab(bool isDarkMode) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 이번달 소비 카테고리 Top 5
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '이번달 소비\n카테고리 Top 5',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        side: BorderSide(
                          color: isDarkMode
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showAllCategories = !_showAllCategories;
                          });
                        },
                        child: Text(
                          _showAllCategories ? '접기' : '더보기',
                          style: TextStyle(
                            color:
                                isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // 카테고리 아이템들
                _buildCategoryItem(
                  '식비',
                  '1,234,567원',
                  0.8,
                  Colors.blue,
                  isDarkMode,
                ),
                _buildCategoryItem(
                  '교육비', 
                  '1,520,000원',
                  0.7,
                  Colors.green,
                  isDarkMode,
                ),
                _buildCategoryItem(
                  '교양비',
                  '980,000원',
                  0.65,
                  Colors.amber,
                  isDarkMode,
                ),
                _buildCategoryItem(
                  '통신비',
                  '850,000원',
                  0.55,
                  Colors.pink,
                  isDarkMode,
                ),
                _buildCategoryItem(
                  '관리비',
                  '720,000원',
                  0.45,
                  Colors.teal,
                  isDarkMode,
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    children: [
                      _buildCategoryItem(
                        '여행비',
                        '1,000,000원',
                        0.6,
                        Colors.orange,
                        isDarkMode,
                      ),
                      _buildCategoryItem(
                        '주유비',
                        '520,000원',
                        0.4,
                        Colors.purple,
                        isDarkMode,
                      ),
                      _buildCategoryItem(
                        '도서비',
                        '320,000원',
                        0.3,
                        Colors.red,
                        isDarkMode,
                      ),
                    ],
                  ),
                  crossFadeState: _showAllCategories 
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                ),
              ],
            ),
          ),
          // 소비 패턴 분석
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '소비 패턴 분석',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '지난달 대비 식비가 20% 증가했어요',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '외식이 잦아진 것 같아요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String category, String amount, double progress,
      Color color, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()..style = PaintingStyle.fill;

    // 외식 40%
    paint.color = Colors.blue;
    canvas.drawArc(rect, 0, 2 * pi * 0.4, true, paint);

    // 페이 20%
    paint.color = Colors.orange;
    canvas.drawArc(rect, 2 * pi * 0.4, 2 * pi * 0.2, true, paint);

    // 건강/미용 15%
    paint.color = Colors.pink;
    canvas.drawArc(rect, 2 * pi * 0.6, 2 * pi * 0.15, true, paint);

    // 교통/여가 25%
    paint.color = Colors.purple;
    canvas.drawArc(rect, 2 * pi * 0.75, 2 * pi * 0.25, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final barWidth = size.width / 8;
    final spacing = barWidth / 2;
    final maxHeight = size.height * 0.8;

    // 막대 그래프 데이터 (높이 비율)
    final data = [0.8, 0.6, 0.4, 0.7];
    final colors = [Colors.blue, Colors.yellow, Colors.red, Colors.grey];

    for (var i = 0; i < data.length; i++) {
      final height = maxHeight * data[i];
      final left = (barWidth + spacing) * i + spacing;
      final top = size.height - height;

      paint.color = colors[i];
      canvas.drawRect(
        Rect.fromPoints(
          Offset(left, top),
          Offset(left + barWidth, top + height),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
