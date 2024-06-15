import 'models/models.dart';

abstract interface class CategoriesApi {
  Future<void> createCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String id);
  Stream<Category> observeCategoryById(String id);
  Stream<List<Category>> observeCategoriesByUserEmail(String email);
}
