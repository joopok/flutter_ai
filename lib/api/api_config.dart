class ApiConfig {
  static const String baseUrl = 'http://192.168.0.109:9002';
  static const Duration timeout = Duration(seconds: 5);

  // API 엔드포인트
  static const String login = '/auth/login';
  static const String users = '/users';
  static const String products = '/products';
  static const String test = '/test.php';

  // 헤더
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
