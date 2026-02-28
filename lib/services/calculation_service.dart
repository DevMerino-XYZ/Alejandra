class CalculationService {

  static double calculateScore({
    required int selectedValue,
    required int weight,
  }) {
    return selectedValue * weight;
  }

  static double calculatePercentage({
    required double scoreTotal,
    required double maxScore,
  }) {
    return (scoreTotal / maxScore) * 100;
  }
}