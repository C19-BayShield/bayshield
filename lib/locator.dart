import 'package:get_it/get_it.dart';
import 'package:supplyside/util/firestore_users.dart';
import 'package:supplyside/util/firestore_orders.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirestoreUsers());
  locator.registerLazySingleton(() => FirestoreOrders());
}