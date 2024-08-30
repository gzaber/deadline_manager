part of 'category_details_cubit.dart';

enum CategoryDetailsFutureStatus {
  initial,
  loading,
  success,
  failure,
}

enum CategoryDetailsStreamStatus {
  initial,
  loading,
  success,
  failure,
}

class CategoryDetailsState extends Equatable {
  CategoryDetailsState({
    this.futureStatus = CategoryDetailsFutureStatus.initial,
    this.streamStatus = CategoryDetailsStreamStatus.initial,
    Category? category,
    this.deadlines = const [],
  }) : category = category ??
            Category(id: '0', owner: '', name: '', icon: 0, color: 0);

  final CategoryDetailsFutureStatus futureStatus;
  final CategoryDetailsStreamStatus streamStatus;
  final Category category;
  final List<Deadline> deadlines;

  @override
  List<Object> get props => [futureStatus, streamStatus, category, deadlines];

  CategoryDetailsState copyWith({
    CategoryDetailsFutureStatus? futureStatus,
    CategoryDetailsStreamStatus? streamStatus,
    Category? category,
    List<Deadline>? deadlines,
  }) {
    return CategoryDetailsState(
      futureStatus: futureStatus ?? this.futureStatus,
      streamStatus: streamStatus ?? this.streamStatus,
      category: category ?? this.category,
      deadlines: deadlines ?? this.deadlines,
    );
  }
}
