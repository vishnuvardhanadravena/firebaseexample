import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// ===============================================================
/// NetworkInfo
/// ===============================================================
///
/// Production Ready Network Service
///
/// Handles:
/// • Current Internet Status
/// • Internet Change Stream
/// • Initialize Listener
/// • Dispose Listener
///
/// Required Packages:
///
/// connectivity_plus:
/// internet_connection_checker_plus:
///
///
/// Usage
/// ===============================================================
///
/// Register
///
/// getIt.registerLazySingleton<NetworkInfo>(
///   () => NetworkInfoImpl(
///     connectivity: Connectivity(),
///     internetConnection: InternetConnection(),
///   ),
/// );
///
///
/// Bootstrap
///
/// await getIt<NetworkInfo>().initialize();
///
///
/// Check Internet
///
/// if(await getIt<NetworkInfo>().isConnected){
///
///     // Internet Available
///
/// }
///
///
/// Listen Changes
///
/// getIt<NetworkInfo>()
///     .onConnectivityChanged
///     .listen((connected){
///
///        if(connected){
///
///            print("Connected");
///
///        }else{
///
///            print("Disconnected");
///
///        }
///
///     });
///
///
/// Dispose
///
/// await getIt<NetworkInfo>().dispose();
///
/// ===============================================================

abstract interface class NetworkInfo {
  ///---------------------------------------------------------------
  /// Initialize
  ///---------------------------------------------------------------
  ///
  /// Call once inside bootstrap.dart
  ///
  Future<void> initialize();

  ///---------------------------------------------------------------
  /// Current Internet Status
  ///---------------------------------------------------------------
  ///
  /// Example
  ///
  /// if(await getIt<NetworkInfo>().isConnected){
  ///
  ///     // Connected
  ///
  /// }
  ///
  Future<bool> get isConnected;

  ///---------------------------------------------------------------
  /// Internet Stream
  ///---------------------------------------------------------------
  ///
  /// Example
  ///
  /// getIt<NetworkInfo>()
  ///     .onConnectivityChanged
  ///     .listen((connected){
  ///
  /// });
  ///
  Stream<bool> get onConnectivityChanged;

  ///---------------------------------------------------------------
  /// Dispose
  ///---------------------------------------------------------------
  ///
  /// Example
  ///
  /// await getIt<NetworkInfo>().dispose();
  ///
  Future<void> dispose();
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({
    required Connectivity connectivity,
    required InternetConnection internetConnection,
  })  : _connectivity = connectivity,
        _internetConnection = internetConnection;

  final Connectivity _connectivity;

  final InternetConnection _internetConnection;

  final StreamController<bool> _controller =
      StreamController<bool>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ///---------------------------------------------------------------
  /// Initialize
  ///---------------------------------------------------------------
  @override
  Future<void> initialize() async {
    _subscription?.cancel();

    _subscription =
        _connectivity.onConnectivityChanged.listen(
      (_) async {
        final connected = await isConnected;

        _controller.add(connected);
      },
    );
  }

  ///---------------------------------------------------------------
  /// Current Internet Status
  ///---------------------------------------------------------------
  @override
  Future<bool> get isConnected async {
    final connectivityResult =
        await _connectivity.checkConnectivity();

    if (connectivityResult.contains(
      ConnectivityResult.none,
    )) {
      return false;
    }

    return _internetConnection.hasInternetAccess;
  }

  ///---------------------------------------------------------------
  /// Internet Change Stream
  ///---------------------------------------------------------------
  @override
  Stream<bool> get onConnectivityChanged =>
      _controller.stream;

  ///---------------------------------------------------------------
  /// Dispose
  ///---------------------------------------------------------------
  @override
  Future<void> dispose() async {
    await _subscription?.cancel();

    await _controller.close();
  }
}