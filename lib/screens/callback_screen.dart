import 'package:flutter/material.dart';
import '../services/discord_auth_service.dart';

class CallbackScreen extends StatefulWidget {
  const CallbackScreen({Key? key}) : super(key: key);

  @override
  State<CallbackScreen> createState() => _CallbackScreenState();
}

class _CallbackScreenState extends State<CallbackScreen> {
  bool _isLoading = true;
  String _status = 'Procesando autorización...';

  @override
  void initState() {
    super.initState();
    _processCallback();
  }

  Future<void> _processCallback() async {
    try {
      setState(() {
        _status = 'Intercambiando código por token...';
      });

      // Simular el proceso de autenticación
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _status = 'Obteniendo información del usuario...';
      });

      // Simular obtención de datos del usuario
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _status = '¡Autenticación exitosa!';
        _isLoading = false;
      });

      // Simular que el login fue exitoso
      await Future.delayed(const Duration(seconds: 1));

      // Cerrar esta ventana y volver a la aplicación principal
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _status = 'Error en la autenticación: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticación Discord'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.security,
              size: 64,
              color: Colors.indigo,
            ),
            const SizedBox(height: 24),
            if (_isLoading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
            ],
            Text(
              _status,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (!_isLoading) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Continuar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
