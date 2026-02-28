class QuestionModel {
  final String id;
  final String text;
  final String type;
  final String scaleId;
  final int order;
  final bool required;
  final int weight;

  QuestionModel({
    required this.id,
    required this.text,
    required this.type,
    required this.scaleId,
    required this.order,
    required this.required,
    required this.weight,
  });

  factory QuestionModel.fromMap(String id, Map<String, dynamic> map) {
    return QuestionModel(
      id: id,
      text: map['text'],
      type: map['type'],
      scaleId: map['scaleId'],
      order: map['order'],
      required: map['required'],
      weight: map['weight'],
    );
  }
}