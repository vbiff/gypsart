class CalculationResult {
  final int moldVolumeInMl;
  final double gypsumAmount;
  final double microcementAmount;
  final double svvAmount;
  final double colorantAmount;
  final double waterAmount;
  final String gypsumType;
  final String solutionType;
  final int colorantPercentage;

  const CalculationResult({
    required this.moldVolumeInMl,
    required this.gypsumAmount,
    required this.microcementAmount,
    required this.svvAmount,
    required this.colorantAmount,
    required this.waterAmount,
    required this.gypsumType,
    required this.solutionType,
    required this.colorantPercentage,
  });
}
