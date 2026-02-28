import '../services/firestore_service.dart';

class SeedData {
  static Future<void> cargarNOM001() async {
    await FirestoreService().createSurvey({
      "title": "Edificios, locales, instalaciones y áreas en los centros de trabajo",
      "nomType": "NOM-001-STPS-2008",
      "questions": [
        {"section": "Áreas de Tránsito", "questionText": "¿Los pisos se encuentran libres de humedad?"},
        {"section": "Áreas de Tránsito", "questionText": "¿Existen desniveles o agujeros no señalizados?"},
        // Aquí agregarías el resto de las 130 preguntas...
      ]
    });
  }
}