import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import '../utils/logger.dart';

/// ===============================================================
/// PermissionService
/// ===============================================================
///
/// Handles:
/// • Camera
/// • Gallery / Photos
/// • Storage
/// • Notification
/// • Location
/// • Microphone
///
/// Required Package
///
/// permission_handler:
///
///
/// Usage
///
/// await PermissionService.requestCamera();
///
/// await PermissionService.requestGallery();
///
/// await PermissionService.requestLocation();
///
/// await PermissionService.requestNotification();
///
/// bool granted =
///     await PermissionService.isCameraGranted();
///
/// ===============================================================

class PermissionService {
  PermissionService._();

  //===============================================================
  // Camera
  //===============================================================

  static Future<bool> requestCamera() async {
    return _request(Permission.camera);
  }

  static Future<bool> isCameraGranted() async {
    return Permission.camera.isGranted;
  }

  //===============================================================
  // Gallery
  //===============================================================

  static Future<bool> requestGallery() async {
    if (Platform.isIOS) {
      return _request(Permission.photos);
    }

    return _request(Permission.photos);
  }

  //===============================================================
  // Storage
  //===============================================================

  static Future<bool> requestStorage() async {
    if (Platform.isAndroid) {
      return _request(Permission.storage);
    }

    return true;
  }

  //===============================================================
  // Notification
  //===============================================================

  static Future<bool> requestNotification() async {
    return _request(Permission.notification);
  }

  //===============================================================
  // Location
  //===============================================================

  static Future<bool> requestLocation() async {
    return _request(Permission.location);
  }

  static Future<bool> requestLocationAlways() async {
    return _request(Permission.locationAlways);
  }

  //===============================================================
  // Microphone
  //===============================================================

  static Future<bool> requestMicrophone() async {
    return _request(Permission.microphone);
  }

  //===============================================================
  // Open Settings
  //===============================================================

  static Future<void> openSettings() async {
    await openAppSettings();
  }

  //===============================================================
  // Generic Permission Request
  //===============================================================

  static Future<bool> _request(
    Permission permission,
  ) async {
    final status = await permission.request();

    switch (status) {
      case PermissionStatus.granted:
        AppLogger.success(
          "${permission.toString()} Granted",
        );
        return true;

      case PermissionStatus.denied:
        AppLogger.warning(
          "${permission.toString()} Denied",
        );
        return false;

      case PermissionStatus.permanentlyDenied:
        AppLogger.error(
          "${permission.toString()} Permanently Denied",
        );

        await openAppSettings();

        return false;

      case PermissionStatus.restricted:
        return false;

      case PermissionStatus.limited:
        return true;

      case PermissionStatus.provisional:
        return true;
    }
  }
}