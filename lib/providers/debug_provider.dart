import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 디버그 설정을 관리하는 프로바이더
final debugSettingsProvider = StateNotifierProvider<DebugSettingsNotifier, DebugSettings>((ref) {
  return DebugSettingsNotifier();
});

// 디버그 설정 클래스
class DebugSettings {
  final bool showFileName;
  
  DebugSettings({this.showFileName = true});
  
  DebugSettings copyWith({bool? showFileName}) {
    return DebugSettings(
      showFileName: showFileName ?? this.showFileName,
    );
  }
}

// 디버그 설정 상태 관리 클래스
class DebugSettingsNotifier extends StateNotifier<DebugSettings> {
  DebugSettingsNotifier() : super(DebugSettings()) {
    _loadSettings();
  }

  // 설정 불러오기
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = DebugSettings(
      showFileName: prefs.getBool('showFileName') ?? true,
    );
  }

  // 파일명 표시 설정 토글
  Future<void> toggleShowFileName() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(showFileName: !state.showFileName);
    await prefs.setBool('showFileName', state.showFileName);
  }
  
  // 파일명 표시 설정 변경
  Future<void> setShowFileName(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(showFileName: value);
    await prefs.setBool('showFileName', value);
  }
} 