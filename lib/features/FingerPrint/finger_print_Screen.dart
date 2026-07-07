

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';



class FingerPrintScreen extends StatefulWidget {
  const FingerPrintScreen({super.key});

  @override
  State<FingerPrintScreen> createState() => _FingerPrintScreenState();
}

class _FingerPrintScreenState extends State<FingerPrintScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    print("=== initState called ===");
    _checkDeviceSupport();
  }

  Future<void> _checkDeviceSupport() async {
    print("Checking if device supports biometrics...");
    try {
      final bool isSupported = await auth.isDeviceSupported();
      print("Device Supported: $isSupported");

      setState(() {
        _supportState = isSupported
            ? _SupportState.supported
            : _SupportState.unsupported;
      });
    } catch (e) {
      print("Error checking device support: $e");
    }
  }

  Future<void> _checkBiometrics() async {
    print("=== _checkBiometrics called ===");
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      print("Can check biometrics: $canCheckBiometrics");
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print("PlatformException in canCheckBiometrics: $e");
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    print("=== _getAvailableBiometrics called ===");
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      print("Available biometrics: $availableBiometrics");
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print("PlatformException in getAvailableBiometrics: $e");
    }

    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    print("=== _authenticate (with fallback) called ===");
    var authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating...';
      });

      print("Calling authenticate() with fallback allowed");
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        persistAcrossBackgrounding: true,
      );

      print("Authentication result: $authenticated");
      setState(() {
        _isAuthenticating = false;
      });
    } on LocalAuthException catch (e) {
      print("LocalAuthException: ${e.code} - ${e.description}");
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.code.name}';
      });
    } on PlatformException catch (e) {
      print("PlatformException: ${e.code} - ${e.message}");
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Unexpected error - ${e.message}';
      });
    }

    if (!mounted) return;

    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    print("=== _authenticateWithBiometrics (biometricOnly) called ===");
    var authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating...';
      });

      print("Calling authenticate with biometricOnly: true");
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint or face to authenticate',
        persistAcrossBackgrounding: true,
        biometricOnly: true,
      );

      print("Biometric authentication result: $authenticated");
      setState(() {
        _isAuthenticating = false;
      });
    } on LocalAuthException catch (e) {
      print("LocalAuthException: ${e.code} - ${e.description}");
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.code.name}';
      });
    } on PlatformException catch (e) {
      print("PlatformException: ${e.code} - ${e.message}");
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Unexpected Error - ${e.message}';
      });
    }

    if (!mounted) return;

    final message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() => _authorized = message);
  }

  Future<void> _cancelAuthentication() async {
    print("=== Cancel Authentication called ===");
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Biometric Debug')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support State: ${_supportState.name}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Can Check Biometrics: $_canCheckBiometrics'),
                    Text(
                      'Available Biometrics: ${_availableBiometrics ?? "Not fetched"}',
                    ),
                    const Divider(),
                    Text(
                      'Current Status: $_authorized',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_isAuthenticating)
              const Center(child: CircularProgressIndicator()),

            ElevatedButton(
              onPressed: _checkBiometrics,
              child: const Text('Check Biometrics'),
            ),
            ElevatedButton(
              onPressed: _getAvailableBiometrics,
              child: const Text('Get Available Biometrics'),
            ),

            const Divider(height: 40),

            ElevatedButton(
              onPressed: _authenticate,
              child: const Text('Authenticate (Allow PIN)'),
            ),
            ElevatedButton(
              onPressed: _authenticateWithBiometrics,
              child: const Text('Authenticate with Biometrics Only'),
            ),

            if (_isAuthenticating)
              ElevatedButton(
                onPressed: _cancelAuthentication,
                child: const Text('Cancel Authentication'),
              ),

            const SizedBox(height: 30),
            const Text(
              'Check Debug Console (VS Code / Terminal) for detailed logs',
            ),
          ],
        ),
      ),
    );
  }
}

enum _SupportState { unknown, supported, unsupported }
