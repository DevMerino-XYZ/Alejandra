import 'package:flutter/material.dart';

class SurveyListScreen extends StatelessWidget {
  const SurveyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva Auditoría"),
      ),
      body: const Center(
        child: Text(
          "Aquí se mostrarán las encuestas disponibles\npara iniciar una nueva auditoría.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}