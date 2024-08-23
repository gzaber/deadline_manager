import 'package:categories_api/categories_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firestore_categories_api/firestore_categories_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final category1 = Category(
    owner: 'owner',
    name: 'name1',
    icon: 100,
    color: 200,
  );
  final category2 = Category(
    owner: 'owner',
    name: 'name2',
    icon: 100,
    color: 200,
  );

  group('FirestoreCategoriesApi', () {
    late FirebaseFirestore fakeFirestore;
    late FirestoreCategoriesApi firestoreCategoriesApi;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      firestoreCategoriesApi = FirestoreCategoriesApi(firestore: fakeFirestore);
    });

    group('constructor', () {
      test('works properly', () {
        expect(
          () => FirestoreCategoriesApi(firestore: fakeFirestore),
          returnsNormally,
        );
      });
    });

    group('createCategory', () {
      test('inserts category into collection', () async {
        await firestoreCategoriesApi.createCategory(category1);

        final snapshot = await fakeFirestore.collection('categories').get();
        expect(snapshot.docs.length, equals(1));
        expect(snapshot.docs.first.data(), equals(category1.toJson()));
      });
    });

    group('updateCategory', () {
      test('updates existing category', () async {
        await fakeFirestore
            .collection('categories')
            .doc(category1.id)
            .set(category1.toJson());

        await firestoreCategoriesApi.updateCategory(
          category1.copyWith(name: 'new name'),
        );

        final snapshot = await fakeFirestore.collection('categories').get();
        expect(
          snapshot.docs.first.data(),
          equals(category1.copyWith(name: 'new name').toJson()),
        );
      });
    });

    group('deleteCategory', () {
      test('deletes existing category', () async {
        await fakeFirestore
            .collection('categories')
            .doc(category1.id)
            .set(category1.toJson());

        await firestoreCategoriesApi.deleteCategory(category1.id);

        final snapshot = await fakeFirestore.collection('categories').get();
        expect(snapshot.docs.length, equals(0));
      });
    });

    group('readCategoryById', () {
      test('reads category by its id', () async {
        await fakeFirestore
            .collection('categories')
            .doc(category1.id)
            .set(category1.toJson());

        final result =
            await firestoreCategoriesApi.readCategoryById(category1.id);
        expect(result, equals(category1));
      });
    });

    group('readCategoriesByOwner', () {
      test('reads category list by owner', () async {
        await fakeFirestore
            .collection('categories')
            .doc(category1.id)
            .set(category1.toJson());
        await fakeFirestore
            .collection('categories')
            .doc(category2.id)
            .set(category2.toJson());

        final result =
            await firestoreCategoriesApi.readCategoriesByOwner('owner');
        expect(
          result,
          equals([category1, category2]),
        );
      });
    });

    group('observeCategoriesByOwner', () {
      test('emits category list by owner', () async {
        await fakeFirestore
            .collection('categories')
            .doc(category1.id)
            .set(category1.toJson());
        await fakeFirestore
            .collection('categories')
            .doc(category2.id)
            .set(category2.toJson());

        expect(
          firestoreCategoriesApi.observeCategoriesByOwner('owner'),
          emits([category1, category2]),
        );
      });
    });
  });
}
