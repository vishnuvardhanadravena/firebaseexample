import 'package:firebaseexample/app.dart';
import 'app/flavor/bootstrap.dart';
import 'app/flavor/environment.dart';

Future<void> main() async {
  await bootstrap(
    environment: Environment.dev,
    app: const MyApp(),
  );
}