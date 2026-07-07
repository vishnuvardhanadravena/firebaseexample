import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/feed_provider.dart';
import '../widgets/feed_card.dart';
import '../widgets/feed_top_bar.dart';
import '../widgets/gradient_bottom_nav.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final _pageController = PageController(viewportFraction: 0.92);
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().loadInitial();
    });

    _pageController.addListener(() {
      final page = _pageController.page ?? 0;
      final provider = context.read<FeedProvider>();
      if (page >= provider.posts.length - 3) {
        provider.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: Consumer<FeedProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                FeedTopBar(
                  userName: 'Sajon.co',
                  avatarUrl: 'https://i.pravatar.cc/150?img=12',
                  onSearchTap: () {},
                  onNotificationsTap: () {},
                  onMenuTap: () {},
                ),
                Expanded(child: _buildBody(provider)),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: GradientBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        onCreateTap: () {
          // Navigate to your create/post flow via go_router, e.g.
          // context.push('/create');
        },
      ),
    );
  }

  Widget _buildBody(FeedProvider provider) {
    switch (provider.status) {
      case FeedStatus.initial:
      case FeedStatus.loading when provider.posts.isEmpty:
        return const Center(child: CircularProgressIndicator());

      case FeedStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.errorMessage ?? 'Something went wrong'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: provider.loadInitial,
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      default:
        return RefreshIndicator(
          onRefresh: provider.loadInitial,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: provider.posts.length,
            itemBuilder: (context, index) {
              final post = provider.posts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: FeedCard(
                  post: post,
                  onLikeTap: () => provider.toggleLike(post.id),
                  onSaveTap: () => provider.toggleSave(post.id),
                  onCommentTap: () {},
                  onShareTap: () {},
                ),
              );
            },
          ),
        );
    }
  }
}
