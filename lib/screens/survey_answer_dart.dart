import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/survey_model.dart';
import '../models/inspection_model.dart';
import '../services/firestore_service.dart';

class SurveyAnswerScreen extends StatefulWidget {
  final Survey survey;

  const SurveyAnswerScreen({
    super.key,
    required this.survey,
  });

  @override
  State<SurveyAnswerScreen> createState() => _SurveyAnswerScreenState();
}

class _SurveyAnswerScreenState extends State<SurveyAnswerScreen> {
  // Mapa para guardar las respuestas: { índice_pregunta: "Sí/No/N/A" }
  final Map<int, String> _responses = {};
  bool _isProcessing = false;

  void _finishSurvey() async {
    // 1. Validación de seguridad
    if (_responses.length < widget.survey.questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Responde todas las preguntas.")),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      
      // 2. Mapeo de respuestas al formato del modelo Inspection
      final List<Map<String, dynamic>> finalAnswers = List.generate(
        widget.survey.questions.length,
        (i) => {
          "questionText": widget.survey.questions[i]['questionText'],
          "section": widget.survey.questions[i]['section'] ?? "General",
          "response": _responses[i],
        },
      );

      // 3. Creación del objeto de inspección
      final inspection = Inspection(
        id: '', // Firestore genera el ID automáticamente
        surveyId: widget.survey.id,
        surveyTitle: widget.survey.title,
        userId: user?.uid ?? 'anon_id',
        userName: user?.email ?? 'Usuario Anónimo',
        date: DateTime.now(),
        answers: finalAnswers,
      );

      // 4. Guardado real en Firebase
      await FirestoreService().saveInspection(inspection);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Auditoría guardada en la nube con éxito"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error al guardar: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // El resto de tu código de diseño (UI) se mantiene igual, 
    // solo asegúrate de que el botón use la nueva lógica de _finishSurvey
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.survey.title),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.survey.questions.length,
              itemBuilder: (context, index) {
                final q = widget.survey.questions[index];
                return _buildQuestionCard(q, index);
              },
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // Componente de Tarjeta de Pregunta (Extraído para limpieza)
  Widget _buildQuestionCard(Map<String, dynamic> q, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("PREGUNTA ${index + 1}", 
                  style: TextStyle(color: Colors.blue[800], fontSize: 11, fontWeight: FontWeight.bold)),
                _buildSectionBadge(q['section'] ?? "GENERAL"),
              ],
            ),
            const SizedBox(height: 12),
            Text(q['questionText'], 
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            _buildChoiceChips(index),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)),
      child: Text(text.toUpperCase(), style: TextStyle(color: Colors.blue[900], fontSize: 9)),
    );
  }

  Widget _buildChoiceChips(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ["Sí", "No", "N/A"].map((option) {
        final isSelected = _responses[index] == option;
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) setState(() => _responses[index] = option);
          },
        );
      }).toList(),
    );
  }

  Widget _buildBottomBar() {
    bool isComplete = _responses.length == widget.survey.questions.length;
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: isComplete ? _finishSurvey : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          minimumSize: const Size.fromHeight(50),
        ),
        child: Text(isComplete ? "FINALIZAR AUDITORÍA" : "FALTAN RESPUESTAS"),
      ),
    );
  }
}