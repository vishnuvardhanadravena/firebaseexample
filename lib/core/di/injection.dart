import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebaseexample/data/controllers/auth/auth_controller.dart';
import 'package:firebaseexample/core/database/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../data/repositories/auth_repository.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';

final GetIt getIt = GetIt.instance;

/// ===============================================================
/// Dependency Injection
/// ===============================================================
///
/// Handles:
///
/// • SharedPreferences
/// • Secure Storage
/// • Network
/// • Dio
/// • Repository
/// • Controller
///
///
/// Usage
///
/// await setupDependencies();
///
///
/// Get Instance
///
/// final auth = getIt<AuthController>();
///
///
/// Repository
///
/// final repo = getIt<AuthRepository>();
///
///
/// Network
///
/// final network = getIt<NetworkInfo>();
///
/// ===============================================================

Future<void> setupDependencies() async {
  //---------------------------------------------------------------
  // Shared Preferences
  //---------------------------------------------------------------

  // final sharedPreferences =
  //     await SharedPreferences.getInstance();

  // getIt.registerLazySingleton<SharedPreferences>(
  //   () => sharedPreferences,
  // );

  //---------------------------------------------------------------
  // Secure Storage
  //---------------------------------------------------------------

  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<AppSecureStorage>(
    () => AppSecureStorage(getIt()),
  );

  //---------------------------------------------------------------
  // Connectivity
  //---------------------------------------------------------------

  getIt.registerLazySingleton(Connectivity.new);

  getIt.registerLazySingleton(InternetConnection.new);

  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: getIt(), internetConnection: getIt()),
  );

  //---------------------------------------------------------------
  // Dio
  //---------------------------------------------------------------

  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      tokenProvider: () async {
        return getIt<AppSecureStorage>().getToken();
      },
      onUnauthorized: () async {
        await getIt<AppSecureStorage>().clearAll();

        // Navigate to Login if needed
      },
    ),
  );

  //---------------------------------------------------------------
  // Repository
  //---------------------------------------------------------------

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(dioClient: getIt(), secureStorage: getIt()),
  );

  //---------------------------------------------------------------
  // Controllers
  //---------------------------------------------------------------

  getIt.registerFactory<AuthController>(() => AuthController(getIt()));
}
