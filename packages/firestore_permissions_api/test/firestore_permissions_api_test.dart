import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firestore_permissions_api/firestore_permissions_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permissions_api/permissions_api.dart';

void main() {
  final permission1 = Permission(
    giver: 'giver1',
    receiver: 'receiver1',
    categoryIds: const ['1', '2'],
  );
  final permission2 = Permission(
    giver: 'giver1',
    receiver: 'receiver2',
    categoryIds: const ['2', '3'],
  );

  group('FirestorePermissionsApi', () {
    late FirebaseFirestore fakeFirestore;
    late FirestorePermissionsApi firestorePermissionsApi;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      firestorePermissionsApi =
          FirestorePermissionsApi(firestore: fakeFirestore);
    });

    group('constructor', () {
      test('works properly', () {
        expect(
          () => FirestorePermissionsApi(firestore: fakeFirestore),
          returnsNormally,
        );
      });
    });

    group('createPermission', () {
      test('inserts permission into collection', () async {
        await firestorePermissionsApi.createPermission(permission1);

        final snapshot = await fakeFirestore.collection('permissions').get();
        expect(snapshot.docs.length, equals(1));
        expect(snapshot.docs.first.data(), equals(permission1.toJson()));
      });
    });

    group('updatePermission', () {
      test('updates existing permission', () async {
        await fakeFirestore
            .collection('permissions')
            .doc(permission1.id)
            .set(permission1.toJson());

        await firestorePermissionsApi.updatePermission(
          permission1.copyWith(receiver: 'new receiver'),
        );

        final snapshot = await fakeFirestore.collection('permissions').get();
        expect(
          snapshot.docs.first.data(),
          equals(permission1.copyWith(receiver: 'new receiver').toJson()),
        );
      });
    });

    group('deletePermission', () {
      test('deletes existing permission', () async {
        await fakeFirestore
            .collection('permissions')
            .doc(permission1.id)
            .set(permission1.toJson());

        await firestorePermissionsApi.deletePermission(permission1.id);

        final snapshot = await fakeFirestore.collection('permissions').get();
        expect(snapshot.docs.length, equals(0));
      });
    });

    group('readPermissionsByCategoryId', () {
      test('reads permission list by category id', () async {
        await fakeFirestore
            .collection('permissions')
            .doc(permission1.id)
            .set(permission1.toJson());
        await fakeFirestore
            .collection('permissions')
            .doc(permission2.id)
            .set(permission2.toJson());

        final result =
            await firestorePermissionsApi.readPermissionsByCategoryId('2');
        expect(
          result,
          equals([permission1, permission2]),
        );
      });
    });

    group('readCategoryIdsByReceiver', () {
      test('reads category ids list by receiver', () async {
        await fakeFirestore
            .collection('permissions')
            .doc(permission1.id)
            .set(permission1.toJson());
        await fakeFirestore
            .collection('permissions')
            .doc(permission2.id)
            .set(permission2.toJson());

        final result = await firestorePermissionsApi
            .readCategoryIdsByReceiver('receiver1');
        expect(
          result,
          equals(['1', '2']),
        );
      });
    });

    group('readPermissionsByGiver', () {
      test('reads permission list by giver', () async {
        await fakeFirestore
            .collection('permissions')
            .doc(permission1.id)
            .set(permission1.toJson());
        await fakeFirestore
            .collection('permissions')
            .doc(permission2.id)
            .set(permission2.toJson());

        final result =
            await firestorePermissionsApi.readPermissionsByGiver('giver1');
        expect(
          result,
          equals([permission1, permission2]),
        );
      });
    });

    group('observePermissionsByGiver', () {
      test('emits permission list by giver', () async {
        await fakeFirestore
            .collection('permissions')
            .doc(permission1.id)
            .set(permission1.toJson());
        await fakeFirestore
            .collection('permissions')
            .doc(permission2.id)
            .set(permission2.toJson());

        expect(
          firestorePermissionsApi.observePermissionsByGiver('giver1'),
          emits([permission1, permission2]),
        );
      });
    });
  });
}
