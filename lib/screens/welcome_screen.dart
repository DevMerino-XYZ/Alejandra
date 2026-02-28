import 'package:flutter/material.dart';

import 'create_survey_screen.dart';
import 'survey_history_screen.dart';
import 'admin_home_screen.dart';
import 'survey_list_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final String fullName;
  final String role;

  const WelcomeScreen({
    super.key,
    required this.fullName,
    required this.role,
  });

  bool get isAdmin => role == "admin" || role == "auxiliar";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 👋 BIENVENIDA
              Text(
                "Bienvenido, $fullName 👋",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "¿Qué deseas hacer hoy?",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),

              /// 🔷 BOTONES PRINCIPALES
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _ActionCard(
                    title: "Nueva Auditoría",
                    icon: Icons.play_circle_fill_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SurveyListScreen(),
                        ),
                      );
                    },
                  ),
                  _ActionCard(
                    title: "Mi Historial",
                    icon: Icons.history_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SurveyHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  if (isAdmin)
                    _ActionCard(
                      title: "Panel Administrador",
                      icon: Icons.admin_panel_settings_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminHomeScreen(),
                          ),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 40),

              /// DIVISIÓN
              Divider(
                thickness: 1.2,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 20),

              /// ENCUESTAS DISPONIBLES
              Text(
                "Encuestas Disponibles",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              /// LISTA DE ENCUESTAS (placeholder)
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text("Encuesta ISO 9001 - v${index + 1}"),
                        subtitle: const Text("Estado: Activa"),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SurveyListScreen(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔹 WIDGET PRIVADO PARA BOTONES PRINCIPALES
class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 120,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}