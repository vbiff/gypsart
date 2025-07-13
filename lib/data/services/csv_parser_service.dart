import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/mold_shape.dart';

class CsvParserService {
  static Future<List<MoldShape>> parseFormsFromCsv() async {
    try {
      final csvString = await rootBundle.loadString('assets/Forms.csv');

      // Use simpler CSV parsing settings
      final List<List<dynamic>> csvData = const CsvToListConverter(
        fieldDelimiter: ',',
        textDelimiter: '"',
        eol: '\n',
      ).convert(csvString);

      // Skip header row
      final dataRows = csvData.skip(1).toList();

      final molds = <MoldShape>[];

      for (int i = 0; i < dataRows.length; i++) {
        try {
          final row = dataRows[i];
          if (row.length >= 5) {
            // Minimum required columns
            final mold = _parseRowToMoldShape(row);
            molds.add(mold);
          }
        } catch (e) {
          // Skip rows with parsing errors
          continue;
        }
      }

      return molds;
    } catch (e) {
      rethrow;
    }
  }

  static MoldShape _parseRowToMoldShape(List<dynamic> row) {
    // Ensure we have enough columns
    final safeRow = List<dynamic>.filled(10, '', growable: false);
    for (int i = 0; i < row.length && i < 10; i++) {
      safeRow[i] = row[i];
    }

    return MoldShape(
      id: safeRow[0]?.toString().trim() ?? '',
      name: safeRow[1]?.toString().trim() ?? '',
      imageUrl: safeRow[2]?.toString().trim() ?? '',
      typeId: safeRow[3]?.toString().trim() ?? '',
      gypsumVolumeInMl: _parseIntOrZero(safeRow[4]),
      selectedGypsumId: _parseStringOrNull(safeRow[5]),
      selectedMixtureId: _parseStringOrNull(safeRow[6]),
      selectedColorant: _parseColorant(safeRow[7]?.toString()),
      isCandle: _parseIsCandle(safeRow[8]),
      candleVolumeInMl: _parseIntOrNull(safeRow[9]),
    );
  }

  static String? _parseStringOrNull(dynamic value) {
    if (value == null) return null;
    final trimmed = value.toString().trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static int _parseIntOrZero(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return 0;
    return int.tryParse(value.toString().trim()) ?? 0;
  }

  static int? _parseIntOrNull(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return null;
    return int.tryParse(value.toString().trim());
  }

  static bool _parseIsCandle(dynamic value) {
    if (value == null) return false;
    final strValue = value.toString().trim().toLowerCase();
    return strValue == 'true' || strValue == '1';
  }

  static double? _parseColorant(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    // Handle European decimal format (comma as decimal separator)
    final normalizedValue = value.trim().replaceAll(',', '.');
    return double.tryParse(normalizedValue);
  }
}
