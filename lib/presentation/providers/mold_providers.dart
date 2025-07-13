import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/mold_shape.dart';
import '../../domain/repositories/mold_repository.dart';
import '../../data/repositories/mold_repository_impl.dart';
import 'calculation_providers.dart';

final moldRepositoryProvider = Provider<MoldRepository>((ref) {
  return MoldRepositoryImpl();
});

final moldsProvider = FutureProvider<List<MoldShape>>((ref) async {
  final repository = ref.watch(moldRepositoryProvider);
  return repository.getAllMolds();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

// Category filter provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final filteredMoldsProvider = FutureProvider<List<MoldShape>>((ref) async {
  final repository = ref.watch(moldRepositoryProvider);
  final query = ref.watch(searchQueryProvider);
  final currentTab = ref.watch(currentTabProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  List<MoldShape> molds;

  // Filter by tab (gypsum vs candles)
  if (currentTab == 'gypsum') {
    molds = await (repository as MoldRepositoryImpl).getGypsumMolds();
  } else {
    molds = await (repository as MoldRepositoryImpl).getCandleMolds();
  }

  // Apply category filter
  if (selectedCategory != null) {
    molds = molds.where((mold) => mold.category == selectedCategory).toList();
  }

  // Apply search filter
  if (query.isNotEmpty) {
    molds = molds
        .where((mold) =>
            mold.name.toLowerCase().contains(query.toLowerCase()) ||
            mold.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  return molds;
});

final selectedMoldProvider = StateProvider<MoldShape?>((ref) => null);

// Provider for getting molds by category
final moldsByCategoryProvider =
    FutureProvider.family<List<MoldShape>, String>((ref, category) async {
  final repository = ref.watch(moldRepositoryProvider);
  return (repository as MoldRepositoryImpl).getMoldsByCategory(category);
});

// Provider for getting available categories for current tab
final availableCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(moldRepositoryProvider);
  final currentTab = ref.watch(currentTabProvider);

  List<MoldShape> molds;
  if (currentTab == 'gypsum') {
    molds = await (repository as MoldRepositoryImpl).getGypsumMolds();
  } else {
    molds = await (repository as MoldRepositoryImpl).getCandleMolds();
  }

  final categories = molds.map((mold) => mold.category).toSet().toList();
  categories.sort();
  return categories;
});
