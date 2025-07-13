import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/mold_shape.dart';
import '../providers/calculation_providers.dart';

class CalculationScreen extends ConsumerWidget {
  final MoldShape mold;

  const CalculationScreen({
    super.key,
    required this.mold,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gypsumTypesAsync = ref.watch(gypsumTypesProvider);
    final solutionTypesAsync = ref.watch(solutionTypesProvider);
    final selectedGypsumType = ref.watch(selectedGypsumTypeProvider);
    final selectedSolutionType = ref.watch(selectedSolutionTypeProvider);
    final selectedColorantPercentage =
        ref.watch(selectedColorantPercentageProvider);
    final calculationResult = ref.watch(calculationResultProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: const Color(0xFFF2F2F7),
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.chevron_left_rounded),
              iconSize: 28,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.8),
                foregroundColor: const Color(0xFF007AFF),
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // Share functionality
                },
                icon: const Icon(Icons.share_rounded),
                iconSize: 20,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.8),
                  foregroundColor: const Color(0xFF007AFF),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Расчет',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 32,
                      ),
                ),
                Text(
                  mold.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF8E8E93),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                ),
              ],
            ),
            expandedHeight: 140,
            floating: false,
            pinned: true,
            snap: false,
            elevation: 0,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Mold Image Card
                _buildMoldImageCard(),
                const SizedBox(height: 20),

                // Gypsum Types Section
                _buildSection(
                  title: 'Виды гипса',
                  child: gypsumTypesAsync.when(
                    data: (gypsumTypes) => _buildGypsumTypesList(
                        gypsumTypes, selectedGypsumType, ref),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Text('Ошибка: $error'),
                  ),
                ),
                const SizedBox(height: 16),

                // Solution Types Section
                _buildSection(
                  title: 'Виды растворов',
                  child: solutionTypesAsync.when(
                    data: (solutionTypes) => _buildSolutionTypeDropdown(
                        solutionTypes, selectedSolutionType, ref),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Text('Ошибка: $error'),
                  ),
                ),
                const SizedBox(height: 16),

                // Colorant Percentage Section
                _buildSection(
                  title: 'Объем красителя',
                  child: _buildColorantPercentageButtons(
                      selectedColorantPercentage, ref),
                ),
                const SizedBox(height: 20),

                // Calculation Results
                if (calculationResult != null)
                  _buildCalculationResultCard(context, calculationResult),

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoldImageCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: mold.imageUrl.isNotEmpty
                ? Image.network(
                    mold.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFFF2F2F7),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF007AFF),
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFF2F2F7),
                        child: const Center(
                          child: Icon(
                            Icons.image_outlined,
                            color: Color(0xFF8E8E93),
                            size: 48,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    color: const Color(0xFFF2F2F7),
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        color: Color(0xFF8E8E93),
                        size: 48,
                      ),
                    ),
                  ),
          ),
          // Volume badge
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF007AFF),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF007AFF).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '${mold.volumeInMl} мл',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Category badge
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                mold.category,
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildGypsumTypesList(
      List<dynamic> gypsumTypes, String? selectedGypsumType, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: gypsumTypes.map((gypsumType) {
        final isSelected = selectedGypsumType == gypsumType.id;
        return GestureDetector(
          onTap: () {
            ref.read(selectedGypsumTypeProvider.notifier).state = gypsumType.id;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF007AFF)
                  : Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF007AFF)
                    : const Color(0xFFE5E5EA),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF007AFF).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              gypsumType.name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSolutionTypeDropdown(List<dynamic> solutionTypes,
      String? selectedSolutionType, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E5EA),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedSolutionType,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF8E8E93),
          ),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              ref.read(selectedSolutionTypeProvider.notifier).state = newValue;
            }
          },
          items: solutionTypes.map((solutionType) {
            return DropdownMenuItem<String>(
              value: solutionType.id,
              child: Text(solutionType.name),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildColorantPercentageButtons(
      int selectedColorantPercentage, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [1, 2, 3, 4, 5].map((percentage) {
        final isSelected = selectedColorantPercentage == percentage;
        return GestureDetector(
          onTap: () {
            ref.read(selectedColorantPercentageProvider.notifier).state =
                percentage;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF007AFF)
                  : Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF007AFF)
                    : const Color(0xFFE5E5EA),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF007AFF).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                '$percentage%',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalculationResultCard(BuildContext context, calculationResult) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calculate_rounded,
                  color: Color(0xFF007AFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Результат расчета',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCalculationRow(
              'Объем формы', '${calculationResult.moldVolumeInMl} мл'),
          _buildCalculationRow(
              'Гипс', '${calculationResult.gypsumAmount.toStringAsFixed(0)} г'),
          if (calculationResult.microcementAmount > 0)
            _buildCalculationRow('Микроцемент',
                '${calculationResult.microcementAmount.toStringAsFixed(0)} г'),
          _buildCalculationRow(
              'СВВ', '${calculationResult.svvAmount.toStringAsFixed(1)} г'),
          _buildCalculationRow('Краситель',
              '${calculationResult.colorantAmount.toStringAsFixed(1)} г'),
          _buildCalculationRow(
              'Вода', '${calculationResult.waterAmount.toStringAsFixed(0)} г'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Расчет сохранен'),
                    backgroundColor: const Color(0xFF007AFF),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_added_rounded, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Сохранить расчет',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF007AFF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
