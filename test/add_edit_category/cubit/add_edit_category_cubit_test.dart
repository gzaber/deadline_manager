import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/add_edit_category/cubit/add_edit_category_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

class FakeCategory extends Fake implements Category {}

void main() {
  group('AddEditCategoryCubit', () {
    late CategoriesRepository categoriesRepository;

    final defaultColor = AppColors.categoryColors.first.value;
    final defaultIcon = AppIcons.categoryIcons.first.codePoint;
    const mockUser = User(id: '1', email: 'email');
    final mockInitialCategory = Category(
      id: '1',
      owner: 'owner',
      name: 'name',
      icon: 100,
      color: 200,
    );

    setUpAll(() {
      registerFallbackValue(FakeCategory());
    });

    setUp(() {
      categoriesRepository = MockCategoriesRepository();
    });

    AddEditCategoryCubit createCubit({
      Category? initialCategory,
    }) {
      return AddEditCategoryCubit(
        categoriesRepository: categoriesRepository,
        category: initialCategory,
        user: mockUser,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(createCubit, returnsNormally);
      });

      test('has correct initial state when initial category is not provided',
          () {
        expect(
          createCubit().state,
          equals(
            AddEditCategoryState(
              user: mockUser,
              color: defaultColor,
              icon: defaultIcon,
            ),
          ),
        );
      });

      test('has correct initial state when initial category is provided', () {
        expect(
          createCubit(initialCategory: mockInitialCategory).state,
          equals(
            AddEditCategoryState(
              user: mockUser,
              initialCategory: mockInitialCategory,
              name: mockInitialCategory.name,
              color: mockInitialCategory.color,
              icon: mockInitialCategory.icon,
            ),
          ),
        );
      });
    });

    group('onNameChanged', () {
      blocTest<AddEditCategoryCubit, AddEditCategoryState>(
        'emits state with changed name',
        build: createCubit,
        act: (cubit) => cubit.onNameChanged('changed'),
        expect: () => [createCubit().state.copyWith(name: 'changed')],
      );
    });

    group('onIconChanged', () {
      blocTest<AddEditCategoryCubit, AddEditCategoryState>(
        'emits state with changed icon',
        build: createCubit,
        act: (cubit) => cubit.onIconChanged(123),
        expect: () => [createCubit().state.copyWith(icon: 123)],
      );
    });

    group('onColorChanged', () {
      blocTest<AddEditCategoryCubit, AddEditCategoryState>(
        'emits state with changed color',
        build: createCubit,
        act: (cubit) => cubit.onColorChanged(321),
        expect: () => [createCubit().state.copyWith(color: 321)],
      );
    });

    group('saveCategory', () {
      blocTest<AddEditCategoryCubit, AddEditCategoryState>(
        'emits state with success when new category was successfully saved',
        setUp: () {
          when(() => categoriesRepository.createCategory(any()))
              .thenAnswer((_) async {});
        },
        build: createCubit,
        seed: () => const AddEditCategoryState(name: 'new name'),
        act: (cubit) => cubit.saveCategory(),
        expect: () => const [
          AddEditCategoryState(
              status: AddEditCategoryStatus.loading, name: 'new name'),
          AddEditCategoryState(
              status: AddEditCategoryStatus.success, name: 'new name'),
        ],
      );

      blocTest<AddEditCategoryCubit, AddEditCategoryState>(
        'emits state with failure when saving created category to repository fails',
        setUp: () {
          when(() => categoriesRepository.createCategory(any()))
              .thenThrow(Exception('failure'));
        },
        build: createCubit,
        seed: () => const AddEditCategoryState(name: 'new name'),
        act: (cubit) => cubit.saveCategory(),
        expect: () => const [
          AddEditCategoryState(
              status: AddEditCategoryStatus.loading, name: 'new name'),
          AddEditCategoryState(
              status: AddEditCategoryStatus.failure, name: 'new name'),
        ],
      );

      blocTest<AddEditCategoryCubit, AddEditCategoryState>(
        'emits state with success when updated category was successfully saved',
        setUp: () {
          when(() => categoriesRepository.updateCategory(any()))
              .thenAnswer((_) async {});
        },
        build: createCubit,
        seed: () => AddEditCategoryState(
            initialCategory: mockInitialCategory, name: 'new name'),
        act: (cubit) => cubit.saveCategory(),
        expect: () => [
          AddEditCategoryState(
            status: AddEditCategoryStatus.loading,
            initialCategory: mockInitialCategory,
            name: 'new name',
          ),
          AddEditCategoryState(
            status: AddEditCategoryStatus.success,
            initialCategory: mockInitialCategory,
            name: 'new name',
          ),
        ],
      );

      blocTest<AddEditCategoryCubit, AddEditCategoryState>(
        'emits state with failure when saving updated category to repository fails',
        setUp: () {
          when(() => categoriesRepository.updateCategory(any()))
              .thenThrow(Exception('failure'));
        },
        build: createCubit,
        seed: () => AddEditCategoryState(
            initialCategory: mockInitialCategory, name: 'new name'),
        act: (cubit) => cubit.saveCategory(),
        expect: () => [
          AddEditCategoryState(
            status: AddEditCategoryStatus.loading,
            initialCategory: mockInitialCategory,
            name: 'new name',
          ),
          AddEditCategoryState(
            status: AddEditCategoryStatus.failure,
            initialCategory: mockInitialCategory,
            name: 'new name',
          ),
        ],
      );
    });
  });
}
