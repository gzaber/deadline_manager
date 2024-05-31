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

  Future<Category> readCategory(String id) async =>
      await _categoriesApi.readCategory(id);

  Stream<List<Category>> observeCategoriesByUserEmail(String email) =>
      _categoriesApi.observeCategoriesByUserEmail(email);

  Stream<List<Category>> observeCategoriesByAuthorizedUserEmail(String email) =>
      _categoriesApi.observeCategoriesByAuthorizedUserEmail(email);
}
