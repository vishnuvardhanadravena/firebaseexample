  
  
  
  import 'package:flavor/app/flavor/flavor_banner.dart';
import 'package:flavor/app/flavor/flavor_config.dart';
import 'package:flavor/core/constants/api_constants.dart';
import 'package:flavor/core/network/network_info.dart';
import 'package:flavor/core/di/injection.dart';
import 'package:flavor/core/theme/app_theme.dart';
import 'package:flavor/features/Animations/animations.dart';
import 'package:flavor/features/GoogeMaps/google_maps.dart';
import 'package:flavor/features/Feed/feed_module.dart';
import 'package:flavor/features/AppUpadate/app_update.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: FlavorConfig.instance.appName,
      theme: AppTheme.lightTheme, // Your Theme
      home: FlavorBanner(child: const DeveloperScreen()),
    );
  }
}

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
  bool internet = false;

  String token = "Not Loaded";

  @override
  void initState() {
    super.initState();
    _loadInternet();
  }

  Future<void> _loadInternet() async {
    internet = await getIt<NetworkInfo>().isConnected;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Developer Dashboard")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text("Flavor"),
              subtitle: Text(FlavorConfig.instance.environment.name),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text("Base Url"),
              subtitle: Text(ApiConstants.baseUrl),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text("Screen Size"),
              subtitle: Text("${size.width} x ${size.height}"),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text("Internet"),
              subtitle: Text(internet ? "Connected" : "Disconnected"),
            ),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Input Theme Test",
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Button Theme"),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text("Headline", style: theme.textTheme.headlineMedium),

                  Text("Body", style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // final t = await NotificationService.fcmToken;

                      // setState(() {
                      //   token = t ?? "No Token";
                      // });
                    },
                    child: const Text("Get FCM Token"),
                  ),

                  const SizedBox(height: 10),

                  SelectableText(token),
                ],
              ),
            ),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  // await NotificationService.initialize();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Notification Initialized")),
                  );
                },
                child: const Text("Initialize Notification"),
              ),
            ),
          ),

          Text("Animation ", style: TextStyle(fontSize: 24)),
          AnimationExample(),
          AnimationWithTween(),
          SlideAnmationexample(),
          SizedBox(height: 20),
          TransfromAnimation(),
          SizedBox(height: 20),
          CombinedTransformLogo(),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FeedModule()),
              );
            },
            child: const Text("Open app finger print Screen"),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GoogleMpasScreen()),
              );
            },
            child: const Text("Open Maps Screen"),
          ),
          const SizedBox(height: 20),

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UpdateScreen()),
              );
            },
            child: const Text("Open app update Screen"),
          ),
        ],
      ),
    );
  }
}
