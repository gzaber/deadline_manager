import 'package:authentication_repository/authentication_repository.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/firebase_options.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_categories_api/firestore_categories_api.dart';
import 'package:firestore_deadlines_api/firestore_deadlines_api.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authenticationRepository = AuthenticationRepository();
  final categoriesRepository = CategoriesRepository(
    categoriesApi: FirestoreCategoriesApi(),
  );
  final deadlinesRepository = DeadlinesRepository(
    deadlinesApi: FirestoreDeadlinesApi(),
  );

  runApp(
    App(
      authenticationRepository: authenticationRepository,
      categoriesRepository: categoriesRepository,
      deadlinesRepository: deadlinesRepository,
    ),
  );
}
