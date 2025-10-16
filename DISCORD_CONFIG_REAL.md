# 🔧 Configuración de Discord para Autenticación Real

## 📋 PASOS PARA CONFIGURAR DISCORD:

### 1. **Ve a Discord Developer Portal:**
- URL: https://discord.com/developers/applications
- Selecciona tu aplicación (ID: 1426988695986110464)

### 2. **Configura OAuth2:**
- Ve a **"OAuth2"** en el menú lateral
- Busca la sección **"Redirects"**

### 3. **AGREGA ESTAS URLs (IMPORTANTE):**
```
http://localhost:3001
http://localhost:3001/callback
com.example.logindiscord://oauth
```

### 4. **Configura los Scopes:**
- ✅ `identify`
- ✅ `email`

### 5. **Guarda los cambios**

## 🚀 DESPUÉS DE CONFIGURAR:

1. **Ejecuta la aplicación:**
   ```bash
   flutter run -d chrome --web-port 3001
   ```

2. **Ve a:** http://localhost:3001

3. **Haz clic en "Iniciar sesión con Discord"**

4. **Autoriza en Discord**

5. **¡Debería funcionar con tu cuenta real!**

## 🔍 DEBUGGING:

Si hay problemas, revisa la consola del terminal para ver los logs:
- `Iniciando autenticación con Discord...`
- `URL de autenticación: ...`
- `Resultado de autenticación: ...`
- `Código obtenido: ...`
- `Token obtenido exitosamente`
- `Usuario obtenido: ...`

## ⚠️ NOTAS IMPORTANTES:

- **Asegúrate de que Discord tenga configurado:** `http://localhost:3001`
- **No uses** `http://localhost:3001/callback` como redirect URI principal
- **La aplicación debe estar corriendo** en el puerto 3001
- **Los scopes `identify` y `email` deben estar marcados**
