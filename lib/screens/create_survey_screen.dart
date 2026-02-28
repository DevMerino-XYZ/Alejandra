import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class CreateSurveyScreen extends StatefulWidget {
  const CreateSurveyScreen({super.key});
  @override
  State<CreateSurveyScreen> createState() => _CreateSurveyScreenState();
}

class _CreateSurveyScreenState extends State<CreateSurveyScreen> {
  final _titleController = TextEditingController();
  final _nomTypeController = TextEditingController();
  final List<TextEditingController> _qControllers = [TextEditingController()];

  void _save() async {
    if (_titleController.text.isEmpty) return;
    
    final questions = _qControllers
        .where((c) => c.text.isNotEmpty)
        .map((c) => {"questionText": c.text, "section": "General"})
        .toList();

    await FirestoreService().createSurvey({
      "title": _titleController.text,
      "nomType": _nomTypeController.text,
      "questions": questions,
    });
    
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva NOM"), actions: [IconButton(onPressed: _save, icon: const Icon(Icons.check))]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Título de la Encuesta")),
          TextField(controller: _nomTypeController, decoration: const InputDecoration(labelText: "Tipo de NOM (Ej: NOM-035)")),
          const Divider(height: 30),
          ..._qControllers.asMap().entries.map((e) => Row(
            children: [
              Expanded(child: TextField(controller: e.value, decoration: InputDecoration(labelText: "Pregunta ${e.key + 1}"))),
              IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _qControllers.removeAt(e.key))),
            ],
          )),
          TextButton.icon(onPressed: () => setState(() => _qControllers.add(TextEditingController())), 
            icon: const Icon(Icons.add), label: const Text("Añadir Pregunta")),
        ],
      ),
    );
  }
}