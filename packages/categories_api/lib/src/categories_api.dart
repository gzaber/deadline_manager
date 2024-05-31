import 'models/models.dart';

abstract interface class CategoriesApi {
  Future<void> createCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String id);
  Future<Category> readCategory(String id);
  Stream<List<Category>> observeCategoriesByUserEmail(String email);
  Stream<List<Category>> observeCategoriesByAuthorizedUserEmail(String email);
}
