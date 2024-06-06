part of 'categories_cubit.dart';

enum CategoriesStatus { initial, success, failure }

final class CategoriesState extends Equatable {
  const CategoriesState({
    this.status = CategoriesStatus.initial,
    this.categories = const [],
    required this.user,
  });

  final CategoriesStatus status;
  final List<Category> categories;
  final User user;

  @override
  List<Object> get props => [status, categories, user];

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<Category>? categories,
    User? user,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      user: user ?? this.user,
    );
  }
}
