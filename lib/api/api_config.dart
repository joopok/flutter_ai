class ApiConfig {
  static const String baseUrl = 'http://localhost:8080';
  static const Duration timeout = Duration(seconds: 5);

  // API 엔드포인트
  static const String login = '/auth/login';
  static const String users = '/users';
  static const String products = '/products';
  static const String findAll = '/api/findAll';
  static const String test = '/api/findAll';
  static const String findById = '/api/findById';
  static const String update = '/api/update';

  // 헤더
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
