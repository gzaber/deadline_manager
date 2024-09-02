import 'package:authentication_repository/authentication_repository.dart';
import 'package:deadline_manager/summary/summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SummaryState', () {
    const mockUser = User(id: '1', email: 'email');
    const dateString = '2024-12-06';
    final mockSummaryDeadline = SummaryDeadline(
      name: 'name',
      expirationDate: DateTime.parse(dateString),
      isShared: true,
      categoryName: 'category-name',
      sharedBy: 'giver',
    );

    SummaryState createState({
      SummaryStatus status = SummaryStatus.initial,
      User user = User.empty,
      List<SummaryDeadline> userDeadlines = const [],
      List<SummaryDeadline> summaryDeadlines = const [],
      bool showDetails = false,
      bool showShared = false,
    }) {
      return SummaryState(
        status: status,
        user: user,
        userDeadlines: userDeadlines,
        summaryDeadlines: summaryDeadlines,
        showDetails: showDetails,
        showShared: showShared,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(createState, returnsNormally);
      });
    });

    test('supports value equality', () {
      expect(createState(), equals(createState()));
    });

    test('props are correct', () {
      expect(
        createState().props,
        equals([
          SummaryStatus.initial,
          User.empty,
          [],
          [],
          false,
          false,
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createState().copyWith(),
          equals(createState()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createState().copyWith(
            status: null,
            user: null,
            userDeadlines: null,
            summaryDeadlines: null,
            showDetails: null,
            showShared: null,
          ),
          equals(createState()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createState().copyWith(
            status: SummaryStatus.success,
            user: mockUser,
            userDeadlines: [mockSummaryDeadline],
            summaryDeadlines: [mockSummaryDeadline],
            showDetails: true,
            showShared: true,
          ),
          equals(
            createState(
              status: SummaryStatus.success,
              user: mockUser,
              userDeadlines: [mockSummaryDeadline],
              summaryDeadlines: [mockSummaryDeadline],
              showDetails: true,
              showShared: true,
            ),
          ),
        );
      });
    });
  });
}
