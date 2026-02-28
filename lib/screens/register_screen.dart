import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _employeeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _companyController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _loading = false;
  String? _error;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _authService.register(
        fullName: _nameController.text.trim(),
        employeeId: _employeeController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        company: _companyController.text.trim(),
      );

      // Limpia los campos después del registro
      _nameController.clear();
      _employeeController.clear();
      _emailController.clear();
      _passwordController.clear();
      _companyController.clear();

      if (mounted) Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = "Error: ${e.toString()}");
    }

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _employeeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Auditor")),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: 400,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      const Text(
                        "Create Auditor Account",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Full Name
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: "Full Name"),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? "Required" : null,
                      ),
                      const SizedBox(height: 12),

                      // Employee ID
                      TextFormField(
                        controller: _employeeController,
                        decoration: const InputDecoration(labelText: "Employee ID"),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? "Required" : null,
                      ),
                      const SizedBox(height: 12),

                      // Company
                      TextFormField(
                        controller: _companyController,
                        decoration: const InputDecoration(labelText: "Company"),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? "Required" : null,
                      ),
                      const SizedBox(height: 12),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: "Email"),
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Required";
                          if (!v.contains("@")) return "Invalid email";
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "Password"),
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Required";
                          if (v.length < 6) return "Minimum 6 characters";
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      if (_error != null)
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 10),

                      _loading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _register,
                              child: const Text("Register"),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}