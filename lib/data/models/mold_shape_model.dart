import '../../domain/entities/mold_shape.dart';

class MoldShapeModel {
  final String id;
  final String name;
  final String imageUrl;
  final String typeId;
  final int gypsumVolumeInMl;
  final String? selectedGypsumId;
  final String? selectedMixtureId;
  final double? selectedColorant;
  final bool isCandle;
  final int? candleVolumeInMl;

  const MoldShapeModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.typeId,
    required this.gypsumVolumeInMl,
    this.selectedGypsumId,
    this.selectedMixtureId,
    this.selectedColorant,
    this.isCandle = false,
    this.candleVolumeInMl,
  });

  factory MoldShapeModel.fromJson(Map<String, dynamic> json) {
    return MoldShapeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      typeId: json['typeId'] as String,
      gypsumVolumeInMl: json['gypsumVolumeInMl'] as int,
      selectedGypsumId: json['selectedGypsumId'] as String?,
      selectedMixtureId: json['selectedMixtureId'] as String?,
      selectedColorant: json['selectedColorant'] as double?,
      isCandle: json['isCandle'] as bool? ?? false,
      candleVolumeInMl: json['candleVolumeInMl'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'typeId': typeId,
      'gypsumVolumeInMl': gypsumVolumeInMl,
      'selectedGypsumId': selectedGypsumId,
      'selectedMixtureId': selectedMixtureId,
      'selectedColorant': selectedColorant,
      'isCandle': isCandle,
      'candleVolumeInMl': candleVolumeInMl,
    };
  }

  MoldShape toEntity() {
    return MoldShape(
      id: id,
      name: name,
      imageUrl: imageUrl,
      typeId: typeId,
      gypsumVolumeInMl: gypsumVolumeInMl,
      selectedGypsumId: selectedGypsumId,
      selectedMixtureId: selectedMixtureId,
      selectedColorant: selectedColorant,
      isCandle: isCandle,
      candleVolumeInMl: candleVolumeInMl,
    );
  }

  factory MoldShapeModel.fromEntity(MoldShape entity) {
    return MoldShapeModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      typeId: entity.typeId,
      gypsumVolumeInMl: entity.gypsumVolumeInMl,
      selectedGypsumId: entity.selectedGypsumId,
      selectedMixtureId: entity.selectedMixtureId,
      selectedColorant: entity.selectedColorant,
      isCandle: entity.isCandle,
      candleVolumeInMl: entity.candleVolumeInMl,
    );
  }
}
