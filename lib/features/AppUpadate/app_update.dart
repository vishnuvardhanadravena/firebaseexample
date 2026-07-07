import 'package:firebaseexample/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

// Future<void> main() async {
//   await bootstrap(environment: Environment.stg, app: const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }




class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  AppUpdateInfo? _updateInfo;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _flexibleUpdateAvailable = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate()
        .then((info) {
          setState(() {
            AppLogger.debug("====>${info}");
            _updateInfo = info;
          });
        })
        .catchError((e, s) {
          showSnack(e.toString());
          AppLogger.error("====>$e");
          AppLogger.error("====>$s");
        });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(
        _scaffoldKey.currentContext!,
      ).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: const Text('In App Update Example App')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Center(child: Text('Update info: $_updateInfo')),
              ElevatedButton(
                child: Text('Check for Update'),
                onPressed: () => checkForUpdate(),
              ),
              ElevatedButton(
                onPressed:
                    _updateInfo?.updateAvailability ==
                        UpdateAvailability.updateAvailable
                    ? () {
                        InAppUpdate.performImmediateUpdate().catchError((e) {
                          showSnack(e.toString());
                          return AppUpdateResult.inAppUpdateFailed;
                        });
                      }
                    : null,
                child: Text('Perform immediate update'),
              ),
              ElevatedButton(
                onPressed:
                    _updateInfo?.updateAvailability ==
                        UpdateAvailability.updateAvailable
                    ? () {
                        InAppUpdate.startFlexibleUpdate()
                            .then((_) {
                              setState(() {
                                _flexibleUpdateAvailable = true;
                              });
                            })
                            .catchError((e) {
                              showSnack(e.toString());
                            });
                      }
                    : null,
                child: Text('Start flexible update'),
              ),
              ElevatedButton(
                onPressed: !_flexibleUpdateAvailable
                    ? null
                    : () {
                        InAppUpdate.completeFlexibleUpdate()
                            .then((_) {
                              showSnack("Success!");
                            })
                            .catchError((e) {
                              showSnack(e.toString());
                            });
                      },
                child: Text('Complete flexible update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
