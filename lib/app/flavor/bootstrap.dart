// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flavor/core/network/network_info.dart';
import 'package:flavor/core/services/stripe_service.dart';
import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/notification_service.dart';
import 'environment.dart';
import 'flavor_config.dart';

Future<void> bootstrap({
  required Environment environment,
  required Widget app,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  await getIt<NetworkInfo>().initialize();
  FlavorConfig.initialize(environment);
  if (environment == Environment.qa) {
    await StripeService.instance.initialize();
  } else {}
  await FirebaseService.initialize();
  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseMessagingBackgroundHandler,
  );
  await NotificationService.initialize();
  runApp(app);
}
