# Configuración de Discord OAuth

Para que la aplicación muestre tu perfil real de Discord (como "mariana06" en lugar de datos genéricos), necesitas configurar Discord OAuth.

## Pasos para configurar Discord OAuth:

### 1. Crear una aplicación en Discord Developer Portal

1. Ve a https://discord.com/developers/applications
2. Haz clic en "New Application"
3. Dale un nombre a tu aplicación (ej: "Mi App Discord")
4. Haz clic en "Create"

### 2. Configurar OAuth2

1. En el panel izquierdo, haz clic en "OAuth2"
2. En la sección "Redirects", agrega esta URL:
   ```
   com.example.logindiscord://oauth
   ```
3. Guarda los cambios

### 3. Obtener las credenciales

1. En la sección "OAuth2" > "General"
2. Copia el **Client ID**
3. Haz clic en "Reset Secret" y copia el **Client Secret**

### 4. Configurar la aplicación

1. Abre el archivo `lib/config/discord_config.dart`
2. Reemplaza las siguientes líneas:

```dart
static const String clientId = 'TU_CLIENT_ID_AQUI';
static const String clientSecret = 'TU_CLIENT_SECRET_AQUI';
```

Con tus credenciales reales:

```dart
static const String clientId = '123456789012345678';
static const String clientSecret = 'abcdefghijklmnopqrstuvwxyz123456';
```

### 5. Configurar permisos (scopes)

En Discord Developer Portal:
1. Ve a "OAuth2" > "URL Generator"
2. Selecciona estos scopes:
   - `identify` - Ver información básica del usuario
   - `email` - Ver email del usuario
   - `guilds` - Ver servidores del usuario
   - `guilds.members.read` - Ver miembros de servidores

### 6. Probar la configuración

1. Ejecuta la aplicación
2. Usa el login por QR o Discord OAuth
3. Deberías ver tu perfil real de Discord (como "mariana06")

## Solución de problemas

### Si sigues viendo datos genéricos:

1. **Verifica las credenciales**: Asegúrate de que Client ID y Client Secret sean correctos
2. **Verifica el redirect URI**: Debe ser exactamente `com.example.logindiscord://oauth`
3. **Verifica los scopes**: Asegúrate de que los scopes estén configurados en Discord
4. **Revisa la consola**: Busca errores en los logs de la aplicación

### Si obtienes errores de OAuth:

- **"Invalid redirect URI"**: Verifica que el redirect URI en Discord coincida exactamente
- **"Invalid client"**: Verifica que Client ID y Client Secret sean correctos
- **"Access denied"**: El usuario canceló la autorización

## Resultado esperado

Una vez configurado correctamente, deberías ver:
- Tu username real de Discord (ej: "mariana06")
- Tu avatar real de Discord
- Tu email real
- Fecha de creación real de tu cuenta
- Tus servidores reales de Discord

En lugar de los datos genéricos que aparecen actualmente.
