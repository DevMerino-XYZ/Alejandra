import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/survey_model.dart';
import 'survey_detail_screen.dart';

class SurveyListScreen extends StatelessWidget {
  const SurveyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seleccionar NOM")),
      body: StreamBuilder<List<Survey>>(
        stream: FirestoreService().getSurveysStream(), // Llama al método que definimos en el servicio
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final surveys = snapshot.data ?? [];
          if (surveys.isEmpty) {
            return const Center(child: Text("No hay plantillas disponibles"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: surveys.length,
            itemBuilder: (context, i) {
              final survey = surveys[i];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  title: Text(survey.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Referencia: ${survey.nomType}"),
                  trailing: const Icon(Icons.play_arrow_rounded, color: Colors.green),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SurveyDetailScreen(
                          surveyId: survey.id,
                          surveyData: {
                            'title': survey.title,
                            'questions': survey.questions,
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}