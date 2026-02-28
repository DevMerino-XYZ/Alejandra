import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importante para el ID del usuario
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
  final Map<int, String> _responses = {};
  bool _isProcessing = false;

  void _finishSurvey() async {
    // 1. Validación
    if (_responses.length < widget.survey.questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Responde todas las preguntas.")),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      
      // 2. Mapear respuestas al formato de Inspection
      final List<Map<String, dynamic>> inspectionAnswers = List.generate(
        widget.survey.questions.length,
        (i) => {
          "questionText": widget.survey.questions[i]['questionText'],
          "section": widget.survey.questions[i]['section'] ?? "General",
          "response": _responses[i],
        },
      );

      // 3. Crear objeto Inspection
      final inspection = Inspection(
        id: '', // Firestore genera el ID
        surveyId: widget.survey.id,
        surveyTitle: widget.survey.title,
        userId: user?.uid ?? 'anon_id',
        userName: user?.email ?? 'Usuario Anónimo',
        date: DateTime.now(),
        answers: inspectionAnswers,
      );

      // 4. Guardar en Base de Datos
      await FirestoreService().saveInspection(inspection);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Auditoría guardada con éxito"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error al guardar: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.survey.title),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.survey.questions.length,
              itemBuilder: (context, index) {
                // CORRECCIÓN: Acceso por llave de mapa []
                final q = widget.survey.questions[index];

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
                            Text(
                              "PREGUNTA ${index + 1}",
                              style: TextStyle(
                                  color: Colors.blue[800],
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                (q['section'] ?? "General").toUpperCase(),
                                style: TextStyle(color: Colors.blue[900], fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          q['questionText'] ?? "",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ["Sí", "No", "N/A"].map((option) {
                            final isSelected = _responses[index] == option;
                            return ChoiceChip(
                              label: Text(option),
                              selected: isSelected,
                              selectedColor: Colors.blue[100],
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) _responses[index] = option;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    final bool isComplete = _responses.length == widget.survey.questions.length;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: ElevatedButton(
        onPressed: isComplete && !_isProcessing ? _finishSurvey : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: Text(
          isComplete ? "FINALIZAR AUDITORÍA" : "FALTAN RESPUESTAS (${_responses.length}/${widget.survey.questions.length})",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}