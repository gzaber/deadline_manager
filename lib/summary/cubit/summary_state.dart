part of 'summary_cubit.dart';

enum SummaryStatus { initial, loading, success, failure }

final class SummaryState extends Equatable {
  const SummaryState({
    this.status = SummaryStatus.initial,
    required this.user,
    this.categories = const [],
    this.deadlines = const [],
  });

  final SummaryStatus status;
  final User user;
  final List<Category> categories;
  final List<SummaryDeadline> deadlines;

  @override
  List<Object> get props => [status, user, categories, deadlines];

  SummaryState copyWith({
    SummaryStatus? status,
    User? user,
    List<Category>? categories,
    List<SummaryDeadline>? deadlines,
  }) {
    return SummaryState(
      status: status ?? this.status,
      user: user ?? this.user,
      categories: categories ?? this.categories,
      deadlines: deadlines ?? this.deadlines,
    );
  }
}
