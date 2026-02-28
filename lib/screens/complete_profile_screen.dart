import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  /// Guarda los datos adicionales en Firestore y marca el perfil como completado
  Future<void> _saveProfile() async {
    // 1. Validar el formulario
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {
        // 2. Llamar al servicio para actualizar los datos
        await AuthService().updateUserProfile(user.uid, {
          "displayName": _nameController.text.trim(),
          "companyName": _companyController.text.trim(),
          "profileCompleted": true,
          "role": "user", // Rol asignado por defecto al completar perfil
          "lastUpdate": DateTime.now().toIso8601String(),
        });

        // NOTA: El AuthGate en main.dart reaccionará al cambio en el 
        // documento de Firestore y redirigirá al UserHomeScreen.
      }
    } catch (e) {
      _showErrorSnackBar("Error al guardar perfil: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar sencilla con opción de salir
      appBar: AppBar(
        title: const Text("Perfil de Auditor"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: "Cerrar sesión",
            onPressed: () => AuthService().logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icono Ilustrativo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.badge_outlined, 
                      size: 80, 
                      color: Colors.blue
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Información Adicional",
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.blueGrey
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Estos datos aparecerán en los reportes de auditoría generados por el sistema.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  const SizedBox(height: 40),

                  // Campo Nombre
                  _buildTextFormField(
                    controller: _nameController,
                    label: "Nombre completo",
                    icon: Icons.person_pin_outlined,
                    hint: "Ej. Juan Pérez",
                  ),
                  const SizedBox(height: 20),

                  // Campo Empresa
                  _buildTextFormField(
                    controller: _companyController,
                    label: "Nombre de la empresa",
                    icon: Icons.business_center_outlined,
                    hint: "Ej. Auditorías Globales S.A.",
                  ),
                  const SizedBox(height: 40),

                  // Botón de acción
                  _loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "GUARDAR Y CONTINUAR",
                              style: TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  const Text(
                    "Tus datos están protegidos por encriptación de extremo a extremo.",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper para construir los inputs con estilo consistente
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Este campo es obligatorio";
        }
        if (value.trim().length < 3) {
          return "Ingresa un nombre válido";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blue),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.blue, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
      ),
    );
  }
}