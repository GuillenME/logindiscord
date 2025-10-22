import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/config/discord_config.dart';

class DiscordAuthService {

  static Future<Map<String, dynamic>?> loginWithDiscord() async {
    try {
      // Check if Discord OAuth is configured
      if (!DiscordConfig.isConfigured) {
        throw Exception('Discord OAuth no está configurado. Por favor configura tu Client ID y Client Secret en lib/config/discord_config.dart');
      }

      // Build the authorization URL
      final authUrl = Uri.parse(DiscordConfig.discordAuthUrl).replace(
        queryParameters: {
          'client_id': DiscordConfig.clientId,
          'redirect_uri': DiscordConfig.redirectUri,
          'response_type': 'code',
          'scope': DiscordConfig.scopes.join(' '),
        },
      );

      print('Abriendo Discord OAuth: ${authUrl.toString()}');

      // Open the Discord OAuth page
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: 'http',
      );

      print('Resultado de Discord OAuth: $result');

      // Extract the authorization code from the callback URL
      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];

      if (code == null) {
        throw Exception('No se recibió el código de autorización de Discord');
      }

      print('Código de autorización recibido: $code');

      // Exchange the code for an access token
      final tokenResponse = await http.post(
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

      print('Respuesta del token: ${tokenResponse.statusCode} - ${tokenResponse.body}');

      if (tokenResponse.statusCode != 200) {
        throw Exception('Error al obtener el token de acceso: ${tokenResponse.body}');
      }

      final tokenData = json.decode(tokenResponse.body);
      final accessToken = tokenData['access_token'] as String;

      print('Token de acceso obtenido: ${accessToken.substring(0, 10)}...');

      // Get user information from Discord API
      final userResponse = await http.get(
        Uri.parse('${DiscordConfig.discordApiBase}/users/@me'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('Respuesta del usuario: ${userResponse.statusCode} - ${userResponse.body}');

      if (userResponse.statusCode != 200) {
        throw Exception('Error al obtener información del usuario: ${userResponse.body}');
      }

      final userData = json.decode(userResponse.body);

      // Get user's guilds (servers)
      final guildsResponse = await http.get(
        Uri.parse('${DiscordConfig.discordApiBase}/users/@me/guilds'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      List<dynamic> guilds = [];
      if (guildsResponse.statusCode == 200) {
        guilds = json.decode(guildsResponse.body);
      }

      print('Usuario autenticado: ${userData['username']}');
      print('Servidores: ${guilds.length}');

      // Save authentication data
      await saveAuthData(accessToken, userData, guilds);

      return {
        'access_token': accessToken,
        'user': userData,
        'guilds': guilds,
      };
    } catch (e) {
      print('Error en login Discord: $e');
      rethrow; // Re-lanzar el error para que se maneje en la UI
    }
  }


  static Future<void> saveAuthData(String accessToken, Map<String, dynamic> userData, List<dynamic> guilds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('discord_access_token', accessToken);
    await prefs.setString('discord_user_data', json.encode(userData));
    await prefs.setString('discord_guilds', json.encode(guilds));
    await prefs.setBool('is_logged_in', true);
  }

  static Future<Map<String, dynamic>?> getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    
    if (!isLoggedIn) return null;

    final userDataString = prefs.getString('discord_user_data');
    if (userDataString == null) return null;

    return json.decode(userDataString);
  }

  static Future<List<dynamic>?> getStoredGuilds() async {
    final prefs = await SharedPreferences.getInstance();
    final guildsString = prefs.getString('discord_guilds');
    if (guildsString == null) return null;
    return json.decode(guildsString);
  }

  static Future<String?> getStoredAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('discord_access_token');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('discord_access_token');
    await prefs.remove('discord_user_data');
    await prefs.remove('discord_guilds');
    await prefs.setBool('is_logged_in', false);
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final accessToken = await getStoredAccessToken();
    if (accessToken == null) return null;

    try {
      final response = await http.get(
        Uri.parse('${DiscordConfig.discordApiBase}/users/@me'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error getting current user: $e');
    }

    return null;
  }
}
