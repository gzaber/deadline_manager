import 'package:authentication_repository/src/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'models/models.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    required firebase_auth.FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  firebase_auth.FirebaseAuth get auth => _firebaseAuth;

  Stream<User> get user => _firebaseAuth.authStateChanges().map(
        (firebaseUser) =>
            firebaseUser == null ? User.empty : firebaseUser.toUser,
      );

  Future<void> signOut() async => await _firebaseAuth.signOut();

  Future<void> deleteUser() async => await _firebaseAuth.currentUser?.delete();
}

extension on firebase_auth.User {
  User get toUser => User(id: uid, email: email ?? '');
}
