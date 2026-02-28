class ScaleOption {
  final int value;
  final String label;

  ScaleOption({
    required this.value,
    required this.label,
  });

  factory ScaleOption.fromMap(Map<String, dynamic> map) {
    return ScaleOption(
      value: map['value'],
      label: map['label'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'label': label,
    };
  }
}

class ScaleModel {
  final String id;
  final String name;
  final List<ScaleOption> options;

  ScaleModel({
    required this.id,
    required this.name,
    required this.options,
  });

  factory ScaleModel.fromMap(String id, Map<String, dynamic> map) {
    return ScaleModel(
      id: id,
      name: map['name'],
      options: (map['options'] as List)
          .map((e) => ScaleOption.fromMap(e))
          .toList(),
    );
  }
}