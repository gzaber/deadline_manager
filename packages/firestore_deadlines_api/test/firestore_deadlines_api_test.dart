import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deadlines_api/deadlines_api.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firestore_deadlines_api/firestore_deadlines_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final deadline1 = Deadline(
    categoryId: '1',
    name: 'name1',
    expirationDate: DateTime.parse('2024-12-06'),
  );
  final deadline2 = Deadline(
    categoryId: '1',
    name: 'name2',
    expirationDate: DateTime.parse('2024-12-07'),
  );
  final deadline3 = Deadline(
    categoryId: '2',
    name: 'name3',
    expirationDate: DateTime.parse('2024-12-08'),
  );

  group('FirestoreDeadlinesApi', () {
    late FirebaseFirestore fakeFirestore;
    late FirestoreDeadlinesApi firestoreDeadlinesApi;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      firestoreDeadlinesApi = FirestoreDeadlinesApi(firestore: fakeFirestore);
    });

    group('constructor', () {
      test('works properly', () {
        expect(
          () => FirestoreDeadlinesApi(firestore: fakeFirestore),
          returnsNormally,
        );
      });
    });

    group('createDeadline', () {
      test('inserts deadline into collection', () async {
        await firestoreDeadlinesApi.createDeadline(deadline1);

        final snapshot = await fakeFirestore.collection('deadlines').get();
        expect(snapshot.docs.length, equals(1));
        expect(snapshot.docs.first.data(), equals(deadline1.toJson()));
      });
    });

    group('updateDeadline', () {
      test('updates existing deadline', () async {
        await fakeFirestore
            .collection('deadlines')
            .doc(deadline1.id)
            .set(deadline1.toJson());

        await firestoreDeadlinesApi.updateDeadline(
          deadline1.copyWith(name: 'new name'),
        );

        final snapshot = await fakeFirestore.collection('deadlines').get();
        expect(
          snapshot.docs.first.data(),
          equals(deadline1.copyWith(name: 'new name').toJson()),
        );
      });
    });

    group('deleteDeadline', () {
      test('deletes existing deadline', () async {
        await fakeFirestore
            .collection('deadlines')
            .doc(deadline1.id)
            .set(deadline1.toJson());

        await firestoreDeadlinesApi.deleteDeadline(deadline1.id);

        final snapshot = await fakeFirestore.collection('deadlines').get();
        expect(snapshot.docs.length, equals(0));
      });
    });

    group('readDeadlinesByCategoryId', () {
      test('reads deadline list by category id', () async {
        await fakeFirestore
            .collection('deadlines')
            .doc(deadline1.id)
            .set(deadline1.toJson());
        await fakeFirestore
            .collection('deadlines')
            .doc(deadline2.id)
            .set(deadline2.toJson());

        final result =
            await firestoreDeadlinesApi.readDeadlinesByCategoryId('1');
        expect(
          result,
          equals([deadline1, deadline2]),
        );
      });
    });

    group('readDeadlinesByCategoryIds', () {
      test('reads deadline list by category ids list', () async {
        await fakeFirestore
            .collection('deadlines')
            .doc(deadline1.id)
            .set(deadline1.toJson());
        await fakeFirestore
            .collection('deadlines')
            .doc(deadline2.id)
            .set(deadline2.toJson());
        await fakeFirestore
            .collection('deadlines')
            .doc(deadline3.id)
            .set(deadline3.toJson());

        final result =
            await firestoreDeadlinesApi.readDeadlinesByCategoryIds(['1', '2']);
        expect(
          result,
          equals([deadline1, deadline2, deadline3]),
        );
      });
    });

    group('observeDeadlinesByCategoryId', () {
      test('emits deadline list by category id', () async {
        await fakeFirestore
            .collection('deadlines')
            .doc(deadline1.id)
            .set(deadline1.toJson());
        await fakeFirestore
            .collection('deadlines')
            .doc(deadline2.id)
            .set(deadline2.toJson());

        expect(
          firestoreDeadlinesApi.observeDeadlinesByCategoryId('1'),
          emits([deadline1, deadline2]),
        );
      });
    });
  });
}
