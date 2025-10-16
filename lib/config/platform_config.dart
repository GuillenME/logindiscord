import 'package:flutter/foundation.dart';

class PlatformConfig {
  // Configuración específica por plataforma
  static String get redirectUri {
    if (kIsWeb) {
      return 'http://localhost:3001/callback';
    } else {
      // Android/iOS
      return 'com.example.logindiscord://oauth';
    }
  }

  static String get callbackUrlScheme {
    if (kIsWeb) {
      return 'http';
    } else {
      return 'com.example.logindiscord';
    }
  }
}
