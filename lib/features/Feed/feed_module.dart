import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/mock_feed_repository.dart';
import 'presentation/providers/feed_provider.dart';
import 'presentation/screens/home_feed_screen.dart';


class FeedModule extends StatelessWidget {
  const FeedModule({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FeedProvider>(
      create: (_) => FeedProvider(
        repository: MockFeedRepository(),
      ),
      child: const HomeFeedScreen(),
    );
  }
}
