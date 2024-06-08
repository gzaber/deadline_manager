part of 'deadlines_cubit.dart';

enum DeadlinesStatus { initial, success, failure }

class DeadlinesState extends Equatable {
  const DeadlinesState({
    this.status = DeadlinesStatus.initial,
    required this.category,
    this.deadlines = const [],
  });

  final DeadlinesStatus status;
  final Category category;
  final List<Deadline> deadlines;

  @override
  List<Object> get props => [status, category, deadlines];

  DeadlinesState copyWith({
    DeadlinesStatus? status,
    Category? category,
    List<Deadline>? deadlines,
  }) {
    return DeadlinesState(
      status: status ?? this.status,
      category: category ?? this.category,
      deadlines: deadlines ?? this.deadlines,
    );
  }
}
