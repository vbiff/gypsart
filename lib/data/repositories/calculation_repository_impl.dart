import '../../domain/entities/calculation_result.dart';
import '../../domain/entities/gypsum_type.dart';
import '../../domain/entities/solution_type.dart';
import '../../domain/repositories/calculation_repository.dart';

class CalculationRepositoryImpl implements CalculationRepository {
  static const List<GypsumType> _gypsumTypes = [
    GypsumType(
      id: 'sWP8u50jSXi9pkR4aB31tw',
      name: 'Гипс-Г16',
      description: 'Высокопрочный гипс для отливки',
      isSelected: true,
    ),
    GypsumType(
      id: 'a-ZcTqQSLQ7GkhG6.WATRqg',
      name: 'Технический гипс',
      description: 'Обычный гипс для базовых изделий',
      isSelected: false,
    ),
  ];

  static const List<SolutionType> _solutionTypes = [
    SolutionType(
      id: 'YO6Ha6xfTzuY8YizbJ4ssA',
      name: 'Раствор с микроцементом',
      description: 'Укрепляющий раствор для прочных изделий',
    ),
    SolutionType(
      id: 'r8qGtZyBRE-3yOT6ZEihwA',
      name: 'Водный раствор',
      description: 'Простой водный раствор',
    ),
    SolutionType(
      id: 'PVPVdrBLRROqLqR90Rh3.A',
      name: 'Акриловый раствор',
      description: 'Раствор с акриловыми добавками',
    ),
  ];

  @override
  Future<List<GypsumType>> getGypsumTypes() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _gypsumTypes;
  }

  @override
  Future<List<SolutionType>> getSolutionTypes() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _solutionTypes;
  }

  @override
  CalculationResult calculateIngredients({
    required int moldVolumeInMl,
    required String gypsumType,
    required String solutionType,
    required int colorantPercentage,
  }) {
    // Базовые расчеты для гипса
    // Для объема 250 мл получаем примерно 263 г гипса
    const double gypsumDensityFactor = 1.052; // 263/250
    final double gypsumAmount = moldVolumeInMl * gypsumDensityFactor;

    // Микроцемент - в зависимости от типа раствора
    final double microcementAmount =
        _calculateMicrocementAmount(solutionType, gypsumAmount);

    // СВВ (Сухая водная добавка) - примерно 1% от гипса
    final double svvAmount = gypsumAmount * 0.01;

    // Краситель - процент от гипса
    final double colorantAmount = gypsumAmount * (colorantPercentage / 100);

    // Вода - примерно 55% от гипса
    final double waterAmount = gypsumAmount * 0.55;

    return CalculationResult(
      moldVolumeInMl: moldVolumeInMl,
      gypsumAmount: gypsumAmount,
      microcementAmount: microcementAmount,
      svvAmount: svvAmount,
      colorantAmount: colorantAmount,
      waterAmount: waterAmount,
      gypsumType: gypsumType,
      solutionType: solutionType,
      colorantPercentage: colorantPercentage,
    );
  }

  double _calculateMicrocementAmount(String solutionType, double gypsumAmount) {
    switch (solutionType) {
      case 'YO6Ha6xfTzuY8YizbJ4ssA': // Раствор с микроцементом
        return gypsumAmount * 0.18; // 18% от гипса
      case 'r8qGtZyBRE-3yOT6ZEihwA': // Водный раствор
        return 0.0; // Нет микроцемента
      case 'PVPVdrBLRROqLqR90Rh3.A': // Акриловый раствор
        return gypsumAmount * 0.12; // 12% от гипса
      default:
        return 0.0;
    }
  }
}
