part of 'categories_cubit.dart';

enum CategoriesFutureStatus {
  initial,
  loading,
  success,
  failure,
}

enum CategoriesStreamStatus {
  initial,
  loading,
  success,
  failure,
}

final class CategoriesState extends Equatable {
  const CategoriesState({
    this.futureStatus = CategoriesFutureStatus.initial,
    this.streamStatus = CategoriesStreamStatus.initial,
    this.categories = const [],
    this.user = User.empty,
  });

  final CategoriesFutureStatus futureStatus;
  final CategoriesStreamStatus streamStatus;
  final List<Category> categories;
  final User user;

  CategoriesState copyWith({
    CategoriesFutureStatus? futureStatus,
    CategoriesStreamStatus? streamStatus,
    List<Category>? categories,
    User? user,
  }) {
    return CategoriesState(
      futureStatus: futureStatus ?? this.futureStatus,
      streamStatus: streamStatus ?? this.streamStatus,
      categories: categories ?? this.categories,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [futureStatus, streamStatus, categories, user];
}
