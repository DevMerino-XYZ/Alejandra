import 'package:flutter/material.dart';

class SurveyHistoryScreen extends StatelessWidget {
  const SurveyHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Historial"),
      ),
      body: const Center(
        child: Text(
          "Aquí podrás revisar todas las auditorías enviadas.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}