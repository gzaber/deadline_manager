import 'package:categories_api/categories_api.dart';

class CategoriesRepository {
  const CategoriesRepository({
    required CategoriesApi categoriesApi,
  }) : _categoriesApi = categoriesApi;

  final CategoriesApi _categoriesApi;

  Future<void> createCategory(Category category) async =>
      await _categoriesApi.createCategory(category);

  Future<void> updateCategory(Category category) async =>
      await _categoriesApi.updateCategory(category);

  Future<void> deleteCategory(String id) async =>
      await _categoriesApi.deleteCategory(id);

  Future<Category> readCategoryById(String id) async =>
      await _categoriesApi.readCategoryById(id);

  Future<List<Category>> readCategoriesByOwner(String owner) async =>
      await _categoriesApi.readCategoriesByOwner(owner);

  Stream<List<Category>> observeCategoriesByOwner(String owner) =>
      _categoriesApi.observeCategoriesByOwner(owner);
}
