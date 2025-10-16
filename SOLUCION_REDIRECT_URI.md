# 🔧 Solución: Redirect URI de OAuth2 no válido

## 🎯 **PROBLEMA:**
Discord está rechazando el redirect URI porque no está configurado correctamente en tu aplicación de Discord.

## ✅ **SOLUCIÓN PASO A PASO:**

### **1. Ve a Discord Developer Portal:**
- URL: https://discord.com/developers/applications
- Selecciona tu aplicación (ID: 1426988695986110464)

### **2. Configura OAuth2:**
- Ve a la sección **"OAuth2"** en el menú lateral
- Busca la sección **"Redirects"**

### **3. Agrega las URLs de redirección:**

#### **Para Web (Chrome):**
```
http://localhost:3001/callback
```

#### **Para Android/Windows:**
```
com.example.logindiscord://oauth
```

### **4. Configura los Scopes:**
Asegúrate de tener seleccionados:
- ✅ `identify` (para información básica del usuario)
- ✅ `email` (para obtener el email del usuario)

### **5. Guarda los cambios:**
- Haz clic en **"Save Changes"**

## 🔍 **VERIFICACIÓN:**

### **URLs que debes agregar en Discord:**
1. `http://localhost:3001/callback` (para web)
2. `com.example.logindiscord://oauth` (para Android/Windows)

### **Configuración actual en tu código:**
- **Web:** `http://localhost:3001/callback`
- **Android/Windows:** `com.example.logindiscord://oauth`

## 🚀 **PRUEBA:**

### **Para Web:**
```bash
flutter run -d chrome --web-port 3001
```
- Abre: http://localhost:3001
- Configura Discord con: `http://localhost:3001/callback`

### **Para Android (cuando funcione):**
```bash
flutter run -d emulator-5554
```
- Configura Discord con: `com.example.logindiscord://oauth`

## ⚠️ **IMPORTANTE:**

1. **Las URLs deben coincidir EXACTAMENTE**
2. **No agregues espacios extra**
3. **Usa http (no https) para localhost**
4. **Guarda los cambios en Discord**

## 🎯 **PASOS RÁPIDOS:**

1. **Discord Developer Portal** → Tu aplicación
2. **OAuth2** → **Redirects**
3. **Agregar:** `http://localhost:3001/callback`
4. **Agregar:** `com.example.logindiscord://oauth`
5. **Scopes:** `identify` y `email`
6. **Save Changes**
7. **Probar la aplicación**

¡Después de esto, el login con Discord debería funcionar perfectamente!
