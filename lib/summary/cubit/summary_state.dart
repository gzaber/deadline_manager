part of 'summary_cubit.dart';

enum SummaryStatus { initial, loading, success, failure }

class SummaryState extends Equatable {
  const SummaryState({
    this.status = SummaryStatus.initial,
    this.user = User.empty,
    this.userDeadlines = const [],
    this.summaryDeadlines = const [],
    this.showDetails = false,
    this.showShared = false,
  });

  final SummaryStatus status;
  final User user;
  final List<SummaryDeadline> userDeadlines;
  final List<SummaryDeadline> summaryDeadlines;
  final bool showDetails;
  final bool showShared;

  SummaryState copyWith({
    SummaryStatus? status,
    User? user,
    List<Category>? categories,
    List<SummaryDeadline>? userDeadlines,
    List<SummaryDeadline>? summaryDeadlines,
    bool? showDetails,
    bool? showShared,
  }) {
    return SummaryState(
      status: status ?? this.status,
      user: user ?? this.user,
      userDeadlines: userDeadlines ?? this.userDeadlines,
      summaryDeadlines: summaryDeadlines ?? this.summaryDeadlines,
      showDetails: showDetails ?? this.showDetails,
      showShared: showShared ?? this.showShared,
    );
  }

  @override
  List<Object> get props => [
        status,
        user,
        userDeadlines,
        summaryDeadlines,
        showDetails,
        showShared,
      ];
}
