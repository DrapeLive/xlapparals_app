import 'package:get_it/get_it.dart';
import 'package:xlapparals_app/core/network/dio_client.dart';
import 'package:xlapparals_app/features/agent/home/data/datasources/items_remote_source.dart';
import 'package:xlapparals_app/features/agent/home/data/datasources/orders_remote_datasource.dart';
import 'package:xlapparals_app/features/agent/home/data/repositories/item_repository.dart';
import 'package:xlapparals_app/features/agent/home/data/repositories/order_repository_impl.dart';
import 'package:xlapparals_app/features/agent/home/domain/repositories/item_repository.dart';
import 'package:xlapparals_app/features/agent/home/domain/repositories/order_repository.dart';
import 'package:xlapparals_app/features/agent/home/domain/usecases/item_usecase.dart';
import 'package:xlapparals_app/features/agent/home/domain/usecases/order_usecase.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/fetch_item/item_fetch_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/orders/orders_bloc.dart';
import 'package:xlapparals_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:xlapparals_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:xlapparals_app/shared/services/secure_storage_service.dart';
import 'package:xlapparals_app/shared/services/user_storage_service.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => SecureStorageService());

  sl.registerLazySingleton(() => UserStorageService());

  sl.registerLazySingleton(() => DioClient(sl<SecureStorageService>()).dio);

  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton(() => LoginUseCase(sl()));

  sl.registerFactory(() => AuthBloc(sl(), sl(), sl()));

  sl.registerLazySingleton<OrdersRemoteDatasource>(
    () => OrdersRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));

  sl.registerFactory(() => OrdersBloc(sl()));

  sl.registerLazySingleton<ItemsRemoteDatasource>(
    () => ItemsRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<ItemRepository>(() => ItemsRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetItemsUseCase(sl()));

  sl.registerFactory(() => ItemFetchBloc(sl(), sl()));
}
