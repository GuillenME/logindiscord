# Configuración de Discord OAuth

Para que la autenticación con Discord funcione correctamente, necesitas configurar una aplicación en Discord y actualizar las credenciales en el código.

## Pasos para configurar Discord OAuth:

### 1. Crear una aplicación en Discord
1. Ve a [Discord Developer Portal](https://discord.com/developers/applications)
2. Haz clic en "New Application"
3. Dale un nombre a tu aplicación (ej: "Mi App Discord")
4. Haz clic en "Create"

### 2. Configurar OAuth2
1. En el panel de tu aplicación, ve a la sección "OAuth2" > "General"
2. Copia el "Client ID" y "Client Secret"
3. En "Redirects", agrega: `com.example.logindiscord://oauth`

### 3. Configurar permisos (Scopes)
Los siguientes scopes están configurados en el código:
- `identify` - Obtener información básica del usuario
- `email` - Obtener email del usuario
- `guilds` - Obtener lista de servidores del usuario
- `guilds.members.read` - Leer información de miembros de servidores

### 4. Actualizar las credenciales en el código
Edita el archivo `lib/services/discord_auth_service.dart` y reemplaza:

```dart
static const String clientId = 'YOUR_DISCORD_CLIENT_ID';
static const String clientSecret = 'YOUR_DISCORD_CLIENT_SECRET';
```

Con tus credenciales reales de Discord.

### 5. Configurar el esquema de URL (Android)
Para Android, necesitas configurar el esquema de URL en `android/app/src/main/AndroidManifest.xml`:

```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"
    android:theme="@style/LaunchTheme"
    android:configChanges="orientation|keyboardHidden|orientation|screenSize"
    android:hardwareAccelerated="true"
    android:windowSoftInputMode="adjustResize">
    <meta-data
        android:name="io.flutter.embedding.android.NormalTheme"
        android:resource="@style/NormalTheme" />
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="com.example.logindiscord" />
    </intent-filter>
</activity>
```

### 6. Configurar el esquema de URL (iOS)
Para iOS, edita `ios/Runner/Info.plist` y agrega:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>discord-oauth</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.example.logindiscord</string>
        </array>
    </dict>
</array>
```

## Funcionalidades implementadas:

✅ **Autenticación OAuth2 con Discord**
- Redirección a la página oficial de Discord
- Intercambio de código por token de acceso
- Obtención de información del usuario

✅ **Pantalla de inicio (Home)**
- Botón de perfil en la barra superior
- Información resumida del usuario
- Acciones rápidas (Ver perfil, Servidores, Configuración, Cerrar sesión)

✅ **Pantalla de perfil completa**
- Avatar del usuario con indicador de estado
- Información de la cuenta (ID, email, verificación)
- Estadísticas (servidores, discriminator)
- Lista de servidores del usuario
- Estado de la cuenta (verificado, Nitro)

✅ **Gestión de estado de autenticación**
- Verificación automática al iniciar la app
- Almacenamiento seguro de tokens
- Navegación automática según estado de login

## Notas importantes:

1. **Seguridad**: Nunca hardcodees las credenciales en el código de producción. Usa variables de entorno o archivos de configuración seguros.

2. **Testing**: Para pruebas, puedes usar el modo de desarrollo de Discord que permite redirecciones HTTP.

3. **Permisos**: Los scopes configurados son los mínimos necesarios. Puedes agregar más según tus necesidades.

4. **URL Scheme**: Asegúrate de que el esquema de URL sea único para tu aplicación.

## Flujo de la aplicación:

1. **Inicio**: La app verifica si el usuario está logueado
2. **Login**: Si no está logueado, muestra la pantalla de login
3. **Autenticación**: Al hacer clic en "Iniciar sesión con Discord", abre Discord en el navegador
4. **Autorización**: El usuario autoriza la aplicación en Discord
5. **Redirección**: Discord redirige de vuelta a la app con el código de autorización
6. **Token**: La app intercambia el código por un token de acceso
7. **Datos**: Se obtiene la información del usuario y servidores
8. **Home**: Se navega a la pantalla de inicio
9. **Perfil**: Desde el home se puede acceder al perfil completo del usuario
