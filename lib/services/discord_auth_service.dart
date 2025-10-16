import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../config/discord_config.dart';
import '../config/platform_config.dart';

class DiscordAuthService {
  /// Inicia el proceso de autenticación con Discord
  static Future<DiscordUser?> signInWithDiscord() async {
    try {
      print('Iniciando autenticación con Discord...');
      print('URL de autenticación: ${DiscordConfig.authUrl}');

      // Abre el navegador para autenticación
      final result = await FlutterWebAuth2.authenticate(
        url: DiscordConfig.authUrl,
        callbackUrlScheme: PlatformConfig.callbackUrlScheme,
      );

      print('Resultado de autenticación: $result');

      // Extrae el código de autorización de la URL de retorno
      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];

      if (code == null) {
        throw Exception('No se pudo obtener el código de autorización');
      }

      print('Código obtenido: $code');

      // Intercambia el código por un token de acceso
      final token = await _exchangeCodeForToken(code);
      if (token == null) {
        throw Exception('No se pudo obtener el token de acceso');
      }

      print('Token obtenido exitosamente');

      // Obtiene la información del usuario
      final user = await _getUserInfo(token);
      if (user == null) {
        throw Exception('No se pudo obtener la información del usuario');
      }

      print('Usuario obtenido: ${user.displayName}');

      // Guarda el token y la información del usuario
      await _saveUserData(user, token);

      return user;
    } catch (e) {
      print('Error en autenticación con Discord: $e');
      return null;
    }
  }

  /// Intercambia el código de autorización por un token de acceso
  static Future<String?> _exchangeCodeForToken(String code) async {
    try {
      final response = await http.post(
        Uri.parse(DiscordConfig.discordTokenUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'client_id': DiscordConfig.clientId,
          'client_secret': DiscordConfig.clientSecret,
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': DiscordConfig.redirectUri,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['access_token'];
      } else {
        print(
            'Error al obtener token: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error al intercambiar código por token: $e');
      return null;
    }
  }

  /// Obtiene la información del usuario de Discord
  static Future<DiscordUser?> _getUserInfo(String token) async {
    try {
      final response = await http.get(
        Uri.parse(DiscordConfig.discordUserUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DiscordUser.fromJson(data);
      } else {
        print(
            'Error al obtener información del usuario: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error al obtener información del usuario: $e');
      return null;
    }
  }

  /// Guarda los datos del usuario en SharedPreferences
  static Future<void> _saveUserData(DiscordUser user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('discord_user', json.encode(user.toJson()));
    await prefs.setString('discord_token', token);
    await prefs.setBool('is_logged_in', true);
  }

  /// Obtiene el usuario actualmente logueado
  static Future<DiscordUser?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('discord_user');
      if (userJson != null) {
        return DiscordUser.fromJson(json.decode(userJson));
      }
      return null;
    } catch (e) {
      print('Error al obtener usuario actual: $e');
      return null;
    }
  }

  /// Verifica si el usuario está logueado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  /// Cierra la sesión
  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('discord_user');
    await prefs.remove('discord_token');
    await prefs.setBool('is_logged_in', false);
  }
}

/// Modelo de datos para el usuario de Discord
class DiscordUser {
  final String id;
  final String username;
  final String discriminator;
  final String? email;
  final String? avatar;
  final bool verified;

  DiscordUser({
    required this.id,
    required this.username,
    required this.discriminator,
    this.email,
    this.avatar,
    required this.verified,
  });

  factory DiscordUser.fromJson(Map<String, dynamic> json) {
    return DiscordUser(
      id: json['id'],
      username: json['username'],
      discriminator: json['discriminator'],
      email: json['email'],
      avatar: json['avatar'],
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'discriminator': discriminator,
      'email': email,
      'avatar': avatar,
      'verified': verified,
    };
  }

  String get displayName => '$username#$discriminator';
  String get avatarUrl => avatar != null
      ? 'https://cdn.discordapp.com/avatars/$id/$avatar.png'
      : 'https://cdn.discordapp.com/embed/avatars/0.png';
}
