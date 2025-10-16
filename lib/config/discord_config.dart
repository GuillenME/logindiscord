import 'platform_config.dart';

class DiscordConfig {
  // IMPORTANTE: Reemplaza estos valores con tus credenciales reales de Discord

  // Para obtener estas credenciales:
  // 1. Ve a https://discord.com/developers/applications
  // 2. Crea una nueva aplicación
  // 3. Ve a la sección "OAuth2"
  // 4. Copia el Client ID y Client Secret
  // 5. Agrega la redirect URI: com.example.logindiscord://oauth

  static const String clientId = '1426988695986110464';
  static const String clientSecret =
      '17bf76d3131de96323c2e2525d3521e0ac64f1466be65fa65e3792d2456d7b32';

  // Usa la configuración específica de plataforma
  static String get redirectUri => PlatformConfig.redirectUri;

  // URLs de Discord API
  static const String discordAuthUrl =
      'https://discord.com/api/oauth2/authorize';
  static const String discordTokenUrl = 'https://discord.com/api/oauth2/token';
  static const String discordUserUrl = 'https://discord.com/api/users/@me';

  // URL completa de autenticación
  static String get authUrl =>
      '$discordAuthUrl?client_id=$clientId&redirect_uri=${Uri.encodeComponent(redirectUri)}&response_type=code&scope=identify%20email';
}
