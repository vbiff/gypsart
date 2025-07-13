import '../../domain/entities/mold_shape.dart';
import '../../domain/repositories/mold_repository.dart';
import '../services/csv_parser_service.dart';

class MoldRepositoryImpl implements MoldRepository {
  List<MoldShape>? _cachedMolds;

  @override
  Future<List<MoldShape>> getAllMolds() async {
    _cachedMolds ??= await CsvParserService.parseFormsFromCsv();
    return _cachedMolds!;
  }

  @override
  Future<List<MoldShape>> searchMolds(String query) async {
    final allMolds = await getAllMolds();
    if (query.isEmpty) return allMolds;

    return allMolds
        .where((mold) =>
            mold.name.toLowerCase().contains(query.toLowerCase()) ||
            mold.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<MoldShape?> getMoldById(String id) async {
    final allMolds = await getAllMolds();
    try {
      return allMolds.firstWhere((mold) => mold.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<MoldShape>> getMoldsByCategory(String category) async {
    final allMolds = await getAllMolds();
    return allMolds.where((mold) => mold.category == category).toList();
  }

  Future<List<MoldShape>> getGypsumMolds() async {
    final allMolds = await getAllMolds();
    return allMolds.where((mold) => !mold.isCandle).toList();
  }

  Future<List<MoldShape>> getCandleMolds() async {
    final allMolds = await getAllMolds();
    return allMolds.where((mold) => mold.isCandle).toList();
  }
}
