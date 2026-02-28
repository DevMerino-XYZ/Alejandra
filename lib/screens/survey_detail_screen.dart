import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/inspection_model.dart';

class SurveyDetailScreen extends StatefulWidget {
  final String surveyId;
  final Map<String, dynamic> surveyData;
  const SurveyDetailScreen({super.key, required this.surveyId, required this.surveyData});

  @override
  State<SurveyDetailScreen> createState() => _SurveyDetailScreenState();
}

class _SurveyDetailScreenState extends State<SurveyDetailScreen> {
  final Map<int, bool?> _answers = {};
  bool _loading = false;

  void _enviar() async {
    final List questions = widget.surveyData['questions'] ?? [];
    if (_answers.length < questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Responde todas las preguntas")));
      return;
    }

    setState(() => _loading = true);
    final user = FirebaseAuth.instance.currentUser;
    
    final inspection = Inspection(
      id: '',
      surveyId: widget.surveyId,
      surveyTitle: widget.surveyData['title'],
      userId: user?.uid ?? '',
      userName: user?.email ?? 'Auditor',
      date: DateTime.now(),
      answers: List.generate(questions.length, (i) => {
        "questionText": questions[i]["questionText"],
        "section": questions[i]["section"],
        "response": _answers[i] == true ? "Sí" : "No",
      }),
    );

    await FirestoreService().saveInspection(inspection);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List questions = widget.surveyData['questions'] ?? [];
    // Agrupar preguntas por sección
    Map<String, List<int>> groups = {};
    for (int i = 0; i < questions.length; i++) {
      String sec = questions[i]['section'] ?? 'General';
      groups.putIfAbsent(sec, () => []).add(i);
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.surveyData['nomType'] ?? "NOM")),
      body: _loading ? const Center(child: CircularProgressIndicator()) : Column(
        children: [
          Expanded(
            child: ListView(
              children: groups.entries.map((entry) => ExpansionTile(
                title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                children: entry.value.map((index) => ListTile(
                  title: Text(questions[index]['questionText']),
                  subtitle: Row(
                    children: [
                      ChoiceChip(label: const Text("Sí"), selected: _answers[index] == true, onSelected: (_) => setState(() => _answers[index] = true)),
                      const SizedBox(width: 8),
                      ChoiceChip(label: const Text("No"), selected: _answers[index] == false, onSelected: (_) => setState(() => _answers[index] = false)),
                    ],
                  ),
                )).toList(),
              )).toList(),
            ),
          ),
          ElevatedButton(onPressed: _enviar, child: const Text("GUARDAR AUDITORÍA")),
        ],
      ),
    );
  }
}