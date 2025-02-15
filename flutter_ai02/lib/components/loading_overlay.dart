import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

enum LoadingType {
  initializing('홈 정보를 불러오는 중...'),
  accountLoading('계좌 정보를 불러오는 중...'),
  assetLoading('자산 정보를 불러오는 중...'),
  benefitLoading('혜택 정보를 불러오는 중...'),
  productLoading('상품 정보를 불러오는 중...'),
  consumeLoading('소비 정보를 불러오는 중...'),
  refreshing('새로고침 중...'),
  navigating('화면 이동 중...');

  final String message;
  const LoadingType(this.message);
}

@immutable
class LoadingState {
  final bool isLoading;
  final String? message;

  const LoadingState({
    this.isLoading = false,
    this.message,
  });

  LoadingState copyWith({
    bool? isLoading,
    String? message,
  }) {
    return LoadingState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }
}

final loadingProvider = StateNotifierProvider<LoadingNotifier, LoadingState>((ref) {
  return LoadingNotifier();
});

class LoadingNotifier extends StateNotifier<LoadingState> {
  LoadingNotifier() : super(const LoadingState());

  void show([LoadingType? type]) {
    state = LoadingState(
      isLoading: true,
      message: type?.message ?? '로딩 중...',
    );
  }

  void hide() {
    state = const LoadingState(isLoading: false);
  }

  Future<T> during<T>(
    Future<T> Function() callback, {
    LoadingType? type,
  }) async {
    try {
      show(type);
      return await callback();
    } finally {
      hide();
    }
  }
}

class LoadingOverlay extends ConsumerWidget {
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingState = ref.watch(loadingProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Stack(
        children: [
          child,
          if (loadingState.isLoading)
            Material(
              color: Colors.black.withAlpha(40),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  margin: const EdgeInsets.symmetric(horizontal: 48),
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballPulse,
                          colors: [
                            isDarkMode ? const Color(0xFF4B7BFF) : const Color(0xFF2D5AF0),
                            isDarkMode ? const Color(0xFF6C8FFF) : const Color(0xFF4169E1),
                            isDarkMode ? const Color(0xFF89A9FF) : const Color(0xFF6384FF),
                          ],
                          strokeWidth: 2,
                        ),
                      ),
                      if (loadingState.message != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          loadingState.message!,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : const Color(0xFF1A1F36),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 