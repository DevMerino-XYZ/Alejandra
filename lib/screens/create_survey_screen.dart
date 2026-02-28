import 'package:flutter/material.dart';

class CreateSurveyScreen extends StatelessWidget {
  const CreateSurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Encuesta"),
      ),
      body: const Center(
        child: Text(
          "Aquí se creará una nueva encuesta para el sistema.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}