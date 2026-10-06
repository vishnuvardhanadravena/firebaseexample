import 'package:flavor/app.dart';

import 'app/flavor/bootstrap.dart';
import 'app/flavor/environment.dart';

Future<void> main() async {
  await bootstrap(environment: Environment.prod, app: const MyApp());
}
