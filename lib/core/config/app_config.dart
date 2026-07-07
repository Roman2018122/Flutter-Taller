// lib/core/config/app_config.dart

class AppConfig {
  // Si pruebas con el emulador de Android Studio, usa: 'http://10.0.2.2:8000'
  // Si pruebas con la Web o estás en producción, cambia a la IP de tu VPS: 'https://tu-dominio.com'
  //static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  // Tiempos de espera para que la app no se quede congelada si el servidor se cae
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const String baseUrl = 'http://192.168.100.29:8000/api/v1';

  AppConfig._();
}
