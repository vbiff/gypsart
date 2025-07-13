class SolutionType {
  final String id;
  final String name;
  final String description;

  const SolutionType({
    required this.id,
    required this.name,
    required this.description,
  });

  static String getNameById(String id) {
    switch (id) {
      case 'YO6Ha6xfTzuY8YizbJ4ssA':
        return 'Раствор с микроцементом';
      case 'r8qGtZyBRE-3yOT6ZEihwA':
        return 'Водный раствор';
      case 'PVPVdrBLRROqLqR90Rh3.A':
        return 'Акриловый раствор';
      default:
        return 'Неизвестный раствор';
    }
  }

  static String getDescriptionById(String id) {
    switch (id) {
      case 'YO6Ha6xfTzuY8YizbJ4ssA':
        return 'Укрепляющий раствор для прочных изделий';
      case 'r8qGtZyBRE-3yOT6ZEihwA':
        return 'Простой водный раствор';
      case 'PVPVdrBLRROqLqR90Rh3.A':
        return 'Раствор с акриловыми добавками';
      default:
        return 'Неизвестный раствор';
    }
  }
}
