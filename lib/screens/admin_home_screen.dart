import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/survey_model.dart';
import 'create_survey_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panel Admin")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateSurveyScreen())),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Survey>>(
        stream: FirestoreService().getSurveysStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              final item = snapshot.data![i];
              return ListTile(
                title: Text(item.title),
                subtitle: Text(item.nomType),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => FirestoreService().deleteSurvey(item.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}