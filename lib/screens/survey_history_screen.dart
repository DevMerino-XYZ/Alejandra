import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import '../models/inspection_model.dart';

class SurveyHistoryScreen extends StatelessWidget {
  const SurveyHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ID del usuario actual para filtrar sus resultados
    final userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Auditorías"), 
        backgroundColor: const Color(0xFF1A237E), 
        foregroundColor: Colors.white
      ),
      body: StreamBuilder<List<Inspection>>(
        // Llama al método que agregamos en el FirestoreService
        stream: FirestoreService().getUserInspectionsStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No tienes auditorías registradas", 
                style: TextStyle(fontSize: 16, color: Colors.grey))
            );
          }

          final docs = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: docs.length,
            itemBuilder: (context, i) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8EAF6),
                  child: Icon(Icons.assignment_turned_in, color: Color(0xFF1A237E)),
                ),
                title: Text(docs[i].surveyTitle, 
                  style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(docs[i].date)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showResults(context, docs[i]),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showResults(BuildContext context, Inspection ins) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        children: [
          // Encabezado del BottomSheet
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(ins.surveyTitle, 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
                ),
                const Icon(Icons.history_edu, color: Colors.indigo),
              ],
            ),
          ),
          const Divider(height: 1),
          // Lista de respuestas
          Expanded(
            child: ListView.builder(
              itemCount: ins.answers.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(ins.answers[i]['questionText'] ?? "Pregunta"),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ins.answers[i]['response'] == "Sí" 
                        ? Colors.green.withOpacity(0.1) 
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ins.answers[i]['response'] ?? "N/A", 
                    style: TextStyle(
                      color: ins.answers[i]['response'] == "Sí" ? Colors.green : Colors.red, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}