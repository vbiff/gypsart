import '../entities/calculation_result.dart';
import '../entities/gypsum_type.dart';
import '../entities/solution_type.dart';

abstract class CalculationRepository {
  Future<List<GypsumType>> getGypsumTypes();
  Future<List<SolutionType>> getSolutionTypes();
  CalculationResult calculateIngredients({
    required int moldVolumeInMl,
    required String gypsumType,
    required String solutionType,
    required int colorantPercentage,
  });
}
