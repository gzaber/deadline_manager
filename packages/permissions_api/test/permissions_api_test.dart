import 'package:permissions_api/permissions_api.dart';
import 'package:test/test.dart';

class TestPermissionsApi implements PermissionsApi {
  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('PermissionsApi', () {
    test('can be implemented and then constructed', () {
      expect(TestPermissionsApi.new, returnsNormally);
    });
  });
}
