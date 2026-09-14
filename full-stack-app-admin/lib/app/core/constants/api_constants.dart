class ApiConstants {
  static const String baseUrl = 'http://192.168.100.38:3001/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // Dashboard endpoints
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardCharts = '/dashboard/charts';

  // Products endpoints
  static const String products = '/products';
  static const String productDetail = '/products/';

  // Categories endpoints
  static const String categories = '/categories';
  static const String categoryDetail = '/categories/';

  // Orders endpoints
  static const String orders = '/orders';
  static const String orderDetail = '/orders/';
  static const String updateOrderStatus = '/orders/status';

  // Customers endpoints
  static const String customers = '/customers';
  static const String customerDetail = '/customers/';

  static void loadConstants() {
    // Load any dynamic constants if needed
    print('API Constants loaded');
  }
}
