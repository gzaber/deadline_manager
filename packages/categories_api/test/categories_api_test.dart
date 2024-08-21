import 'package:categories_api/categories_api.dart';
import 'package:test/test.dart';

class TestCategoriesApi implements CategoriesApi {
  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('CategoriesApi', () {
    test('can be implemented and then constructed', () {
      expect(TestCategoriesApi.new, returnsNormally);
    });
  });
}
