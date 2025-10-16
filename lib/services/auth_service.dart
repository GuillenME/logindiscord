import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userEmailKey = 'user_email';
  static const String _userPasswordKey = 'user_password';
  static const String _isLoggedInKey = 'is_logged_in_local';

  // Simular autenticación con Discord
  // En una app real, esto se conectaría con la API de Discord
  static Future<bool> loginWithEmailPassword(String email, String password) async {
    try {
      print('Intentando login con: $email');
      
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Simular que cualquier email/contraseña es válido para Discord
      // En una implementación real, aquí verificarías con Discord API
      print('Login exitoso para: $email');
      
      // Guardar datos de sesión
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userEmailKey, email);
      await prefs.setString(_userPasswordKey, password);
      await prefs.setBool(_isLoggedInKey, true);
      
      return true;
    } catch (e) {
      print('Error en login: $e');
      return false;
    }
  }


  static Future<bool> isLoggedInLocally() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<Map<String, String>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_userEmailKey);
    final password = prefs.getString(_userPasswordKey);
    
    if (email != null && password != null) {
      return {
        'email': email,
        'password': password,
      };
    }
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userPasswordKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  static Future<Map<String, dynamic>> getUserProfile(String email) async {
    // Simular datos de perfil basados en el email
    return {
      'username': email.split('@')[0],
      'email': email,
      'displayName': email.split('@')[0].toUpperCase(),
      'avatar': null,
      'id': email.hashCode.toString(),
      'verified': true,
      'created_at': DateTime.now().toIso8601String(),
      'premium_type': null,
      'locale': 'es',
    };
  }
}
