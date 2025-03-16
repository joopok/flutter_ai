class ApiConfig {
  // 개발 환경에서는 에뮬레이터에서 localhost 대신 10.0.2.2를 사용해야 함
  // 실제 기기에서는 실제 서버 IP 또는 도메인을 사용해야 함
  static const String baseUrl = 'http://localhost:8081';
  // static const String baseUrl = 'http://실제_서버_IP_또는_도메인:8081';
  static const Duration timeout = Duration(seconds: 10); // 타임아웃 시간 증가

  // API 엔드포인트
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String register = '/api/auth/register';
  static const String users = '/users';
  static const String products = '/products';
  static const String findAll = '/api/findAll';
  static const String test = '/api/test';
  static const String findById = '/api/findById';
  static const String update = '/api/update';
  static const String notice = '/api/notice';
  static const String eventList = '/api/events/list';
  static const String noticeList = '/api/notices/list';
  static const String noticeMainList = '/api/notices/mainList';
  static const String noticeDetail = '/api/noticeDetail';
  static const String noticeInsert = '/api/noticeInsert';
  static const String noticeUpdate = '/api/noticeUpdate';
  static const String noticeDelete = '/api/noticeDelete';

  // 헤더
  static Map<String, String> get headers => {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8',
  };
}
