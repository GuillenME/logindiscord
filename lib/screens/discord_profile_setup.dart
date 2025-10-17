import 'package:flutter/material.dart';
import '/services/discord_auth_service.dart';

class DiscordProfileSetup extends StatefulWidget {
  const DiscordProfileSetup({Key? key}) : super(key: key);

  @override
  State<DiscordProfileSetup> createState() => _DiscordProfileSetupState();
}

class _DiscordProfileSetupState extends State<DiscordProfileSetup> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _globalNameController = TextEditingController();
  final _discordIdController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _globalNameController.dispose();
    _discordIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2F33),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23272A),
        elevation: 0,
        title: const Text(
          'Configurar Perfil Discord',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5865F2), Color(0xFF7289DA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Configurar tu Perfil de Discord',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ingresa tus datos reales de Discord para sincronizar tu perfil',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Form fields
              _buildTextField(
                controller: _usernameController,
                label: 'Username de Discord',
                hint: 'mariana06',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu username de Discord';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _globalNameController,
                label: 'Nombre Global (opcional)',
                hint: 'Mariana',
                icon: Icons.badge,
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _emailController,
                label: 'Email de Discord',
                hint: 'mariana@discord.com',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu email de Discord';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Ingresa un email válido';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _discordIdController,
                label: 'ID de Discord (opcional)',
                hint: '123456789012345678',
                icon: Icons.fingerprint,
                keyboardType: TextInputType.number,
              ),
              
              const SizedBox(height: 24),
              
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF23272A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF40444B)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Cómo obtener estos datos?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Abre Discord en tu navegador\n'
                      '2. Haz clic derecho en tu avatar\n'
                      '3. Selecciona "Copiar ID de usuario"\n'
                      '4. Tu username aparece en la parte inferior izquierda',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Save button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5865F2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Guardar Perfil de Discord',
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: const Color(0xFF5865F2)),
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
        fillColor: const Color(0xFF23272A),
      ),
      validator: validator,
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Crear datos de Discord con la información proporcionada
      final discordData = {
        'id': _discordIdController.text.isNotEmpty 
            ? _discordIdController.text 
            : _usernameController.text.hashCode.toString(),
        'username': _usernameController.text.trim(),
        'discriminator': '0001',
        'global_name': _globalNameController.text.trim().isNotEmpty 
            ? _globalNameController.text.trim() 
            : _usernameController.text.trim(),
        'avatar': null,
        'email': _emailController.text.trim(),
        'verified': true,
        'created_at': DateTime.now().subtract(const Duration(days: 365)).toIso8601String(),
        'premium_type': null,
        'locale': 'es',
      };

      // Simular algunos servidores
      final guilds = [
        {
          'id': '111111111111111111',
          'name': 'Servidor de Prueba',
          'icon': null,
        },
        {
          'id': '222222222222222222',
          'name': 'Gaming Community',
          'icon': null,
        },
      ];

      // Guardar datos de Discord
      await DiscordAuthService.saveAuthData(
        'manual_token_${DateTime.now().millisecondsSinceEpoch}',
        discordData,
        guilds,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Perfil de Discord configurado para ${discordData['username']}!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Navegar al home
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar perfil: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
