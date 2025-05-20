import 'package:get_it/get_it.dart';
import '../features/auth/domain/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/sign_in_usecase.dart';
import '../features/auth/domain/usecases/sign_up_usecase.dart';
import '../features/auth/domain/usecases/sign_out_usecase.dart';
import '../features/auth/presentation/blocs/auth_bloc.dart';
import '../features/auth/domain/repositories/user_repository.dart';
import '../features/product/domain/usecases/add_product_usecase.dart';
import '../features/product/domain/repositories/product_repository.dart'; // ✅ Import ProductRepository (Impl is in the same file)
import '../features/product/presentation/blocs/product_bloc.dart';

/// ✅ Creating a global instance of `GetIt`
final sl = GetIt.instance;

/// ✅ Function to set up Dependency Injection
void setupLocator() {
  /// ✅ Registering `AuthRepositoryImpl` as an `AuthRepository`
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  /// ✅ Registering use cases for authentication
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => UserRepository());

  /// ✅ Registering `AuthBloc`
  sl.registerFactory(() => AuthBloc(
        signUp: sl(),
        signIn: sl(),
        signOut: sl(),
      ));

  // -----------------------------------------------
  // ✅ Register Product Dependencies
  // -----------------------------------------------

  /// ✅ Register `ProductRepositoryImpl`
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());

  /// ✅ Register `AddProductUseCase`
  sl.registerLazySingleton(() => AddProductUseCase(
      repository: sl<ProductRepository>())); // ✅ Named parameter

  /// ✅ Register `ProductBloc`
  sl.registerFactory(() => ProductBloc(addProductUseCase: sl()));
}
