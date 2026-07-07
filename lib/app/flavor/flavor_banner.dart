import 'package:flutter/material.dart';

import 'flavor_config.dart';

class FlavorBanner extends StatelessWidget {
  const FlavorBanner({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final flavor = FlavorConfig.instance;

    if (!flavor.showBanner) {
      return child;
    }

    return Banner(
      message: flavor.environment.name,
      location: BannerLocation.topStart,
      color: flavor.bannerColor,
      child: child,
    );
  }
}