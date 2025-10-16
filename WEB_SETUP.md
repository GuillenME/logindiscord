# Configuración para Web - Discord OAuth

## ⚠️ IMPORTANTE: Configuración de Discord para Web

Para que funcione el login con Discord en la versión web, necesitas actualizar la configuración en Discord Developer Portal:

### 1. Actualizar Redirect URI en Discord

1. Ve a [Discord Developer Portal](https://discord.com/developers/applications)
2. Selecciona tu aplicación (ID: 1426988695986110464)
3. Ve a la sección "OAuth2"
4. En "Redirects", agrega esta URL:
   ```
   http://localhost:3000/callback
   ```
5. También puedes agregar para producción:
   ```
   https://tu-dominio.com/callback
   ```

### 2. Configuración actual en el código

El archivo `lib/config/discord_config.dart` ya está configurado para web:
```dart
static const String redirectUri = 'http://localhost:3000/callback';
```

### 3. Ejecutar la aplicación

```bash
flutter run -d chrome --web-port 3000
```

## 🔧 Solución de problemas de Android

Si quieres ejecutar en Android, necesitas:

### 1. Instalar Android Command Line Tools

1. Ve a [Android Studio SDK Manager](https://developer.android.com/studio/intro/update#sdk-manager)
2. Instala "Android SDK Command-line Tools (latest)"
3. O ejecuta:
```bash
sdkmanager --install "cmdline-tools;latest"
```

### 2. Aceptar licencias

```bash
flutter doctor --android-licenses
```

### 3. Para Android, cambiar redirect URI

En `lib/config/discord_config.dart`:
```dart
static const String redirectUri = 'com.example.logindiscord://oauth';
```

## 🌐 Configuración para diferentes plataformas

### Web (localhost)
```
http://localhost:3000/callback
```

### Web (producción)
```
https://tu-dominio.com/callback
```

### Android
```
com.example.logindiscord://oauth
```

### iOS
```
com.example.logindiscord://oauth
```

## 📱 Pruebas recomendadas

1. **Web**: `flutter run -d chrome --web-port 3000`
2. **Android**: `flutter run -d android` (después de configurar SDK)
3. **Windows**: `flutter run -d windows`

## 🚀 Despliegue en producción

Para producción web, actualiza:
1. Redirect URI en Discord
2. URL en `discord_config.dart`
3. Ejecuta: `flutter build web`
