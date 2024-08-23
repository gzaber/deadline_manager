import 'package:categories_api/categories_api.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCategoriesApi extends Mock implements CategoriesApi {}

class FakeCategory extends Fake implements Category {}

void main() {
  group('CategoriesRepository', () {
    late CategoriesApi api;
    late CategoriesRepository repository;

    final category1 = Category(
      id: '1',
      owner: 'owner',
      name: 'name1',
      icon: 100,
      color: 200,
    );
    final category2 = Category(
      id: '2',
      owner: 'owner',
      name: 'name2',
      icon: 300,
      color: 400,
    );

    setUpAll(() {
      registerFallbackValue(FakeCategory());
    });

    setUp(() {
      api = MockCategoriesApi();
      repository = CategoriesRepository(categoriesApi: api);

      when(() => api.createCategory(any())).thenAnswer((_) async {});
      when(() => api.updateCategory(any())).thenAnswer((_) async {});
      when(() => api.deleteCategory(any())).thenAnswer((_) async {});
      when(() => api.readCategoryById(any()))
          .thenAnswer((_) async => category1);
      when(() => api.readCategoriesByOwner(any()))
          .thenAnswer((_) async => [category1, category2]);
      when(() => api.observeCategoriesByOwner(any()))
          .thenAnswer((_) => Stream.value([category1, category2]));
    });

    group('constructor', () {
      test('works properly', () {
        expect(
          () => CategoriesRepository(categoriesApi: api),
          returnsNormally,
        );
      });
    });

    group('createCategory', () {
      test('makes correct api request', () {
        final category = Category(
          owner: 'owner',
          name: 'name',
          icon: 100,
          color: 200,
        );

        expect(repository.createCategory(category), completes);
        verify(() => api.createCategory(category)).called(1);
      });
    });

    group('updateCategory', () {
      test('makes correct api request', () {
        expect(repository.updateCategory(category1), completes);
        verify(() => api.updateCategory(category1)).called(1);
      });
    });

    group('deleteCategory', () {
      test('makes correct api request', () {
        expect(repository.deleteCategory(category1.id), completes);
        verify(() => api.deleteCategory(category1.id)).called(1);
      });
    });

    group('readCategoryById', () {
      test('makes correct api request', () {
        expect(repository.readCategoryById(category1.id), completes);
        verify(() => api.readCategoryById(category1.id)).called(1);
      });

      test('returns category by id', () async {
        expect(
          await repository.readCategoryById(category1.id),
          equals(category1),
        );
      });
    });

    group('readCategoriesByOwner', () {
      test('makes correct api request', () {
        expect(repository.readCategoriesByOwner(category1.owner), completes);
        verify(() => api.readCategoriesByOwner(category1.owner)).called(1);
      });

      test('returns category list by owner', () async {
        expect(
          await repository.readCategoriesByOwner(category1.owner),
          equals([category1, category2]),
        );
      });
    });

    group('observeCategoriesByOwner', () {
      test('makes correct api request', () {
        expect(
          repository.observeCategoriesByOwner(category1.owner),
          isNot(throwsA(anything)),
        );
        verify(() => api.observeCategoriesByOwner(category1.owner)).called(1);
      });

      test('returns stream of category list by owner', () {
        expect(
          repository.observeCategoriesByOwner(category1.owner),
          emits([category1, category2]),
        );
      });
    });
  });
}
