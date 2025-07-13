class GypsumType {
  final String id;
  final String name;
  final String description;
  final bool isSelected;

  const GypsumType({
    required this.id,
    required this.name,
    required this.description,
    this.isSelected = false,
  });

  GypsumType copyWith({
    String? id,
    String? name,
    String? description,
    bool? isSelected,
  }) {
    return GypsumType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  static String getNameById(String id) {
    switch (id) {
      case 'sWP8u50jSXi9pkR4aB31tw':
        return 'Гипс-Г16';
      case 'a-ZcTqQSLQ7GkhG6.WATRqg':
        return 'Технический гипс';
      default:
        return 'Неизвестный гипс';
    }
  }
}
