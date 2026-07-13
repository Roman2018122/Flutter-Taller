class AppConfig {
  AppConfig._();

  // Emulador oficial de Android:
  //static const String baseUrl = 'http://10.0.2.2:8000/api/';
  static const String baseUrl = 'http://192.168.100.29:8000/api/';

  static const String tokenEndpoint = 'token/';
  static const String refreshEndpoint = 'token/refresh/';
}
