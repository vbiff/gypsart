import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mold_providers.dart';
import '../providers/calculation_providers.dart';
import '../widgets/mold_card.dart';
import '../widgets/search_bar_widget.dart';
import 'calculation_screen.dart';

class MoldSelectionScreen extends ConsumerWidget {
  const MoldSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredMoldsAsync = ref.watch(filteredMoldsProvider);
    final availableCategoriesAsync = ref.watch(availableCategoriesProvider);
    final currentTab = ref.watch(currentTabProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // Apple's system background
      body: CustomScrollView(
        slivers: [
          // Apple-style Large Title App Bar
          SliverAppBar.large(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFF2F2F7),
                      const Color(0xFFF2F2F7).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              title: const Text(
                'Forms',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                  letterSpacing: -0.5,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            ),
            expandedHeight: 120,
            floating: false,
            pinned: true,
            snap: false,
            elevation: 0,
          ),
          // Controls Section
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Apple-style Search Bar
                const SearchBarWidget(),
                const SizedBox(height: 16),
                // Apple-style Segmented Control
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSegmentButton(
                          'Gypsum',
                          Icons.view_in_ar_outlined,
                          currentTab == 'gypsum',
                          () {
                            ref.read(currentTabProvider.notifier).state =
                                'gypsum';
                            ref.read(searchQueryProvider.notifier).state = '';
                            ref.read(selectedCategoryProvider.notifier).state =
                                null;
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildSegmentButton(
                          'Candles',
                          Icons.local_fire_department_rounded,
                          currentTab == 'candles',
                          () {
                            ref.read(currentTabProvider.notifier).state =
                                'candles';
                            ref.read(searchQueryProvider.notifier).state = '';
                            ref.read(selectedCategoryProvider.notifier).state =
                                null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Category Filter with Loading State
                availableCategoriesAsync.when(
                  data: (categories) => categories.isNotEmpty
                      ? _buildCategoryFilter(categories, selectedCategory, ref)
                      : const SizedBox.shrink(),
                  loading: () => _buildCategoryFilterLoading(),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
                // Active Filters Indicator
                if (selectedCategory != null || searchQuery.isNotEmpty)
                  _buildActiveFiltersIndicator(
                      selectedCategory, searchQuery, ref),
              ]),
            ),
          ),
          // Content Grid
          filteredMoldsAsync.when(
            data: (molds) => molds.isEmpty
                ? SliverFillRemaining(
                    child: _buildEmptyState(
                        currentTab, selectedCategory, searchQuery),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final mold = molds[index];
                          return TweenAnimationBuilder(
                            duration:
                                Duration(milliseconds: 150 + (index * 50)),
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            curve: Curves.easeOutCubic,
                            builder: (context, double value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: MoldCard(
                                    mold: mold,
                                    onTap: () {
                                      _onMoldSelected(context, ref, mold);
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        childCount: molds.length,
                      ),
                    ),
                  ),
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF007AFF),
                ),
              ),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: Colors.grey.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(
      List<String> categories, String? selectedCategory, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Категории',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1, // +1 for "All" button
            itemBuilder: (context, index) {
              if (index == 0) {
                // "All" button
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildCategoryChip(
                    'Все',
                    selectedCategory == null,
                    () {
                      ref.read(selectedCategoryProvider.notifier).state = null;
                    },
                  ),
                );
              }

              final category = categories[index - 1];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildCategoryChip(
                  category,
                  selectedCategory == category,
                  () {
                    ref.read(selectedCategoryProvider.notifier).state =
                        category;
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCategoryFilterLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Категории',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3, // Show 3 loading placeholders
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  width: 80,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Color(0xFF007AFF),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildActiveFiltersIndicator(
      String? selectedCategory, String searchQuery, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF007AFF).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF007AFF).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.filter_alt_rounded,
            size: 16,
            color: Color(0xFF007AFF),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _buildFilterText(selectedCategory, searchQuery),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF007AFF),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              ref.read(selectedCategoryProvider.notifier).state = null;
              ref.read(searchQueryProvider.notifier).state = '';
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF007AFF).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.clear_rounded,
                size: 14,
                color: Color(0xFF007AFF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildFilterText(String? selectedCategory, String searchQuery) {
    final filters = <String>[];

    if (selectedCategory != null) {
      filters.add('Категория: $selectedCategory');
    }

    if (searchQuery.isNotEmpty) {
      filters.add('Поиск: "$searchQuery"');
    }

    return filters.join(' • ');
  }

  Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF007AFF)
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF007AFF) : const Color(0xFFE5E5EA),
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
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentButton(
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected
                      ? const Color(0xFF007AFF)
                      : const Color(0xFF8E8E93),
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF000000)
                        : const Color(0xFF8E8E93),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      String currentTab, String? selectedCategory, String searchQuery) {
    String title;
    String subtitle;

    if (searchQuery.isNotEmpty) {
      title = selectedCategory != null
          ? 'Нет результатов в категории "$selectedCategory"'
          : 'Нет результатов поиска';
      subtitle = selectedCategory != null
          ? 'Попробуйте изменить категорию или поисковый запрос'
          : 'Попробуйте изменить поисковый запрос';
    } else if (selectedCategory != null) {
      title = 'Нет форм в категории "$selectedCategory"';
      subtitle = 'Попробуйте выбрать другую категорию';
    } else {
      title = currentTab == 'gypsum' ? 'Нет гипсовых форм' : 'Нет свечных форм';
      subtitle =
          'Формы для ${currentTab == 'gypsum' ? 'гипса' : 'свечей'} не найдены';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              searchQuery.isNotEmpty
                  ? Icons.search_off_rounded
                  : (currentTab == 'gypsum'
                      ? Icons.view_in_ar_outlined
                      : Icons.local_fire_department_rounded),
              size: 48,
              color: const Color(0xFF007AFF).withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _onMoldSelected(BuildContext context, WidgetRef ref, mold) {
    ref.read(selectedMoldProvider.notifier).state = mold;
    ref.read(selectedMoldVolumeProvider.notifier).state = mold.volumeInMl;

    // Set predefined values if available
    if (mold.selectedGypsumId != null) {
      ref.read(selectedGypsumTypeProvider.notifier).state =
          mold.selectedGypsumId!;
      ref.read(predefinedGypsumTypeProvider.notifier).state =
          mold.selectedGypsumId;
    }

    if (mold.selectedMixtureId != null) {
      ref.read(selectedSolutionTypeProvider.notifier).state =
          mold.selectedMixtureId!;
      ref.read(predefinedSolutionTypeProvider.notifier).state =
          mold.selectedMixtureId;
    }

    if (mold.selectedColorant != null) {
      final colorantPercentage = (mold.selectedColorant! * 100).round();
      ref.read(selectedColorantPercentageProvider.notifier).state =
          colorantPercentage;
      ref.read(predefinedColorantPercentageProvider.notifier).state =
          mold.selectedColorant;
    }

    ref.read(shouldUsePredefinedValuesProvider.notifier).state =
        mold.selectedGypsumId != null ||
            mold.selectedMixtureId != null ||
            mold.selectedColorant != null;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalculationScreen(mold: mold),
      ),
    );
  }
}
