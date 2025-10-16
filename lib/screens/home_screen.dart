import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/services/discord_auth_service.dart';
import '/services/auth_service.dart';
import '/screens/profile_screen.dart';
import '/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Try Discord first
    final discordData = await DiscordAuthService.getStoredUserData();
    if (discordData != null) {
      setState(() {
        userData = discordData;
        isLoading = false;
      });
    } else {
      // Try local auth
      final localUser = await AuthService.getCurrentUser();
      if (localUser != null) {
        final profileData = await AuthService.getUserProfile(localUser['email']!);
        setState(() {
          userData = profileData;
          isLoading = false;
        });
      } else {
        setState(() {
          userData = null;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF2C2F33),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF5865F2),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF2C2F33),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23272A),
        elevation: 0,
        title: const Text(
          'Discord App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          // Profile button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userData: userData),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF5865F2),
                    backgroundImage: userData?['avatar'] != null
                        ? NetworkImage('https://cdn.discordapp.com/avatars/${userData!['id']}/${userData!['avatar']}.png')
                        : null,
                    child: userData?['avatar'] == null
                        ? Text(
                            userData?['username']?[0]?.toUpperCase() ?? 'U',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    userData?['username'] ?? 'Usuario',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
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
                  Text(
                    '¡Bienvenido, ${userData?['global_name'] ?? userData?['username'] ?? 'Usuario'}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Has iniciado sesión exitosamente con Discord',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick actions
            const Text(
              'Acciones Rápidas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'Ver Perfil',
                    Icons.person,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(userData: userData),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    'Ir a Discord',
                    Icons.discord,
                    () {
                      _openDiscord();
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: _buildActionCard(
                'Cerrar Sesión',
                Icons.logout,
                () {
                  _showLogoutDialog();
                },
              ),
            ),
            
            const SizedBox(height: 24),
            
            // User info summary
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
                    'Información de la Cuenta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Usuario', userData?['username'] ?? 'N/A'),
                  _buildInfoRow('ID', userData?['id'] ?? 'N/A'),
                  _buildInfoRow('Email', userData?['email'] ?? 'N/A'),
                  _buildInfoRow('Verificado', userData?['verified'] == true ? 'Sí' : 'No'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          children: [
            Icon(
              icon,
              color: const Color(0xFF5865F2),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGuildsDialog() async {
    final guilds = await DiscordAuthService.getStoredGuilds();
    if (guilds == null || guilds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontraron servidores')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF23272A),
        title: const Text(
          'Tus Servidores',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: guilds.length,
            itemBuilder: (context, index) {
              final guild = guilds[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF5865F2),
                  backgroundImage: guild['icon'] != null
                      ? NetworkImage('https://cdn.discordapp.com/icons/${guild['id']}/${guild['icon']}.png')
                      : null,
                  child: guild['icon'] == null
                      ? Text(
                          guild['name'][0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        )
                      : null,
                ),
                title: Text(
                  guild['name'],
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'ID: ${guild['id']}',
                  style: const TextStyle(color: Colors.grey),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar', style: TextStyle(color: Color(0xFF5865F2))),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF23272A),
        title: const Text(
          'Cerrar Sesión',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Estás seguro de que quieres cerrar sesión?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              // Logout from both services
              await DiscordAuthService.logout();
              await AuthService.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
            child: const Text('Cerrar Sesión', style: TextStyle(color: Color(0xFFF04747))),
          ),
        ],
      ),
    );
  }

  Future<void> _openDiscord() async {
    try {
      const discordUrl = 'https://discord.com/login';
      final uri = Uri.parse(discordUrl);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Discord abierto en el navegador'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir Discord'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
