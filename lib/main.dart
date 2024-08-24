import 'package:authentication_repository/authentication_repository.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/firebase_options.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_categories_api/firestore_categories_api.dart';
import 'package:firestore_deadlines_api/firestore_deadlines_api.dart';
import 'package:firestore_permissions_api/firestore_permissions_api.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter/material.dart';
import 'package:permissions_repository/permissions_repository.dart';

void main() async {
  setUrlStrategy(null);
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  final authenticationRepository =
      AuthenticationRepository(firebaseAuth: FirebaseAuth.instance);
  final categoriesRepository = CategoriesRepository(
    categoriesApi: FirestoreCategoriesApi(firestore: firestore),
  );
  final deadlinesRepository = DeadlinesRepository(
    deadlinesApi: FirestoreDeadlinesApi(firestore: firestore),
  );
  final permissionsRepository = PermissionsRepository(
    permissionsApi: FirestorePermissionsApi(firestore: firestore),
  );

  runApp(
    App(
      authenticationRepository: authenticationRepository,
      categoriesRepository: categoriesRepository,
      deadlinesRepository: deadlinesRepository,
      permissionsRepository: permissionsRepository,
    ),
  );
}
