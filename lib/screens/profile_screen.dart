import 'package:flutter/material.dart';
import '/services/discord_auth_service.dart';
import '/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  
  const ProfileScreen({Key? key, this.userData}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  List<dynamic>? guilds;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (widget.userData != null) {
      setState(() {
        userData = widget.userData;
        isLoading = false;
      });
    } else {
      // Try Discord first
      final discordData = await DiscordAuthService.getStoredUserData();
      if (discordData != null) {
        final guildsData = await DiscordAuthService.getStoredGuilds();
        setState(() {
          userData = discordData;
          guilds = guildsData;
          isLoading = false;
        });
      } else {
        // Try local auth
        final localUser = await AuthService.getCurrentUser();
        if (localUser != null) {
          final profileData = await AuthService.getUserProfile(localUser['email']!);
          setState(() {
            userData = profileData;
            guilds = [];
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
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF2C2F33),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF5865F2),
          ),
        ),
      );
    }

    if (userData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF2C2F33),
        appBar: AppBar(
          backgroundColor: const Color(0xFF23272A),
          title: const Text(
            'Perfil',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(
          child: Text(
            'No se pudo cargar la información del usuario',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF2C2F33), // Discord dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF23272A),
        elevation: 0,
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Settings functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner section
            _buildBannerSection(),
            const SizedBox(height: 20),
            
            // Profile header with avatar and basic info
            _buildProfileHeader(),
            const SizedBox(height: 20),
            
            // User information cards
            _buildUserInfoCards(),
            const SizedBox(height: 20),
            
            // Activity section
            _buildActivitySection(),
            const SizedBox(height: 20),
            
            // Badges section
            _buildBadgesSection(),
            const SizedBox(height: 20),
            
            // Mutual servers
            _buildMutualServersSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSection() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF5865F2), // Discord blurple
            const Color(0xFF7289DA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: userData!['banner'] != null
          ? Image.network(
              'https://cdn.discordapp.com/banners/${userData!['id']}/${userData!['banner']}.png',
              fit: BoxFit.cover,
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF5865F2),
                    const Color(0xFF7289DA),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with status indicator
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF5865F2),
                backgroundImage: userData!['avatar'] != null
                    ? NetworkImage('https://cdn.discordapp.com/avatars/${userData!['id']}/${userData!['avatar']}.png')
                    : null,
                child: userData!['avatar'] == null
                    ? Text(
                        userData!['username'][0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              // Status indicator
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getStatusColor('online'), // Default to online for now
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF2C2F33),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData!['global_name'] ?? userData!['username'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${userData!['username']}#${userData!['discriminator'] ?? '0'}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF23272A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Usuario de Discord',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Account info card
          _buildInfoCard(
            'Información de la cuenta',
            'ID: ${userData!['id']}\n'
            'Email: ${userData!['email'] ?? 'No disponible'}\n'
            'Verificado: ${userData!['verified'] == true ? 'Sí' : 'No'}\n'
            'Cuenta creada: ${_formatDiscordDate(userData!['created_at'])}',
            Icons.account_circle,
          ),
          
          const SizedBox(height: 12),
          
          // Stats card
          _buildInfoCard(
            'Estadísticas',
            'Servidores: ${guilds?.length ?? 0}\n'
            'Discriminator: #${userData!['discriminator'] ?? '0'}\n'
            'Avatar: ${userData!['avatar'] != null ? 'Personalizado' : 'Por defecto'}',
            Icons.analytics_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Container(
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
          Row(
            children: [
              Icon(icon, color: const Color(0xFF5865F2), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
            const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF5865F2), size: 20),
                SizedBox(width: 8),
                Text(
                  'Información adicional',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Tipo de cuenta: ${userData!['premium_type'] != null ? 'Nitro' : 'Gratuita'}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Localización: ${userData!['locale'] ?? 'No especificada'}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
            const Row(
              children: [
                Icon(Icons.workspace_premium, color: Color(0xFF5865F2), size: 20),
                SizedBox(width: 8),
                Text(
                  'Estado de la cuenta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF40444B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('✅', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 4),
                      Text(
                        userData!['verified'] == true ? 'Verificado' : 'No verificado',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (userData!['premium_type'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF40444B),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('💎', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 4),
                        Text(
                          'Nitro',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMutualServersSection() {
    if (guilds == null || guilds!.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
            const Row(
              children: [
                Icon(Icons.dns, color: Color(0xFF5865F2), size: 20),
                SizedBox(width: 8),
                Text(
                  'Tus Servidores',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...guilds!.take(5).map<Widget>((guild) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF43B581),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        guild['name'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            if (guilds!.length > 5)
              Text(
                '... y ${guilds!.length - 5} servidores más',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return const Color(0xFF43B581);
      case 'idle':
        return const Color(0xFFFAA61A);
      case 'dnd':
        return const Color(0xFFF04747);
      case 'offline':
      default:
        return const Color(0xFF747F8D);
    }
  }

  String _formatDiscordDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
