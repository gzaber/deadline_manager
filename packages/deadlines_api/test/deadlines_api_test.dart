import 'package:deadlines_api/deadlines_api.dart';
import 'package:test/test.dart';

class TestDeadlinesApi implements DeadlinesApi {
  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('DeadlinesApi', () {
    test('can be implemented and then constructed', () {
      expect(TestDeadlinesApi.new, returnsNormally);
    });
  });
}
