import '../entities/mold_shape.dart';

abstract class MoldRepository {
  Future<List<MoldShape>> getAllMolds();
  Future<List<MoldShape>> searchMolds(String query);
  Future<MoldShape?> getMoldById(String id);
}
