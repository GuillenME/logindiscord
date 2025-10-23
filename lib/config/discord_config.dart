class DiscordConfig {
  // Discord OAuth Configuration
  // Para obtener estas credenciales:
  // 1. Ve a https://discord.com/developers/applications
  // 2. Crea una nueva aplicación o selecciona una existente
  // 3. Ve a la sección "OAuth2"
  // 4. Copia el Client ID y Client Secret aquí

  static const String clientId = '1426988695986110464';
  static const String clientSecret = 'i8iHNJXeH3AsnLM7j4u4KvhqbvAkeXUS';

  // Redirect URI - debe coincidir con el configurado en Discord Developer Portal
  static const String redirectUri = 'com.example.logindiscord://oauth';

  // Discord API URLs
  static const String discordAuthUrl =
      'https://discord.com/api/oauth2/authorize';
  static const String discordTokenUrl = 'https://discord.com/api/oauth2/token';
  static const String discordApiBase = 'https://discord.com/api/v10';

  // OAuth scopes
  static const List<String> scopes = [
    'identify',
    'email',
    'guilds',
    'guilds.members.read',
  ];

  // Verificar si Discord OAuth está configurado
  static bool get isConfigured {
    return clientId != '1426988695986110464' &&
        clientSecret != 'i8iHNJXeH3AsnLM7j4u4KvhqbvAkeXUS' &&
        clientId.isNotEmpty &&
        clientSecret.isNotEmpty;
  }
}
