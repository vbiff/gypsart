import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/calculation_result.dart';
import '../../domain/entities/gypsum_type.dart';
import '../../domain/entities/solution_type.dart';
import '../../domain/repositories/calculation_repository.dart';
import '../../data/repositories/calculation_repository_impl.dart';

final calculationRepositoryProvider = Provider<CalculationRepository>((ref) {
  return CalculationRepositoryImpl();
});

final gypsumTypesProvider = FutureProvider<List<GypsumType>>((ref) async {
  final repository = ref.watch(calculationRepositoryProvider);
  return repository.getGypsumTypes();
});

final solutionTypesProvider = FutureProvider<List<SolutionType>>((ref) async {
  final repository = ref.watch(calculationRepositoryProvider);
  return repository.getSolutionTypes();
});

final selectedGypsumTypeProvider =
    StateProvider<String>((ref) => 'sWP8u50jSXi9pkR4aB31tw');
final selectedSolutionTypeProvider =
    StateProvider<String>((ref) => 'YO6Ha6xfTzuY8YizbJ4ssA');
final selectedColorantPercentageProvider = StateProvider<int>((ref) => 1);

final calculationResultProvider = Provider<CalculationResult?>((ref) {
  final repository = ref.watch(calculationRepositoryProvider);
  final moldVolumeInMl = ref.watch(selectedMoldVolumeProvider);
  final gypsumType = ref.watch(selectedGypsumTypeProvider);
  final solutionType = ref.watch(selectedSolutionTypeProvider);
  final colorantPercentage = ref.watch(selectedColorantPercentageProvider);

  if (moldVolumeInMl == null) return null;

  return repository.calculateIngredients(
    moldVolumeInMl: moldVolumeInMl,
    gypsumType: gypsumType,
    solutionType: solutionType,
    colorantPercentage: colorantPercentage,
  );
});

final selectedMoldVolumeProvider = StateProvider<int?>((ref) => null);

// New providers for handling predefined values from CSV
final shouldUsePredefinedValuesProvider = StateProvider<bool>((ref) => false);
final predefinedGypsumTypeProvider = StateProvider<String?>((ref) => null);
final predefinedSolutionTypeProvider = StateProvider<String?>((ref) => null);
final predefinedColorantPercentageProvider =
    StateProvider<double?>((ref) => null);

// Current tab provider for gypsum vs candles
final currentTabProvider = StateProvider<String>((ref) => 'gypsum');
