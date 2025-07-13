class MoldShape {
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

  const MoldShape({
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

  String get category {
    switch (typeId) {
      case 'A6apoYfmSjCNSjpHvFVmjA':
        return 'Вазы';
      case 'niCjhp9gSS2mGKFf7tytdQ':
        return isCandle ? 'Свечи' : 'Формы';
      case 'a.e.3JDyUQpi.VKOvfD6otg':
        return 'Скульптуры';
      case 'UjcSXWmUSRW40hfMoPAwow':
        return 'Подносы';
      default:
        return 'Другое';
    }
  }

  int get volumeInMl => gypsumVolumeInMl;
}
