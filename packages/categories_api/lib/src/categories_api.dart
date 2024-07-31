import 'models/models.dart';

abstract interface class CategoriesApi {
  Future<void> createCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String id);
  Future<Category> readCategoryById(String id);
  Future<List<Category>> readCategoriesByOwner(String owner);
  Stream<List<Category>> observeCategoriesByOwner(String owner);
}
