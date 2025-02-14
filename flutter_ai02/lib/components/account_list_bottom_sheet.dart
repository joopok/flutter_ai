import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'loading_overlay.dart';

class AccountListBottomSheet extends ConsumerStatefulWidget {
  final bool isAmountVisible;
  final VoidCallback onToggleAmountVisibility;
  final Future<void> Function() onRefresh;

  const AccountListBottomSheet({
    super.key,
    required this.isAmountVisible,
    required this.onToggleAmountVisibility,
    required this.onRefresh,
  });

  @override
  ConsumerState<AccountListBottomSheet> createState() => _AccountListBottomSheetState();
}

class _AccountListBottomSheetState extends ConsumerState<AccountListBottomSheet> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeScreen());
  }

  Future<void> _initializeScreen() async {
    if (!mounted) return;
    
    try {
      ref.read(loadingProvider.notifier).show(LoadingType.accountLoading);
      // 여기에 계좌 목록 데이터 로딩 로직 추가
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('계좌 목록 로딩 중 오류가 발생했습니다: $e'),
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
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '전체 계좌',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: '.SF Pro Display',
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close,
                        color: isDarkMode ? Colors.white : Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 16,
            color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: widget.onRefresh,
              child: ListView(
                children: [
                  _buildAccountItem(
                    context,
                    '저축예금',
                    '우리 122-201290-02-101',
                    '9,742,028',
                    isDarkMode ? Colors.grey[800]! : const Color(0xFFF8E8FF),
                  ),
                  _buildAccountItem(
                    context,
                    '입출금통장',
                    '신한 110-123-456789',
                    '2,580,000',
                    isDarkMode ? Colors.grey[800]! : const Color(0xFFE8F3FF),
                  ),
                  _buildAccountItem(
                    context,
                    'CMA 통장',
                    'KB 123-45-6789012',
                    '5,320,450',
                    isDarkMode ? Colors.grey[800]! : const Color(0xFFE8FFE8),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: isDarkMode 
                    ? Colors.black26 
                    : Colors.grey.withAlpha(25),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '총 자산',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: '.SF Pro Text',
                          color: isDarkMode ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        widget.isAmountVisible ? '17,642,478원' : '******',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: '.SF Pro Display',
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '계좌 추가하기',
                    style: TextStyle(
                      fontFamily: '.SF Pro Display',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem(BuildContext context, String title, String accountNumber,
      String amount, Color backgroundColor) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () => _showAccountDetail(context, title, accountNumber, amount),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: '.SF Pro Display',
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.grey[300] : Colors.black54,
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.more_horiz,
                    color: isDarkMode ? Colors.white : Colors.black87),
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'copy',
                      child: Text('계좌번호 복사',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'share',
                      child: Text('공유하기',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'copy') {
                      // 계좌번호 복사 기능
                    } else if (value == 'share') {
                      // 공유하기 기능
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: '.SF Pro Display',
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  accountNumber,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: '.SF Pro Text',
                    color: isDarkMode ? Colors.grey[300] : Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAccountDetail(
      BuildContext context, String title, String accountNumber, String amount) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close,
                        color: isDarkMode ? Colors.white : Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      accountNumber,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$amount원',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: 10,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        '거래내역 ${index + 1}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      subtitle: Text(DateTime.now()
                          .subtract(Duration(days: index))
                          .toString()
                          .split(' ')[0],
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                      trailing: Text(
                        '-${(index + 1) * 10000}원',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
