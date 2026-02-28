class ResponseModel {
  final String questionId;
  final String questionText;
  final int selectedValue;
  final String selectedLabel;
  final int weight;
  final double score;
  final String? observation;

  ResponseModel({
    required this.questionId,
    required this.questionText,
    required this.selectedValue,
    required this.selectedLabel,
    required this.weight,
    required this.score,
    this.observation,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'questionText': questionText,
      'selectedValue': selectedValue,
      'selectedLabel': selectedLabel,
      'weight': weight,
      'score': score,
      'observation': observation,
    };
  }
}