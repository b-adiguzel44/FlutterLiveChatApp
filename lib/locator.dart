import 'package:flutter_munasaka/repository/user_repository.dart';
import 'package:flutter_munasaka/services/fake_auth_service.dart';
import 'package:flutter_munasaka/services/firebase_auth_service.dart';
import 'package:flutter_munasaka/services/firebase_storage_service.dart';
import 'package:flutter_munasaka/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => FUserRepository());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
}