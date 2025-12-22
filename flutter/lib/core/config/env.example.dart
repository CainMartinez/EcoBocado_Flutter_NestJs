/// Configuración de variables de entorno y helpers de URL.
class Env {

  static const String ultraMessageInstanceId = 'TU_INSTANCE_ID_AQUI';

  static const String ultraMessageToken = 'TU_TOKEN_AQUI';

  static const String _publicKeyStripe =
      String.fromEnvironment('PUBLIC_KEY_STRIPE', defaultValue: 'your_key_here');

  static const String _apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'your_url/api');
  
  static const String _minioBaseUrl =
      String.fromEnvironment('MINIO_BASE_URL', defaultValue: 'your_url');

  /// Base URL para llamadas HTTP, sin barra final.
  static String get apiBaseUrl => _apiBaseUrl.endsWith('/')
      ? _apiBaseUrl.substring(0, _apiBaseUrl.length - 1)
      : _apiBaseUrl;

  static String get publicKeyStripe => _publicKeyStripe;

  /// Base URL del servidor (sin /api), para recursos estáticos
  static String get serverBaseUrl {
    final url = apiBaseUrl;
    // Si termina en /api, lo removemos
    if (url.endsWith('/api')) {
      return url.substring(0, url.length - 4);
    }
    return url;
  }

  /// Base URL de MinIO para servir imágenes, sin barra final.
  static String get minioBaseUrl => _minioBaseUrl.endsWith('/')
      ? _minioBaseUrl.substring(0, _minioBaseUrl.length - 1)
      : _minioBaseUrl;

  /// Construye URL absolutas contra `apiBaseUrl`.
  static Uri apiUri(String path, {Map<String, dynamic>? query}) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$apiBaseUrl$normalized').replace(queryParameters: query);
  }

  bool get isNotificationConfigured {
    return Env.ultraMessageInstanceId != 'TU_INSTANCE_ID_AQUI' &&
          Env.ultraMessageToken != 'TU_TOKEN_AQUI';
  }
}