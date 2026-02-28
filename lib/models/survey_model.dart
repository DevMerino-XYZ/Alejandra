class Survey {
  final String id;
  final String title;
  final String nomType;
  final List<Map<String, dynamic>> questions;

  Survey({required this.id, required this.title, required this.nomType, required this.questions});

  factory Survey.fromFirestore(Map<String, dynamic> data, String id) {
    return Survey(
      id: id,
      title: data['title'] ?? '',
      nomType: data['nomType'] ?? '',
      questions: List<Map<String, dynamic>>.from(data['questions'] ?? []),
    );
  }
}