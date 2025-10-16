import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2F33), // Discord dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF23272A),
        elevation: 0,
        title: const Text(
          'Sobre Nosotros',
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
        child: Column(
          children: [
            // Header section
            _buildHeaderSection(),
            const SizedBox(height: 30),

            // Team members section
            _buildTeamSection(),
            const SizedBox(height: 30),

            // Project info section
            _buildProjectInfoSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
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
      child: Column(
        children: [
          const Icon(
            Icons.group,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Nuestro Equipo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Desarrolladores de la aplicación Discord Login',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    final teamMembers = [
      {
        'name': 'Mariana Eurice',
        'role': 'Desarrolladora Principal',
        'description': 'Especialista en Flutter y desarrollo móvil',
        'avatar': '👨‍💻',
        'skills': ['Flutter', 'Dart', 'Mobile Development'],
      },
      {
        'name': 'Froilan',
        'role': 'Diseñador UX/UI',
        'description':
            'Experta en diseño de interfaces y experiencia de usuario',
        'avatar': '👩‍🎨',
        'skills': ['UI/UX Design'],
      },
      {
        'name': 'Hugo ruben',
        'role': 'Desarrollador Backend',
        'description': 'Especialista en APIs y integración con Discord',
        'avatar': '👨‍🔧',
        'skills': ['APIs', 'Discord Integration'],
      },
      {
        'name': 'José Alejandro',
        'role': 'QA Tester',
        'description': 'Responsable de testing y calidad del software',
        'avatar': '👩‍🔬',
        'skills': ['Testing', 'Bug Tracking'],
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Integrantes del Equipo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...teamMembers.map((member) => _buildTeamMemberCard(member)).toList(),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(Map<String, dynamic> member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF23272A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF40444B),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF5865F2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                member['avatar'],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Member info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member['role'],
                  style: const TextStyle(
                    color: Color(0xFF5865F2),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  member['description'],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: (member['skills'] as List<String>).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF40444B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF23272A),
          borderRadius: BorderRadius.circular(12),
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
                Icon(Icons.school, color: Color(0xFF5865F2), size: 24),
                SizedBox(width: 8),
                Text(
                  'Información del Proyecto',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Materia:', 'Desarrollo de Aplicaciones Móviles'),
            _buildInfoRow(
                'Universidad:', 'Universidad Tecnológica de la selva'),
            _buildInfoRow('Cuatrimestre:', '10 Cuatrimestre'),
            _buildInfoRow('Profesor:', 'Dr. Armando Morales'),
            _buildInfoRow('Fecha y Año:', '16/10/2025'),
            const SizedBox(height: 16),
            const Text(
              'Este proyecto fue desarrollado como parte de los requerimientos académicos para la materia de Desarrollo de Aplicaciones Móviles, utilizando Flutter y la API de Discord para crear una aplicación de autenticación moderna y funcional.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                height: 1.5,
              ),
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
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
