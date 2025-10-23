class DiscordConfig {
  // Discord OAuth Configuration
  // Para obtener estas credenciales:
  // 1. Ve a https://discord.com/developers/applications
  // 2. Crea una nueva aplicación o selecciona una existente
  // 3. Ve a la sección "OAuth2" 
  // 4. Copia el Client ID y Client Secret aquí
  
  
  static const String clientId = '1430609415479890074';
  static const String clientSecret = 'MaKi6OAnXoOM1BAtj9PYQf-AWSMS62Gn';
  
  // Redirect URI - debe coincidir con el configurado en Discord Developer Portal
  static const String redirectUri = 'com.example.logindiscord://oauth';
  
  // Discord API URLs
  static const String discordAuthUrl = 'https://discord.com/api/oauth2/authorize';
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
    return clientId != 'YOUR_DISCORD_CLIENT_ID_HERE' && 
           clientSecret != 'YOUR_DISCORD_CLIENT_SECRET_HERE' &&
           clientId.isNotEmpty && 
           clientSecret.isNotEmpty;
  }
}
