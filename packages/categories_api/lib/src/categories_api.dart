import 'models/models.dart';

abstract interface class CategoriesApi {
  Future<void> createCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String id);
  Future<Category> readCategoryById(String id);
  Future<List<Category>> readCategoriesByUserEmail(String email);
  Stream<List<Category>> observeCategoriesByUserEmail(String email);
}
