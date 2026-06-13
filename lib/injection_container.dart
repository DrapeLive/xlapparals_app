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
import 'package:xlapparals_app/features/agent/orders/customers/data/datasources/create_order_data_source.dart';
import 'package:xlapparals_app/features/agent/orders/customers/data/datasources/customer_remote_data_source.dart';
import 'package:xlapparals_app/features/agent/orders/customers/data/repository/create_order_repository_impl.dart';
import 'package:xlapparals_app/features/agent/orders/customers/data/repository/customer_repository_impl.dart';
import 'package:xlapparals_app/features/agent/orders/customers/domain/repository/customer_repository.dart';
import 'package:xlapparals_app/features/agent/orders/customers/domain/repository/order_repository.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/customer_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/order_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/data/datasource/order_remote_data_source.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/data/repository/order_repository_imp.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/repository/order_repository.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/agent_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/data/datasources/add_item_remote_data_source.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/data/repositories/add_item_repository_impl.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/domain/repositories/add_item_repository.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/domain/usecases/add_item_to_order_usecase.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/domain/usecases/get_item_by_qr_usecase.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_details_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/data/data_source/order_form_data_source.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/data/repositories/order_form_repository_impl.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/repositories/order_form_repository.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/presentation/bloc/order_form_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/data/datasource/scan_data_source.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/data/repository/scan_repository_impl.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/domain/repositories/scan_repository.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/domain/usecases/check_usecase.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/presentation/blocs/scan_bloc.dart';
import 'package:xlapparals_app/features/agent/profile/data/repository/profile_repository_imp.dart';
import 'package:xlapparals_app/features/agent/profile/domain/repository/profile_repository.dart';
import 'package:xlapparals_app/features/agent/profile/presentation/blocs/profile/profile_bloc.dart';
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
    () => ItemsRemoteDatasourceImpl(sl(), sl()),
  );

  sl.registerLazySingleton<ItemRepository>(() => ItemsRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetItemsUseCase(sl()));

  sl.registerFactory(() => ItemFetchBloc(sl(), sl()));

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  sl.registerFactory(() => ProfileBloc(sl()));

  sl.registerLazySingleton<CustomerRemoteDataSource>(
    () => CustomerRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => CustomerBloc(sl<CustomerRepository>()));

  sl.registerLazySingleton<OrderDetailsRemoteDatasource>(
    () => OrderDetailsRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<OrderDetailsRepository>(
    () => OrderDetailsRepositoryImpl(sl<OrderDetailsRemoteDatasource>()),
  );

  sl.registerFactory(() => OrderDetailsBloc(sl<OrderDetailsRepository>()));

  sl.registerLazySingleton<CreateOrderRemoteDatasource>(
    () => CreateOrderRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<CreateOrderRepository>(
    () => CreateOrderRepositoryImpl(sl<CreateOrderRemoteDatasource>()),
  );

  sl.registerFactory(
    () => CreateOrderBloc(
      repository: sl<CreateOrderRepository>(),
      userStorageService: sl<UserStorageService>(),
    ),
  );

  sl.registerLazySingleton(() => CheckQrUsecase(sl()));

  sl.registerLazySingleton<ScanRemoteDatasource>(
    () => ScanRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<ScanRepository>(
    () => ScanRepositoryImpl(sl<ScanRemoteDatasource>()),
  );

  sl.registerFactory(() => ScanBloc(sl()));

  sl.registerLazySingleton<AddItemRemoteDataSource>(
    () => AddItemRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AddItemRepository>(
    () => AddItemRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetItemByQrUseCase(sl<AddItemRepository>()));

  sl.registerLazySingleton(
    () => AddItemToOrderUseCase(sl<AddItemRepository>()),
  );

  sl.registerFactory(
    () =>
        ItemDetailsBloc(sl<GetItemByQrUseCase>(), sl<AddItemToOrderUseCase>()),
  );

  sl.registerFactory(() => AgentBloc(sl<UserStorageService>()));

  sl.registerLazySingleton<OrderFormDataSource>(
    () => OrderFormDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<OrderInvoiceRepository>(
    () => OrderInvoiceRepositoryImpl(sl<OrderFormDataSource>()),
  );

  sl.registerFactory(() => OrderInvoiceBloc(sl<OrderInvoiceRepository>()));
}
