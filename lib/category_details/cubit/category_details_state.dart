part of 'category_details_cubit.dart';

enum CategoryDetailsStatus { initial, success, failure }

final class CategoryDetailsState extends Equatable {
  const CategoryDetailsState({
    this.status = CategoryDetailsStatus.initial,
    required this.categoryId,
    required this.categoryName,
    this.deadlines = const [],
  });

  final CategoryDetailsStatus status;
  final String categoryId;
  final String categoryName;
  final List<Deadline> deadlines;

  @override
  List<Object> get props => [status, categoryId, categoryName, deadlines];

  CategoryDetailsState copyWith({
    CategoryDetailsStatus? status,
    String? categoryId,
    String? categoryName,
    List<Deadline>? deadlines,
  }) {
    return CategoryDetailsState(
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      deadlines: deadlines ?? this.deadlines,
    );
  }
}
