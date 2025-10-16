# Configuración de Discord OAuth

Para que funcione el login con Discord, necesitas configurar una aplicación en Discord y obtener las credenciales.

## Pasos para configurar Discord OAuth:

### 1. Crear una aplicación en Discord

1. Ve a [Discord Developer Portal](https://discord.com/developers/applications)
2. Haz clic en "New Application"
3. Dale un nombre a tu aplicación (ej: "Mi App Login")
4. Haz clic en "Create"

### 2. Configurar OAuth2

1. En el panel de tu aplicación, ve a la sección "OAuth2"
2. En "Redirects", agrega la siguiente URL:
   ```
   com.example.logindiscord://oauth
   ```
3. En "Scopes", selecciona:
   - `identify` (para obtener información básica del usuario)
   - `email` (para obtener el email del usuario)

### 3. Obtener las credenciales

1. En la sección "OAuth2", copia el **Client ID**
2. Haz clic en "Reset Secret" para generar un **Client Secret**
3. Copia el **Client Secret**

### 4. Configurar la aplicación

1. Abre el archivo `lib/config/discord_config.dart`
2. Reemplaza `TU_CLIENT_ID_AQUI` con tu Client ID
3. Reemplaza `TU_CLIENT_SECRET_AQUI` con tu Client Secret

```dart
class DiscordConfig {
  static const String clientId = 'TU_CLIENT_ID_REAL_AQUI';
  static const String clientSecret = 'TU_CLIENT_SECRET_REAL_AQUI';
  // ... resto del código
}
```

### 5. Instalar dependencias

Ejecuta el siguiente comando para instalar las dependencias:

```bash
flutter pub get
```

### 6. Ejecutar la aplicación

```bash
flutter run
```

## Notas importantes:

- **Nunca** subas las credenciales reales a un repositorio público
- Para producción, usa variables de entorno o un archivo de configuración seguro
- El redirect URI debe coincidir exactamente con el configurado en Discord
- Asegúrate de que la aplicación tenga los permisos necesarios en Discord

## Solución de problemas:

- Si el login no funciona, verifica que las credenciales sean correctas
- Asegúrate de que el redirect URI esté configurado correctamente en Discord
- Verifica que la aplicación tenga los scopes necesarios
- Revisa los logs de la aplicación para ver errores específicos
