part of 'deadlines_cubit.dart';

enum DeadlinesStatus { initial, success, failure }

final class DeadlinesState extends Equatable {
  const DeadlinesState({
    this.status = DeadlinesStatus.initial,
    required this.categoryId,
    required this.categoryName,
    this.deadlines = const [],
  });

  final DeadlinesStatus status;
  final String categoryId;
  final String categoryName;
  final List<Deadline> deadlines;

  @override
  List<Object> get props => [status, categoryId, categoryName, deadlines];

  DeadlinesState copyWith({
    DeadlinesStatus? status,
    String? categoryId,
    String? categoryName,
    List<Deadline>? deadlines,
  }) {
    return DeadlinesState(
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      deadlines: deadlines ?? this.deadlines,
    );
  }
}
