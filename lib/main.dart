import 'package:flutter/material.dart';
import '/screens/login_screen.dart';
import '/screens/home_screen.dart';
import '/screens/callback_screen.dart';
import '/services/discord_auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Discord',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/callback': (context) => const CallbackScreen(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await DiscordAuthService.isLoggedIn();
      print('AuthWrapper: Estado de login inicial: $isLoggedIn');
      setState(() {
        _isLoggedIn = isLoggedIn;
        _isLoading = false;
      });
    } catch (e) {
      print('AuthWrapper: Error al verificar estado: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Método para actualizar el estado después del login
  void _onLoginSuccess() {
    print('AuthWrapper: Login exitoso, actualizando estado...');
    setState(() {
      _isLoggedIn = true;
    });
  }

  // Método para actualizar el estado después del logout
  void _onLogout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return _isLoggedIn
        ? HomeScreen(onLogout: _onLogout)
        : LoginScreen(onLoginSuccess: _onLoginSuccess);
  }
}
