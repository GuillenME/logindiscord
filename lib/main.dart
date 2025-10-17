import 'package:flutter/material.dart';
import '/screens/login_screen.dart';
import '/screens/home_screen.dart';
import '/screens/profile_screen.dart';
import '/services/discord_auth_service.dart';
import '/services/auth_service.dart';
import '/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RootApp());
}

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    // Mostrar splash durante 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      // Mientras el splash esté activo
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      );
    }

    // Luego continúa con el flujo original (MyApp)
    return const MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discord Login App',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF5865F2), // Discord blurple
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
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
    final discordLoggedIn = await DiscordAuthService.isLoggedIn();
    final localLoggedIn = await AuthService.isLoggedInLocally();
    setState(() {
      _isLoggedIn = discordLoggedIn || localLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF2C2F33),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF5865F2),
          ),
        ),
      );
    }

    return _isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}
