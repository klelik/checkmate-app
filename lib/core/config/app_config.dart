class AppConfig {
  AppConfig._();

  static const bool useMockData = true;
  static const String appName = 'CheckMate';
  static const String appVersion = '1.0.0';

  // Pricing
  static const double freeCheckPrice = 0.0;
  static const double standardCheckPrice = 4.99;
  static const double fullCheckPrice = 9.99;
  static const double bundle3Price = 12.99;
  static const double bundle5Price = 19.99;

  // API (swap these when real APIs are ready)
  static const String baseUrl = 'https://api.checkmate.com/v1';
  static const String stripePublishableKey = 'pk_test_mock_key';
}
