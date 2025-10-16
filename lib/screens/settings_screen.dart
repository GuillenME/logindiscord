import 'package:flutter/material.dart';
import '/config/discord_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _clientIdController = TextEditingController();
  final _clientSecretController = TextEditingController();
  bool _isConfigured = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentConfig();
  }

  @override
  void dispose() {
    _clientIdController.dispose();
    _clientSecretController.dispose();
    super.dispose();
  }

  void _loadCurrentConfig() {
    setState(() {
      _clientIdController.text = DiscordConfig.clientId;
      _clientSecretController.text = DiscordConfig.clientSecret;
      _isConfigured = DiscordConfig.isConfigured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2F33),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23272A),
        elevation: 0,
        title: const Text(
          'Configuración',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Discord OAuth Configuration
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF23272A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isConfigured ? Colors.green : Colors.orange,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isConfigured ? Icons.check_circle : Icons.warning,
                        color: _isConfigured ? Colors.green : Colors.orange,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Discord OAuth',
                        style: TextStyle(
                          color: _isConfigured ? Colors.green : Colors.orange,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isConfigured 
                        ? 'Configurado correctamente'
                        : 'No configurado - Usando datos simulados',
                    style: TextStyle(
                      color: _isConfigured ? Colors.green : Colors.orange,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Client ID Field
                  TextFormField(
                    controller: _clientIdController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Client ID',
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintText: '123456789012345678',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF40444B)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF5865F2)),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF2C2F33),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Client Secret Field
                  TextFormField(
                    controller: _clientSecretController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Client Secret',
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintText: 'abcdefghijklmnopqrstuvwxyz123456',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF40444B)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF5865F2)),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF2C2F33),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Instructions
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2F33),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF40444B)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cómo obtener las credenciales:',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '1. Ve a https://discord.com/developers/applications\n'
                          '2. Crea una nueva aplicación\n'
                          '3. Ve a OAuth2 > General\n'
                          '4. Copia Client ID y Client Secret\n'
                          '5. En Redirects, agrega: com.example.logindiscord://oauth',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _saveConfiguration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5865F2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Guardar Configuración',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Current Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF23272A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF40444B),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estado actual:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isConfigured 
                        ? '✅ Discord OAuth configurado - Verás tu perfil real'
                        : '⚠️ Discord OAuth no configurado - Verás datos simulados',
                    style: TextStyle(
                      color: _isConfigured ? Colors.green : Colors.orange,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveConfiguration() {
    // Note: In a real app, you would save this to a config file or secure storage
    // For now, we'll just show a message that the user needs to manually update the config file
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF23272A),
        title: const Text(
          'Configuración Manual Requerida',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Para configurar Discord OAuth, necesitas editar manualmente el archivo:\n\n'
          'lib/config/discord_config.dart\n\n'
          'Reemplaza:\n'
          'clientId = "YOUR_DISCORD_CLIENT_ID_HERE"\n'
          'clientSecret = "YOUR_DISCORD_CLIENT_SECRET_HERE"\n\n'
          'Con tus credenciales reales:\n'
          'clientId = "${_clientIdController.text}"\n'
          'clientSecret = "${_clientSecretController.text}"',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Entendido',
              style: TextStyle(color: Color(0xFF5865F2)),
            ),
          ),
        ],
      ),
    );
  }
}
