# Instrucciones de Configuración para el Equipo

## 🚀 Configuración Inicial

Cuando bajes los cambios, sigue estos pasos:

### 1. Instalar Dependencias
```bash
flutter pub get
```

### 2. Verificar que no hay errores
```bash
flutter analyze
```

### 3. Ejecutar la aplicación
```bash
flutter run
```

## 📱 Nuevas Funcionalidades Agregadas

### ✅ **Sistema de Perfil Discord Mejorado**
- **Configuración manual de perfil**: Puedes ingresar tus datos reales de Discord
- **Detección automática**: La app detecta si tu perfil no está sincronizado
- **Login QR mejorado**: Usa datos más realistas por defecto

### ✅ **Pantallas Nuevas**
- `SettingsScreen`: Configuración de Discord OAuth
- `DiscordProfileSetup`: Configuración manual del perfil
- Mejoras en `HomeScreen` y `QRLoginScreen`

### ✅ **Archivos Nuevos**
- `lib/config/discord_config.dart`: Configuración centralizada
- `lib/screens/settings_screen.dart`: Pantalla de configuración
- `lib/screens/discord_profile_setup.dart`: Configuración manual del perfil

## 🔧 Cómo Usar las Nuevas Funcionalidades

### **Opción 1: Configuración Manual (RECOMENDADA)**
1. Ejecuta la app
2. Si ves datos genéricos, aparecerá una notificación naranja
3. Haz clic en "Configurar Mi Perfil"
4. Ingresa tus datos reales de Discord
5. ¡Listo!

### **Opción 2: Desde Configuración**
1. Haz clic en el botón de configuración (⚙️)
2. Haz clic en "Configurar Perfil Manualmente"
3. Ingresa tus datos reales de Discord

## 🛠️ Configuración Avanzada (Opcional)

### **Discord OAuth Real**
Si quieres usar Discord OAuth real (no simulado):

1. Ve a https://discord.com/developers/applications
2. Crea una nueva aplicación
3. Ve a OAuth2 > General
4. Copia Client ID y Client Secret
5. En Redirects, agrega: `com.example.logindiscord://oauth`
6. Edita `lib/config/discord_config.dart`:
   ```dart
   static const String clientId = 'TU_CLIENT_ID_REAL';
   static const String clientSecret = 'TU_CLIENT_SECRET_REAL';
   ```

## 📋 Dependencias Agregadas

Las siguientes dependencias ya están en `pubspec.yaml`:
- `flutter_web_auth_2: ^3.0.0`
- `http: ^1.1.0`
- `shared_preferences: ^2.2.2`
- `qr_flutter: ^4.1.0`
- `url_launcher: ^6.2.2`

## ⚠️ Notas Importantes

- **No hay errores críticos**: Solo sugerencias de estilo
- **Compatibilidad**: Funciona con Flutter 3.5.4+
- **Fallback**: Si Discord OAuth no está configurado, usa datos simulados
- **Configuración opcional**: Puedes usar la app sin configurar Discord OAuth

## 🐛 Solución de Problemas

### **Si hay errores de compilación:**
```bash
flutter clean
flutter pub get
flutter run
```

### **Si no ves las nuevas pantallas:**
- Verifica que todos los archivos estén en `lib/screens/`
- Verifica que todos los imports estén correctos

### **Si el perfil sigue mostrando datos genéricos:**
- Usa la opción "Configurar Mi Perfil" desde la notificación naranja
- O ve a Configuración > "Configurar Perfil Manualmente"

## 📞 Soporte

Si tienes problemas:
1. Verifica que todas las dependencias estén instaladas
2. Ejecuta `flutter analyze` para ver si hay errores
3. Revisa que todos los archivos estén presentes
4. Contacta al desarrollador principal

---
**¡La app está lista para usar! 🎉**
