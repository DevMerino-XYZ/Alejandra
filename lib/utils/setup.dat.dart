import '../services/firestore_service.dart';

class SurveySeeder {
  static Future<void> uploadNOMs() async {
    final firestore = FirestoreService();

    // EJEMPLO ESTRUCTURADO PARA NOM-001
    await firestore.createSurvey({
      "title": "Condiciones de Seguridad en Edificios e Instalaciones",
      "nomType": "NOM-001-STPS-2008",
      "createdAt": DateTime.now(),
      "questions": [
        // SECCIÓN: Áreas de Tránsito y Pisos
        {"section": "Áreas de Tránsito", "questionText": "¿Los pisos se encuentran libres de humedad?"},
        {"section": "Áreas de Tránsito", "questionText": "¿Existen desniveles o agujeros no señalizados?"},
        // ... Agrega las 10 de esta sección
        
        // SECCIÓN: Techos, Paredes y Estructuras
        {"section": "Techos y Paredes", "questionText": "¿Los techos presentan filtraciones o goteras?"},
        // ... Y así sucesivamente
      ]
    });

    // REPETIR PARA NOM-025
    await firestore.createSurvey({
      "title": "Condiciones de Iluminación en los Centros de Trabajo",
      "nomType": "NOM-025-STPS-2008",
      "createdAt": DateTime.now(),
      "questions": [
        {"section": "Niveles de Iluminación", "questionText": "¿Se cuenta con estudio de luxometría?"},
        {"section": "Mantenimiento", "questionText": "¿Existe programa de limpieza de luminarias?"},
      ]
    });
  }
}